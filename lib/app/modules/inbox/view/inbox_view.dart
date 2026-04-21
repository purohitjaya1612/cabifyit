import 'package:cabifyit/app/routes/app_pages.dart';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../reusability/theme/app_images.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';
import '../controller/inbox_controller.dart';

class InboxView extends GetView<InboxController> {

  @override
  var controller = Get.put(InboxController());

  InboxView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "Inbox"),
      body: GetBuilder<InboxController>(
        builder: (context) {
          return controller.isLoading.value?Center(child: loader()):
          controller.chats.isEmpty?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Get.height * 0.2),
              Text("There is no messages yet", style: AppTextStyle.size18MediumAppBlackText),
              Image.asset(AppImages.noRide, height: Get.height * 0.3),
            ],
          ):
          ListView.builder(
            itemCount: controller.chats.length,
            itemBuilder: (context, index) {
              var chat = controller.chats[index];
            return GestureDetector(
              onTap: () {
                Get.toNamed(Routes.MESSAGE, arguments: [chat.rideDetail?.id.toString(), chat.driverDetail?.id.toString(), chat.driverDetail?.name, chat.driverDetail?.profileImage, chat.rideDetail?.bookingStatus]);
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: Get.width * 0.05),
                padding: EdgeInsets.all(Get.width * 0.03),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lightBlue)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: Get.width * 0.02),
                          decoration: BoxDecoration(
                              color: AppColors.lightGrey,
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: Text("Ride ID: ${chat.rideDetail?.bookingId ?? ""}", style: AppTextStyle.size12MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                        ),
                        Spacer(),
                        Text("${Utils().getCurrencySymbol()}${(double.tryParse(chat.rideDetail?.bookingAmount ?? '0') ?? 0) + (double.tryParse(chat.rideDetail?.waitingAmount ?? '0') ?? 0)}", style: AppTextStyle.size16MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(chat.message, overflow: TextOverflow.ellipsis, textAlign: TextAlign.start, maxLines: 1, style: AppTextStyle.size12RegularAppBlackText),
                    SizedBox(height: 10),
                    Divider(color: AppColors.grey),
                    Row(
                      children: [
                        Text(DateFormat('dd/MM/yyyy').format(DateTime.tryParse(chat.rideDetail?.bookingDate ?? DateTime.now().toString()) ?? DateTime.now()), style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
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
          },);
        }
      ),
    );
  }

}