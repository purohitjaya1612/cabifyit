import 'package:cabifyit/app/modules/content/binding/content_binding.dart';
import 'package:cabifyit/app/modules/content/view/content_view.dart';
import 'package:cabifyit/app/modules/driver_location/binding/driver_location_binding.dart';
import 'package:cabifyit/app/modules/driver_location/view/driver_location_view.dart';
import 'package:cabifyit/app/modules/rides/binding/rides_binding.dart';
import 'package:cabifyit/app/modules/rides/view/rides_view.dart';
import 'package:cabifyit/app/modules/tickets/binding/tickets_binding.dart';
import 'package:cabifyit/app/modules/tickets/view/tickets_view.dart';
import 'package:cabifyit/app/modules/verify_otp/binding/verify_otp_binding.dart';
import 'package:cabifyit/app/modules/verify_otp/view/verify_otp_view.dart';
import 'package:cabifyit/app/modules/wallet/binding/wallet_binding.dart';
import 'package:cabifyit/app/modules/wallet/view/wallet_view.dart';
import 'package:get/get.dart';
import '../modules/contact_us/binding/contact_us_binding.dart';
import '../modules/contact_us/view/contact_us_view.dart';
import '../modules/dashboard/binding/dashboard_binding.dart';
import '../modules/dashboard/view/dashboard_view.dart';
import '../modules/faq/binding/faq_binding.dart';
import '../modules/faq/view/faq_view.dart';
import '../modules/inbox/binding/inbox_binding.dart';
import '../modules/inbox/view/inbox_view.dart';
import '../modules/location/binding/location_binding.dart';
import '../modules/location/view/location_view.dart';
import '../modules/login/binding/login_binding.dart';
import '../modules/login/view/login_view.dart';
import '../modules/main/binding/main_binding.dart';
import '../modules/main/view/main_view.dart';
import '../modules/message/binding/message_binding.dart';
import '../modules/message/view/message_view.dart';
import '../modules/notification/binding/notification_binding.dart';
import '../modules/notification/view/notification_view.dart';
import '../modules/onboarding/binding/onboarding_binding.dart';
import '../modules/onboarding/view/onboarding_view.dart';
import '../modules/profile/binding/profile_binding.dart';
import '../modules/profile/view/profile_view.dart';
import '../modules/register/binding/register_binding.dart';
import '../modules/register/view/register_view.dart';
import '../modules/ride_bid/binding/ride_bid_binding.dart';
import '../modules/ride_bid/view/ride_bid_view.dart';
import '../modules/ride_detail/binding/ride_detail_binding.dart';
import '../modules/ride_detail/view/ride_detail_view.dart';
import '../modules/safety/binding/safety_binding.dart';
import '../modules/safety/view/safety_view.dart';
import '../modules/splash/binding/splash_binding.dart';
import '../modules/splash/view/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static String INITIAL = Routes.MAIN;

  static final routes = [
    GetPage(
      name: _Paths.MAIN,
      page: () => MainView(),
      binding: MainBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
      binding: SplashBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => OnboardingView(),
      binding: OnboardingBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
      transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.VERIFY_OTP,
        page: () => VerifyOtpView(),
        binding: VerifyOtpBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: RegisterBinding(),
      transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => DashBoardView(),
      binding: DashBoardBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.RIDES,
      page: () => RidesView(),
      binding: RidesBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.RIDEDETAIL,
        page: () => RideDetailView(),
        binding: RideDetailBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.TICKETS,
      page: () => TicketsView(),
      binding: TicketsBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.FAQ,
      page: () => FaqView(),
      binding: FaqBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.CONATCT_US,
      page: () => ContactUsView(),
      binding: ContactUsBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.WALLET,
        page: () => WalletView(),
        binding: WalletBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.CONTENT,
        page: () => ContentView(),
        binding: ContentBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.LOCATION,
        page: () => LocationView(),
        binding: LocationBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.RIDEBIDS,
        page: () => RideBidView(),
        binding: RideBidBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.INBOX,
        page: () => InboxView(),
        binding: InboxBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.MESSAGE,
        page: () => MessageView(),
        binding: MessageBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.DRIVERLOCATION,
        page: () => DriverLocationView(),
        binding: DriverLocationBinding(),
        transition: Transition.downToUp
    ),
    // GetPage(
    //     name: _Paths.RESETPIN,
    //     page: () => ResetPinView(),
    //     binding: ResetPinBinding(),
    //     transition: Transition.downToUp
    // ),
    // GetPage(
    //     name: _Paths.CHANGEPIN,
    //     page: () => ChangePinView(),
    //     binding: ChangePinBinding(),
    //     transition: Transition.downToUp
    // ),
    GetPage(
        name: _Paths.SAFETY,
        page: () => SafetyView(),
        binding: SafetyBinding(),
        transition: Transition.downToUp
    ),
    GetPage(
        name: _Paths.NOTIFICATION,
        page: () => NotificationView(),
        binding: NotificationBinding(),
        transition: Transition.downToUp
    ),
  ];
}
