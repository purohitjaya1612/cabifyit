import 'dart:convert';

import 'package:cabifyit/app/data/model/common_model.dart';
import 'package:cabifyit/app/data/model/faq_model.dart';
import 'package:cabifyit/app/data/model/tickets_model.dart';
import 'package:cabifyit/app/data/network/network.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:http/http.dart' as http;

import '../model/notification_model.dart';
import 'api_url_list.dart';

class GeneralService {
  NetworkHandler networkHandler = NetworkHandler();

  Future getContent({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.policies;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  Future<CommonModel?> createContactUs({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.contactUs;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<NotificationModel?> getNotification({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.notificationApi;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return NotificationModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<FaqModel?> getFaqs({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.faqApi;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return FaqModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<TicketsModel?> getMyTicket({client, page}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = "${ApiUrlList.ticketsApi}?page=$page";
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return TicketsModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<CommonModel?> addTicket({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.createTicketApi;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future getApisKey({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.getApiKeys;
    var result = await networkHandler.get(url, client, token, showError: false);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  storeToken({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.storeToken;
    await networkHandler.post(url, client, token, model: body, showError: false);
  }
}