import 'dart:convert';

import 'package:cabifyit/app/data/model/common_model.dart';
import 'package:cabifyit/app/data/model/profile_model.dart';
import 'package:cabifyit/app/data/network/network.dart';
import 'package:http/http.dart' as http;

import '../../../reusability/utils/utils.dart';
import 'api_url_list.dart';

class ProfileService {
  NetworkHandler networkHandler = NetworkHandler();

  Future<ProfileModel?> getProfile({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.getProfile;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return ProfileModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }


  Future<CommonModel?> updateProfile({client, body, files}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.updateProfile;
    var result = await networkHandler.postMultiPartData(url, client, token, model: body, files: files);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }
}