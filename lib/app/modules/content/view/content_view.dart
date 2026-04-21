import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:cabifyit/reusability/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import '../controller/content_controller.dart';

class ContentView extends GetView<ContentController> {

  @override
  final controller = Get.put(ContentController());

  ContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppWidgets.appBar(title: controller.title),
      body: Obx(() => controller.isLoading.value ?
      Center(child: loader()) : controller.content.value.isEmpty ? Center(child: noDataFound()) :
      SingleChildScrollView(child: Html(data: controller.content.value))
      ),
    );
  }

}