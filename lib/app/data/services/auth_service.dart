import 'dart:convert';

import 'package:cabifyit/app/data/model/common_model.dart';
import 'package:http/http.dart' as http;

import '../../../reusability/utils/utils.dart';
import '../network/network.dart';
import 'api_url_list.dart';

class AuthService {
  NetworkHandler networkHandler = NetworkHandler();

  Future login({client, body, tenant}) async {
    client ??= http.Client();

    var url = ApiUrlList.loginApi;
    var result = await networkHandler.postWithoutToken(url, client, model: body, returnOriginalResponse: true, tenant: tenant);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  Future<CommonModel?> register({client, body, tenant}) async {
    client ??= http.Client();

    var url = ApiUrlList.registerApi;
    var result = await networkHandler.postWithoutToken(url, client, model: body, tenant: tenant);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  verifyOtp({client, body}) async {
    client ??= http.Client();

    var url = ApiUrlList.verifyOtpApi;
    var result = await networkHandler.postWithoutToken(url, client, model: body);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  Future<CommonModel?> logout({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.logoutApi;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<CommonModel?> deleteAccount({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.deleteAccountApi;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }
}