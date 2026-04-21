class CommonModel {
  int? success;
  String? message;

  CommonModel({this.success, this.message});

  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
      success: json['success'],
      message: json['message'],
    );
  }
}