import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_colors.dart';
import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../reusability/shared/textfied.dart';
import '../controller/wallet_controller.dart';

class WalletView extends GetView<WalletController> {

  @override
  var controller = Get.put(WalletController());

  WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "Wallet"),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Get.width * 0.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white
              ),
              child: Column(
                children: [
                  Obx(() => Text("${Utils().getCurrencySymbol()}${controller.wallet.value}", style: AppTextStyle.size22MediumAppBlackText.copyWith(fontSize: 30))),
                  SizedBox(height: 5),
                  Text("Total Balance", style: AppTextStyle.size16RegularAppBlackText),
                  SizedBox(height: 20),
                  SizedBox(
                    width: Get.width * 0.9,
                    child: MaterialButton(
                      onPressed: () {
                        commonBottomSheet(addAmount());
                      },
                      height: 55,
                      elevation: 0.5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: AppColors.appPrimaryColor)
                      ),
                      color: AppColors.appPrimaryColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppIcons.walletAdd, height: Get.width * 0.05),
                          SizedBox(width: Get.width * 0.02),
                          Text(
                            "Add Balance",
                            textAlign: TextAlign.center,
                            style: AppTextStyle.size14MediumAppBlackText.copyWith(fontSize: 16, color: AppColors.white, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lightBlue),
                  color: AppColors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text("Balance History", style: AppTextStyle.size16MediumAppBlackText),
                    SizedBox(height: 10),
                    Expanded(
                      child: GetBuilder<WalletController>(
                        builder: (context) {
                          return controller.isLoading.value ? Center(child: loader()):
                          controller.history.isEmpty ? Center(child: noDataFound()):
                          ListView.builder(
                            itemCount: controller.history.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              var transaction = controller.history[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: transaction.type == 'add' ? AppColors.green.withValues(alpha: 0.1) : AppColors.red.withValues(alpha: 0.1)
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("${Utils().getCurrencySymbol()}${transaction.amount}", style: AppTextStyle.size14MediumAppBlackText.copyWith(color: transaction.type == 'add' ? AppColors.green : AppColors.red, fontSize: 24)),
                                        Text(transaction.comment ?? "", style: AppTextStyle.size14RegularAppBlackText)
                                      ],
                                    ),
                                  ),
                                  Image.asset(transaction.type == 'add' ? AppIcons.moneyReceive:AppIcons.moneySend, width: Get.width * 0.07),
                                  SizedBox(width: Get.width * 0.03),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("On ${DateFormat('dd/MM/yyyy').format(DateTime.parse(transaction.createdAt ?? DateTime.now().toString()))}", style: AppTextStyle.size14MediumAppBlackText),
                                      Text(DateFormat('hh:mm a').format(DateTime.parse(transaction.createdAt ?? DateTime.now().toString())), style: AppTextStyle.size12RegularAppBlackText)
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },);
                        }
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  Widget addAmount() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(left: Get.width * 0.07, right: Get.width * 0.07, bottom: 50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          SizedBox(height: 10),
          Center(child: Text("Add Money", style: AppTextStyle.size16RegularAppBlackText.copyWith(fontSize: 22))),
          SizedBox(height: 10),
          Text("If your transaction fails and money deducted from your account, it will be credited in your account within 24 hours. If not please create ticket in support.", textAlign: TextAlign.center, style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
          SizedBox(height: 20),
          TextFieldTheme.buildTextFiled(
              hintText: "Amount",
              controller: controller.amountController,
              borderColor: AppColors.grey,
              hintStyle: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey),
              height: 50
          ),
          // SizedBox(height: 20),
          // Row(
          //   children: [
          //     Expanded(child: Text("Amount (This comes to us)", style: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey))),
          //     Text("${Utils().getCurrency()}50.00", style: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey)),
          //   ],
          // ),
          // SizedBox(height: 5),
          // Divider(color: AppColors.lightBlue),
          // SizedBox(height: 5),
          // Row(
          //   children: [
          //     Expanded(child: Text("Total", style: AppTextStyle.size14MediumAppBlackText)),
          //     Text("${Utils().getCurrency()}59.00", style: AppTextStyle.size14MediumAppBlackText),
          //   ],
          // ),
          SizedBox(height: 30),
          Row(
            children: [
              Image.asset(AppIcons.note, width: Get.width * 0.05),
              SizedBox(width: Get.width * 0.02),
              Text("Note", style: AppTextStyle.size16MediumAppBlackText)
            ],
          ),
          SizedBox(height: 10),
          Text("Please do not close app until your amount credited into your wallet. Otherwise yur amount will be lose.", style: AppTextStyle.size12RegularAppBlackText),
          SizedBox(height: 20),
          AppWidgets.buildButton(
            title: "Add",
            btnWidthRatio: 1,
            onPress: () {
              controller.createPaymentIntent();
            },
          ),
        ],
      ),
    );
  }
}