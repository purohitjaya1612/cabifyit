import 'package:get/get.dart';

import '../controller/rides_controller.dart';

class RidesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RidesController>(
          () => RidesController(),
    );
  }
}
