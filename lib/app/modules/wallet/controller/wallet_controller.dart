import 'dart:convert';

import 'package:cabifyit/app/data/model/transaction_model.dart';
import 'package:cabifyit/app/data/services/wallet_service.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_images.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../data/services/profile_service.dart';

class WalletController extends GetxController {
  TextEditingController amountController = TextEditingController();
  WalletService walletService = WalletService();
  var isLoading = true.obs;
  List<TransactionData> history = [];
  var wallet = '0'.obs;

  @override
  void onInit() {
    super.onInit();
    getHistory();
    getProfile();
  }

  initPayment({required data}) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: data['client_secret'],
          merchantDisplayName: "Cabifyit",
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      addPayment();
    } on StripeException catch (e) {
      print("Stripe error: ${e.error.localizedMessage}");

      if (e.error.code == FailureCode.Canceled) {
        Utils.toastError("Payment cancelled by user");
      } else {
        Utils.toastError(e.error.localizedMessage ?? "Payment failed");
      }
    } catch (e) {
      Utils.toastError("Payment Fail!");
    }
  }

  createPaymentIntent() async {
    if(amountController.text.trim().isEmpty) {
      Utils.toastError("Please enter amount");
      return;
    }
    Utils.showLoadingDialog();
    var amount = (int.tryParse(amountController.text.trim()) ?? 0) * 100;
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization': 'Bearer ${Utils().getStripeKey()}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': amount.toString(),
        'currency': Utils().getCurrency(),
      },
    );
    if(Get.isDialogOpen ?? false)Get.back();
    print("Status Code : ${response.statusCode}");
    print("Body : ${response.body}");

    if (response.statusCode == 200) {
      initPayment(data: jsonDecode(response.body));
    }
  }

  addPayment() async {
    Get.back();
    Utils.showLoadingDialog();
    var body = {
      "amount": (int.tryParse(amountController.text.trim()) ?? 0).toString(),
      "comment": "Topup"
    };

    var result = await walletService.addAmount(body: body);
    if(Get.isDialogOpen ?? false)Get.back();
    if(result != null) {
      amountController.text = "";
      getHistory();
      getProfile();
      commonBottomSheet(success());
    }
  }

  getHistory() async {
    isLoading.value = true;
    update();
    var result = await walletService.getHistory();
    isLoading.value = false;

    if(result != null) {
      history.clear();
      history.addAll(result.data ?? []);
    }
    update();
  }

  Widget success() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: 50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: Get.width * 0.1,
                width: Get.width * 0.1,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                ),
                child: Icon(Icons.close),
              ),
            ),
          ),
          Image.asset(AppImages.success, width: Get.width * 0.2),
          SizedBox(height: 20),
          Text("Your money has been added successfully. It will be credited in your account within 24 hours. If not please create ticket in support.", textAlign: TextAlign.center, style: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey)),
          SizedBox(height: 20),
          AppWidgets.buildButton(
            title: "Okay",
            btnWidthRatio: 1,
            onPress: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  getProfile() async {
    var result = await ProfileService().getProfile();

    if(result != null) {
      Utils().setBox("userEmail", result.data?.email ?? "");
      Utils().setBox("userPhone", result.data?.phoneNo ?? "");
      Utils().setBox("userName", result.data?.name?? "");
      Utils().setBox("userCountryCode", result.data?.countryCode ?? "");
      Utils().setBox("userImage", result.data?.profile ?? "");
      Utils().setBox("walletBalance", result.data?.walletBalance ?? "");
      wallet.value = result.data?.walletBalance ?? "";
    }
  }
}