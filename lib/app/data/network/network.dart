import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../reusability/utils/utils.dart';
import 'exception.dart';

class NetworkHandler {
  Future<dynamic> post(String url, http.Client client, token, {dynamic model, bool showError = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
      'database': Utils().getTenantId()
    };

    var responseData;
    try {
      final http.Response response = await client.post(Uri.parse(url),
          headers: headers, body: model != null ? jsonEncode(model) : null);
      logData(url: url, response: response, method: "POST", model: jsonEncode(model), header: headers);
      responseData = returnResponse(
        response,
        url,
        "POST",
        model: model,
        showError: showError,
      );
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseData;
  }

  Future<dynamic> delete(String url, http.Client client, token, {dynamic model}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
      'database': Utils().getTenantId()
    };
    var responseData;
    try {
      final http.Response response = await client.delete(Uri.parse(url),
          headers: headers, body: model != null ? jsonEncode(model) : null);
      logData(url: url, response: response, method: "DELETE", model: model, header: headers);
      responseData = returnResponse(response, url, "DELETE", model: model);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseData;
  }

  Future<dynamic> postMultiPartData(String url, http.Client client, token, {Map<String, String>? model, List<http.MultipartFile>? files,bool showError = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
      'database': Utils().getTenantId()
    };

    var responseJson;
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      request.headers.addAll(headers);
      if(files!=null) {
        request.files.addAll(files);
      }
      request.fields.addAll(model ?? {});
      var response = await request.send();

      var responseData = await http.Response.fromStream(response);
      logData(url: url, response: responseData, method: "POST", model: request.fields, header: headers, files: request.files);
      responseJson = returnResponse(responseData, url, "POST", model: model, showError: showError);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseJson;
  }

  Future<dynamic> put(String url, http.Client client, token, {dynamic model}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
      'database': Utils().getTenantId()
    };
    var responseData;
    try {
      final http.Response response = await client.put(Uri.parse(url),
          headers: headers, body: model != null ? jsonEncode(model) : null);
      logData(url: url, response: response, method: "PUT", model: model,header: headers);
      responseData = returnResponse(response, url, "PUT", model: model);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
    return responseData;
  }

  Future<dynamic> get(String url, http.Client client, token, {bool showError = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: token,
      'database': Utils().getTenantId()
    };
    var responseData;
    try {
      http.Response response =
      await client.get(Uri.parse(url), headers: headers);
      logData(url: url, response: response, method: "GET",header: headers);
        responseData = returnResponse(response, url, "GET",showError: showError);
    } on SocketException {
      throw FetchDataException('No Internet connection');
    } finally {}
    return responseData;
  }

  Future<dynamic> getWithoutToken(String url, http.Client client) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'database': Utils().getTenantId()
    };
    var responseData;
    try {
      final http.Response response =
      await client.get(Uri.parse(url), headers: headers);
      logData(url: url, response: response, method: "GET",header: headers);
      responseData = returnResponse(response, url, "GET");
    } on Exception {
      throw FetchDataException('No Internet connection');
    }
    return responseData;
  }

  Future<dynamic> postWithoutToken(String url, http.Client client, {dynamic model,bool showError = true, bool returnOriginalResponse = false, String? tenant}) async {
    Map<String, String> headers = {'Content-Type': 'application/json; charset=UTF-8','database': tenant ?? Utils().getTenantId()};
    var responseData;
    try {
      final http.Response response = await client.post(Uri.parse(url),
          headers: headers, body: jsonEncode(model));
      logData(url: url, response: response, method: "POST", model: model,header: headers);
      responseData =
          returnResponse(response, url, "POST", model: model, showError: showError, returnOriginalResponse: returnOriginalResponse);
    } on Exception {
      throw FetchDataException('No Internet connection');
    }
    return responseData;
  }

  dynamic returnResponse(http.Response response, url, method, {bool toLogin = true, model, bool showError = true, bool returnOriginalResponse = false}) async {
    if(Get.isDialogOpen ?? false) {
      Get.back();
    }
    switch (response.statusCode) {
      case 200:
        return getResponse(response,url, method, toLogin: toLogin, model: model, showError: showError, returnOriginalResponse: returnOriginalResponse);
      case 201:
        return getResponse(response,url, method, toLogin: toLogin, model: model, showError: showError, returnOriginalResponse: returnOriginalResponse);
      case 400:
        if(showError)Utils.toastWarning(jsonDecode(response.body)['message'] ?? " ");
        if(returnOriginalResponse) {
          return response.body;
        } else {
          return null;
        }
      case 401:
        Utils().logOutData();
        Utils.toastWarning("Session Expired!. Please Login Again");
        return null;
      case 403:
        if(showError)Utils.toastWarning("Something went wrong! ");
        var responseJson = response.body;
        return responseJson;
      case 404:
        if(showError)Utils.toastWarning("Something went wrong! ");
        return null;
      case 500:
        if(showError)Utils.toastWarning("Something went wrong! ");
        return null;
      default:
        if(showError)Utils.toastWarning("Something went wrong! ");
        return null;
    }
  }

  dynamic getResponse(http.Response response, url, method, {bool toLogin = true, model, bool showError = true, bool returnOriginalResponse = false}) async {
    if(Get.isDialogOpen ?? false) {
      Get.back();
    }
    if (jsonDecode(response.body)['error'] == null) {
        var responseJson = response.body;
        return responseJson;
    } else {
      if(showError)Utils.toastWarning(jsonDecode(response.body)['message'] ?? " ");
      if(returnOriginalResponse) {
        return response.body;
      } else {
        return null;
      }
    }
  }

  logData({required String url, required http.Response response, required String method, model, header, List? files}) {
    log("url: $url");
    log("model: $model");
    log("status code: ${response.statusCode}");
    log("response: ${response.body}");
    log("method: $method");
    log("header: $header");
    if((files ?? []).isNotEmpty)log("files: $files");
  }
}
