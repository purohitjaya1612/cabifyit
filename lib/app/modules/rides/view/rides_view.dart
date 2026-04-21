import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../routes/app_pages.dart';
import '../controller/rides_controller.dart';

class RidesView extends GetView<RidesController> {

  @override
  final controller = Get.put(RidesController());

  RidesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppWidgets.appBar(title: "Rides"),
      body: Container(
          color: AppColors.white100,
        padding: EdgeInsets.only(top: 10, left: Get.width * 0.05, right: Get.width * 0.05, bottom:  MediaQuery.of(context).padding.bottom),
        child: Column(
          children: [
            Obx(() => Container(
              height: 40,
              margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColors.white,
                border: Border.all(color: AppColors.lightBlue),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedTab.value != 'completed' && !controller.isMoreLoading.value) {
                          controller.selectedDate = null;
                          controller.selectedTab.value = 'completed';
                          controller.page = 1;
                          controller.getRides();
                          controller.update();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          color: controller.selectedTab.value == "completed" ? AppColors.appPrimaryColor.withValues(alpha: 0.1) : null
                        ),
                        alignment: Alignment.center,
                        child: Text("Completed", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: controller.selectedTab.value == "completed" ? AppColors.appPrimaryColor : null)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedTab.value != 'upcoming' && !controller.isMoreLoading.value) {
                          controller.selectedDate = null;
                          controller.selectedTab.value = 'upcoming';
                          controller.page = 1;
                          controller.getRides();
                          controller.update();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.selectedTab.value == "upcoming" ? AppColors.appPrimaryColor.withValues(alpha: 0.1) : null
                        ),
                        alignment: Alignment.center,
                        child: Text("Upcoming", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: controller.selectedTab.value == "upcoming" ? AppColors.appPrimaryColor : null)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (controller.selectedTab.value != 'cancelled' && !controller.isMoreLoading.value) {
                          controller.selectedDate = null;
                          controller.selectedTab.value = 'cancelled';
                          controller.page = 1;
                          controller.getRides();
                          controller.update();
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: controller.selectedTab.value == "cancelled" ? AppColors.appPrimaryColor.withValues(alpha: 0.1) : null
                        ),
                        alignment: Alignment.center,
                        child: Text("Cancelled", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: controller.selectedTab.value == "cancelled" ? AppColors.appPrimaryColor : null)),
                      ),
                    ),
                  ),
                ],
              ),
            )),
            SizedBox(height: 10),
            Container(
              height: 60,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColors.lightBlue)
              ),
              child: Row(
                children: [
                  SizedBox(width: Get.width * 0.04),
                  GetBuilder<RidesController>(
                    builder: (context) {
                      return Text(controller.selectedDate != null ? DateFormat('dd/MM/yyyy').format(controller.selectedDate!.value):"", style: AppTextStyle.size16MediumAppBlackText.copyWith(color: AppColors.textGrey));
                    }
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      commonBottomSheet(
                          Container(
                            color: AppColors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                                                    children: [
                            SizedBox(
                              height: 300,
                              child: CupertinoDatePicker(
                                mode: CupertinoDatePickerMode.date,
                                minimumDate: controller.selectedTab.value == "completed" ? DateTime(2025, 11) : controller.selectedTab.value == "upcoming" ? DateTime.now().subtract(Duration(days: 1)) : DateTime(2025, 11),
                                maximumDate: controller.selectedTab.value == "completed" ? DateTime.now().add(Duration(days: 1)) : controller.selectedTab.value == "upcoming" ? DateTime.now().add(Duration(days: 365)) : DateTime.now().add(Duration(days: 1)),
                                initialDateTime: controller.selectedDate != null ? controller.selectedDate!.value : DateTime.now(),
                                onDateTimeChanged: (DateTime newDate) {
                                  controller.selectedDate = newDate.obs;
                                },
                              ),
                            ),
                            CupertinoButton(
                              child: Text("Done"),
                              onPressed: () {
                                controller.page = 1;
                                controller.update();
                                controller.getRides();
                                Get.back();
                              },
                            )
                                                    ],
                                                  ),
                          ),
                      );
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.grey
                      ),
                      child: Image.asset(AppIcons.calendar),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: GetBuilder<RidesController>(
                builder: (context) {
                  return controller.isLoading.value?
                  Center(child: loader()):
                  controller.rides.isEmpty?Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: Get.height * 0.1),
                      Text("There is no ${controller.selectedTab.value} rides yet", style: AppTextStyle.size18MediumAppBlackText),
                      Image.asset(AppImages.noRide, height: Get.height * 0.3),
                    ],
                  ):
                  ListView.builder(
                    itemCount: controller.rides.length,
                    padding: EdgeInsets.zero,
                    controller: controller.scrollController,
                    itemBuilder: (context, index) {
                      var ride = controller.rides[index];
                      return GestureDetector(
                        onTap: () async {
                          await Get.toNamed(Routes.RIDEDETAIL, arguments: [ride, controller.selectedTab.value]);
                          controller.getRides();
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: EdgeInsets.all(Get.width * 0.04),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.lightBlue)
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: Get.width * 0.02),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Text("Ride ID: ${ride.bookingId}", style: AppTextStyle.size12MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                                  ),
                                  Spacer(),
                                  Text("${Utils().getCurrencySymbol()}${((double.tryParse(ride.bookingAmount) ?? 0) + (double.tryParse(ride.waitingAmount ?? "0") ?? 0))}", style: AppTextStyle.size16MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(AppIcons.location, color: AppColors.green, height: Get.width * 0.05),
                                  SizedBox(width: Get.width * 0.02),
                                  Expanded(child: Text(ride.pickupLocation, style: AppTextStyle.size12MediumAppBlackText))
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(AppIcons.location, color: AppColors.blue, height: Get.width * 0.05),
                                  SizedBox(width: Get.width * 0.02),
                                  Expanded(child: Text(ride.destinationLocation, style: AppTextStyle.size12MediumAppBlackText))
                                ],
                              ),
                              SizedBox(height: 10),
                              Divider(color: AppColors.grey),
                              Row(
                                children: [
                                  Text(DateFormat('dd/MM/yyyy').format(DateTime.parse(ride.bookingDate)).toString(), style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                  Spacer(),
                                  Text("View", style: AppTextStyle.size14RegularAppBlackText),
                                  SizedBox(width: 2),
                                  Icon(Icons.arrow_forward_ios, size: 14)
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              ),
            ),
            Obx(() => !controller.isLoading.value && controller.isMoreLoading.value ?
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: loader(),
            ) :
            Container()),
          ],
        ),
      )
    );
  }
}