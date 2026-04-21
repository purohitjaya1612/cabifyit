import 'package:cabifyit/app/data/model/tickets_model.dart';
import 'package:cabifyit/app/data/services/general_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_images.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';

class TicketsController extends GetxController {
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var autoValidate = AutovalidateMode.disabled.obs;
  GeneralService generalService = GeneralService();
  var page = 1;
  var total = 0;
  List<TicketsData> tickets = [];
  var isLoading = true.obs;
  var isMoreLoading = true.obs;
  ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    getTickets();
    scrollController.addListener(() {
      if (tickets.length < total && !(isMoreLoading.value) && scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        page++;
        getTickets();
      }
    });
  }

  getTickets() async {
    if(page == 1) {
      isLoading.value = true;
      tickets.clear();
    }
    isMoreLoading.value = true;
    update();
    var result = await generalService.getMyTicket(page: page);
    isLoading.value = false;
    isMoreLoading.value = false;
    if(result != null) {
      tickets.addAll(result.list?.data ?? []);
      total = int.tryParse(result.list?.total ?? "0") ?? 0;
    }
    update();
  }

  addTicket() async {
    Utils.showLoadingDialog();
    var body = {
      "subject": subjectController.text.trim(),
      "message": descriptionController.text.trim()
    };
    var result = await generalService.addTicket(body: body);
    if(Get.isDialogOpen ?? false)Get.back();
    if(result != null) {
      subjectController.text = '';
      descriptionController.text = '';
      Get.back();
      page = 1;
      getTickets();
      commonBottomSheet(success());
    }
  }

  validate() {
    if(formKey.currentState!.validate()) {
      addTicket();
    } else {
      autoValidate.value = AutovalidateMode.always;
    }
  }

  Widget success() {
    return Container(
      width: Get.width,
      padding: EdgeInsets.only(left: Get.width * 0.05, right: Get.width * 0.05, bottom: 50),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          color: AppColors.white
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
          Image.asset(AppImages.success, width: Get.width * 0.2),
          SizedBox(height: 20),
          Text("Successfully Sent", style: AppTextStyle.size20RegularAppBlackText),
          SizedBox(height: 10),
          Text("Your ticket has been raised successfully.", style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.textGrey)),
          SizedBox(height: 20),
          AppWidgets.buildButton(
            title: "Okay",
            btnWidthRatio: 1,
            onPress: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}