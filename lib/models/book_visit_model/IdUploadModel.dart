class IdUploadModel {
  int? statusCode;
  String? message;
  List<String>? uploadedImagePaths;

  IdUploadModel({this.statusCode, this.message, this.uploadedImagePaths});

  IdUploadModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    message = json['message'];
    uploadedImagePaths = json['uploadedImagePaths'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['message'] = message;
    data['uploadedImagePaths'] = uploadedImagePaths;
    return data;
  }
}
