import 'package:get/get.dart';
import '../controller/driver_location_controller.dart';

class DriverLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DriverLocationController>(
          () => DriverLocationController(),
    );
  }
}
