import 'package:cabifyit/app/data/services/general_service.dart';
import 'package:get/get.dart';

class ContentController extends GetxController {
  var title = "";
  var content = "".obs;
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    List args = Get.arguments ?? [];
    if((args).isNotEmpty) {
      title = args.first;
    }
    getContent();
  }

  getContent() async {
    isLoading.value = true;
    var result = await GeneralService().getContent();
    isLoading.value = false;
    if(result != null && result['data'] != null) {
      if(title.toLowerCase().contains("privacy")) {
        content.value = result['data']['privacy_policy'] ?? "";
      } else if(title.toLowerCase().contains("terms")) {
        content.value = result['data']['terms_conditions'] ?? "";
      } else if (title.toLowerCase().contains("about")) {
        content.value = result['data']['about_us'] ?? "";
      }
    }
    update();
  }
}