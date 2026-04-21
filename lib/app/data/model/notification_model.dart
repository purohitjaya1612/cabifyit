class NotificationModel {
  int? status;
  List<NotificationData>? data;
  String? message;

  NotificationModel({this.status, this.data, this.message});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    List notifications = json['list'] ?? [];
    List<NotificationData> data = notifications.map((e) => NotificationData.fromJson(e)).toList();
    return NotificationModel(
      status: json['status'],
      data: data,
      message: json['message'],
    );
  }
}

class NotificationData {
  String? id;
  String? title;
  String? message;
  String? createdAt;

  NotificationData({this.id, this.title, this.message, this.createdAt});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      id: (json['id'] ?? "").toString(),
      title: json['title'],
      message: json['message'],
      createdAt: json['created_at'],
    );
  }
}