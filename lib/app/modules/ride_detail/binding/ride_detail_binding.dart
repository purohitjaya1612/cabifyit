import 'package:get/get.dart';

import '../controller/ride_detail_controller.dart';

class RideDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideDetailController>(
          () => RideDetailController(),
    );
  }
}
