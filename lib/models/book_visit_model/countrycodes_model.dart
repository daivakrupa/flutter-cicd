class CountryCodesModel {
  int? statusCode;
  String? message;
  List<CountryCodeData>? data;

  CountryCodesModel({this.statusCode, this.message, this.data});

  CountryCodesModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CountryCodeData>[];
      json['data'].forEach((v) {
        data!.add(new CountryCodeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CountryCodeData {
  String? country;
  String? code;

  CountryCodeData({this.country, this.code});

  CountryCodeData.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['code'] = code;
    return data;
  }
}