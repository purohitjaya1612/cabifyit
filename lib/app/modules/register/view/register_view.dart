import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../reusability/shared/textfied.dart';
import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';
import '../controller/register_controller.dart';

class RegisterView extends GetView<RegisterController> {

  @override
  var controller = Get.put(RegisterController());

  RegisterView({super.key});
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
                   Text("Signup", style: AppTextStyle.size20MediumAppBlackText.copyWith(fontWeight: FontWeight.w400)),
                   SizedBox(
                     height: Get.height * 0.02,
                   ),
                   TextFieldTheme.buildTextFiled(hintText: "Full Name", controller: controller.nameController),
                   SizedBox(height: Get.height * 0.02),
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
                       enabled: false,
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
                             enabled: false,
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
                   const SizedBox(
                     height: 30,
                   ),
                   TextFieldTheme.buildTextFiled(hintText: "Email", controller: controller.emailController),
                   SizedBox(height: Get.height * 0.02),
                   TextFieldTheme.buildTextFiled(hintText: "Company Id", controller: controller.tenantController, validator: (value) {
                     if((value ?? "").trim().isEmpty) {
                       return "Please Enter Company Id";
                     }
                     return null;
                   },),
                   SizedBox(height: Get.height * 0.02),
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