import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import '../utils/utils.dart';

class TextFieldTheme {
  const TextFieldTheme({Key? key});

  static buildTextFiled({
        required String hintText,
        required TextEditingController controller,
        TextInputType keyBoardType = TextInputType.text,
        bool enable = true,
        bool readOnly = false,
        bool obscureText = false,
        int maxLine = 1,
        List<TextInputFormatter>? inputFormatters,
        Widget? prefix,
        Widget? suffix,
        double? height,
        double? radius,
        double? verticalPadding,
        TextStyle? hintStyle,
        Color? borderColor,
        String? Function(String?)? validator,
        Function()? onTap,
        ValueChanged<String>? onChange
      }) {

    return SizedBox(
      height: height,
      child: TextFormField(
          controller: controller,
          textAlign: TextAlign.start,
          enabled: enable,
          keyboardType: keyBoardType,
          maxLines: maxLine,
          readOnly: readOnly,
          onTap: onTap,
          onChanged: onChange,
          obscureText: obscureText,
          validator: validator,
          inputFormatters: inputFormatters,
          style: AppTextStyle.size14MediumAppBlackText,
          scrollPadding: EdgeInsets.zero,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: Get.width * 0.03, vertical: verticalPadding ?? 1),
            prefix: prefix,
              suffix: suffix,
              filled: true,
              fillColor: AppColors.white,
              disabledBorder: selectedTextFieldBorder(radius: radius ?? 30),
              focusedBorder: selectedTextFieldBorder(radius: radius ?? 30, borderColor: AppColors.appPrimaryColor),
              enabledBorder: selectedTextFieldBorder(radius: radius ?? 30, borderColor: borderColor),
              errorBorder: selectedTextFieldBorder(radius: radius ?? 30, borderColor: AppColors.red),
              border: selectedTextFieldBorder(radius: radius ?? 30, borderColor: borderColor),
              hintText: hintText,
            hintStyle: hintStyle
          )),
    );
  }
}
