import 'dart:convert';

import 'package:cabifyit/app/data/network/network.dart';
import 'package:http/http.dart' as http;

import '../../../reusability/utils/utils.dart';
import '../model/common_model.dart';
import '../model/transaction_model.dart';
import 'api_url_list.dart';

class WalletService {
  NetworkHandler networkHandler = NetworkHandler();

  Future<CommonModel?> addAmount({client, body}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.addMoney;
    var result = await networkHandler.post(url, client, token, model: body);

    if(result != null) {
      return CommonModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }

  Future<TransactionModel?> getHistory({client}) async {
    client ??= http.Client();
    var token = Utils().getToken() ?? "";

    var url = ApiUrlList.walletHistory;
    var result = await networkHandler.get(url, client, token);

    if(result != null) {
      return TransactionModel.fromJson(jsonDecode(result));
    } else {
      return null;
    }
  }
}