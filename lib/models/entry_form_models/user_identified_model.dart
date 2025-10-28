// ignore_for_file: unnecessary_this

class UserIdentifiedModel {
  String? message;
  String? userId;
  String? orgId;
  String? branchId;
  String? visitorCode;
  String? email;

  UserIdentifiedModel({
    this.message,
    this.userId,
    this.orgId,
    this.branchId,
    this.visitorCode,
    this.email,
  });

  UserIdentifiedModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    userId = json['user_id'];
    orgId = json['org_id'];
    branchId = json['branch_id'];
    visitorCode = json['visitor_code'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['org_id'] = this.orgId;
    data['branch_id'] = this.branchId;
    data['visitor_code'] = this.visitorCode;
    data['email'] = this.email;
    return data;
  }
}
