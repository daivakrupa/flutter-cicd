class CreateFaceModel {
  int? statusCode;
  String? status;
  String? message;
  Data? data;
  bool? allowNDA;

  CreateFaceModel({this.statusCode, this.status, this.message, this.data, this.allowNDA});

  CreateFaceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    allowNDA = json['allowNDA'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['allowNDA'] = allowNDA;
    return data;
  }
}

class Data {
  String? faceId;
  String? userId;

  Data({this.faceId, this.userId});

  Data.fromJson(Map<String, dynamic> json) {
    faceId = json['face_id'];
    userId = json['user_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['face_id'] = faceId;
    data['user_id'] = userId;
    return data;
  }
}