import 'dart:async';
import 'package:cabifyit/app/data/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../routes/app_pages.dart';

class VerifyOtpController extends GetxController {
  final otpKey = GlobalKey<FormState>();
  var otpAutoValidate = AutovalidateMode.disabled.obs;
  TextEditingController otpController = TextEditingController();
  var firebaseToken = "".obs;
  var deviceToken = "".obs;
  var phone = '';
  var email = ''.obs;
  var countryCode = '';
  late Timer appStateTimer;
  late Timer messageTimer;
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;
  var isOtpSent = false.obs;
  var isLoading = false.obs;
  var remainingSeconds = 300.obs;
  Timer? otpTimer;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    List args = Get.arguments ?? [];
    
    if(args.isNotEmpty) {
      phone = args.first;
      countryCode = args[1];
      if (args.length > 2) {
        email.value = args[2];
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    if(otpTimer != null) otpTimer!.cancel();
  }

  getFCMToken() async {
    deviceToken.value = await FlutterUdid.udid;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    firebaseToken.value = (await firebaseMessaging.getToken())!;

    print("Firebase Token : ${firebaseToken.value}");
  }

  verifyPin() async {
    Utils.showLoadingDialog();
    var body = {
      "phone": phone,
      "country_code": countryCode,
      "otp": otpController.text,
      if(email.isNotEmpty) "email": email.value
    };
    var result = await AuthService().verifyOtp(body: body);
    if(Get.isDialogOpen ?? false) Get.back();
    if(result != null) {
      Utils().setBox("token", result['token'] ?? "");
      Utils().setBox("userId", (result['user']['id'] ?? "").toString());
      Utils().setBox("userEmail", result['user']['email'] ?? "");
      Utils().setBox("userPhone", result['user']['phone_no'] ?? "");
      Utils().setBox("userName", result['user']['name'] ?? "");
      Utils().setBox("userImage", result['user']['profile'] ?? "");
      Utils().setBox("userCountryCode", result['user']['country_code'] ?? "");
      Utils().setLogin(true);
      Get.offNamedUntil(Routes.DASHBOARD, (route) => false);
    }
  }


  verifyPassword() async {
    Utils.showLoadingDialog();
    var body = {
      "phone": phone,
      "country_code": countryCode,
      "password": otpController.text
    };
    var result = await AuthService().verifyPassword(body: body);
    if(Get.isDialogOpen ?? false) Get.back();
    if(result != null) {
      Utils().setBox("token", result['token'] ?? "");
      Utils().setBox("userId", (result['user']['id'] ?? "").toString());
      Utils().setBox("userEmail", result['user']['email'] ?? "");
      Utils().setBox("userPhone", result['user']['phone_no'] ?? "");
      Utils().setBox("userName", result['user']['name'] ?? "");
      Utils().setBox("userImage", result['user']['profile'] ?? "");
      Utils().setBox("userCountryCode", result['user']['country_code'] ?? "");
      Utils().setLogin(true);
      Get.offNamedUntil(Routes.DASHBOARD, (route) => false);
    }
  }

  startOtpTimer() {
    otpTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      remainingSeconds.value = remainingSeconds.value - 1;
      if(remainingSeconds.value == 0) {
        otpTimer!.cancel();
      }
      update();
    });
  }

  validateOtp() {
    if(formKey.currentState!.validate()) {
      verifyPin();
    } else {
      otpAutoValidate.value = AutovalidateMode.always;
    }
    update();
  }

  validatePassword() {
    if(formKey.currentState!.validate()) {
      verifyPassword();
    } else {
      otpAutoValidate.value = AutovalidateMode.always;
    }
    update();
  }
}