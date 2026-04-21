import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_udid/flutter_udid.dart';
import 'package:get/get.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../data/services/auth_service.dart';
import '../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController tenantController = TextEditingController();
  var countryCode = "+92".obs;
  var deviceToken = "".obs;
  var firebaseToken = "".obs;
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    List args = Get.arguments ?? [];
    if(args.isNotEmpty) {
      phoneNumberController.text = args.first;
      countryCode.value = args[1];
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  getFCMToken() async {
    deviceToken.value = await FlutterUdid.udid;
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    firebaseToken.value = (await firebaseMessaging.getToken())!;

    print("Firebase Token : ${firebaseToken.value}");
  }

  register() async {
    Utils.showLoadingDialog();
    var body = {
      "name": nameController.text,
      "email": emailController.text,
      "phone": phoneNumberController.text.trim(),
      "country_code": countryCode.value
    };
    var result = await AuthService().register(body: body, tenant: tenantController.text.trim());
    if(Get.isDialogOpen ?? false) Get.back();
    if(result != null) {
      Utils().setTenantId(tenantController.text.trim());
      Get.toNamed(Routes.VERIFY_OTP, arguments: [phoneNumberController.text.trim(), countryCode.value, emailController.text.trim()]);
    }
  }

  validate() {
    if(formKey.currentState!.validate()) {
      register();
    } else {
      autoValidate.value = AutovalidateMode.always;
    }
    update();
  }
}