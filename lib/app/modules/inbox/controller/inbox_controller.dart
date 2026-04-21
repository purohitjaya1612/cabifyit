import 'package:cabifyit/app/data/services/message_service.dart';
import 'package:get/get.dart';

import '../../../data/model/chat_model.dart';

class InboxController extends GetxController {
  var isLoading = true.obs;
  List<ChatMessage> chats = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getChats();
  }

  getChats() async {
    isLoading.value = true;
    var result = await MessageService().getChat();
    isLoading.value = false;
    if(result != null) {
      chats.addAll(result.list);
    }
    update();
  }
}