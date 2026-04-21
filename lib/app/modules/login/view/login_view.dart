import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../reusability/shared/textfied.dart';
import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../routes/app_pages.dart';
import '../controller/login_controller.dart';

class LoginView extends GetView<LoginController> {

  @override
  var controller = Get.put(LoginController());

  LoginView({super.key});
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: Container(
       decoration: BoxDecoration(
         image: DecorationImage(image: AssetImage(AppImages.login), fit: BoxFit.fill),
       ),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
         children: [
           SizedBox(height: MediaQuery.of(context).padding.top + Get.height * 0.03),
           Image.asset(AppImages.textLogo, width: Get.width * 0.6),
           Obx(() => Form(
             key: controller.formKey,
             autovalidateMode: controller.autoValidate.value,
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                 children: [
                   SizedBox(
                     height: Get.height * 0.02,
                   ),
                   Text("Login or Signup", style: AppTextStyle.size12MediumAppBlackText.copyWith(fontWeight: FontWeight.w400, fontSize: 12)),
                   SizedBox(
                     height: Get.height * 0.015,
                   ),
                   Text("Welcome Back!", style: AppTextStyle.size12MediumAppBlackText.copyWith(fontWeight: FontWeight.w400, fontSize: 20)),
                   SizedBox(
                     height: Get.height * 0.02,
                   ),
                   Text(" Existing customers just enter your number. If you're new here, please enter your number and let us sign you up!", textAlign: TextAlign.center, style: AppTextStyle.size12RegularAppBlackText),
                   SizedBox(
                     height: Get.height * 0.02,
                   ),
                   TextFormField(
                       validator: (value) {
                         if((value ?? "").isEmpty) {
                           return "Please Enter Phone Number";
                         }
                         return null;
                       },
                       keyboardType: TextInputType.number,
                       textCapitalization: TextCapitalization.sentences,
                       controller: controller.phoneNumberController,
                       textAlign: TextAlign.start,
                       style: AppTextStyle.size14MediumAppBlackText.copyWith(color: Colors.black),
                       inputFormatters: [
                         FilteringTextInputFormatter.digitsOnly,
                         LengthLimitingTextInputFormatter(12),
                       ],
                       decoration: InputDecoration(
                           isDense: true,
                           contentPadding: const EdgeInsets.symmetric(vertical: 12),
                           prefixIcon: CountryCodePicker(
                             onChanged: (value) {
                               controller.countryCode.value = value.dialCode.toString();
                             },
                             initialSelection: controller.countryCode.value,
                             pickerStyle: PickerStyle.bottomSheet,
                             comparator: (a, b) => b.name!.compareTo(a.name.toString()),
                             flagDecoration: BoxDecoration(
                               borderRadius: BorderRadius.all(Radius.circular(2)),
                               color: AppColors.appPrimaryColor
                             ),
                           ),
                           filled: true,
                           fillColor: AppColors.white,
                           disabledBorder: selectedTextFieldBorder(radius: 30),
                           focusedBorder: selectedTextFieldBorder(radius: 30),
                           enabledBorder: selectedTextFieldBorder(radius: 30),
                           errorBorder: selectedTextFieldBorder(radius: 30),
                           border: selectedTextFieldBorder(radius: 30),
                           hintText: "Phone number")),
                   SizedBox(height: Get.height * 0.02),
                   TextFieldTheme.buildTextFiled(hintText: "Company Id", controller: controller.tenantController, validator: (value) {
                     if((value ?? "").trim().isEmpty) {
                       return "Please Enter Company Id";
                     }
                     return null;
                   },),
                   const SizedBox(
                     height: 30,
                   ),
                   AppWidgets.buildButton(
                     title: "Next",
                     btnWidthRatio: 0.8,
                     onPress: () {
                       FocusScope.of(context).unfocus();
                       controller.validate();
                     },
                   ),
                   const SizedBox(
                     height: 10,
                   ),
                   Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                       child: Text.rich(
                         textAlign: TextAlign.center,
                         TextSpan(
                           text: 'By tapping "Next" you agree to '.tr,
                           style: AppTextStyle.size14MediumAppBlackText,
                           children: <TextSpan>[
                             TextSpan(
                                 recognizer: TapGestureRecognizer()
                                   ..onTap = () {
                                   Get.toNamed(Routes.CONTENT, arguments: ['Terms & conditions']);
                                   },
                                 text: 'Terms & conditions',
                                 style: AppTextStyle.size14MediumAppBlackText.copyWith(decoration: TextDecoration.underline, color: AppColors.appPrimaryColor)),
                             TextSpan(text: ' and ', style: AppTextStyle.size14MediumAppBlackText),
                             TextSpan(
                                 recognizer: TapGestureRecognizer()
                                   ..onTap = () {
                                     Get.toNamed(Routes.CONTENT, arguments: ['Privacy Policy']);
                                   },
                                 text: 'privacy policy',
                                 style: AppTextStyle.size14MediumAppBlackText.copyWith(decoration: TextDecoration.underline, color: AppColors.appPrimaryColor)),
                             // can add more TextSpans here...
                           ],
                         ),
                       )
                   )
                 ],
               ),
             ),
           ))
         ],
       ),
     ),
   );
  }

}