import 'package:cabifyit/reusability/shared/textfied.dart';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../controller/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {

  @override
  final controller = Get.put(ChangePasswordController());

  ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "Change Password"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Obx(() => Form(
          key: controller.formKey,
           autovalidateMode: controller.autoValidate.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              TextFieldTheme.buildTextFiled(
                  hintText: "Old Password",
                  controller: controller.oldPasswordController,
                validator: (value) {
                  if((value ?? "").isEmpty) {
                    return "Please Enter Old Password";
                  }
                  return null;
                },
                borderColor: AppColors.grey,
                radius: 20
              ),
              SizedBox(height: 20),
              TextFieldTheme.buildTextFiled(
                  hintText: "New Password",
                  controller: controller.newPasswordController,
                  validator: (value) {
                    if((value ?? "").isEmpty) {
                      return "Please Enter New Password";
                    } else if((value ?? '').length < 6) {
                      return " Password must be 6 character long";
                    }
                    return null;
                  },
                  borderColor: AppColors.grey,
                  radius: 20
              ),
              SizedBox(height: 20),
              TextFieldTheme.buildTextFiled(
                  hintText: "Confirm Password",
                  controller: controller.confirmPasswordController,
                  validator: (value) {
                    if((value ?? "") != controller.newPasswordController.text.trim()) {
                      return "Password doesn't match";
                    }
                    return null;
                  },
                  borderColor: AppColors.grey,
                  radius: 20
              ),
              Spacer(),
              AppWidgets.buildButton(
                title: "Change",
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