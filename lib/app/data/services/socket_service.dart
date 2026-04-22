import 'dart:developer';

import 'package:cabifyit/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect() {
    final currentSocket = socket;
    if (currentSocket != null &&
        (currentSocket.connected || currentSocket.disconnected == false)) {
      return;
    }

    var url = 'https://backend.cabifyit.com';
    socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setExtraHeaders({
        "Authorization": Utils().getToken() ?? ""
      })
          .setQuery({
        "role": "user",
        "user_id": Utils().getUserId() ?? "",
        "database": Utils().getTenantId(),
      })
          .build(),
    );

    print("URL : ${socket!.io.uri}, Options : ${socket!.io.options}, Query : ${socket!.query}");

    socket!.onConnect((_) {
      print("✅ Socket Connected: ${socket!.id}");
      Get.find<DashBoardController>().getSocketEvent();
    });

    socket!.onDisconnect((_) {
      print("❌ Socket Disconnected");
    });

    socket!.onConnectError((data) => print("⚠️ Connect Error: $data"));
    socket!.onError((data) => print("⚠️ Error: $data"));


    socket!.onAny((event, data) {
      log("New Event $event, $data");
    },);
  }

  void disconnect() {
    if (socket == null) return;
    socket?.disconnect();
    socket?.dispose();
    socket = null;
  }

  void emitEvent(String event, dynamic data) {
    print("Emitting : $event, $data");
    socket?.emit(event, data);
  }

  void listenEvent(String event, Function(dynamic) callback) {
    socket?.on(event, callback);
  }
}
