import 'dart:convert';

import 'package:cabifyit/app/data/model/chat_model.dart';
import 'package:http/http.dart' as http;

import '../../../reusability/utils/utils.dart';
import '../model/message_model.dart';
import '../network/network.dart';
import 'api_url_list.dart';

class MessageService {
  NetworkHandler networkHandler = NetworkHandler();

  Future<ChatResponse?> getChat({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.getChats;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return ChatResponse.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<MessageModel?> getMessage({client, params}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = "${ApiUrlList.getMessages}$params";
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return MessageModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future sendMessage({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.sendMessages;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }
}