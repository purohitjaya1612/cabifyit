import 'dart:convert';

import 'package:cabifyit/app/data/model/common_model.dart';
import 'package:cabifyit/app/data/model/current_ride_model.dart';
import 'package:cabifyit/app/data/model/vehicle_list_model.dart';
import 'package:cabifyit/app/data/network/network.dart';
import 'package:http/http.dart' as http;

import '../../../reusability/utils/utils.dart';
import '../model/rides_model.dart';
import 'api_url_list.dart';

class BookingService {
  NetworkHandler networkHandler = NetworkHandler();

  Future<VehicleListModel?> getVehicles({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.getVehicles;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return VehicleListModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future getFare({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.calculatePrice;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  Future createBooking({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.placeRide;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return jsonDecode(result);
    } else {
      return null;
    }
  }

  Future<CommonModel?> cancelRide({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.cancelRide;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<CommonModel?> cancelBooking({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.cancelCurrentRide;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<CurrentBookingResponse?> getCurrentRide({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.getCurrentRide;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return CurrentBookingResponse.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<RidesModel?> getRides({client, params, type}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.getCompletedRides;
    if(type == 'cancelled') {
      url = ApiUrlList.getCancelledRides;
    }
    if(type == 'upcoming') {
      url = ApiUrlList.getUpcomingRides;
    }

    url = url + params;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return RidesModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<RidesModel?> changeBidStatus({client, body, type}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.changeBidStatus;

    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return RidesModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<CommonModel?> rateDriver({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.rateRide;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }
}