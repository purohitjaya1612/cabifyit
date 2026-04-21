import 'package:cabifyit/app/data/services/booking_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/model/rides_model.dart';

class RidesController extends GetxController {
  Rx<DateTime>? selectedDate;
  var selectedTab = 'completed'.obs;
  var page = 1;
  var total = 0;
  var isLoading = true.obs;
  var isMoreLoading = true.obs;
  List<RideData> rides = [];
  ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    getRides();
    scrollController.addListener(() {
      if (rides.length < total && !(isMoreLoading.value) && scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        getRides();
      }
    });
  }


  getRides() async {
    if(page == 1) {
      total = 0;
      isLoading.value = true;
      rides.clear();
    }
    var params = "?page=$page";
    if(selectedDate != null) {
      params = "$params&date=${DateFormat('yyyy-MM-dd').format(selectedDate!.value)}";
    }

    isMoreLoading.value = true;
    update();
    var result = await BookingService().getRides(params: params, type: selectedTab.value);
    isLoading.value = false;
    isMoreLoading.value = false;
    if(result != null) {
      rides.addAll(result.list.data);
      total = int.tryParse(result.list.total.toString()) ?? 0;
    }
    update();
  }

}