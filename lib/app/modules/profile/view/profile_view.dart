import 'dart:io';

import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../reusability/shared/textfied.dart';
import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';
import '../controller/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {

  @override
  var controller = Get.put(ProfileController());

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "Profile"),
      body: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05, vertical: Get.height * 0.03),
        child: Obx(() => controller.isLoading.value?Center(child: loader()):Form(
          key: controller.formKey,
          autovalidateMode: controller.autoValidate.value,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Obx(() => controller.imagePath.value.isNotEmpty?
                    Container(
                      height: Get.width * 0.3,
                      width: Get.width * 0.3,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(image: FileImage(File(controller.imagePath.value)), fit: BoxFit.cover)
                      ),
                    ):
                    controller.networkImagePath.isNotEmpty?
                    CachedNetworkImage(
                      imageUrl: getImage(controller.networkImagePath.value),
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: Get.width * 0.3,
                          width: Get.width * 0.3,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
                          ),
                        );
                      },
                      progressIndicatorBuilder: (context, url, progress) {
                        return SizedBox(
                          height: Get.width * 0.3,
                          width: Get.width * 0.3,
                          child: Center(
                              child: loader()
                          ),
                        );
                      },
                      errorWidget: (context, url, error) {
                        return SizedBox(
                          height: Get.width * 0.3,
                          width: Get.width * 0.3,
                          child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.asset(AppImages.profile,height: Get.width * 0.2)
                          ),
                        );
                      },
                    ):
                    SizedBox(
                      height: Get.width * 0.3,
                      width: Get.width * 0.3,
                      child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset(AppImages.profile,height: Get.width * 0.2,)
                      ),
                    )),
                    GestureDetector(
                      onTap: () async {
                        var image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 50);

                        if(image != null) {
                          controller.imagePath.value = image.path;
                          controller.update();
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(Get.width * 0.02),
                          decoration: BoxDecoration(
                              color: AppColors.appPrimaryColor,
                              shape: BoxShape.circle
                          ),
                          child: Image.asset(AppIcons.edit, width: Get.width * 0.03, color: AppColors.white),
                    )),
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.02),
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
                  controller: controller.phoneController,
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
              AppWidgets.buildButton(
                title: "Update",
                btnRadius: 30,
                onPress: () {
                  controller.validate();
                },
              )
            ],
          ),
        )),
      ),
    );
  }

}