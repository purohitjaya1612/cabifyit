class MessageModel {
  List<MessageData>? data;

  MessageModel({this.data});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    List list = json['messages'] ?? [];
    List<MessageData> data = list.map((e) => MessageData.fromJson(e)).toList();
    return MessageModel(
      data: data
    );
  }
}

class MessageData {
  final int id;
  final String sendBy;
  final String? driverId;
  final String? userId;
  final String? rideId;
  final String message;
  final String status;
  final DateTime? createdAt;

  MessageData({
    required this.id,
    required this.sendBy,
    this.driverId,
    this.userId,
    this.rideId,
    required this.message,
    required this.status,
    this.createdAt,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      id: json['id'],
      sendBy: json['send_by'] ?? '',
      driverId: (json['driver_id'] ?? "").toString(),
      userId: (json['user_id'] ?? "").toString(),
      rideId: (json['ride_id'] ?? "").toString(),
      message: json['message'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }
}