import 'dart:math';

import 'package:cabifyit/app/routes/app_pages.dart';
import 'package:cabifyit/reusability/shared/dropdown.dart';
import 'package:cabifyit/reusability/shared/ui_component_drawer.dart';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as m;
import 'package:url_launcher/url_launcher.dart';

import '../../../../reusability/shared/textfied.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../controller/dashboard_controller.dart';

class DashBoardView extends GetView<DashBoardController> {

  @override
  final controller = Get.put(DashBoardController());

  DashBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      drawer: CommonDrawer(),
      body: Container(
          color: AppColors.white100,
        child: Stack(
          children: [
            map(context),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, bottom: MediaQuery.of(context).padding.bottom, left: Get.width * 0.05, right: Get.width * 0.05),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          controller.scaffoldKey.currentState!.openDrawer();
                        },
                        child: Container(
                          height: Get.width * 0.12,
                          width: Get.width * 0.12,
                          padding: EdgeInsets.all(Get.width * 0.02),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white
                          ),
                          child: Image.asset(AppIcons.menu, height: Get.width * 0.07, width: Get.width * 0.07),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.PROFILE);
                        },
                        child: Container(
                          height: Get.width * 0.12,
                          width: Get.width * 0.12,
                          padding: EdgeInsets.all(Get.width * 0.01),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.white
                          ),
                          child: CachedNetworkImage(
                              imageUrl: getImage(Utils().getUserImage() ?? ""),
                            imageBuilder: (context, imageProvider) {
                              return Container(
                                height: Get.width * 0.1,
                                width: Get.width * 0.1,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
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
                                    borderRadius: BorderRadius.circular(10),
                                    color: AppColors.white,
                                    image: DecorationImage(image: AssetImage(AppImages.profile), fit: BoxFit.cover)
                                ),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                  Spacer(),
                  GetBuilder<DashBoardController>(
                      builder: (context) {
                        return controller.currentBooking != null ? currentRideWidget() : bookRideWidget();
                      }
                  )
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget bookRideWidget() {
    return GetBuilder<DashBoardController>(
      builder: (context) {
        return controller.isLoading.value?Container():Container(
          padding: EdgeInsets.all(Get.width * 0.05),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Form(
            key: controller.formKey,
            autovalidateMode: controller.autoValidate.value,
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.type.value = 'local';
                        controller.selectedRide.value = -1;
                        controller.fareKm.value = '';
                        controller.farePrice.value = '';
                        controller.update();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: controller.type.value == 'local'?AppColors.appPrimaryColor.withValues(alpha: 0.05):AppColors.lightGrey,
                          border: Border.all(color: controller.type.value == 'local'?AppColors.appPrimaryColor:AppColors.lightGrey)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: Get.width * 0.08,
                              width: Get.width * 0.08,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage(AppIcons.local)),
                              ),
                            ),
                            SizedBox(width: Get.width * 0.02),
                            Text("Local", style: AppTextStyle.size14RegularAppBlackText),
                            SizedBox(width: Get.width * 0.01),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: Get.width * 0.03,
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.type.value = 'intercity';
                        controller.selectedRide.value = -1;
                        controller.fareKm.value = '';
                        controller.farePrice.value = '';
                        controller.update();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.type.value != 'local'?AppColors.appPrimaryColor.withValues(alpha: 0.1):AppColors.lightGrey,
                            border: Border.all(color: controller.type.value != 'local'?AppColors.appPrimaryColor:AppColors.lightGrey)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: Get.width * 0.08,
                              width: Get.width * 0.08,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: AssetImage(AppIcons.intercity)),
                              ),
                            ),
                            SizedBox(width: Get.width * 0.02),
                            Text("Intercity", style: AppTextStyle.size14RegularAppBlackText),
                            SizedBox(width: Get.width * 0.01),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: Get.height * 0.02),
                TextFormField(
                  controller: controller.pickupController,
                  style: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.appPrimaryColor),
                  onTap: () async {
                    var result = await Get.toNamed(Routes.LOCATION, arguments: [true]);
                    FocusScope.of(Get.context!).unfocus();
                    if(result != null) {
                      controller.pickupController.text = result[0];
                      controller.pickupLat.value = result[1].toString();
                      controller.pickupLong.value = result[2].toString();
                      controller.pickupPointId.value = result[3].toString();
                      controller.update();
                      controller.calculateFare();
                    }
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Enter pickup",
                    hintStyle: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.appPrimaryColor.withValues(alpha: 0.5)),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: 5,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppColors.appPrimaryColor, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.015),
                TextFormField(
                  controller: controller.destinationController,
                  style: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.appPrimaryColor),
                  onTap: () async {
                    var result = await Get.toNamed(Routes.LOCATION, arguments: [false]);
                    FocusScope.of(Get.context!).unfocus();
                    if(result != null) {
                      controller.destinationController.text = result[0];
                      controller.dropLat.value = result[1].toString();
                      controller.dropLong.value = result[2].toString();
                      controller.dropPointId.value = result[3].toString();
                      controller.update();
                      controller.calculateFare();
                    }
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Enter destination",
                    hintStyle: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.appPrimaryColor.withValues(alpha: 0.5)),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Get.width * 0.05,
                      vertical: 5,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppColors.appPrimaryColor, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                  ),
                ),
                SizedBox(height: Get.height * 0.01),
                Divider(color: AppColors.lightGrey, thickness: 2),
                SizedBox(height: Get.height * 0.01),
                if(Utils().getBox("company_booking_system") == "auto_dispatch")Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: AppWidgets.buildButton(
                        title: controller.when.value == 'now'?"Schedule Later":"Go Now",
                        txtSize: 12,
                        btnRadius: 5,
                        btnHeight: 40,
                        onPress: () {
                  if (controller.when.value == "now") {
                    controller.bookingDate.value = '';
                    controller.pickupTime.value = '';
                    controller.when.value = "later";
                  } else {
                    controller.when.value = "now";
                  }
                  controller.update();
                })),
                Obx(() =>
                  controller.when.value == "now"?
                  Container():
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: [
                        Expanded(child: GestureDetector(
                          onTap: () async {
                            var date = await showDatePicker(context: Get.context!, firstDate: DateTime.now(), lastDate: DateTime.now().add(Duration(days: 7)));

                            if(date != null) {
                              controller.bookingDate.value = DateFormat('dd/MM/yyyy').format(date);
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppColors.lightGrey,
                            ),
                            child: Text(controller.bookingDate.value.isNotEmpty?controller.bookingDate.value:"Booking Date", style: AppTextStyle.size14RegularAppBlackText),
                          ),
                        )),
                        SizedBox(width: Get.width * 0.03),
                        Expanded(child: GestureDetector(
                          onTap: () async {
                            var time = await showTimePicker(context: Get.context!, initialTime: TimeOfDay.now());

                            if (time != null) {
                              final now = DateTime.now();

                              final formattedTime = DateFormat('hh:mm a').format(
                                DateTime(
                                  now.year,
                                  now.month,
                                  now.day,
                                  time.hour,
                                  time.minute,
                                ),
                              );

                              controller.pickupTime.value = formattedTime;
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppColors.lightGrey,
                            ),
                            child: Text(controller.pickupTime.value.isNotEmpty?controller.pickupTime.value:"Pickup Time", style: AppTextStyle.size14RegularAppBlackText),
                          ),
                        ))
                      ],
                    ),
                  )
                ),
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    itemCount: controller.vehicles.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var type = controller.vehicles[index].vehicleTypeService;

                    return controller.type.value != type?Container():GestureDetector(
                      onTap: () {
                        controller.selectedRide.value = index;
                        controller.calculateFare();
                        controller.update();
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: Get.width * 0.02),
                        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02, vertical: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.selectedRide.value == index ? AppColors.appPrimaryColor.withValues(alpha: 0.05):AppColors.lightGrey,
                            border: Border.all(color: controller.selectedRide.value == index ? AppColors.appPrimaryColor:AppColors.lightGrey)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CachedNetworkImage(
                              imageUrl: getImage(controller.vehicles[index].vehicleImage ?? ""),
                              height: Get.width * 0.08,
                              width: Get.width * 0.08,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) => Container(),
                            ),
                            SizedBox(width: Get.width * 0.02),
                            Text(controller.vehicles[index].vehicleTypeName ?? "", style: AppTextStyle.size14RegularAppBlackText.copyWith(color: controller.selectedRide.value == index.toString() ?AppColors.appPrimaryColor:null)),
                            SizedBox(width: Get.width * 0.01),
                          ],
                        ),
                      ),
                    );
                  },),
                ),
                SizedBox(height: Get.height * 0.02),
                Obx(() =>
                (controller.isCalculationLoading.value || (controller.fareKm.value.isNotEmpty && controller.farePrice.value.isNotEmpty) ?
                Container(
                  height: 50,
                  width: Get.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lightBlue)
                  ),
                  child: controller.isCalculationLoading.value?
                  Center(child: Text("Loading Fare...", style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor))):
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${controller.fareKm.value} KM", style: AppTextStyle.size14MediumAppBlackText),
                      SizedBox(width: Get.width * 0.03),
                      Image.asset(AppImages.arrow, width: Get.width * 0.15),
                      SizedBox(width: Get.width * 0.03),
                      Text("${Utils().getCurrencySymbol()}${controller.farePrice.value}", style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor))
                    ],
                  ),
                ):Container())),
                SizedBox(height: Get.height * 0.02),
                AppWidgets.buildButton(
                    title: "Next",
                    btnWidthRatio: 0.8,
                    btnColor: controller.pickupLong.value.isNotEmpty && controller.pickupLat.value.isNotEmpty && controller.dropLat.value.isNotEmpty && controller.dropLong.value.isNotEmpty && !controller.isCalculationLoading.value ? AppColors.appPrimaryColor : AppColors.grey,
                    borderColor: controller.pickupLong.value.isNotEmpty && controller.pickupLat.value.isNotEmpty && controller.dropLat.value.isNotEmpty && controller.dropLong.value.isNotEmpty && !controller.isCalculationLoading.value ? AppColors.appPrimaryColor : AppColors.grey,
                    onPress: () {
                      if(controller.formKey.currentState!.validate()) {
                        if(controller.pickupController.text.isEmpty) {
                          Utils.toastWarning("Please Select Pickup Location");
                          return;
                        }
                        if(controller.destinationController.text.isEmpty) {
                          Utils.toastWarning("Please Select Destination Location");
                          return;
                        }
                        if(controller.selectedRide.value == -1) {
                          Utils.toastWarning("Please Select Vehicle");
                          return;
                        }

                        if(controller.when.value == 'later') {
                          if(controller.bookingDate.value.isEmpty) {
                            Utils.toastWarning("Please Select Booking Date");
                            return;
                          }

                          if(controller.pickupTime.value.isEmpty) {
                            Utils.toastWarning("Please Select Pickup Time");
                            return;
                          }
                        }

                        if(!controller.isCalculationLoading.value) {
                          if (Utils().getBox("company_booking_system") == "auto_dispatch") {
                            controller.rateController.text =
                                controller.farePrice.value;
                            controller.createBooking();
                          } else {
                            controller.rateController.text =
                                controller.farePrice.value;
                            commonBottomSheet(offerRate());
                          }
                        }
                      } else {
                        controller.autoValidate.value = AutovalidateMode.always;
                        controller.update();
                      }
                    },
                )
              ],
            ),
          ),
        );
      }
    );
  }

  Widget currentRideWidget() {
    return GetBuilder<DashBoardController>(
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(Get.width * 0.05),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Column(
            children: [
              SizedBox(height: 0),
              Text("Current Ride Details", style: AppTextStyle.size22MediumAppBlackText),
              if(controller.currentBooking?.bookingStatus == "arrived")SizedBox(height: Get.height * 0.02),
              if(controller.currentBooking?.bookingStatus == "arrived")Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                ),
                child: Text("Driver has arrived at your location.", style: AppTextStyle.size16MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
              ),
              SizedBox(height: Get.height * 0.02),
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
                    Expanded(child: Text(controller.currentBooking?.pickupLocation ?? "", style: AppTextStyle.size14MediumAppBlackText))
                  ],
                ),
              ),
              SizedBox(height: 2),
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
                    Expanded(child: Text(controller.currentBooking?.destinationLocation ?? "", style: AppTextStyle.size14MediumAppBlackText))
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.02),
              Divider(),
              SizedBox(height: Get.height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ride Type", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                        SizedBox(height: Get.height * 0.01),
                        Text((controller.currentBooking?.bookingType ?? "local").capitalizeFirst ?? "", style: AppTextStyle.size16MediumAppBlackText),
                      ]
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vehicle", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                          SizedBox(height: Get.height * 0.01),
                          Text(controller.currentBooking?.vehicleDetail?.vehicleTypeName ?? "", style: AppTextStyle.size16MediumAppBlackText),
                        ]
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Vehicle Number", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                          SizedBox(height: Get.height * 0.01),
                          Text(controller.currentBooking?.driverDetail?.plateNo ?? "", style: AppTextStyle.size16MediumAppBlackText),
                        ]
                    ),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Price", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                          SizedBox(height: Get.height * 0.01),
                          Text("${Utils().getCurrencySymbol()}${controller.currentBooking?.bookingAmount ?? "0"}", style: AppTextStyle.size16MediumAppBlackText),
                        ]
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Distance", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                          SizedBox(height: Get.height * 0.01),
                          Text("${controller.currentBooking?.distance ?? ""} KM", style: AppTextStyle.size16MediumAppBlackText),
                        ]
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Payment Mode", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                          SizedBox(height: Get.height * 0.01),
                          Text((controller.currentBooking?.paymentMethod ?? "cash").capitalizeFirst ?? "Cash", style: AppTextStyle.size16MediumAppBlackText),
                        ]
                    ),
                  ),
                ],
              ),
              if((controller.currentBooking?.note ?? "").isNotEmpty)SizedBox(height: Get.height * 0.02),
              if((controller.currentBooking?.note ?? "").isNotEmpty)Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Note : ", style: AppTextStyle.size12MediumAppBlackText),
                  Expanded(child: Text(controller.currentBooking?.note ?? "", style: AppTextStyle.size12RegularAppBlackText)),
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              Divider(),
              SizedBox(height: Get.height * 0.02),
              Row(
                children: [
                  SizedBox(width: Get.width * 0.01),
                  CachedNetworkImage(
                    imageUrl: getImage(controller.currentBooking?.driverDetail?.profileImage ?? ""),
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
                  SizedBox(width: Get.width * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.currentBooking?.driverDetail?.name ?? "", style: AppTextStyle.size16MediumAppBlackText),
                        Text("Ride ID: ${controller.currentBooking?.bookingId ?? ""}", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.black200)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var number = controller.currentBooking?.driverDetail?.phoneNo ?? "";
                      print("Number : $number");
                      launchUrl(Uri.parse("tel:$number"));
                    },
                    child: Container(
                        padding: EdgeInsets.all(Get.width * 0.03),
                        decoration: BoxDecoration(
                            color: AppColors.appPrimaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle
                        ),
                        child: Image.asset(AppIcons.call, width: Get.width * 0.04)),
                  ),
                  SizedBox(width: Get.width * 0.01),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.MESSAGE, arguments: [controller.currentBooking?.id.toString(), controller.currentBooking?.driverDetail?.id.toString(), controller.currentBooking?.driverDetail?.name, controller.currentBooking?.driverDetail?.profileImage, controller.currentBooking?.bookingStatus]);
                    },
                    child: Container(
                        padding: EdgeInsets.all(Get.width * 0.03),
                        decoration: BoxDecoration(
                            color: AppColors.appPrimaryColor.withValues(alpha: 0.1),
                            shape: BoxShape.circle
                        ),
                        child: Image.asset(AppIcons.message, width: Get.width * 0.04)),
                  ),
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              if(controller.currentBooking?.bookingStatus == "ongoing" || controller.currentBooking?.bookingStatus == "arrived")Text("OTP", style: AppTextStyle.size16MediumAppBlackText),
              if(controller.currentBooking?.bookingStatus == "ongoing" || controller.currentBooking?.bookingStatus == "arrived")SizedBox(height: Get.height * 0.01),
              if(controller.currentBooking?.bookingStatus == "ongoing" || controller.currentBooking?.bookingStatus == "arrived")Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: Get.width * 0.1,
                    width: Get.width * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                    ),
                    child: Text(controller.currentBooking!.otp[0], style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor),),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.width * 0.1,
                    width: Get.width * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                    ),
                    child: Text(controller.currentBooking!.otp[1], style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor),),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.width * 0.1,
                    width: Get.width * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                    ),
                    child: Text(controller.currentBooking!.otp[2], style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor),),
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Container(
                    height: Get.width * 0.1,
                    width: Get.width * 0.1,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                    ),
                    child: Text(controller.currentBooking!.otp[3], style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor),),
                  ),
                ],
              ),
              if(controller.currentBooking?.bookingStatus == "ongoing" || controller.currentBooking?.bookingStatus == "arrived")SizedBox(height: Get.height * 0.01),
              if(controller.currentBooking?.bookingStatus == "ongoing" || controller.currentBooking?.bookingStatus == "arrived")Row(
                children: [
                  Icon(Icons.error, size: 16, color: AppColors.appPrimaryColor.withValues(alpha: 0.5)),
                  Expanded(child: Text(" Do not share OTP with driver before pickup on call or message.", style: AppTextStyle.size10RegularAppBlackText.copyWith(fontSize: 9)))
                ],
              ),
              SizedBox(height: Get.height * 0.01),
              Row(
                children: [
                  Expanded(
                    child: AppWidgets.buildButton(
                      title: "Cancel Ride",
                      onPress: () {
                        controller.cancelReasonController.text = '';
                        controller.reasonAutoValidate.value = AutovalidateMode.disabled;
                        commonBottomSheet(cancelRideReason());
                      },
                        btnHeight: 40,
                        txtSize: 12,
                      borderColor: AppColors.red,
                      txtColor: AppColors.red,
                      btnColor: AppColors.white
                    )
                  ),
                  SizedBox(width: Get.width * 0.03),
                  Expanded(
                      child: AppWidgets.buildButton(
                          title: "Driver Location",
                          onPress: () {
                            Get.toNamed(Routes.DRIVERLOCATION, arguments: [controller.currentBooking?.driverDetail?.id.toString(),controller.currentBooking?.driverDetail?.profileImage.toString()]);
                          },
                          btnHeight: 40,
                          txtSize: 12,
                      )
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.01),
            ],
          ),
        );
      }
    );
  }

  Widget map(context) {
    return Obx(() => controller.isMapLoading.value?Center(child: loader()):
    Utils().getMap()?
    GoogleMap(
        initialCameraPosition: controller.currentPosition,
      onMapCreated: (mapController) {
        controller.mapController = mapController;
      },
    ):
    m.MapLibreMap(
      initialCameraPosition: controller.mCurrentPosition,
      onMapCreated: (mapController) {
        controller.mController = mapController;
      },
      myLocationEnabled: true,
      attributionButtonPosition: m.AttributionButtonPosition.bottomLeft,
      attributionButtonMargins: Point(-1000, -1000),
      compassViewMargins: Point(10,(MediaQuery.of(context).padding.bottom + 100 + Get.width * 0.16)),
      compassViewPosition: m.CompassViewPosition.bottomRight,
      onMapClick: (point, coordinates) {
      },
      styleString: controller.bariKoiStyle ,
    ));
  }

  Widget offerRate() {
    return StatefulBuilder(
      builder: (context, state) {
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
              SizedBox(height: 10),
              Text("Offer Your Rate", textAlign: TextAlign.center, style: AppTextStyle.size20RegularAppBlackText),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(Get.width * 0.03),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.lightBlue.withValues(alpha: 0.1)
                ),
                child: Column(
                  children: [
                    TextFieldTheme.buildTextFiled(
                        hintText: "Rate",
                        controller: controller.rateController,
                        borderColor: AppColors.grey,
                        radius: 10,
                        hintStyle: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey),
                        height: 50,
                      onChange: (value) {
                        state(() {});
                      },
                      validator: (value) {
                        if((value ?? "").isEmpty) {
                          return "Please enter price!";
                        } else if((double.tryParse(value ?? "0") ?? 0) < (double.tryParse(controller.farePrice.value) ?? 0)) {
                          return "Minimum fare is ${controller.farePrice.value}";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                      children: [
                        Image.asset(AppIcons.info, height: Get.width * 0.04),
                        SizedBox(width: Get.width * 0.02),
                        Text("Recommended Fare: ${Utils().getCurrencySymbol()}${controller.farePrice.value}", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey))
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.lightBlue)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("${controller.fareKm.value} KM", style: AppTextStyle.size14MediumAppBlackText),
                    SizedBox(width: Get.width * 0.03),
                    Image.asset(AppImages.arrow, width: Get.width * 0.15),
                    SizedBox(width: Get.width * 0.03),
                    Text("${Utils().getCurrencySymbol()}${controller.rateController.text}", style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor))
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.02),
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
                    Expanded(child: Text(controller.pickupController.text, style: AppTextStyle.size14MediumAppBlackText))
                  ],
                ),
              ),
              SizedBox(height: 2),
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
                    Expanded(child: Text(controller.destinationController.text, style: AppTextStyle.size14MediumAppBlackText))
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.01),
              TextFieldTheme.buildTextFiled(
                  hintText: "Note for driver..",
                  controller: controller.noteController,
                  borderColor: AppColors.grey,
                  verticalPadding: 10,
                  radius: 10,
                  hintStyle: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey),
                  maxLine: 6
              ),
              SizedBox(height: Get.height * 0.01),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonDropdown(onChanged: (value) {
                    controller.paymentMethod.value = value!;
                    controller.update();
                  }),
                  SizedBox(width: Get.width * 0.05),
                  AppWidgets.buildButton(
                    title: "Find Driver",
                    btnWidthRatio: 0.5,
                    btnHeight: 50,
                    onPress: () async {
                      var value = controller.rateController.text.trim();
                      if((value ?? "").isEmpty) {
                        Utils.toastWarning("Please enter price!");
                      } else if((double.tryParse(value ?? "0") ?? 0) < (double.tryParse(controller.farePrice.value) ?? 0)) {
                        Utils.toastWarning("Minimum fare is ${controller.farePrice.value}");
                      } else {
                        controller.createBooking();
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        );
      }
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
        key: controller.reasonKey,
        autovalidateMode: controller.reasonAutoValidate.value,
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