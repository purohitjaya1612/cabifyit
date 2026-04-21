import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget backgroundImage() {
  return SizedBox(
    height: Get.height,
    width: Get.width,
    child: Image.asset("assets/images/background.png"),
  );
}

DecorationImage background() {
  return const DecorationImage(image: AssetImage("assets/images/background.png"));
}

Widget saveez() {
  return SizedBox(
    width: Get.width * 0.5,
    child: Image.asset("assets/images/saveez_splash_logo.png",width: Get.width * 0.5),
  );
}

Widget augmont() {
  return SizedBox(
    width: Get.width * 0.4,height: Get.height * 0.07,
    child: Image.asset("assets/images/augmont_logo.png",width: Get.width * 0.4,height: Get.height * 0.07),
  );
}

Widget madeWithIndia() {
  return SizedBox(
    height: Get.height * 0.05,
    width: Get.width * 0.5,
    child: Image.asset("assets/images/made_with_india.png",width: Get.width * 0.5,height: Get.height * 0.05),
  );
}

