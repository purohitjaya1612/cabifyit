import 'package:cabifyit/app/data/services/auth_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController tenantController = TextEditingController();
  var countryCode = "+92".obs;
  var firebaseToken = "".obs;
  var deviceToken = "".obs;
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;
  var loginResultData;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getFCMToken();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  getFCMToken() async {
    deviceToken.value = await FlutterUdid.udid;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(alert: true, badge: true, sound: true);
    firebaseToken.value = (await firebaseMessaging.getToken())!;

    print("Firebase Token : ${firebaseToken.value}");
  }

  login() async {
    Utils.showLoadingDialog();
    var body = {
      "phone": phoneNumberController.text.trim(),
      "country_code": countryCode.value
    };
    var result = await AuthService().login(body: body, tenant: tenantController.text.trim());
    if(Get.isDialogOpen ?? false) Get.back();
    if(result != null) {
      if(result['message'] == "User not exists with this Phone No.") {
        Get.toNamed(Routes.REGISTER, arguments: [phoneNumberController.text.trim(), countryCode.value]);
      } else if (result['success'] == 1)  {
        Utils().setTenantId(tenantController.text.trim());
          Get.toNamed(Routes.VERIFY_OTP, arguments: [
            phoneNumberController.text.trim(),
            countryCode.value
          ]);
      }
    }
  }

  validate() {
    if(formKey.currentState!.validate()) {
      login();
    } else {
      autoValidate.value = AutovalidateMode.always;
    }
    update();
  }
}