import 'package:cabifyit/app/data/services/auth_service.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_images.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../data/services/general_service.dart';

class ChangePasswordController extends GetxController {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;

  changePassword() async {
    Utils.showLoadingDialog();
    var body = {
      'country_code': Utils().getUserCountryCode() ?? "",
      "phone": Utils().getUserPhone() ?? "",
      "old_password": oldPasswordController.text.trim(),
      "new_password": newPasswordController.text.trim()
    };

    var result = await AuthService().changePassword(body: body);
    if(Get.isDialogOpen!) Get.back();
    if(result != null) {
      Get.back();
      Utils.toastOk("Password Changed Successfully!");
    }
  }

  validate() {
    if(formKey.currentState!.validate()) {
      changePassword();
    } else {
      autoValidate.value = AutovalidateMode.always;
      update();
    }
  }

  Widget success() {
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
          Image.asset(AppImages.success, width: Get.width * 0.2),
          SizedBox(height: 20),
          Text("Successfully Sent", style: AppTextStyle.size20RegularAppBlackText),
          SizedBox(height: 10),
          Text("Your issue/feedback has been sent successfully.", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
          SizedBox(height: 20),
          AppWidgets.buildButton(
            title: "Okay",
            btnWidthRatio: 1,
            onPress: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}