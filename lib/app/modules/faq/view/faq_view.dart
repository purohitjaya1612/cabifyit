import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_textstyle.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../controller/faq_controller.dart';

class FaqView extends GetView<FaqController> {

  @override
  final controller = Get.put(FaqController());

  FaqView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: "FAQs"),
      body: GetBuilder<FaqController>(
        builder: (context) {
          return controller.isLoading.value?Center(child: loader()):
          controller.faqs.isEmpty?Center(child: noDataFound()):
          ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            itemCount: controller.faqs.length,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: Get.width * 0.03),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grey)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.faqs[index].isSelected= !controller.faqs[index].isSelected;
                        controller.update();
                      },
                      child: Row(
                        children: [
                          Expanded(child: Text(controller.faqs[index].question ?? "", style: AppTextStyle.size14MediumAppBlackText)),
                          Icon(Icons.keyboard_arrow_down)
                        ],
                      ),
                    ),
                    if(controller.faqs[index].isSelected)SizedBox(height: 5),
                    if(controller.faqs[index].isSelected)Text(controller.faqs[index].answer ?? "", style: AppTextStyle.size12MediumAppBlackText.copyWith(color: AppColors.textGrey))
                  ],
                ),
              );
            },
          );
        }
      ),
    );
  }

}