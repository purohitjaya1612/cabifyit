import 'package:cabifyit/app/data/model/current_ride_model.dart';
import 'package:cabifyit/app/data/model/vehicle_list_model.dart';
import 'package:cabifyit/app/data/services/auth_service.dart';
import 'package:cabifyit/app/data/services/booking_service.dart';
import 'package:cabifyit/app/data/services/general_service.dart';
import 'package:cabifyit/app/data/services/profile_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as m;
import '../../../../reusability/utils/utils.dart';
import '../../../data/services/socket_service.dart';
import '../../../routes/app_pages.dart';

class DashBoardController extends GetxController with WidgetsBindingObserver {
  final reasonKey = GlobalKey<FormState>();
  var reasonAutoValidate = AutovalidateMode.disabled.obs;
  var isMapLoading = true.obs;
  var isLoading = true.obs;
  var isCalculationLoading = false.obs;

  var when = "now".obs;
  var bookingDate = "".obs;
  var pickupTime = ''.obs;

  CurrentBooking? currentBooking;

  BookingService bookingService = BookingService();
  AuthService authService = AuthService();

  TextEditingController pickupController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController cancelReasonController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;

  var pickupLat = "".obs;
  var pickupLong = "".obs;
  var dropLat = "".obs;
  var dropLong = "".obs;
  var pickupPointId = "".obs;
  var dropPointId = "".obs;

  var fareKm = ''.obs;
  var farePrice = ''.obs;

  List<VehicleData> vehicles = [];

  var paymentMethod = 'Cash'.obs;
  var type = 'local'.obs;
  var selectedRide = 0.obs;

