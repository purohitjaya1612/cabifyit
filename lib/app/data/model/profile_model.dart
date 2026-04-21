class ProfileModel {
  int? status;
  ProfileData? data;
  String? message;

  ProfileModel({this.status, this.data, this.message});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
    status : json['status'],
    data : json['data'] != null ? ProfileData.fromJson(json['data']) : null,
    message : json['message'],
    );
  }
}

class ProfileData {
  String? name;
  String? email;
  String? phoneNo;
  String? countryCode;
  String? profile;
  String? walletBalance;

  ProfileData(
      {
        this.name,
        this.email,
        this.phoneNo,
        this.countryCode,
        this.profile,
        this.walletBalance,
      });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
    name : json['name'],
    email : json['email'],
    phoneNo : json['phone_no'],
    countryCode : json['country_code'],
    profile : json['profile_image'],
    walletBalance: (json['wallet_balance'] ?? "0").toString(),
    );
  }
}