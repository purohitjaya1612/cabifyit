import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../controller/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {

  @override
  var controller = Get.put(NotificationController());

  NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "Notification"),
      body: GetBuilder<NotificationController>(
        builder: (context) {
          return controller.isLoading.value?Center(child: loader()):
          ListView.builder(
            itemCount: controller.notification.length,
            itemBuilder: (context, index) {
              return Container(
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
                        Expanded(child: Text(controller.notification[index].title ?? "", maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyle.size14MediumAppBlackText)),
                        SizedBox(width: 10),
                        Text(DateFormat('dd/MM/yy').format(DateTime.parse(controller.notification[index].createdAt ?? DateTime.now().toString())), overflow: TextOverflow.ellipsis, style: AppTextStyle.size10RegularAppBlackText)
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Text(controller.notification[index].message ?? "", style: AppTextStyle.size12RegularAppBlackText)),
                        SizedBox(width: 10),
                        Text(DateFormat('hh:mm a').format(DateTime.parse(controller.notification[index].createdAt ?? DateTime.now().toString())), overflow: TextOverflow.ellipsis, style: AppTextStyle.size10RegularAppBlackText)
                      ],
                    ),
                  ],
                ),
              );
            },);
        }
      ),
    );
  }

}