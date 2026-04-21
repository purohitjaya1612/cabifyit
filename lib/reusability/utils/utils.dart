import 'dart:ui';
import 'package:cabifyit/app/data/services/api_url_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../app/routes/app_pages.dart';
import '../theme/app_colors.dart';
import '../theme/app_textstyle.dart';
import 'package:url_launcher/url_launcher_string.dart';

TextStyle getAppFont(TextStyle textStyle) {
  return GoogleFonts.poppins(textStyle: textStyle);
}

OutlineInputBorder selectedTextFieldBorder({double? radius, bool isDisable = false, Color? borderColor}) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: borderColor ?? (isDisable?AppColors.black.withOpacity(0.5):AppColors.white), width: 1),
    borderRadius: BorderRadius.circular(radius ?? 5),
  );
}

OutlineInputBorder errorBorder({double? radius}) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.red, width: 1),
    borderRadius: BorderRadius.circular(radius ?? 5),
  );
}

Widget requiredField({required String title}) {
  return RichText(text: TextSpan(
    children: [
      TextSpan(text: title, style: AppTextStyle.size12MediumAppBlackText),
      TextSpan(text: "*", style: AppTextStyle.size12MediumAppBlackText.copyWith(color: AppColors.red))
    ]
  ));
}

class Utils {
  var box = GetStorage();

  void setBox(String key, String val) {
    box.write(key, val);
  }

  void setLogin(bool val) {
    box.write('isLogin', val);
  }

  void setTheme(bool val) {
    box.write('isDarkMode', val);
  }

  void setMap(bool val) {
    box.write('isGoogleMap', val);
  }

  void setSearch(bool val) {
    box.write('isGoogleSearch', val);
  }

  void setBarikoiMapKey(String val) {
    box.write('barikoiMapKey', val);
  }

  void setGoogleMapKey(String val) {
    box.write('googleMapKey', val);
  }

  void setOnboarding(bool val) {
    box.write('isOnboardingCompleted', val);
  }

  void setSearchedLocation(String val) {
    box.write('searchedLocation', val);
  }

  void setEmergencyContactName(String val) {
    box.write('emergencyName', val);
  }

  void setEmergencyContactNumber(String val) {
    box.write('emergencyNumber', val);
  }

  void setEmergencyCountryCode(String val) {
    box.write('emergencyCountryCode', val);
  }

  setTenantId(String val) {
    box.write("tenant_id", val);
  }

  getBox(String key) {
    try {
      return box.read(key);
    } catch (e) {
      return "";
    }
  }

  bool isLogin() {
    try {
      return box.read('isLogin');
    } catch (e) {
      return false;
    }
  }

  bool isDarkMode() {
    try {
      return box.read('isDarkMode');
    } catch (e) {
      return false;
    }
  }

  bool isOnboardingCompleted() {
    try {
      return box.read('isOnboardingCompleted');
    } catch (e) {
      return false;
    }
  }

  String? getToken() {
    try {
      return "Bearer ${box.read("token")}";
    } catch (e) {
      return null;
    }
  }

  String getTenantId() {
    try {
      return box.read("tenant_id");
    } catch (e) {
      return "";
    }
  }

  bool getMap() {
    try {
      return box.read("isGoogleMap");
    } catch (e) {
      return false;
    }
  }

  bool getSearch() {
    try {
      return box.read("isGoogleSearch");
    } catch (e) {
      return false;
    }
  }

  String getBarikoiMapKey() {
    try {
      return box.read("barikoiMapKey");
    } catch (e) {
      return "";
    }
  }

  String getGoogleMapKey() {
    try {
      return box.read("googleMapKey");
    } catch (e) {
      return "";
    }
  }

  String getSearchedLocation() {
    try {
      return box.read("searchedLocation");
    } catch (e) {
      return "[]";
    }
  }

  String? getUserId() {
    try {
      return box.read("userId");
    } catch (e) {
      return null;
    }
  }

  String? getUserEmail() {
    try {
      return box.read("userEmail");
    } catch (e) {
      return null;
    }
  }

  String? getUserPhone() {
    try {
      return "${box.read("userPhone")}";
    } catch (e) {
      return null;
    }
  }

  String? getUserCountryCode() {
    try {
      return "${box.read("userCountryCode")}";
    } catch (e) {
      return null;
    }
  }

  String getUserPhoneNumber() {
    return "${box.read("userCountryCode") ?? ""} ${box.read("userPhone") ?? ""}";
  }

  String? countryOfUser() {
    try {
      return box.read("country_of_user");
    } catch (e) {
      return null;
    }
  }

  String? getReferralCode() {
    try {
      return box.read("referralCode");
    } catch (e) {
      return null;
    }
  }

  String? getUserImage() {
    try {
      return box.read("userImage");
    } catch (e) {
      return null;
    }
  }

  String? getEmergencyContactName() {
    try {
      return box.read("emergencyName");
    } catch (e) {
      return null;
    }
  }