  m.MapLibreMapController? mController;
  GoogleMapController? mapController;
  var mCurrentPosition = m.CameraPosition(
      target: m.LatLng(29.1674247217301,69.6462672649231),
      zoom: 4
  );
  var currentPosition = CameraPosition(
      target: LatLng(29.1674247217301,69.6462672649231),
      zoom: 4
  );

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var bariKoiStyle = "https://map.barikoi.com/styles/osm-liberty/style.json?key=${Utils().getBarikoiMapKey()}";

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    storeToken();
    getApisKey();
    getProfile();
    getVehicleList();
    connectSocket();
    getCurrentRide();
    determinePosition();
  }

  getApisKey() async {
    isMapLoading.value = true;
    var result = await GeneralService().getApisKey();
    isMapLoading.value = false;
    if(result != null && result['setting'] != null) {
      var setting = result['setting'];
      if((setting['stripe_key'] ?? "").isNotEmpty)Stripe.publishableKey = setting['stripe_key'] ?? "";
      if((setting['stripe_key'] ?? "").isNotEmpty)await Stripe.instance.applySettings();
      if(setting['enable_map'] == "google") {
        Utils().setMap(true);
      } else {
        Utils().setMap(false);
      }
      if(setting['enable_map'] == "google") {
        Utils().setSearch(true);
      } else {
        Utils().setSearch(false);
      }
      Utils().setBarikoiMapKey(setting['barikoi_api_keys'] ?? "");
      Utils().setGoogleMapKey(setting['google_api_keys'] ?? "");
      Utils().setBox("currency",setting['company_currency'] ?? "USD");
      var currencySymbol = Utils().getSymbolCurrency(setting['company_currency'] ?? "USD");
      Utils().setBox("currency_symbol", currencySymbol);
      Utils().setBox("stripe_key", setting['stripe_secret_key'] ?? "");
      Utils().setBox("support_no", setting['support_contact_no'] ?? "");
      Utils().setBox("emergency_no", setting['support_emergency_no'] ?? "");
      Utils().setBox("rescue_no", setting['support_rescue_number'] ?? "");
      Utils().setBox("country_of_user", setting['country_of_user'] ?? "");
      Utils().setBox("company_booking_system", setting['company_booking_system'] ?? "auto_dispatch");
      bariKoiStyle = "https://map.barikoi.com/styles/osm-liberty/style.json?key=${Utils().getBarikoiMapKey()}";
    }
  }

  logout() async {
    Utils.showLoadingDialog();
    await authService.logout();
    if(Get.isDialogOpen ?? false)Get.back();
    Get.back();
    Utils().logOutData();
    SocketService().disconnect();
  }

  deleteAccount() async {
    Utils.showLoadingDialog();
    var result = await authService.deleteAccount();
    if(Get.isDialogOpen ?? false)Get.back();
    if(result != null) {
      Get.back();
      Utils().logOutData();
      Utils.toastOk(result.message ?? "");
      SocketService().disconnect();
    }
  }

  getProfile() async {
    var result = await ProfileService().getProfile();

    if(result != null) {
      Utils().setBox("userEmail", result.data?.email ?? "");
      Utils().setBox("userPhone", result.data?.phoneNo ?? "");
      Utils().setBox("userName", result.data?.name?? "");
      Utils().setBox("userCountryCode", result.data?.countryCode ?? "");
      Utils().setBox("userImage", result.data?.profile ?? "");
      Utils().setBox("walletBalance", result.data?.walletBalance ?? "");
    }
  }

  getVehicleList() async {
    isLoading.value = true;
    var result = await bookingService.getVehicles();
    isLoading.value = false;

    if(result != null) {
      vehicles.addAll(result.list ?? []);
    }
    update();
  }

  calculateFare() async {
    if (vehicles.isNotEmpty && pickupLat.value.isNotEmpty && pickupLong.value.isNotEmpty &&
        dropLat.value.isNotEmpty && dropLong.value.isNotEmpty && selectedRide.value != -1) {
      var body = {
        "pickup_point": {
          "latitude": pickupLat.value,
          "longitude": pickupLong.value,
        },
        "destination_point": {
          "latitude": dropLat.value,
          "longitude": dropLong.value,
        },
        "vehicle_id": vehicles[selectedRide.value].id
      };
      isCalculationLoading.value = true;
      var result = await bookingService.getFare(body: body);
      isCalculationLoading.value = false;
      if(result != null) {
        fareKm.value = ((double.tryParse((result['distance'] ?? 0).toString()) ?? 0) / 1000).toStringAsFixed(2);
        farePrice.value = (double.tryParse((result['calculate_fare'] ?? 0).toString()
        ) ?? 0).toStringAsFixed(2);
      }
      update();
    }
  }

  createBooking() async {
    var date = '';
    if(when.value == 'later') {
      date = DateFormat('yyyy-MM-dd').format(DateFormat("dd/MM/yyyy").parse(bookingDate.value)).toString();
      var bookingTime = DateFormat("dd/MM/yyyy hh:mm a").parse("${bookingDate.value} ${pickupTime.value}");
      if(bookingTime.isBefore(DateTime.now().add(Duration(hours: 1)))) {
        Utils.toastWarning("For scheduled bookings, the pickup time must be at least 1 hour from now. Please select a later time.");
        return;
      }
    }
    var body = {
      'booking_type': type.value,
      "pickup_plot_id": pickupPointId.value,
      'pickup_point': '${pickupLat.value}, ${pickupLong.value}',
      'pickup_location': pickupController.text,
      'destination_point': '${dropLat.value}, ${dropLong.value}',
      'destination_location': destinationController.text,
      'vehicle': vehicles[selectedRide.value].id ?? "",
      'offered_amount': rateController.text.trim(),
      'recommended_amount': farePrice.value,
      "distance": fareKm.value,
      "payment_method": paymentMethod.value,
      "note": noteController.text.trim(),
      if(when.value == 'later')'booking_date': date,
      if(when.value == 'later')'pickup_time': pickupTime.value
    };
    Utils.showLoadingDialog();
    var result = await bookingService.createBooking(body: body);
    if(Get.isDialogOpen ?? false) Get.back();

    if(result != null) {
      FocusScope.of(Get.context!).unfocus();
      if(when.value == 'later') {
        pickupPointId.value = '';
        pickupLat.value = '';
        pickupLong.value = '';
        pickupController.text = '';
        destinationController.text = '';
        dropLat.value = '';
        dropLong.value = '';
        dropPointId.value = '';
        fareKm.value = '';
        farePrice.value = '';
        type.value = 'local';
        rateController.text = '';
        noteController.text = '';
        paymentMethod.value = 'Cash';
        bookingDate.value = '';
        pickupTime.value = '';
        when.value = 'now';
        update();
        Utils.toastOk("Booking placed successfully. You'll get notified when driver assigned to you. You can track booking in upcoming ride.");
      } else {
        var rideResult = await Get.toNamed(Routes.RIDEBIDS, arguments: [(result['newBooking']['id'].toString()), rateController.text.trim(), fareKm.value]);
        if(rideResult != null && rideResult) {
          if (Utils().getBox("company_booking_system") == "bidding")Get.back();
          getCurrentRide();
        }
      }
    }
  }

  void connectSocket() {
    SocketService().connect();
  }

  void disconnectSocket() {
    SocketService().disconnect();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      print("📌 App Resumed -> Connect Socket");
      connectSocket();
    } else {
      disconnectSocket();
    }
  }

  storeToken() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
    String firebaseToken = (await firebaseMessaging.getToken()) ?? "";
    String udId = await FlutterUdid.udid;
    var body = {
      "fcm_token": firebaseToken,
      "device_token": udId
    };

    await GeneralService().storeToken(body: body);
  }

  getCurrentRide() async {
    var result = await BookingService().getCurrentRide();

    if(result != null && result.currentBooking != null) {
      currentBooking = result.currentBooking;
      pickupPointId.value = '';
      pickupLat.value = '';
      pickupLong.value = '';
      pickupController.text = '';
      destinationController.text = '';
      dropLat.value = '';
      dropLong.value = '';
      dropPointId.value = '';
      fareKm.value = '';
      farePrice.value = '';
      type.value = 'local';
      rateController.text = '';
      noteController.text = '';
      paymentMethod.value = 'Cash';
      bookingDate.value = '';
      pickupTime.value = '';
      when.value = 'now';
      update();
    }
  }

  validateReason() {
    if(reasonKey.currentState!.validate()) {
      cancelBooking();
    } else {
      reasonAutoValidate.value = AutovalidateMode.always;
    }
    update();
  }

  cancelBooking() async {
    Utils.showLoadingDialog();
    var body = {
      "booking_id": (currentBooking?.id ?? 0).toString(),
      "cancel_reason": cancelReasonController.text.trim()
    };
    var result = await BookingService().cancelBooking(body: body);
    if(Get.isDialogOpen ?? false)Get.back();
    if(result != null) {
      Get.back();
      currentBooking = null;
      update();
    }
  }
  
  getSocketEvent() {
    SocketService().socket?.on("user-ride-status-event", (data) {
      print("Ride Updated");
      if(currentBooking != null) {
        if(data['status'] == "ride_started") {
          currentBooking?.bookingStatus = 'started';
        } else if(data['status'] == "complete_current_ride") {
          currentBooking = null;
        } else if(data['status'] == "arrived_driver") {
          currentBooking?.bookingStatus = "arrived";
        } else if(data['status'] == "cancel_confirm_ride") {
          currentBooking = null;
        }
        update();
      }
    },);
  }

  determinePosition() async {
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
    var location = await Geolocator.getCurrentPosition();

    if (Utils().getMap()) {
      currentPosition = CameraPosition(target: LatLng(location.latitude, location.longitude), zoom: 16);
      if (mapController != null) {
        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(location.latitude, location.longitude),
              zoom: 16,
            ),
          ),
        );
      }
      print("Marker ADDED");
    } else {
      mCurrentPosition = m.CameraPosition(
          target: m.LatLng(location.latitude, location.longitude),
          zoom: 16
      );
      if(mController!=null) {
        mController!
            .animateCamera(m.CameraUpdate.newLatLngZoom(
            m.LatLng(location.latitude, location.longitude), 16));
      }
    }
  }
}