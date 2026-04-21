import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../reusability/shared/textfied.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_images.dart';
import '../controller/ride_detail_controller.dart';

class RideDetailView extends GetView<RideDetailController> {

  @override
  final controller = Get.put(RideDetailController());

  RideDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "${controller.selectedTab.value.capitalizeFirst ?? ""} Ride Details"),
      body: Container(
          color: AppColors.white100,
        padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom:  MediaQuery.of(context).padding.bottom),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if((controller.rideData?.cancelReason ?? "").isNotEmpty)Container(
                width: Get.width,
                padding: EdgeInsets.all(Get.width * 0.05),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Reason for cancellation", style: AppTextStyle.size16MediumAppBlackText),
                    SizedBox(height: 15),
                    Text(controller.rideData?.cancelReason ?? "", style: AppTextStyle.size14RegularAppBlackText),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.width * 0.03),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${Utils().getCurrencySymbol()}${controller.rideData?.bookingAmount ?? '0'}", style: AppTextStyle.size22MediumAppBlackText),
                    SizedBox(height: 10),
                    Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Date", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                SizedBox(height: 5),
                                Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(controller.rideData!.bookingDate)).toString(), style: AppTextStyle.size14MediumAppBlackText),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Journey Type", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                SizedBox(height: 5),
                                Text((controller.rideData?.bookingType ?? "Local").capitalizeFirst ?? "Local", style: AppTextStyle.size14MediumAppBlackText),
                              ],
                            ),
                          ),
                        ]
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              GetBuilder<RideDetailController>(
                builder: (context) {
                  return controller.rideData?.driverDetail == null? Container() :
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.width * 0.03),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.white
                    ),
                    child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: getImage(controller.rideData?.driverDetail?.profileImage ?? ""),
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
                                    borderRadius: BorderRadius.circular(10),
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
                          SizedBox(width: Get.width * 0.03),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(controller.rideData?.driverDetail?.name ?? "", style: AppTextStyle.size16MediumAppBlackText),
                              if(controller.selectedTab.value == 'completed' && ((controller.rideData?.ratingDetail ?? []).isNotEmpty || ((controller.rideData?.ratingDetail ?? []).where((element) => element.userType == 'user').isNotEmpty)))
                                RatingBar.readOnly(filledIcon: Icons.star, emptyIcon: Icons.star_border, isHalfAllowed: true, size: 30, halfFilledIcon: Icons.star_half, initialRating: double.tryParse((controller.rideData?.ratingDetail ?? []).where((element) => element.userType == 'user').first.rating ?? "0") ?? 0,)
                            ],
                          )),
                          if(controller.selectedTab.value == 'completed' && ((controller.rideData?.ratingDetail ?? []).isEmpty || ((controller.rideData?.ratingDetail ?? []).where((element) => element.userType == 'user').isEmpty)))
                            AppWidgets.buildButton(
                              title: "Rate Driver",
                              onPress: () {
                                commonBottomSheet(ratingWidget());
                              },
                              btnWidthRatio: 0.25,
                              btnHeight: 40,
                                btnRadius: 5,
                              txtSize: 10
                            )
                        ]
                    ),
                  );
                }
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(Get.width * 0.05),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Duration", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                              SizedBox(height: 5),
                              Text(controller.selectedTab.value != "completed"?"-":"${(DateTime.tryParse(controller.rideData?.driverDropoffTime ?? DateTime.now().toString()) ?? DateTime.now()).difference((DateTime.tryParse(controller.rideData?.driverPickupTime ?? DateTime.now().toString()) ?? DateTime.now())).inMinutes} min", style: AppTextStyle.size14MediumAppBlackText),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Distance", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                              SizedBox(height: 5),
                              Text("${controller.rideData?.distance ?? "0"} Km", style: AppTextStyle.size14MediumAppBlackText),
                            ],
                          ),
                        ),
                      ]
                    ),
                    SizedBox(height: 15),
                    Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Waiting Time", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                SizedBox(height: 5),
                                Text("${controller.rideData?.waitingTime ?? "0"} min", style: AppTextStyle.size14MediumAppBlackText),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Ride ID", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                SizedBox(height: 5),
                                Text(controller.rideData?.bookingId ?? "", style: AppTextStyle.size14MediumAppBlackText),
                              ],
                            ),
                          ),
                        ]
                    ),
                    SizedBox(height: 15),
                    Container(
                      padding: EdgeInsets.all(Get.width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.green.withValues(alpha: 0.1)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppIcons.location, color: AppColors.green, height: Get.width * 0.05),
                          SizedBox(width: Get.width * 0.02),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Pickup", style: AppTextStyle.size12RegularAppBlackText),
                              SizedBox(height: 5),
                              Text(controller.rideData?.pickupLocation ?? "", style: AppTextStyle.size14MediumAppBlackText),
                            ],
                          ))
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(Get.width * 0.02),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(AppIcons.location, color: AppColors.blue, height: Get.width * 0.05),
                          SizedBox(width: Get.width * 0.02),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Destination", style: AppTextStyle.size12RegularAppBlackText),
                              SizedBox(height: 5),
                              Text(controller.rideData?.destinationLocation ?? "", style: AppTextStyle.size14MediumAppBlackText),
                            ],
                          ))
                        ],
                      ),
                    ),
                    if((controller.rideData?.note ?? "").isNotEmpty)SizedBox(height: 20),
                    if((controller.rideData?.note ?? "").isNotEmpty)RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(text: "Note : ", style: AppTextStyle.size16MediumAppBlackText),
                            TextSpan(text: controller.rideData?.note ?? "", style: AppTextStyle.size14RegularAppBlackText)
                          ]
                        )
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(Get.width * 0.05),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.white
                ),
                child: Row(
                    children: [
                      Image.asset(AppIcons.wallet, width: Get.width * 0.06),
                      SizedBox(width: Get.width * 0.03),
                      Text("Payment Method : ", style: AppTextStyle.size16RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                      Text((controller.rideData?.paymentMethod ?? "Cash").capitalizeFirst ?? "", style: AppTextStyle.size16MediumAppBlackText),
                    ]
                ),
              ),
              SizedBox(height: 10),
              if((controller.selectedTab.value == 'completed' || controller.selectedTab.value == 'upcoming') && controller.rideData?.driverDetail != null)Container(
                padding: EdgeInsets.all(Get.width * 0.05),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Invoice", style: AppTextStyle.size16MediumAppBlackText),
                    SizedBox(height: 10),
                    Row(
                        children: [
                          Expanded(child: Text("Fares", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey))),
                          Text("${Utils().getCurrencySymbol()}${controller.rideData?.bookingAmount ?? "0"}", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                        ]
                    ),
                    SizedBox(height: 10),
                    Row(
                        children: [
                          Expanded(child: Text("Waiting Charge", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey))),
                          Text("${Utils().getCurrencySymbol()}${controller.rideData?.waitingAmount ?? "0"}", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                        ]
                    ),
                    // SizedBox(height: 10),
                    // Row(
                    //     children: [
                    //       Expanded(child: Text("Fee", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey))),
                    //       Text("${Utils().getCurrencySymbol()}199.50", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                    //     ]
                    // ),
                    SizedBox(height: 5),
                    Divider(),
                    SizedBox(height: 5),
                    Row(
                        children: [
                          Expanded(child: Text("Total Fare", style: AppTextStyle.size14MediumAppBlackText)),
                          Text("${Utils().getCurrencySymbol()}${((double.tryParse(controller.rideData?.bookingAmount ?? "0") ?? 0) + (double.tryParse(controller.rideData?.waitingAmount ?? "0") ?? 0))}", style: AppTextStyle.size14MediumAppBlackText),
                        ]
                    ),
                  ],
                ),
              ),
              if(controller.selectedTab.value == 'upcoming')AppWidgets.buildButton(
                  title: "Cancel Ride",
                  btnColor: Colors.white,
                  btnWidthRatio: 0.9,
                  btnHeight: 50,
                  borderColor: AppColors.red,
                  txtColor: AppColors.red,
                  onPress: () {
                    controller.otpAutoValidate.value = AutovalidateMode.disabled;
                    controller.cancelReasonController.text = '';
                    commonBottomSheet(cancelRideReason());
                  }
              ),
            ],
          ),
        )
      )
    );
  }

  Widget ratingWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * 0.05),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        color: AppColors.white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.all(Get.width * 0.02),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.lightGrey
                ),
                child: Icon(Icons.close, size: 18),
              ),
            ),
          ),
          SizedBox(height: Get.height * 0.01),
          Text("Rate Driver", style: AppTextStyle.size20MediumAppBlackText),
          SizedBox(height: Get.height * 0.01),
          Text("Give rating to your driver based on your experience", style: AppTextStyle.size14RegularAppBlackText),
          SizedBox(height: Get.height * 0.02),
          Row(
            children: [
              SizedBox(width: Get.width * 0.01),
              CachedNetworkImage(
                imageUrl: getImage(controller.rideData?.driverDetail?.profileImage ?? ""),
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
                child: Text(controller.rideData?.driverDetail?.name ?? "", style: AppTextStyle.size16MediumAppBlackText),
              ),
            ],
          ),
          SizedBox(height: Get.height * 0.02),
          Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Destination", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                      SizedBox(height: 5),
                      Text("${controller.rideData?.distance ?? "0"} KM", style: AppTextStyle.size14MediumAppBlackText),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Distance", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                      SizedBox(height: 5),
                      Text("${controller.rideData?.distance ?? "0"} Km", style: AppTextStyle.size14MediumAppBlackText),
                    ],
                  ),
                ),
              ]
          ),
          SizedBox(height: 15),
          Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Payment Method", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                      SizedBox(height: 5),
                      Text((controller.rideData?.paymentMethod ?? "Cash").capitalizeFirst ?? "Cash", style: AppTextStyle.size14MediumAppBlackText),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ride ID", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                      SizedBox(height: 5),
                      Text(controller.rideData?.bookingId ?? "", style: AppTextStyle.size14MediumAppBlackText),
                    ],
                  ),
                ),
              ]
          ),
          SizedBox(height: Get.height * 0.03),
          Container(
            padding: EdgeInsets.all(Get.width * 0.03),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.appPrimaryColor.withValues(alpha: 0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: RatingBar(
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    halfFilledIcon: Icons.star_half,
                    onRatingChanged: (value) {
                      controller.rating = value.toString();
                    },
                    initialRating: 0,
                    maxRating: 5,
                    alignment: Alignment.center,
                    size: 40,
                    isHalfAllowed: true,
                  ),
                ),
                SizedBox(height: 10),
                AppWidgets.buildButton(title: "Submit", onPress: () {
                  if (controller.rating == '0') {
                    Utils.toastWarning("Please give rating");
                  } else {
                    controller.rateCustomer();
                  }
                },),
              ],
            ),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget cancelRideReason() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))
      ),
      child: Obx(() => Form(
        key: controller.otpKey,
        autovalidateMode: controller.otpAutoValidate.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: Get.height * 0.02,
            ),
            Text("Cancel Ride", style: AppTextStyle.size12MediumAppBlackText.copyWith(fontWeight: FontWeight.w400, fontSize: 20)),
            SizedBox(
              height: Get.height * 0.015,
            ),
            Text("Please provide a reason for cancel ride.", style: AppTextStyle.size14MediumAppBlackText),
            SizedBox(
              height: Get.height * 0.02,
            ),
            TextFieldTheme.buildTextFiled(
              hintText: "Reason..",
              controller: controller.cancelReasonController,
              borderColor: AppColors.grey,
              verticalPadding: 10,
              radius: 10,
              hintStyle: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey),
              maxLine: 6,
              validator: (value) {
                if ((value ?? "").isEmpty) {
                  return "Please Provide Reason";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            AppWidgets.buildButton(
              title: "Cancel",
              btnWidthRatio: 0.8,
              onPress: () {
                controller.validateReason();
              },
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      )),
    );
  }
}
