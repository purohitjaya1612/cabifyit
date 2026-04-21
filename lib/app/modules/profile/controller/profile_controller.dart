import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../../reusability/utils/utils.dart';
import '../../../data/services/profile_service.dart';

class ProfileController extends GetxController {
  ProfileService profileService = ProfileService();
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;
  var isLoading = true.obs;
  var imagePath = "".obs;
  var networkImagePath = "".obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var countryCode = "+92".obs;
  @override
  void onInit() {
    super.onInit();
    getProfile();
  }


  getProfile() async {
    isLoading.value = true;
    var result = await profileService.getProfile();
    isLoading.value = false;

    if(result != null) {
      emailController.text = result.data?.email ?? "";
      nameController.text = result.data?.name ?? "";
      phoneController.text = result.data?.phoneNo ?? "";
      countryCode.value = result.data?.countryCode ?? "";
      networkImagePath.value = result.data?.profile ?? "";
      Utils().setBox("userEmail", result.data?.email ?? "");
      Utils().setBox("userPhone", result.data?.phoneNo ?? "");
      Utils().setBox("userName", result.data?.name?? "");
      Utils().setBox("userCountryCode", result.data?.countryCode ?? "");
      Utils().setBox("userImage", result.data?.profile ?? "");
      Utils().setBox("walletBalance", result.data?.walletBalance ?? "");
    }
  }

  updateProfile() async {
    var body = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone_no": phoneController.text.trim(),
      "country_code": countryCode.value,
    };

    List<http.MultipartFile> files = [];
    
    if(imagePath.value.isNotEmpty) {
      http.MultipartFile file = await http.MultipartFile.fromPath(
        'profile_image',
        imagePath.value,
      );
      files.add(file);
    }
    Utils.showLoadingDialog();
    var result = await profileService.updateProfile(body: body, files: files);
    if(Get.isDialogOpen ?? false) Get.back();
    if(result != null) {
      Utils.toastOk(result.message ?? "");
      getProfile();
    }
  }

  validate() {
    if(formKey.currentState!.validate()) {
      updateProfile();
    } else {
      autoValidate.value = AutovalidateMode.always;
      update();
    }
  }

}