import 'dart:async';
import 'dart:ui' as ui;
import 'package:cabifyit/app/data/services/socket_service.dart';
import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:maplibre_gl/maplibre_gl.dart' as m;
import '../../../../reusability/theme/app_icons.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../data/network/network.dart';

class DriverLocationController extends GetxController {
  var lat = 0.00.obs;
  var lng = 0.00.obs;
  var driverId = "";
  var driverImage = "";
  m.MaplibreMapController? mController;
  GoogleMapController? mapController;
  m.Symbol? _symbol;
  var useGoogleMap = false.obs;
  var isDarkMode = false.obs;
  var googleMapKey = "".obs;
  Set<Marker> markers = {};

  late Timer driverLocationTimer;

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
    useGoogleMap.value = Utils().getMap();
    googleMapKey.value = Utils().getGoogleMapKey();
    List args = Get.arguments ?? [];
    if(args.isNotEmpty) {
      driverId = args.first;
      driverImage = args[1];
    }
    getLocation();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    driverLocationTimer.cancel();
    SocketService().socket?.off("get-driver-location-on-user");
  }

  animateCamera({required double latitude,required double longitude}) async {
    lat.value = latitude;
    lng.value = longitude;

      if (Utils().getMap()) {
        currentPosition = CameraPosition(target: LatLng(lat.value, lng.value), zoom: 20);
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
                zoom: 14,
              ),
            ),
          );
        }
        print("Marker ADDED");
      } else {
        mCurrentPosition = m.CameraPosition(
            target: m.LatLng(lat.value, lng.value),
            zoom: 5
        );
        if(mController!=null) {
            if(_symbol != null) {
              await mController!.removeSymbol(_symbol!);
            }
          m.SymbolOptions symbolOptions = m.SymbolOptions(
            geometry: m.LatLng(lat.value, lng.value),
            iconImage: 'custom-marker',
            iconColor: '#ffffff',
            iconSize: .5,
            iconAnchor: '',
          );
            mController!
                .animateCamera(m.CameraUpdate.newLatLngZoom(
                m.LatLng(lat.value, lng.value), 10));
            addImageFromAsset("custom-marker", AppIcons.currentPosition)
                .then((value) async {
                _symbol = await mController!.addSymbol(symbolOptions);});
        }
      }
    update();
  }

  Future<BitmapDescriptor> getMarkerIcon() async {
     var markerIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(100, 100)),
      AppIcons.currentPosition,
    );

    return markerIcon;
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    Uint8List list = bytes.buffer.asUint8List();

    return mController!.addImage(name, list);
  }

  getLocation() {
    SocketService().emitEvent("get-driver-location", {
      "driver_id": driverId,
      "database": Utils().getTenantId(),
    });

    driverLocationTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      SocketService().emitEvent("get-driver-location", {
        "driver_id": driverId,
        "database": Utils().getTenantId(),
      });
    });

    SocketService().socket?.on("get-driver-location-on-user", (data) {
      if(data['data'] != null && data['data']['data'] != null) {
        var latitude = double.tryParse((data['data']['data']['latitude'] ?? "0").toString()) ?? 0.00;
        var longitude = double.tryParse((data['data']['data']['longitude'] ?? "0").toString()) ?? 0.00;
        if(latitude != 0.00 && longitude != 0.00)animateCamera(latitude: latitude, longitude: longitude);
      }
    },);
  }
}