  String? getEmergencyContactNumber() {
    try {
      return box.read("emergencyNumber");
    } catch (e) {
      return null;
    }
  }

  String? getEmergencyCountryCode() {
    try {
      return box.read("emergencyCountryCode");
    } catch (e) {
      return null;
    }
  }

  String? getUserName() {
    try {
      return box.read("userName");
    } catch (e) {
      return null;
    }
  }

  String getCurrencySymbol() {
    try {
      return box.read("currency_symbol");
    } catch (e) {
      return "\$ ";
    }
  }

  String getCurrency() {
    try {
      return box.read("currency");
    } catch (e) {
      return "USD";
    }
  }

  String getSymbolCurrency(String currencyCode) {
    final format = NumberFormat.simpleCurrency(name: currencyCode);
    return format.currencySymbol;
  }

  String getWalletBalance() {
    try {
      return box.read("walletBalance");
    } catch (e) {
      return "0";
    }
  }

  String getStripeKey() {
    try {
      return box.read("stripe_key");
    } catch (e) {
      return "";
    }
  }

  static void toastOk(String msg) {
    _toast(msg, Colors.green);
  }

  static void toastError(String msg, {bool exit = true}) {
    _toast(msg, Colors.red, exit: exit);
  }

  static void toastWarning(String msg) {
    _toast(msg, Colors.red);
  }

  static void _toast(String msg, Color bg,
      {bool exit = true}) {

    Get.showSnackbar(GetSnackBar(
      message: msg,
      padding: EdgeInsets.symmetric(vertical: 20,horizontal: Get.width * 0.03),
      backgroundColor: bg,
      duration: const Duration(seconds: 2),
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
      dismissDirection: DismissDirection.horizontal,
      isDismissible: true,
    ));
  }

  static showLoadingDialog() {
    return Get.dialog(
      Center(
        child: CircularProgressIndicator(color: AppColors.appPrimaryColor),
      ),
      barrierDismissible: true,
    );
  }

  logOutData() async {
    Utils().setLogin(false);
    Utils().setBox("token", "");
    Utils().setBox("userId", "");
    Utils().setBox("userName", "");
    Utils().setBox("userEmail", "");
    // Utils().setBox("userPhone", "");
    Utils().setBox("userImage", "");
    Utils().setBox("userUniqueId", "");
    Get.offNamedUntil(Routes.LOGIN, (route) => false);
  }
}

Widget noDataFound() {
  return Center(
    child: Text("No Data Found",style: AppTextStyle.size16MediumAppBlackText),
  );
}

Widget commonButton({required String title, Function()? onTap,double? height, double? width,Color? bgColor, Color? borderColor, TextStyle? textStyle,double? radius}) {
  return GestureDetector(
    onTap: onTap ?? () {},
    child: Container(
      height: height ?? Get.height * 0.06,
      width: width ?? Get.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(color: borderColor ?? AppColors.appPrimaryColor),
        color: bgColor ?? AppColors.appPrimaryColor,
        borderRadius: BorderRadius.circular(radius ?? 5),
      ),
      child: Text(title, style: textStyle ?? AppTextStyle.size18MediumAppBlackText.copyWith(color: AppColors.white)),
    ),
  );
}

Widget loader() {
  return CupertinoActivityIndicator(color: AppColors.appPrimaryColor);
}

Future<void> commonDialogBox(child, {barrierDismissible = true,isBackVisible = false, padding, radius = 10.00, width}) {
  return Get.dialog(
    Material(
      type: MaterialType.transparency,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius)),
                child: Stack(
                  children: [
                    Container(
                        width: width ?? Get.width * 0.8,
                        padding: EdgeInsets.all(padding ?? 2.0),
                        child: child ?? Container()),
                    Visibility(
                      visible: isBackVisible,
                      child: Positioned(
                        top: 15,
                        right: 15,
                        child: GestureDetector(
                          onTap: () {
                            if (Get.isDialogOpen!) Get.back();
                          },
                          child: const Icon(Icons.close,size: 20,),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: barrierDismissible,
  );
}

Future<void> commonBottomSheet(child, {double? initialValue, double? minValue, double? maxValue}) {
  return Get.bottomSheet(
    isDismissible: true,
    enableDrag: true,
    isScrollControlled: true,
      enterBottomSheetDuration: Duration(milliseconds: 300),
      exitBottomSheetDuration: Duration(milliseconds: 300),
      child
      // DraggableScrollableSheet(
      //   initialChildSize: initialValue ?? 0.5,
      //   minChildSize: minValue ?? 0.1,
      //   maxChildSize: maxValue ?? 0.8,
      //   builder: (context, s) {
      //     return Padding(
      //       padding: EdgeInsets.only(bottom: MediaQuery.of(Get.context!).viewInsets.bottom),
      //         child: child
      //     );
      //   },
      // )
  );
}

getImage(String image) {
  return "${ApiUrlList.baseUrl}$image";
}
