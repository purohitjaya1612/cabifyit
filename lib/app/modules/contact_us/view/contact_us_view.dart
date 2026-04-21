import 'package:cabifyit/reusability/shared/textfied.dart';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../controller/contact_us_controller.dart';

class ContactUsView extends GetView<ContactUsController> {

  @override
  final controller = Get.put(ContactUsController());

  ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "Contact Us"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Obx(() => Form(
          key: controller.formKey,
           autovalidateMode: controller.autoValidate.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("Let us know your issue & feedback", style: AppTextStyle.size14MediumAppBlackText),
              SizedBox(height: 20),
              TextFieldTheme.buildTextFiled(
                  hintText: "Describe your issue and feedback",
                  controller: controller.feedbackController,
                validator: (value) {
                  if((value ?? "").isNotEmpty && value!.length < 10) {
                    return "Please Enter Valid Feedback";
                  }
                  return null;
                },
                borderColor: AppColors.grey,
                maxLine: 6,
                verticalPadding: 10,
                radius: 20
              ),
              Spacer(),
              AppWidgets.buildButton(
                title: "Send",
                btnWidthRatio: 1,
                onPress: () {
                  controller.validate();
              },),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        )),
      ),
    );
  }
}