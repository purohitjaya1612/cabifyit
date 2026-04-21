import 'dart:async';
import 'package:get/get.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {

  @override
  void onInit() {
    super.onInit();
    redirectScreen();
  }

  redirectScreen() async {
    await Future.delayed(Duration(seconds: 2));
    if (!Utils().isOnboardingCompleted()) {
      Get.offNamed(Routes.ONBOARDING);
    } else {
      if (Utils().isLogin()) {
        Get.offNamed(Routes.DASHBOARD);
      } else {
        Get.offNamed(Routes.LOGIN);
      }
    }
  }
}