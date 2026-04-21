import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';
import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../routes/app_pages.dart';
import '../controller/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetX<OnboardingController>(
        builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Swiper(
                    itemCount: controller.onBoardingImages.length,
                    controller: controller.swiperController,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          SizedBox(
                            height: MediaQuery
                                .of(context)
                                .padding
                                .top,
                          ),
                          Expanded(
                            child: Image.asset(
                              controller.onBoardingImages[controller
                                  .selectedPageIndex.value], width: Get.width,
                              fit: BoxFit.fitWidth,),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Text(
                            controller.onBoardingText[index],
                            style: AppTextStyle.size12MediumAppBlackText.copyWith(fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.8),
                          ),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              controller.onBoardingDescription[index],
                              textAlign: TextAlign.center,
                              style: AppTextStyle.size12MediumAppBlackText.copyWith(fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.5),
                            ),
                          ),
                        ],
                      );
                    },
                    loop: false,
                    onIndexChanged: (value) {
                      controller.selectedPageIndex.value = value;
                      controller.update();
                    },
                  )
              ),
              SizedBox(
                height: Get.height * 0.01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.onBoardingImages.length,
                        (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: controller.selectedPageIndex.value == index ? AppColors.appPrimaryColor : const Color(0xffD4D5E0),
                          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        )),
                  ),
                ),
              ),
              AppWidgets.buildButton(
                title: controller.selectedPageIndex.value == 2 ? "Let's Go" : 'Next',
                btnRadius: 30,
                onPress: () {
                  if (controller.selectedPageIndex.value == 2) {
                    Utils().setOnboarding(true);
                    Get.offAllNamed(Routes.LOGIN);
                  } else {
                    controller.swiperController.next();
                    // controller.pageController.jumpToPage(controller.selectedPageIndex.value + 1);
                  }
                },
              ),
              SizedBox(
                height: Get.height * 0.06,
              )
            ],
          );
        }
      ),
    );
  }
}