import 'package:get/get.dart';

import '../../../data/model/notification_model.dart';
import '../../../data/services/general_service.dart';

class NotificationController extends GetxController {

  var isLoading = true.obs;
  List<NotificationData> notification = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getNotification();
  }

  getNotification() async {
    isLoading.value = true;
    var result = await GeneralService().getNotification();
    isLoading.value = false;

    if(result != null) {
      notification.addAll(result.data ?? []);
    }
    update();
  }
}