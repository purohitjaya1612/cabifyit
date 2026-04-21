class TicketsModel {
  int? status;
  TicketsList? list;
  String? message;

  TicketsModel({this.status, this.list, this.message});

  factory TicketsModel.fromJson(Map<String, dynamic> json) {
    return TicketsModel(
      status: json['success'],
      list: TicketsList.fromJson(json['list']),
      message: json['message'],
    );
  }
}

class TicketsList {
  List<TicketsData>? data;
  String? total;

  TicketsList({this.data, this.total});

  factory TicketsList.fromJson(Map<String, dynamic> json) {
    List tickets = json['data'] ?? [];
    List<TicketsData> data = tickets.map((e) => TicketsData.fromJson(e)).toList();
    return TicketsList(
      data: data,
      total: (json['total'] ?? "0").toString(),
    );
  }
}

class TicketsData {
  String? id;
  String? ticketId;
  String? subject;
  String? message;
  String? status;
  String? createdDate;
  String? replyMessage;

  TicketsData({this.id, this.ticketId, this.subject, this.message, this.status, this.createdDate, this.replyMessage});

  factory TicketsData.fromJson(Map<String, dynamic> json) {
    return TicketsData(
      id: (json['id'] ?? "").toString(),
      ticketId: json['ticket_id'] ?? "",
      subject: json['subject'] ?? "",
      message: json['message'] ?? "",
      status: json['status'] ?? "",
      createdDate: json['created_at'] ?? "",
      replyMessage: json['reply_message'] ?? "",
    );
  }
}