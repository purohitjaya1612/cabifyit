

import '../../../reusability/utils/utils.dart';

class ApiUrlList {
  static String baseUrl = "https://backend.cabifyit.com/";
  static String apiBaseUrl = "${baseUrl}api/rider/";

  ///Auth APIs'
  static String loginApi = '${apiBaseUrl}login';
  static String logoutApi = '${apiBaseUrl}logout';
  static String registerApi = '${apiBaseUrl}register';
  static String verifyOtpApi = '${apiBaseUrl}verify-otp';
  static String deleteAccountApi = '${apiBaseUrl}delete-account';

  ///Faq APIs
  static String faqApi = '${apiBaseUrl}faqs';

  ///Support APIs
  static String ticketsApi = '${apiBaseUrl}list-ticket';
  static String createTicketApi = '${apiBaseUrl}create-ticket';

  ///Profile APIs
  static String getProfile = "${apiBaseUrl}get-profile";
  static String updateProfile = "${apiBaseUrl}update-profile";

  ///Vehicle APIs
  static String getVehicles = "${apiBaseUrl}vehicle-list";

  ///Wallet APIs
  static String addMoney = '${apiBaseUrl}add-wallet-amount';
  static String walletHistory = '${apiBaseUrl}balance-transaction';

  ///Booking APIs
  static String calculatePrice = '${apiBaseUrl}calculate-fare';
  static String getCurrentRide = '${apiBaseUrl}current-ride';
  static String getPrices = '${apiBaseUrl}ride/get-price';
  static String placeRide = '${apiBaseUrl}create-booking';
  static String cancelCurrentRide = '${apiBaseUrl}cancel-confirm-ride';
  static String cancelRide = '${apiBaseUrl}cancel-ride';
  static String getPlots = '${apiBaseUrl}get-plot';
  static String changeBidStatus = '${apiBaseUrl}change-bid-status';
  static String rateRide = '${apiBaseUrl}rate-ride';


  ///Rides APIs
  static String getCompletedRides = '${apiBaseUrl}completed-ride';
  static String getCancelledRides = '${apiBaseUrl}cancelled-ride';
  static String getUpcomingRides = '${apiBaseUrl}upcoming-ride';

  ///Messages APIs
  static String getChats = '${apiBaseUrl}message-list';
  static String getMessages = '${apiBaseUrl}message-history';
  static String sendMessages = '${apiBaseUrl}send-message';


  ///Setting APIs
  static String getApiKeys = '${apiBaseUrl}get-api-keys';
  static String storeToken = '${apiBaseUrl}store-token';

  ///Policies
  static String policies = '${apiBaseUrl}policies';

  ///Contact Us
  static String contactUs = '${apiBaseUrl}create-contact-us';

  ///Notification APIs
  static String notificationApi = '${apiBaseUrl}notification-list';

  ///Barikoi
  static String findPlaces = 'https://barikoi.xyz/api/v2/autocomplete/new?country_code=${Utils().countryOfUser()}&bangla=false&key=${Utils()
      .getBarikoiMapKey()}&q=';

  static String getAddress = 'https://barikoi.xyz/v2/api/search/reverse/geocode?country_code=${Utils().countryOfUser()}&bangla=false&api_key=${Utils()
      .getBarikoiMapKey()}&country_code=pk&district=true&post_code=true&country=true&sub_district=true&union=true&pauroshova=true&location_type=true&division=true&address=true&area=true&bangla=false';
}
