import 'package:cabifyit/app/data/model/rides_model.dart';
import 'package:cabifyit/app/data/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../reusability/utils/utils.dart';
import '../../rides/controller/rides_controller.dart';

class RideDetailController extends GetxController {
  final otpKey = GlobalKey<FormState>();
  var otpAutoValidate = AutovalidateMode.disabled.obs;
  TextEditingController cancelReasonController = TextEditingController();
  Rx<DateTime>? selectedDate;
  var selectedTab = 'completed'.obs;
  RideData? rideData;
  var rating = '0';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    List args = Get.arguments ?? [];

    if(args.isNotEmpty) {
      rideData = args.first;
      selectedTab.value = args[1];
    }
  }

  rateCustomer() async {
    Utils.showLoadingDialog();
    var body = {
      'booking_id': rideData?.id.toString(),
      'rating': rating
    };
    var result = await BookingService().rateDriver(body: body);
    if(Get.isDialogOpen ?? false) Get.back();
    if(result != null) {
      Get.back();
      var rate = RatingDetail(rating: rating,userType: "user");
      (rideData?.ratingDetail ?? []).add(rate);
      Get.find<RidesController>().rides.forEach((element) {
        if(element == rideData) {
          (element.ratingDetail ?? []).add(rate);
        }
      });
    }
    update();
  }

  cancelBooking() async {
    Utils.showLoadingDialog();
    var body = {
      "booking_id": (rideData?.id ?? 0).toString(),
      "cancel_reason": cancelReasonController.text.trim()
    };
    var result = rideData?.driverDetail != null ? (await BookingService().cancelBooking(body: body)) : (await BookingService().cancelRide(body: body));
    if(Get.isDialogOpen ?? false)Get.back();
    if(result != null) {
      Get.back();
      Get.back();
      update();
    }
  }

  validateReason() {
    if(otpKey.currentState!.validate()) {
      cancelBooking();
    } else {
      otpAutoValidate.value = AutovalidateMode.always;
    }
    update();
  }

}