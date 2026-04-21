import 'dart:io';
import 'dart:math';
import 'package:cabifyit/reusability/shared/widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as m;
import 'package:url_launcher/url_launcher.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/utils/utils.dart';
import '../controller/driver_location_controller.dart';

class DriverLocationView extends GetView<DriverLocationController> {

  @override
  var controller = Get.put(DriverLocationController());

  DriverLocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            GetBuilder<DriverLocationController>(
              builder: (c) {
                return map(context);
              }
            ),
            Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 10, top: MediaQuery.of(context).padding.top + 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      padding: EdgeInsets.all(Get.width * 0.02),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                      ),
                        child: Icon(Icons.arrow_back, size: 30, color: AppColors.appPrimaryColor)
                    ),
                  ),
                  Spacer(),
                  AppWidgets.buildButton(
                      title: "View on Google Map",
                      btnHeight: 40,
                      btnRadius: 5,
                      txtSize: 12,
                      btnWidthRatio: 0.9,
                      onPress: () async {
                        Uri url = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=${controller.lat.value},${controller.lng.value}&travelmode=driving");
                        if(Platform.isIOS) {
                          url = Uri.parse("http://maps.apple.com/?daddr=${controller.lat.value},${controller.lng.value}&dirflg=d");
                        }
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      }
                  )
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Widget map(context) {
    print("MAp : ${Utils().getMap()}");
    return Utils().getMap()?
    GoogleMap(
      markers: controller.markers,
      initialCameraPosition: controller.currentPosition,
      onTap: (argument) {
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      onMapCreated: (mapController) {
        controller.mapController = mapController;
      },
    ):m.MaplibreMap(
      initialCameraPosition: controller.mCurrentPosition,
      onMapCreated: (mapController) {
        controller.mController = mapController;
      },
      myLocationEnabled: true,
      attributionButtonPosition: m.AttributionButtonPosition.bottomLeft,
      attributionButtonMargins: Point(-1000, -1000),
      compassViewMargins: Point(10,(MediaQuery.of(context).padding.bottom + 100 + Get.width * 0.16)),
      compassViewPosition: m.CompassViewPosition.bottomRight,
      onMapClick: (point, coordinates) {
      },
      styleString: controller.isDarkMode.value?controller.bariKoiDarkStyle:controller.bariKoiStyle ,
    );
  }
}