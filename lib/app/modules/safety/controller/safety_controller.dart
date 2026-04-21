
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../reusability/utils/utils.dart';


class SafetyController extends GetxController {
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  var emergencyName = "".obs;
  var emergencyNumber = "".obs;
  var countryCode = "+92".obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getEmergencyContact();
  }


  getEmergencyContact() {
    emergencyName.value = Utils().getEmergencyContactName() ?? "";
    emergencyNumber.value = Utils().getEmergencyContactNumber() ?? "";
    countryCode.value = Utils().getEmergencyCountryCode() ?? "";
    update();
  }

  addEmergencyContact() {
    Utils().setEmergencyContactName(nameController.text);
    Utils().setEmergencyContactNumber(numberController.text);
    Utils().setEmergencyCountryCode(countryCode.value);
    getEmergencyContact();
  }

  validate() {
    if(formKey.currentState!.validate()) {
      Get.back();
      addEmergencyContact();
    } else {
      autoValidate.value = AutovalidateMode.always;
    }
    update();
  }
}