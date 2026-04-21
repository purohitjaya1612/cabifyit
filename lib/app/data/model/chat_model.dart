import 'package:cabifyit/app/data/model/current_ride_model.dart';
import 'package:cabifyit/app/data/model/rides_model.dart';

class ChatResponse {
  final int success;
  final List<ChatMessage> list;

  ChatResponse({
    required this.success,
    required this.list,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      success: json['success'] ?? 0,
      list: json['list'] != null
          ? List<ChatMessage>.from(
        json['list'].map((x) => ChatMessage.fromJson(x)),
      )
          : [],
    );
  }
}

class ChatMessage {
  final int id;
  final String sendBy;
  final String? driverId;
  final String? userId;
  final String? rideId;
  final String message;
  final String status;
  final DateTime? createdAt;
  final RideData? rideDetail;
  final DriverDetail? driverDetail;

  ChatMessage({
    required this.id,
    required this.sendBy,
    this.driverId,
    this.userId,
    this.rideId,
    required this.message,
    required this.status,
    this.createdAt,
    this.rideDetail,
    this.driverDetail,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sendBy: json['send_by'],
      driverId: json['driver_id'],
      userId: json['user_id'],
      rideId: json['ride_id'],
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      rideDetail: json['ride_detail'] != null
          ? RideData.fromJson(json['ride_detail'])
          : null,
      driverDetail: json['driver_detail'] != null
          ? DriverDetail.fromJson(json['driver_detail'])
          : null,
    );
  }
}

