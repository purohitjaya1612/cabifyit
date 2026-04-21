import 'package:cabifyit/app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/theme/app_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/routes/app_pages.dart';
import '../theme/app_colors.dart';
import '../theme/app_images.dart';
import '../theme/app_textstyle.dart';
import '../utils/utils.dart';

class CommonDrawer extends StatelessWidget {
  final bool fromOther;
  const CommonDrawer({super.key, this.fromOther = false});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: Get.width * 0.9,
      backgroundColor: AppColors.white100,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: MediaQuery.viewPaddingOf(context).top + Get.height * 0.02),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: getImage(Utils().getUserImage() ?? ""),
                    imageBuilder: (context, imageProvider) {
                      return Container(
                        height: Get.width * 0.12,
                        width: Get.width * 0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover)
                        ),
                      );
                    },
                    progressIndicatorBuilder: (context, url, progress) {
                      return Container(
                        height: Get.width * 0.12,
                        width: Get.width * 0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white
                        ),
                        child: loader(),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        height: Get.width * 0.12,
                        width: Get.width * 0.12,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.white,
                            image: DecorationImage(image: AssetImage(AppImages.profile), fit: BoxFit.cover)
                        ),
                      );
                    },
                  ),
                  SizedBox(width: Get.width * 0.02),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Utils().getUserName() ?? "", style: AppTextStyle.size16RegularAppBlackText),
                        SizedBox(height: 5),
                        Text(Utils().getUserPhoneNumber(), style: AppTextStyle.size12RegularAppBlackText.copyWith(color: AppColors.appPrimaryColor)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                      Get.toNamed(Routes.PROFILE);
                    },
                    child: Container(
                      height: Get.width * 0.12,
                      width: Get.width * 0.12,
                      padding: EdgeInsets.all(Get.width * 0.04),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.appPrimaryColor.withValues(alpha: 0.1)
                      ),
                      child: Image.asset(AppIcons.edit, color: AppColors.appPrimaryColor,),
                    ),
                  )
                ],
              ),
              SizedBox(height: Get.height * 0.02),
              // drawerItem(title: "My Wallet", image: AppIcons.wallet, onTap: () {
              //   Get.back();
              //   Get.toNamed(Routes.WALLET);
              // }),
              drawerItem(title: "Rides", image: AppIcons.ride, onTap: () {
                Get.back();
                Get.toNamed(Routes.RIDES);
              }),
              drawerItem(title: "Inbox", image: AppIcons.inbox, onTap: () {
                Get.back();
                Get.toNamed(Routes.INBOX);
              }),
              drawerItem(title: "Notifications", image: AppIcons.notification, onTap: () {
                Get.back();
                Get.toNamed(Routes.NOTIFICATION);
              }),
              drawerItem(title: "Safety", image: AppIcons.safety, onTap: () {
                Get.back();
                Get.toNamed(Routes.SAFETY);
              }),
              SizedBox(height: Get.height * 0.01),
              Divider(color: AppColors.lightBlue, thickness: 2),
              SizedBox(height: Get.height * 0.01),
              drawerItem(title: "Contact Us", image: AppIcons.headphone, onTap: () {
                Get.back();
                Get.toNamed(Routes.CONATCT_US);
              }),
              drawerItem(title: "Support - Tickets", image: AppIcons.support, onTap: () {
                Get.back();
                Get.toNamed(Routes.TICKETS);
              }),
              drawerItem(title: "FAQs", image: AppIcons.faq, onTap: () {
                Get.back();
                Get.toNamed(Routes.FAQ);
              }),
              SizedBox(height: Get.height * 0.01),
              Divider(color: AppColors.lightBlue, thickness: 2),
              SizedBox(height: Get.height * 0.01),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.lightBlue),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white
                ),
                child: Column(
                  children: [
                    SizedBox(height: Get.height * 0.01),
                    drawerItem(title: "Terms & Conditions", image: AppIcons.terms, onTap: () {
                      Get.back();
                      Get.toNamed(Routes.CONTENT, arguments: ['Terms & conditions']);
                    }),
                    drawerItem(title: "Privacy Policy", image: AppIcons.privacy, onTap: () {
                      Get.back();
                      Get.toNamed(Routes.CONTENT, arguments: ['Privacy Policy']);
                    }),
                    drawerItem(title: "About Us", image: AppIcons.about, onTap: () {
                      Get.back();
                      Get.toNamed(Routes.CONTENT, arguments: ['About Us']);
                    }),
                    Divider(color: AppColors.lightBlue, thickness: 2, indent: Get.width * 0.05, endIndent: Get.width * 0.05),
                    Row(
                      children: [
                        drawerItem(title: "Logout", image: AppIcons.logout, onTap: () {
                          Get.back();
                          commonBottomSheet(logout());
                        }),
                        Spacer(),
                        drawerItem(title: "Delete Account", image: AppIcons.delete, onTap: () {
                          Get.back();
                          commonBottomSheet(delete());
                        }),
                        SizedBox(width: Get.width * 0.05),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: Get.height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  Widget drawerItem({required String title, required String image, required Function() onTap, double? width}) {
    return GestureDetector(
      onTap: onTap,
      child: Material(
        color: Colors.transparent,
        shadowColor: AppColors.black,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.01,vertical: Get.height * 0.018),
          child: Row(
            children: [
              SizedBox(width: Get.width * 0.04),
              Image.asset(image,height: width ?? Get.width * 0.05, color: AppColors.black.withValues(alpha: 0.6)),
              SizedBox(width: Get.width * 0.02),
              Text(title,style: AppTextStyle.size14RegularAppBlackText.copyWith(color: AppColors.black.withValues(alpha: 0.8)))
            ],
          ),
        ),
      ),
    );
  }

  Widget logout() {
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
          Image.asset(AppImages.logout, width: Get.width * 0.2),
          SizedBox(height: 20),
          Text("Are you sure you want to logout?", textAlign: TextAlign.center, style: AppTextStyle.size20RegularAppBlackText),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppWidgets.buildButton(
                title: "No",
                btnWidthRatio: 0.4,
                btnHeight: 50,
                btnColor: AppColors.white,
                txtColor: AppColors.appPrimaryColor,
                onPress: () {
                  Get.back();
                },
              ),
              SizedBox(width: Get.width * 0.05),
              AppWidgets.buildButton(
                title: "Yes",
                btnWidthRatio: 0.4,
                btnHeight: 50,
                onPress: () {
                  Get.find<DashBoardController>().logout();
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget delete() {
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
          Image.asset(AppImages.delete, width: Get.width * 0.2),
          SizedBox(height: 20),
          Text("Are you sure you want to delete the account?", textAlign: TextAlign.center, style: AppTextStyle.size20RegularAppBlackText),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppWidgets.buildButton(
                title: "No",
                btnWidthRatio: 0.4,
                btnHeight: 50,
                btnColor: AppColors.white,
                txtColor: AppColors.appPrimaryColor,
                onPress: () {
                  Get.back();
                },
              ),
              SizedBox(width: Get.width * 0.05),
              AppWidgets.buildButton(
                title: "Yes",
                btnWidthRatio: 0.4,
                btnHeight: 50,
                onPress: () {
                  Get.find<DashBoardController>().deleteAccount();
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}