import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_controller.dart';

class MainView extends GetView<MainController> {

  @override
  var controller = Get.put(MainController());

  MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(color: Colors.white)
    );
  }

}