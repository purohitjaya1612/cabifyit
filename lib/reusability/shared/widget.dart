import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';

class AppWidgets {

  static AppBar appBar({required String title}) {
    return AppBar(
      leading: GestureDetector(onTap: () {
        Get.back();
      },child: Icon(Icons.arrow_back_ios)),
      title: Text(title, style: AppTextStyle.size16MediumAppBlackText),
      backgroundColor: AppColors.white100,
      scrolledUnderElevation: 0,
      elevation: 0,
      centerTitle: true,
    );
  }

  static Widget loader() {
    return Center(
      child: CircularProgressIndicator(color: AppColors.appPrimaryColor),
    );
  }

  static buildButton({
        required String title,
        double btnHeight = 60,
        double txtSize = 16,
        double btnWidthRatio = 0.7,
        double btnRadius = 30,
        Color? btnColor,
        Color? borderColor,
        Color txtColor = Colors.white,
        required Function() onPress,
        bool isVisible = true,
      }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Get.width * btnWidthRatio,
        child: MaterialButton(
          onPressed: onPress,
          height: btnHeight,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(btnRadius),
            side: BorderSide(color: borderColor ?? AppColors.appPrimaryColor)
          ),
          color: btnColor ?? AppColors.appPrimaryColor,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyle.size14MediumAppBlackText.copyWith(fontSize: txtSize, color: txtColor, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  static buildBorderButton(
      {
        required String title,
        double btnHeight = 60,
        double txtSize = 16,
        double btnWidthRatio = 0.9,
        double borderRadius = 30,
        required Function() onPress,
        bool isVisible = true,
        bool iconVisibility = false,
        String iconAssetImage = '',
      }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Get.width * btnWidthRatio,
        height: btnHeight,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
            foregroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                side: BorderSide(
                  color: AppColors.appPrimaryColor,
                ),
              ),
            ),
          ),
          onPressed: onPress,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: iconVisibility,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Image.asset(iconAssetImage, fit: BoxFit.cover, width: 32),
                ),
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyle.size14MediumAppBlackText.copyWith(color: AppColors.appPrimaryColor, fontSize: txtSize, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static roundButton(
      BuildContext context, {
        required String title,
        required Color btnColor,
        required Color txtColor,
        double btnHeight = 48,
        double txtSize = 14,
        double btnWidthRatio = 0.9,
        required Function() onPress,
        bool isVisible = true,
      }) {
    return Visibility(
      visible: isVisible,
      child: SizedBox(
        width: Get.width * btnWidthRatio,
        child: MaterialButton(
          onPressed: onPress,
          height: btnHeight,
          elevation: 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          color: btnColor,
          child: Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: AppTextStyle.size12MediumAppBlackText.copyWith(color: txtColor, fontSize: txtSize, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}