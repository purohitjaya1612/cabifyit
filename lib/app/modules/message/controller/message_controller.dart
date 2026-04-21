import 'package:cabifyit/app/data/services/message_service.dart';
import 'package:cabifyit/app/data/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/model/message_model.dart';

class MessageController extends GetxController {
  var isLoading = true.obs;
  MessageService messageService = MessageService();
  TextEditingController messageController = TextEditingController();
  var rideId = '';
  var driverId = '';
  var driverName = '';
  var driverProfile = '';
  var rideStatus = '';
  List<MessageData> messages = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    List args = Get.arguments ?? [];
    if(args.isNotEmpty) {
      rideId = args.first ?? "";
      driverId = args[1] ?? "";
      driverName = args[2] ?? "";
      driverProfile = args[3] ?? "";
      rideStatus = args[4] ?? "";
      getMessage();
      getNewMessage();
    }
  }

  getMessage() async {
    isLoading.value = true;
    var result = await messageService.getMessage(params: "?ride_id=$rideId");
    isLoading.value = false;

    if(result != null) {
      messages.addAll(result.data ?? []);
    }
    update();
  }

  sendMessage() async {
    if(messageController.text.trim().isEmpty)return;
    var body = {
      "driver_id": driverId,
      "ride_id": rideId,
      'message': messageController.text.trim()
    };
    var result = await messageService.sendMessage(body: body);

    if(result != null) {
      messageController.text = '';
      var message = MessageData.fromJson(result['chat']);
      messages.insert(0, message);
      update();
    }
  }

  getNewMessage() {
    SocketService().socket?.on("user-message-event", (data) {
      if((data['ride_id'] ?? "").toString() == rideId) {
        var message = MessageData.fromJson(data);
        messages.insert(0, message);
        update();
      }
    },);
  }
}