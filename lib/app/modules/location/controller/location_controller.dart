import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:cabifyit/app/data/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart' as m;
import '../../../../reusability/utils/utils.dart';
import '../../../data/model/places_model.dart';

class LocationController extends GetxController {
  TextEditingController locationController = TextEditingController();
  m.MaplibreMapController? mController;
  GoogleMapController? mapController;
  m.Symbol? _symbol;
  LocationService locationService = LocationService();

  var isPickup = false.obs;
  var lat = 0.0.obs;
  var lng = 0.0.obs;
  var currentLatitude = 0.0.obs;
  var currentLongitude = 0.0.obs;
  var location = "".obs;
  var pointId = "".obs;
  var isDarkMode = false.obs;
  var googleMapKey = "".obs;
  List<Place> place = [];
  List<Place> searchedLocation = [];
  Set<Marker> markers = {};

  var bariKoiStyle = "https://map.barikoi.com/styles/osm-liberty/style.json?key=${Utils().getBarikoiMapKey()}";
  var bariKoiDarkStyle = "https://map.barikoi.com/styles/barikoi-dark-mode/style.json?key=${Utils().getBarikoiMapKey()}";
  
  var mCurrentPosition = m.CameraPosition(
      target: m.LatLng(29.1674247217301,69.6462672649231),
      zoom: 4
  );

  var currentPosition = CameraPosition(
      target: LatLng(29.1674247217301,69.6462672649231),
      zoom: 4
  );

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    var args = Get.arguments ?? [];
    isPickup.value = args[0];
    googleMapKey.value = Utils().getGoogleMapKey();
    print("Barikoi Ket : ${bariKoiStyle}");
    getLocation();
  }

  getLocation() async {
    var result = await determinePosition();

    if(result != null) {
      currentLatitude.value = result.latitude;
      currentLongitude.value = result.longitude;
      animateCamera(latitude: result.latitude, longitude: result.longitude);
    }
  }

  animateCamera({required double latitude,required double longitude}) async {
    pointId.value = '';
    lat.value = latitude;
    lng.value = longitude;
    update();

    await getPlot(lat: lat.value.toString(), long: lng.value.toString());

    if(location.value.isEmpty) {
      if (Utils().getSearch()) {
        getAddressFromLatLng(lat.value, lng.value);
      } else {
        getAddress();
      }
    }

      if (Utils().getMap()) {
        currentPosition = CameraPosition(target: LatLng(lat.value, lng.value), zoom: 16);
        final icon = await getMarkerIcon();
        markers.clear();
        markers.add(
          Marker(
            markerId: const MarkerId("driver"),
            position: LatLng(lat.value, lng.value),
            icon: icon,
          ),
        );
        if (mapController != null) {
          mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(lat.value, lng.value),
                zoom: 16,
              ),
            ),
          );
        }
        print("Marker ADDED");
      } else {
        mCurrentPosition = m.CameraPosition(
            target: m.LatLng(lat.value, lng.value),
            zoom: 16
        );
        if(mController!=null) {
            if(_symbol != null) {
              await mController!.removeSymbol(_symbol!);
            }
          m.SymbolOptions symbolOptions = m.SymbolOptions(
            geometry: m.LatLng(lat.value, lng.value),
            iconImage: 'custom-marker',
            iconColor: '#ffffff',
            iconSize: .2,
            iconAnchor: '',
          );
            mController!
                .animateCamera(m.CameraUpdate.newLatLngZoom(
                m.LatLng(lat.value, lng.value), 16));
            addImageFromAsset("custom-marker", "assets/images/pin.png")
                .then((value) async {
                _symbol = await mController!.addSymbol(symbolOptions);});
        }
      }
    update();
  }

  Future<BitmapDescriptor> getMarkerIcon() async {
    return await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(30, 30)),
      "assets/images/pin.png",
    );
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mController!.addImage(name, list);
  }

  Future<Position?> determinePosition() async {
    print("Getting");
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("Getting $serviceEnabled");
    if (!serviceEnabled) {
      Geolocator.openAppSettings();
    }

    permission = await Geolocator.checkPermission();
    print("Getting $permission");
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return null;
      }
    }
    print("Getting Denied not");
    if (permission == LocationPermission.deniedForever) {
      print("Getting Denied Forever");
      return null;
    }
    print("Getting Enable");
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Place>?> findPlaces({required String search}) async {
    log("123");
    if (search.isNotEmpty) {
      if (Utils().getSearch()) {
        place.clear();
        final url =
            "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&key=${googleMapKey.value}&components=country:${Utils().countryOfUser()}";
        final response = await http.get(Uri.parse(url));
        final json = jsonDecode(response.body);

        List places = json['predictions'] ?? [];
        for (var element in places) {
          place.add(Place(address: element['description'], name: element['structured_formatting']['main_text'] ?? "", id: element['place_id']));
        }
        return place;
      } else {
        var s = search;
        if(currentLatitude.value != 0.0 && currentLongitude.value != 0.0) {
          s = "$s&focus_lon=$currentLongitude&focus_lat=$currentLatitude";
        }
        var result = await locationService.getPlaces(
            params: s,
            isNearby: (currentLatitude.value != 0.0 && currentLongitude.value != 0.0)
        );
        if(result != null) {
          place = result.place ?? [];
          return place;
        }
        return [];
      }
    }
    return [];
  }

  Future getAddress() async {
    var result = await locationService.getAddress(params: '&longitude=${lng.value}&latitude=${lat.value}');
    if(result != null) {
      location.value = result['place']['address'];
    }
    update();
  }

  Future getAddressFromLatLng(double lat, double lng) async {
    final url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${googleMapKey.value}";

    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);

    if (json['status'] == 'OK') {
      location.value = json['results'][0]['formatted_address'];
    }
  }

  Future getLatLongFromPlaceId(id) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$id&key=${googleMapKey.value}";
    final response = await http.get(Uri.parse(url));
    final json = jsonDecode(response.body);
    print("URL : ${url}");
    print("Status : ${response.statusCode}");
    print("Response : ${response.body}");

    return json['result']['geometry']['location'];
  }

  Future getPlot({required lat, required long}) async {
    var body = {
      "latitude": lat,
      "longitude": long,
    };
    var result = await LocationService().getPlot(body: body);

    if(result != null && (result['found'] ?? "0").toString() != "0" && result['record'] != null) {
        var record = result['record'];
        pointId.value = (record['id'] ?? "").toString();
        update();
    } else {
      Utils.toastWarning("We're not providing service at your location.");
    }
  }
}