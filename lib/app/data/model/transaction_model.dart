class TransactionModel {
  int? status;
  List<TransactionData>? data;
  String? message;

  TransactionModel({this.status, this.data, this.message});

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    List plans = json['transactionHistory'] ?? [];
    List<TransactionData> data = plans.map((e) => TransactionData.fromJson(e)).toList();
    return TransactionModel(
      status: json['success'],
      data: data,
      message: json['message'],
    );
  }
}

class TransactionData {
  String? id;
  String? amount;
  String? type;
  String? createdAt;
  String? transactionId;
  String? comment;

  TransactionData({this.id, this.amount, this.type, this.createdAt, this.transactionId, this.comment});

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      id: json['id'].toString(),
      amount: (json['amount'] ?? "0").toString(),
      createdAt: json['created_at'],
      type: json['type'],
      transactionId: json['transaction_id'],
      comment: json['comment'],
    );
  }
}