class VehicleListModel {
  int? success;
  List<VehicleData>? list;

  VehicleListModel({
    this.success,
    this.list,
  });

  factory VehicleListModel.fromJson(Map<String, dynamic> json) {
    List dataList = json['list'] ?? [];
    List<VehicleData> vehicles =
    dataList.map((e) => VehicleData.fromJson(e)).toList();

    return VehicleListModel(
      success: json['success'],
      list: vehicles,
    );
  }
}

class VehicleData {
  String? id;
  String? vehicleTypeName;
  String? vehicleTypeService;
  String? recommendedPrice;
  String? minimumPrice;
  String? minimumDistance;
  String? baseFareLessThanXMiles;
  String? baseFareLessThanXPrice;
  String? baseFareFromXMiles;
  String? baseFareToXMiles;
  String? baseFareFromToPrice;
  String? baseFareGreaterThanXMiles;
  String? baseFareGreaterThanXPrice;
  String? firstMileKm;
  String? secondMileKm;
  String? orderNo;
  String? vehicleImage;
  String? baseFareSystemStatus;
  String? mileageSystem;
  bool isSelected;

  VehicleData({
    this.id,
    this.vehicleTypeName,
    this.vehicleTypeService,
    this.recommendedPrice,
    this.minimumPrice,
    this.minimumDistance,
    this.baseFareLessThanXMiles,
    this.baseFareLessThanXPrice,
    this.baseFareFromXMiles,
    this.baseFareToXMiles,
    this.baseFareFromToPrice,
    this.baseFareGreaterThanXMiles,
    this.baseFareGreaterThanXPrice,
    this.firstMileKm,
    this.secondMileKm,
    this.orderNo,
    this.vehicleImage,
    this.baseFareSystemStatus,
    this.mileageSystem,
    this.isSelected = false,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: (json['id'] ?? "").toString(),
      vehicleTypeName: json['vehicle_type_name'] ?? "",
      vehicleTypeService: json['vehicle_type_service'] ?? "",
      recommendedPrice: (json['recommended_price'] ?? "").toString(),
      minimumPrice: (json['minimum_price'] ?? "").toString(),
      minimumDistance: (json['minimum_distance'] ?? "").toString(),
      baseFareLessThanXMiles:
      (json['base_fare_less_than_x_miles'] ?? "").toString(),
      baseFareLessThanXPrice:
      (json['base_fare_less_than_x_price'] ?? "").toString(),
      baseFareFromXMiles:
      (json['base_fare_from_x_miles'] ?? "").toString(),
      baseFareToXMiles:
      (json['base_fare_to_x_miles'] ?? "").toString(),
      baseFareFromToPrice:
      (json['base_fare_from_to_price'] ?? "").toString(),
      baseFareGreaterThanXMiles:
      (json['base_fare_greater_than_x_miles'] ?? "").toString(),
      baseFareGreaterThanXPrice:
      (json['base_fare_greater_than_x_price'] ?? "").toString(),
      firstMileKm: (json['first_mile_km'] ?? "").toString(),
      secondMileKm: (json['second_mile_km'] ?? "").toString(),
      orderNo: (json['order_no'] ?? "").toString(),
      vehicleImage: json['vehicle_image'] ?? "",
      baseFareSystemStatus: json['base_fare_system_status'] ?? "",
      mileageSystem: json['mileage_system'] ?? "",
      isSelected: false,
    );
  }
}
