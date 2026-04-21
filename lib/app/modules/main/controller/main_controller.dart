import 'dart:async';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class MainController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    Timer(const Duration(milliseconds: 500), () => Get.offNamed(Routes.SPLASH));
  }

}