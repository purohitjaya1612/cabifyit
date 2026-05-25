import 'dart:convert';

class CurrentBookingResponse {
  int success;
  CurrentBooking? currentBooking;

  CurrentBookingResponse({
    required this.success,
    this.currentBooking,
  });

  factory CurrentBookingResponse.fromJson(Map<String, dynamic> json) {
    return CurrentBookingResponse(
      success: json['success'] ?? 0,
      currentBooking: json['currentBooking'] != null
          ? CurrentBooking.fromJson(json['currentBooking'])
          : null,
    );
  }
}

class CurrentBooking {
  int id;
  String bookingId;
  String bookingType;
  String bookingStatus;
  String pickupPoint;
  String destinationPoint;
  String pickupLocation;
  String destinationLocation;
  String distance;
  String paymentMethod;
  String paymentStatus;
  String otp;
  String offeredAmount;
  String note;
  String bookingAmount;
  List viaLocation;
  DriverDetail? driverDetail;
  VehicleDetail? vehicleDetail;
  List<WaitingDetails>? waitingDetails;

  CurrentBooking({
    required this.id,
    required this.bookingId,
    required this.bookingType,
    required this.bookingStatus,
    required this.pickupPoint,
    required this.destinationPoint,
    required this.pickupLocation,
    required this.destinationLocation,
    required this.distance,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.otp,
    required this.offeredAmount,
    required this.bookingAmount,
    required this.note,
    required this.viaLocation,
    this.driverDetail,
    this.vehicleDetail,
    this.waitingDetails,
  });

  factory CurrentBooking.fromJson(Map<String, dynamic> json) {
    List waiting = json['waiting_detail'] ?? [];
    List<WaitingDetails> waitingList = waiting.map((e) => WaitingDetails.fromJson(e)).toList();
    return CurrentBooking(
      id: json['id'],
      bookingId: json['booking_id'] ?? '',
      bookingType: json['booking_type'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      pickupPoint: json['pickup_point'] ?? '',
      destinationPoint: json['destination_point'] ?? '',
      pickupLocation: json['pickup_location'] ?? '',
      destinationLocation: json['destination_location'] ?? '',
      distance: json['distance'] ?? '0',
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      otp: json['otp'] ?? '0000',
      offeredAmount: json['offered_amount'] ?? '0',
      bookingAmount: json['booking_amount'] ?? '0',
      note: json['note'] ?? '',
      viaLocation: json['via_location'] != null && json['via_location'].toString() != "null" &&
          json['via_location'].toString().isNotEmpty
          ? List<String>.from(
        jsonDecode(json['via_location'] ?? '[]'),
      ): [],
      driverDetail: json['driver_detail'] != null
          ? DriverDetail.fromJson(json['driver_detail'])
          : null,
      vehicleDetail: json['vehicle_detail'] != null
          ? VehicleDetail.fromJson(json['vehicle_detail'])
          : null,
      waitingDetails: waitingList
    );
  }
}

class DriverDetail {
  int id;
  String name;
  String email;
  String phoneNo;
  String latitude;
  String longitude;
  String plateNo;
  String color;
  String drivingStatus;
  String profileImage;

  DriverDetail({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.latitude,
    required this.longitude,
    required this.plateNo,
    required this.color,
    required this.drivingStatus,
    required this.profileImage,
  });

  factory DriverDetail.fromJson(Map<String, dynamic> json) {
    return DriverDetail(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      plateNo: json['plate_no'] ?? '',
      color: json['color'] ?? '',
      drivingStatus: json['driving_status'] ?? '',
      profileImage: json['profile_image'] ?? '',
    );
  }
}

class VehicleDetail {
  int id;
  String vehicleTypeName;
  String vehicleTypeService;
  String minimumDistance;
  String mileageSystem;
  String vehicleImage;

  VehicleDetail({
    required this.id,
    required this.vehicleTypeName,
    required this.vehicleTypeService,
    required this.minimumDistance,
    required this.mileageSystem,
    required this.vehicleImage,
  });

  factory VehicleDetail.fromJson(Map<String, dynamic> json) {
    return VehicleDetail(
      id: json['id'],
      vehicleTypeName: json['vehicle_type_name'] ?? '',
      vehicleTypeService: json['vehicle_type_service'] ?? '',
      minimumDistance: json['minimum_distance'] ?? '0',
      mileageSystem: json['mileage_system'] ?? '',
      vehicleImage: json['vehicle_image'] ?? '',
    );
  }
}

class WaitingDetails {
  String? startTime;
  String? endTime;
  String? status;

  WaitingDetails({this.startTime, this.endTime, this.status});

  factory WaitingDetails.fromJson(Map<String, dynamic> json) {
    return WaitingDetails(
      startTime: json['start_time'] ?? "",
      endTime: json['end_time'] ?? "",
      status: json['status'] ?? "",
    );
  }
}


