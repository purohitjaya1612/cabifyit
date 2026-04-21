import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/splash_controller.dart';

class SplashView extends GetView<SplashController> {
 SplashView({super.key});

  @override
  var controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.2),
        child: Image.asset(AppImages.splash, width: Get.width * 0.6),
      ),
    );
  }
}
