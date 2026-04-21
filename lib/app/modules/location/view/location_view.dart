import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maplibre_gl/maplibre_gl.dart' as m;

import '../../../../reusability/shared/widget.dart';
import '../../../../reusability/theme/app_colors.dart';
import '../../../../reusability/theme/app_textstyle.dart';
import '../../../../reusability/utils/utils.dart';
import '../../../data/model/places_model.dart';
import '../controller/location_controller.dart';

class LocationView extends GetView<LocationController> {

  @override
  var controller = Get.put(LocationController());

  LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: true,
        child: Stack(
          children: [
            GetBuilder<LocationController>(
              builder: (c) {
                return map(context);
              }
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 20),
                searchField(),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: Obx(() => Text("If you are not able to find exact location search the area and drop a pin", textAlign: TextAlign.center, style: AppTextStyle.size12MediumAppBlackText.copyWith(color: controller.isDarkMode.value ? Colors.white : null))),
                ),
                Spacer(),
                if(!Utils().getMap())GetBuilder<LocationController>(
                  builder: (context) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              controller.getLocation();
                            },
                            child: Container(
                                height: Get.width *0.1,
                                width: Get.width *0.1,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white
                                ),child: Icon(Icons.gps_fixed, color: AppColors.appPrimaryColor,)),
                          ),
                        ],
                      ),
                    );
                  }
                ),
                SizedBox(height: 10),
                Obx(() => controller.location.value.isNotEmpty?Container(
                  width: Get.width,
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                  child: Material(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      shadowColor: Colors.black,
                      elevation: 3,
                      child: Padding(
                        padding: EdgeInsets.all(Get.width * 0.02),
                        child: Obx(() => Text(controller.location.value, maxLines: 3, textAlign: TextAlign.center,style: AppTextStyle.size16MediumAppBlackText)),
                      )),
                ):SizedBox()),
                SizedBox(height: 10),
                Center(child: Obx(() => AppWidgets.buildButton(
                  title: "Continue",
                  btnRadius: 15,
                  btnColor: controller.location.value.isEmpty || controller.pointId.value.isEmpty ? AppColors.textGrey : null,
                  borderColor: controller.location.value.isEmpty || controller.pointId.value.isEmpty ? AppColors.textGrey : null,
                  onPress: () {
                    if (controller.location.value.isEmpty) {
                      Utils.toastWarning("Please Select Location");
                    } else if(controller.pointId.value.isEmpty) {
                      Utils.toastWarning("We're not providing service at your location.");
                    }else {
                      Get.back(result: [controller.location.value, controller.lat.value, controller.lng.value, controller.pointId.value]);
                    }
                  },
                ))),
                SizedBox(height: MediaQuery.of(context).padding.bottom + 10),
              ],
            ),
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
        controller.location.value = "";
        controller.animateCamera(latitude: argument.latitude, longitude: argument.longitude);
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
        controller.location.value = "";
        controller.animateCamera(latitude: coordinates.latitude, longitude: coordinates.longitude);
      },
      styleString: controller.isDarkMode.value?controller.bariKoiDarkStyle:controller.bariKoiStyle ,
    );
  }

  Widget searchField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
      child: TypeAheadField<Place>(
        suggestionsCallback: (search) => controller.findPlaces(search: search),
        hideOnSelect: true,
        hideKeyboardOnDrag: true,
        hideOnEmpty: true,
        hideOnError: true,
        controller: controller.locationController,
        builder: (context, controller, focusNode) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10)
            ),
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search Place"
              ),
            ),
          );
        },
        itemBuilder: (context, item) {
          return ListTile(
            title: (item.name ?? "").isNotEmpty?Text(item.name ?? "", style: AppTextStyle.size14RegularAppBlackText):null,
            subtitle: (item.address ?? "").isNotEmpty?Text(item.address ?? "", style: AppTextStyle.size12RegularAppBlackText,):null,
          );
        },
        onSelected: (item)  async {
          if (Utils().getSearch()) {
            controller.location.value = item.address ?? "";
            controller.locationController.text = "";
            var result = await controller.getLatLongFromPlaceId(item.id);
            item.latitude = result['lat'];
            item.longitude = result['lng'];
            if(item.latitude!=null && item.longitude !=null) {
              print("HAVE COORDINATES");
              controller.animateCamera(latitude: item.latitude ?? 0, longitude: item.longitude ?? 0);
            } else {
              print("NO COORDINATES");
            }
          } else {
            controller.location.value = item.address ?? "";
            controller.locationController.text = "";
            if(item.latitude!=null && item.longitude !=null) {
              print("HAVE COORDINATES");
              controller.animateCamera(latitude: item.latitude ?? 0, longitude: item.longitude ?? 0);
            } else {
              print("NO COORDINATES");
            }
          }
        },
      ),
    );
  }
}