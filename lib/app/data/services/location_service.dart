import 'dart:convert';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:http/http.dart' as http;
import '../model/places_model.dart';
import '../network/network.dart';
import 'api_url_list.dart';

class LocationService {
  NetworkHandler networkHandler = NetworkHandler();

  Future<PlacesModel?> getPlaces({client, params, isNearby = false}) async {
    client ??= http.Client();

    var url = "${ApiUrlList.findPlaces}$params";
    var result = await networkHandler.getWithoutToken(url, client);

    if(result != null) {
      return PlacesModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future getAddress({client, params}) async {
    client ??= http.Client();

    var url = "${ApiUrlList.getAddress}$params";
    var result = await networkHandler.getWithoutToken(url, client);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  Future getPlot({client, body, isNearby = false}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.getPlots;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }
}