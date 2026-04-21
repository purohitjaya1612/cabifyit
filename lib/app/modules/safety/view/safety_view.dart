import 'package:cabifyit/app/routes/app_pages.dart';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../reusability/theme/app_colors.dart';
import '../controller/safety_controller.dart';

class SafetyView extends GetView<SafetyController> {

  @override
  var controller = Get.put(SafetyController());

  SafetyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "Safety"),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Get.width * 0.05),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.white
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.TICKETS);
                        },
                        child: Container(
                          height: Get.width * 0.38,
                          width: Get.width * 0.38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFFF9F5EB)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.mail, height: Get.width * 0.19),
                              SizedBox(height: Get.width * 0.02),
                              Text("Support", style: AppTextStyle.size16MediumAppBlackText)
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          var number = Utils().getBox("support_no");
                          print("Number : $number");
                          launchUrl(Uri.parse("tel:$number"));
                        },
                        child: Container(
                          height: Get.width * 0.38,
                          width: Get.width * 0.38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFF8FAFF)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.guide, height: Get.width * 0.19),
                              SizedBox(height: Get.width * 0.02),
                              Text("Contact", style: AppTextStyle.size16MediumAppBlackText)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.width * 0.04),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          var number = Utils().getBox("emergency_no");
                          print("Number : $number");
                          launchUrl(Uri.parse("tel:$number"));
                        },
                        child: Container(
                          height: Get.width * 0.38,
                          width: Get.width * 0.38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFF9EBEB)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.emergency, height: Get.width * 0.19),
                              SizedBox(height: Get.width * 0.02),
                              Text("Call Emergency", style: AppTextStyle.size16MediumAppBlackText)
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          var number = Utils().getBox("rescue_no");
                          print("Number : $number");
                          launchUrl(Uri.parse("tel:$number"));
                        },
                        child: Container(
                          height: Get.width * 0.38,
                          width: Get.width * 0.38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFCB292C)
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(AppImages.rescue, height: Get.width * 0.2,),
                              SizedBox(height: Get.width * 0.02),
                              Text("Call Rescue", style: AppTextStyle.size16MediumAppBlackText.copyWith(color: AppColors.white))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.width * 0.04),
                  Row(
                    children: [
                      Image.asset(AppIcons.info, height: Get.width * 0.04),
                      SizedBox(width: Get.width * 0.02),
                      Text("You can call emergency service directly", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey))
                    ],
                  )
                ],
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(Get.width * 0.03),
              decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.lightBlue)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("How you are protected", overflow: TextOverflow.ellipsis, style: AppTextStyle.size14MediumAppBlackText),
                  SizedBox(height: 10),
                  Text("You can call or send sms to your emergency contact direct from app", maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyle.size12RegularAppBlackText),
                  SizedBox(height: 5),
                  Divider(color: AppColors.grey),
                  SizedBox(height: 5),
                  Obx(() => controller.emergencyNumber.value.isNotEmpty?GestureDetector(
                    onTap: () {
                      controller.nameController.text = controller.emergencyName.value;
                      controller.numberController.text = controller.emergencyNumber.value;
                      commonBottomSheet(addContact());
                    },
                    child: Row(
                      children: [
                        Expanded(child: Text(controller.emergencyName.value, overflow: TextOverflow.ellipsis, style: AppTextStyle.size22MediumAppBlackText)),
                        GestureDetector(
                          onTap: () {
                            launchUrlString("tel:${controller.countryCode.value}${controller.emergencyNumber.value}");
                          },
                          child: Container(
                            height: Get.width * 0.1,
                            width: Get.width * 0.1,
                            padding: EdgeInsets.all(Get.width * 0.03),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                            ),
                            child: Image.asset(AppIcons.call, color: AppColors.appPrimaryColor,),
                          ),
                        ),
                        SizedBox(width: Get.width * 0.03),
                        GestureDetector(
                          onTap: () {
                            launchUrlString("sms:${controller.countryCode.value}${controller.emergencyNumber.value}");
                          },
                          child: Container(
                            height: Get.width * 0.1,
                            width: Get.width * 0.1,
                            padding: EdgeInsets.all(Get.width * 0.03),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                            ),
                            child: Image.asset(AppIcons.message, color: AppColors.appPrimaryColor,),
                          ),
                        )
                      ],
                    ),
                  ):
                  GestureDetector(
                    onTap: () {
                      commonBottomSheet(addContact());
                    },
                    child: Row(
                      children: [
                        Text("Add Emergency Contact", style: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                        SizedBox(width: 2),
                        Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.appPrimaryColor)
                      ],
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget addContact() {
    return Obx(() => Form(
      key: controller.formKey,
      autovalidateMode: controller.autoValidate.value,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.white
        ),
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
            Center(child: Text("Add Emergency Contact", style: AppTextStyle.size16RegularAppBlackText.copyWith(fontSize: 22))),
            SizedBox(height: 10),
            Text("Name", style: AppTextStyle.size16MediumAppBlackText),
            SizedBox(height: 10),
            TextFormField(
                validator: (value) {
                  if((value ?? "").isEmpty) {
                    return "Please Enter Name";
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.sentences,
                controller: controller.nameController,
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
                    hintText: "Enter name")),
            SizedBox(height: 10),
            Text("Phone Number", style: AppTextStyle.size16MediumAppBlackText),
            SizedBox(height: 10),
            TextFormField(
                validator: (value) {
                  if((value ?? "").isEmpty) {
                    return "Please Enter Phone Number";
                  } else if (value!.length != 10) {
                    return "Please Enter Valid Phone Number";
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.sentences,
                controller: controller.numberController,
                textAlign: TextAlign.start,
                style: AppTextStyle.size14MediumAppBlackText.copyWith(color: Colors.black),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 20),
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
                    disabledBorder: selectedTextFieldBorder(radius: 20),
                    focusedBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.appPrimaryColor),
                    enabledBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.lightBlue),
                    errorBorder: selectedTextFieldBorder(radius: 20, borderColor: AppColors.red),
                    border: selectedTextFieldBorder(radius: 20, borderColor: AppColors.lightBlue),
                    hintText: "Phone number")),
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
      ),
    ));
  }

}