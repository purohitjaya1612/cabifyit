import 'package:get/get.dart';

import '../controller/safety_controller.dart';

class SafetyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SafetyController>(
          () => SafetyController(),
    );
  }
}
