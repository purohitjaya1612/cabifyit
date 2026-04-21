import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_images.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../data/services/general_service.dart';

class ContactUsController extends GetxController {
  TextEditingController feedbackController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;

  createContactUs() async {
    Utils.showLoadingDialog();
    var body = {
      "message": feedbackController.text.trim()
    };

    var result = await GeneralService().createContactUs(body: body);
    if(Get.isDialogOpen ?? false) Get.back();
    if(result != null) {
      FocusScope.of(Get.context!).unfocus();
      feedbackController.text = '';
      commonBottomSheet(success());
    }
  }

  validate() {
    if(formKey.currentState!.validate()) {
      createContactUs();
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