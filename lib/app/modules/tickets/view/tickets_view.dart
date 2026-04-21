import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';
import '../controller/tickets_controller.dart';

class TicketsView extends GetView<TicketsController> {

  @override
  var controller = Get.put(TicketsController());

  TicketsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "My Ticket - Support"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Column(
          children: [
            Expanded(
              child: GetBuilder<TicketsController>(
                builder: (context) {
                  return controller.isLoading.value?Center(child: loader()):
                  controller.tickets.isEmpty?Center(child: noDataFound()):
                  ListView.builder(
                    itemCount: controller.tickets.length,
                    padding: EdgeInsets.zero,
                    controller: controller.scrollController,
                    itemBuilder: (context, index) {
                      var ticket = controller.tickets[index];
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(Get.width * 0.04),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.lightBlue)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: Get.width * 0.02),
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(15)
                              ),
                              child: Text("Ticket ID: #${ticket.ticketId}", style: AppTextStyle.size12MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                            ),
                            SizedBox(height: 10),
                            Text(ticket.subject ?? "", overflow: TextOverflow.ellipsis, style: AppTextStyle.size14MediumAppBlackText),
                            SizedBox(height: 10),
                            Text(ticket.message ?? "", style: AppTextStyle.size12RegularAppBlackText),
                            SizedBox(height: 10),
                            Divider(color: AppColors.grey, height: 1),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Text(DateFormat('dd/MM/yyyy hh:mm a').format(DateTime.parse((ticket.createdDate ?? DateTime.now()).toString())), style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
                                Spacer(),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: (ticket.status == "closed"?AppColors.green:AppColors.appPrimaryColor).withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Text(ticket.status == "closed"?"● Close":"● Open", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: ticket.status == "closed"?AppColors.green:AppColors.appPrimaryColor)),
                                ),
                              ],
                            ),
                            if((ticket.replyMessage ?? "").isNotEmpty)SizedBox(height: 10),
                            if((ticket.replyMessage ?? "").isNotEmpty)Text("Reply : ${ticket.replyMessage ?? ""}", style: AppTextStyle.size12RegularAppBlackText),
                          ],
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
            SizedBox(height: 20),
            AppWidgets.buildButton(title: "Create Ticket", btnWidthRatio: 1, onPress: () {
              commonBottomSheet(createTicket());
            },),
            SizedBox(height: MediaQuery.of(context).padding.bottom)
          ],
        ),
      ),
    );
  }

  Widget createTicket() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: 50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.white
      ),
      child: Obx(() => Form(
        key: controller.formKey,
        autovalidateMode: controller.autoValidate.value,
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
            Center(child: Text("Raise Ticket", style: AppTextStyle.size16RegularAppBlackText.copyWith(fontSize: 22))),
            SizedBox(height: 10),
            Text("Subject", style: AppTextStyle.size16MediumAppBlackText),
            SizedBox(height: 10),
            TextFormField(
                validator: (value) {
                  if((value ?? "").isEmpty) {
                    return "Please Enter Subject";
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
                controller: controller.subjectController,
                textAlign: TextAlign.start,
                style: AppTextStyle.size14MediumAppBlackText.copyWith(color: Colors.black),
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: Get.width * 0.05),
                    filled: true,
                    fillColor: AppColors.white,
                    disabledBorder: selectedTextFieldBorder(radius: 20),
                    focusedBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.appPrimaryColor),
                    enabledBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.lightBlue),
                    errorBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.red),
                    border: selectedTextFieldBorder(radius: 20, borderColor: AppColors.lightBlue),
                    hintText: "Subject")),
            SizedBox(height: 20),
            Text("Description", style: AppTextStyle.size16MediumAppBlackText),
            SizedBox(height: 10),
            TextFormField(
                validator: (value) {
                  if((value ?? "").isEmpty) {
                    return "Please Enter Description";
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
                textAlign: TextAlign.start,
                controller: controller.descriptionController,
                maxLines: 6,
                style: AppTextStyle.size14MediumAppBlackText.copyWith(color: Colors.black),
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: Get.width * 0.05),
                    filled: true,
                    fillColor: AppColors.white,
                    disabledBorder: selectedTextFieldBorder(radius: 20),
                    focusedBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.appPrimaryColor),
                    enabledBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.lightBlue),
                    errorBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.red),
                    border: selectedTextFieldBorder(radius: 20, borderColor: AppColors.lightBlue),
                    hintText: "Description")),
            SizedBox(height: 20),
            AppWidgets.buildButton(
              title: "Submit",
              btnWidthRatio: 1,
              onPress: () {
                controller.validate();
              },
            ),
          ],
        ),
      )),
    );
  }
}