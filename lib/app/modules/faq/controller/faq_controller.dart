import 'package:cabifyit/app/data/model/faq_model.dart';
import 'package:cabifyit/app/data/services/general_service.dart';
import 'package:get/get.dart';

class FaqController extends GetxController {
  var isLoading = true.obs;
  List<FaqData> faqs = [];

  @override
  void onInit() {
    super.onInit();
    getFaqs();
  }

  getFaqs() async {
    isLoading.value = true;
    var result = await GeneralService().getFaqs();
    isLoading.value = false;

    if(result != null) {
      faqs.addAll(result.data ?? []);
    }
    update();
  }
}