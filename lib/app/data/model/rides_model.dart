import 'package:cabifyit/app/data/model/current_ride_model.dart';

class RidesModel {
  int success;
  RideList list;

  RidesModel({
    required this.success,
    required this.list,
  });

  factory RidesModel.fromJson(Map<String, dynamic> json) {
    return RidesModel(
      success: json['success'] ?? 0,
      list: RideList.fromJson(json['list'] ?? {}),
    );
  }
}
class RideList {
  int currentPage;
  List<RideData> data;
  int total;

  RideList({
    required this.currentPage,
    required this.data,
    required this.total,
  });

  factory RideList.fromJson(Map<String, dynamic> json) {
    return RideList(
      currentPage: json['current_page'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => RideData.fromJson(e))
          .toList(),
      total: json['total'] ?? 0,
    );
  }
}

class RideData {
  int id;
  String pickupTime;
  String bookingDate;
  String bookingType;
  String pickupPoint;
  String destinationPoint;
  String name;
  String email;
  String phoneNo;
  String journeyType;
  String bookingAmount;
  String bookingId;
  String bookingStatus;
  String paymentMethod;
  String paymentStatus;
  String distance;
  String pickupLocation;
  String note;
  String destinationLocation;
  String otp;
  String? waitingAmount;
  String? waitingTime;
  String? cancelReason;
  String? cancelledBy;
  String? driverDropoffTime;
  String? driverPickupTime;
  DriverDetail? driverDetail;
  List<RatingDetail>? ratingDetail;

  RideData({
    required this.id,
    required this.pickupTime,
    required this.bookingDate,
    required this.bookingType,
    required this.pickupPoint,
    required this.destinationPoint,
    required this.name,
    required this.email,
    required this.phoneNo,
    required this.journeyType,
    required this.bookingAmount,
    required this.bookingId,
    required this.bookingStatus,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.distance,
    required this.pickupLocation,
    required this.note,
    required this.destinationLocation,
    required this.otp,
    this.cancelReason,
    this.waitingTime,
    this.waitingAmount,
    this.cancelledBy,
    this.driverDropoffTime,
    this.driverPickupTime,
    this.driverDetail,
    this.ratingDetail,
  });

  factory RideData.fromJson(Map<String, dynamic> json) {
    return RideData(
      id: json['id'] ?? 0,
      pickupTime: json['pickup_time'] ?? '',
      bookingDate: json['booking_date'] ?? '',
      bookingType: json['booking_type'] ?? '',
      pickupPoint: json['pickup_point'] ?? '',
      destinationPoint: json['destination_point'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNo: json['phone_no'] ?? '',
      journeyType: json['journey_type'] ?? '',
      bookingAmount: (json['booking_amount'] ?? json['offered_amount'] ?? "0").toString(),
      bookingId: json['booking_id'] ?? '',
      bookingStatus: json['booking_status'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'] ?? '',
      distance: (json['distance'] ?? "0").toString(),
      pickupLocation: json['pickup_location'] ?? '',
      note: json['note'] ?? '',
      destinationLocation: json['destination_location'] ?? '',
      otp: json['otp'] ?? '',
      cancelReason: json['cancel_reason'],
      waitingAmount: (json['waiting_amount'] ?? 0).toString(),
      waitingTime: (json['waiting_time'] ?? 0).toString(),
      cancelledBy: json['cancelled_by'],
      driverDropoffTime: json['driver_dropoff_time'],
      driverPickupTime: json['driver_pickup_time'],
      driverDetail: json['driver_detail'] != null ? DriverDetail.fromJson(json['driver_detail']) : null,
      ratingDetail: (json['rating_detail'] as List<dynamic>? ?? [])
          .map((e) => RatingDetail.fromJson(e))
          .toList(),
    );
  }
}

class RatingDetail {
  String? userType;
  String? rating;

  RatingDetail({this.userType, this.rating});

  factory RatingDetail.fromJson(Map<String, dynamic> json) {
    return RatingDetail(
      userType: (json['user_type'] ?? "").toString(),
      rating: (json['rating'] ?? "0").toString(),
    );
  }
}

