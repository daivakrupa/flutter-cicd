
class CheckFaceModel {
  int? statusCode;
  String? status;
  String? message;
  Data? data;


  CheckFaceModel({this.statusCode, this.status, this.message, this.data,});

  CheckFaceModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  UserDetails? userDetails;

  Data({this.userDetails});

  Data.fromJson(Map<String, dynamic> json) {
    userDetails = json['userDetails'] != null
        ? UserDetails.fromJson(json['userDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (userDetails != null) {
      data['userDetails'] = userDetails!.toJson();
    }
    return data;
  }
}

class UserDetails {
  String? srq;
  String? branchId;
  String? purposeOfVisit;
  String? photo;
  String? lastExit;
  String? phNo;
  bool? isEntry;
  String? lastEntry;
  String? phExt;
  String? signature;
  String? orgId;
  String? userId;
  String? lastName;
  String? kycId;
  String? kycType;
  String? firstName;
  String? faceId;
  String? emailId;
  String? asset;
  String? areaofpermit;
  bool? allowNDA;
  String? role;
  String? roleName;


//kyc_id kyc_type
  UserDetails(
      {this.srq,
      this.branchId,
      this.purposeOfVisit,
      this.photo,
      this.lastExit,
      this.phNo,
      this.isEntry,
      this.lastEntry,
      this.phExt,
      this.signature,
      this.orgId,
      this.userId,
      this.lastName,
      this.kycId,
      this.firstName,
      this.faceId,
      this.emailId,
      this.kycType,
      this.asset,
      this.areaofpermit,
      this.allowNDA,
      this.role,
      this.roleName});

  UserDetails.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    purposeOfVisit = json['purpose_of_visit'];
    photo = json['photo'];
    lastExit = json['last_exit'];
    phNo = json['ph_no'];
    isEntry = json['isEntry'];
    lastEntry = json['last_entry'];
    phExt = json['ph_ext'];
    signature = json['signature'];
    orgId = json['org_id'];
    userId = json['user_id'];
    lastName = json['last_name'];
    kycId = json['kyc_id'];
    firstName = json['first_name'];
    faceId = json['face_id'];
    emailId = json['email'];
    srq = json['last_visited_code'];
    kycType = json['kyc_type'];
    asset = json['asset'];
    areaofpermit= json['area_of_permit'];
    allowNDA = json['allowNDA'];
    role = json['role'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['purpose_of_visit'] = purposeOfVisit;
    data['photo'] = photo;
    data['last_exit'] = lastExit;
    data['ph_no'] = phNo;
    data['isEntry'] = isEntry;
    data['last_entry'] = lastEntry;
    data['ph_ext'] = phExt;
    data['signature'] = signature;
    data['org_id'] = orgId;
    data['user_id'] = userId;
    data['last_name'] = lastName;
    data['kyc_id'] = kycId;
    data['first_name'] = firstName;
    data['face_id'] = faceId;
    data['email'] = emailId;
    data['last_visited_code'] = srq;
    data['kyc_type'] = kycType;
    data['asset'] = asset;
    data['area_of_permit'] = areaofpermit;
    data['allowNDA'] = allowNDA;
    data['role'] = role;
    data['role_name'] = roleName;
    return data;
  }
}
