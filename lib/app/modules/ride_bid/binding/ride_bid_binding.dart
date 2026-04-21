import 'package:get/get.dart';

import '../controller/ride_bid_controller.dart';

class RideBidBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RideBidController>(
          () => RideBidController(),
    );
  }
}
