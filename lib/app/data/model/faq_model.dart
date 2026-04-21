class FaqModel {
  int? status;
  List<FaqData>? data;
  String? message;

  FaqModel({this.status, this.data, this.message});

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    List tickets = json['list'] ?? [];
    List<FaqData> data = tickets.map((e) => FaqData.fromJson(e)).toList();
    return FaqModel(
      status: json['success'],
      data: data,
      message: json['message'],
    );
  }
}

class FaqData {
  String? id;
  String? question;
  String? answer;
  bool isSelected;

  FaqData({this.id, this.question, this.answer, this.isSelected = false});

  factory FaqData.fromJson(Map<String, dynamic> json) {
    return FaqData(
      id: (json['id'] ?? "").toString(),
      question: json['question'],
      answer: json['answer'],
      isSelected: false
    );
  }
}