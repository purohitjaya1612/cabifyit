import 'package:get/get.dart';

import '../controller/tickets_controller.dart';

class TicketsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TicketsController>(
          () => TicketsController(),
    );
  }
}
