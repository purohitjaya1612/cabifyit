import 'dart:async';

import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_images.dart';
import '../controller/ride_bid_controller.dart';

class RideBidView extends GetView<RideBidController> {

  @override
  final controller = Get.put(RideBidController());

  RideBidView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        controller.cancelRide(goBack: true);
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom, left: Get.width * 0.05, right: Get.width * 0.05),
          child: GetBuilder<RideBidController>(
            builder: (context) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: controller.bids.length,
                      itemBuilder: (context, index) {
                        var bid = controller.bids[index];
                        return Container(
                          padding: EdgeInsets.all(Get.width * 0.05),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text("Amount From Driver", style: AppTextStyle.size14MediumAppBlackText),
                                  Spacer(),
                                  Image.asset(AppImages.arrow, color: AppColors.textGrey, width: Get.width * 0.2),
                                  Spacer(),
                                  Text("${Utils().getCurrencySymbol()}${bid['amount']}", textAlign: TextAlign.end, style: AppTextStyle.size18MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  SizedBox(width: Get.width * 0.01),
                                  CachedNetworkImage(
                                    imageUrl: getImage(bid['profile_image'] ?? ""),
                                    imageBuilder: (context, imageProvider) {
                                      return Container(
                                        height: Get.width * 0.1,
                                        width: Get.width * 0.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
                                        ),
                                      );
                                    },
                                    progressIndicatorBuilder: (context, url, progress) {
                                      return Container(
                                        height: Get.width * 0.1,
                                        width: Get.width * 0.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.white
                                        ),
                                        child: loader(),
                                      );
                                    },
                                    errorWidget: (context, url, error) {
                                      return Container(
                                        height: Get.width * 0.1,
                                        width: Get.width * 0.1,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: AppColors.white,
                                            image: DecorationImage(image: AssetImage(AppImages.profile), fit: BoxFit.cover)
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(width: Get.width * 0.04),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(bid['driver_name'] ?? "", style: AppTextStyle.size16MediumAppBlackText),
                                        SizedBox(height: 2),
                                        if((bid['rating'] ?? 0).toString() != "0")Row(
                                          children: [
                                            Image.asset(AppIcons.star, width: Get.width * 0.04),
                                            SizedBox(width: 5),
                                            Text((bid['rating'] ?? 0).toString(), style: AppTextStyle.size12RegularAppBlackText),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Divider(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Type", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                          SizedBox(height: Get.height * 0.01),
                                          Text(bid['vehicle_type'] ?? "", style: AppTextStyle.size16MediumAppBlackText),
                                        ]
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Model", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                          SizedBox(height: Get.height * 0.01),
                                          Text(bid['vehicle_name'] ?? "", style: AppTextStyle.size16MediumAppBlackText),
                                        ]
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                      child: AppWidgets.buildButton(
                                        title: "Cancel",
                                        btnColor: AppColors.white,
                                        txtColor: AppColors.red,
                                        borderColor: AppColors.red,
                                        onPress: () {
                                          controller.changeStatus(bidId: (bid['bid_id'] ?? "").toString(), status: "rejected");
                                        },
                                        btnHeight: 40
                                      )
                                  ),
                                  SizedBox(width: Get.width * 0.05),
                                  Expanded(
                                      child: AcceptTimer(
                                          startTime: bid['time'],
                                          onPress: () {
                                            controller.changeStatus(bidId: (bid['bid_id'] ?? "").toString(), status: "accepted");
                                          }
                                      )
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      }
                    ),
                  ),
                  if(controller.bids.isEmpty)Spacer(),
                  waitingWidget()
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget waitingWidget() {
    return GetBuilder<RideBidController>(
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(Get.width * 0.05),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              children: [
                Text("Finding nearest driver for you", style: AppTextStyle.size20MediumAppBlackText),
                if(controller.bids.isEmpty)SizedBox(height: Get.height * 0.02),
                if(controller.bids.isEmpty)Lottie.asset('assets/lottie/car_drive.json'),
                SizedBox(height: Get.height * 0.02),
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.lightBlue)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${controller.km.value} KM", style: AppTextStyle.size14MediumAppBlackText),
                      SizedBox(width: Get.width * 0.02),
                      Image.asset(AppImages.arrow, width: Get.width * 0.12),
                      SizedBox(width: Get.width * 0.02),
                      Text("${Utils().getCurrencySymbol()}${controller.amount.value}", style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                      SizedBox(width: Get.width * 0.02),
                      if (Utils().getBox("company_booking_system") != "auto_dispatch")GestureDetector(onTap: () {
                        controller.cancelRide(goBack: false);
                      },child: Image.asset(AppIcons.edit, width: Get.width * 0.04))
                    ],
                  ),
                ),
                SizedBox(height: Get.height * 0.015),
                AppWidgets.buildButton(
                  title: "Cancel Request",
                  btnColor: AppColors.white,
                  borderColor: AppColors.red,
                  txtColor: AppColors.red,
                  btnWidthRatio: 0.8,
                  btnHeight: 50,
                  onPress: () {
                    controller.cancelRide(goBack: true);
                  },
                )
              ],
            ),
          );
        }
    );
  }
}

class AcceptTimer extends StatefulWidget {
  DateTime startTime;
  Function() onPress;
  AcceptTimer({super.key, required this.startTime, required this.onPress});

  @override
  State<AcceptTimer> createState() => _AcceptTimerState();
}

class _AcceptTimerState extends State<AcceptTimer> {
  var remaining = 10;
  late Timer timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateSeconds();
  }

  updateSeconds() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      remaining = 10 - DateTime.now().difference(widget.startTime).inSeconds;
      if(remaining == 0) timer.cancel();
      setState(() {});
    },);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: widget.onPress,
      height: 40,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: AppColors.appPrimaryColor)
      ),
      color: AppColors.white,
      child: Text(
        "Accept $remaining",
        textAlign: TextAlign.center,
        style: AppTextStyle.size14MediumAppBlackText.copyWith(fontSize: 16, color: AppColors.appPrimaryColor, fontWeight: FontWeight.w600),
      ),
    );
  }
}