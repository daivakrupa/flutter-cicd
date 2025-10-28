// ignore_for_file: unnecessary_this

class OCRResults {
  String? message;
  UserData? userData;

  OCRResults({this.message, this.userData});

  OCRResults.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userData = json['userData'] != null
        ? UserData.fromJson(json['userData'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = this.message;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    return data;
  }
}

class UserData {
  String? firstName;
  String? lastName;
  String? dob;
  String? passport;

  UserData({this.firstName, this.lastName, this.dob, this.passport});

  UserData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    dob = json['dob'];
    passport = json['passport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['dob'] = this.dob;
    data['passport'] = this.passport;
    return data;
  }
}
