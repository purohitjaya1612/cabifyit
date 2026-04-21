import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../routes/app_pages.dart';
import '../controller/verify_otp_controller.dart';

class VerifyOtpView extends GetView<VerifyOtpController> {

  @override
  var controller = Get.put(VerifyOtpController());

  VerifyOtpView({super.key});
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
                   Text("Please enter the security pin", style: AppTextStyle.size12MediumAppBlackText.copyWith(fontWeight: FontWeight.w400, fontSize: 20)),
                   SizedBox(
                     height: Get.height * 0.02,
                   ),
                   Pinput(
                     useNativeKeyboard: true,
                     controller: controller.otpController,
                     length: 4,
                     closeKeyboardWhenCompleted: true,
                     pinAnimationType: PinAnimationType.scale,
                     pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                     animationCurve: Curves.bounceIn,
                     crossAxisAlignment: CrossAxisAlignment.center,
                     keyboardType: TextInputType.number,
                     autofocus: true,
                     defaultPinTheme: PinTheme(
                       width: Get.width * 0.15,
                       height: Get.width * 0.15,
                       textStyle: AppTextStyle.size14MediumAppBlackText,
                       decoration: BoxDecoration(
                         color: AppColors.white,
                         shape: BoxShape.circle,
                       ),
                     ),
                     validator: (value) {
                       if (value == "") {
                         return 'Please enter OTP';
                       } else if (value!.length < 4) {
                         return 'Please enter valid OTP';
                       }
                       return null;
                     },
                     focusedPinTheme: PinTheme(
                       width: Get.width * 0.15,
                       height: Get.width * 0.15,
                       textStyle: AppTextStyle.size14MediumAppBlackText,
                       decoration: BoxDecoration(
                         color: AppColors.white,
                         shape: BoxShape.circle,
                       ),
                     ),
                     submittedPinTheme: PinTheme(
                       width: Get.width * 0.15,
                       height: Get.width * 0.15,
                       textStyle: AppTextStyle.size14MediumAppBlackText,
                       decoration: BoxDecoration(
                         color: AppColors.white100,
                         shape: BoxShape.circle,
                       ),
                     ),
                     errorPinTheme: PinTheme(
                       width: Get.width * 0.15,
                       height: Get.width * 0.15,
                       textStyle: AppTextStyle.size14MediumAppBlackText,
                       decoration: BoxDecoration(
                         color: AppColors.white,
                         shape: BoxShape.circle,
                         border: Border.all(color: AppColors.red),
                       ),
                     ),),
                   const SizedBox(
                     height: 30,
                   ),
                   AppWidgets.buildButton(
                     title: "Continue",
                     btnWidthRatio: 0.8,
                     onPress: () {
                       FocusScope.of(context).unfocus();
                         controller.verifyPin();
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