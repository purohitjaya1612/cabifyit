import 'package:cabifyit/app/data/services/socket_service.dart';
import 'package:cabifyit/reusability/shared/textfied.dart';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_images.dart';
import '../controller/message_controller.dart';

class MessageView extends GetView<MessageController> {

  @override
  var controller = Get.put(MessageController());

  MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        SocketService().socket?.off("user-message-event");
      },
      child: Scaffold(
          appBar: AppWidgets.appBar(title: "Message"),
          body: Obx(() => controller.isLoading.value ? Center(child: loader()) : Column(
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04, vertical: Get.width * 0.03),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.white
                ),
                child: Row(
                    children: [
                      CachedNetworkImage(
                        imageUrl: getImage(controller.driverProfile),
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
                      Expanded(child: Text(controller.driverName, style: AppTextStyle.size16MediumAppBlackText)),
                    ]
                ),
              ),
              SizedBox(height: 10),
              Expanded(child: GetBuilder<MessageController>(
                builder: (context) {
                  return ListView.builder(
                      itemCount: controller.messages.length,
                      shrinkWrap: true,
                      reverse: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        var message = controller.messages[index];
                        return Align(
                          alignment:
                          message.sendBy == "user"
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: Get.width * 0.75,
                            ),
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: message.sendBy == "user" ? Get.width *
                                      0.15 : Get.width * 0.03,
                                  right: message.sendBy == "user" ? Get.width *
                                      0.03 : Get.width * 0.15,
                                  bottom: 20),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: Get.width * 0.04),
                              decoration: BoxDecoration(
                                  color: message.sendBy == "user"
                                      ? AppColors.appPrimaryColor.withValues(
                                      alpha: 0.1)
                                      : AppColors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                      bottomLeft: Radius.circular(
                                          message.sendBy == "user" ? 20 : 0),
                                      bottomRight: Radius.circular(
                                          message.sendBy == "user" ? 0 : 20))
                              ),
                              child: Column(
                                crossAxisAlignment: message.sendBy == "user"
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Text(message.message, style: AppTextStyle
                                      .size14RegularAppBlackText),
                                  Text(DateFormat('dd/MM/yyyy - hh:mm a').format(
                                      message.createdAt ?? DateTime.now()),
                                      style: AppTextStyle
                                          .size10RegularAppBlackText.copyWith(
                                          color: AppColors.textGrey))
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
              )),
              SizedBox(height: 10),
              if(controller.rideStatus != 'completed' && controller.rideStatus != 'cancelled')Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20))
                ),
                padding: EdgeInsets.only(top: 20,bottom: MediaQuery.of(context).padding.bottom, left: Get.width * 0.03, right:Get.width * 0.03),
                child: Row(
                  children: [
                    Expanded(
                        child: SizedBox(
                            height: 50,
                            child: TextFieldTheme.buildTextFiled(
                            hintText: "Write here..",
                            controller: controller.messageController,
                          borderColor: AppColors.grey,
                          hintStyle: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.textGrey),
                          height: 50
                        ))
                    ),
                    SizedBox(width: Get.width * 0.02),
                    AppWidgets.buildButton(
                      title: "Send",
                      btnWidthRatio: 0.2,
                      btnHeight: 50,
                      onPress: () {
                        FocusScope.of(context).unfocus();
                        controller.sendMessage();
                      },
                    ),
                  ],
                ),
              )
            ],
          ))
      ),
    );
  }

}