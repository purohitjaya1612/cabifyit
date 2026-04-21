import 'package:cabifyit/reusability/theme/app_images.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';

class OnboardingController extends GetxController {

  var selectedPageIndex = 0.obs;

  bool get isLastPage => selectedPageIndex.value == onBoardingImages.length - 1;
  var swiperController = SwiperController();

  var onBoardingImages = [
    AppImages.onboarding1,
    AppImages.onboarding2,
    AppImages.onboarding3
  ];

  var onBoardingText = [
    "Set Your Own Price",
    "Rides on Your Terms",
    "Safe & Reliable",
  ];

  var onBoardingDescription = [
    "You offer what feels right — drivers nearby can accept or negotiate. You stay in control.",
    "Find nearby drivers within seconds. Choose who you ride with and when. Simple, quick, and fair.",
    "Every driver is verified and rated. You choose who you trust — your safety, your say.",
  ];
}