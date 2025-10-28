class OrganisationModel {
  String? message;
  Data? data;
  List<UserAttributes>? userAttributes;
  String? role;
  OrganisationDetails? organisationDetails;

  OrganisationModel({
    this.message,
    this.data,
    this.userAttributes,
    this.organisationDetails,
  });

  OrganisationModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    role = json['role'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['userAttributes'] != null) {
      userAttributes = <UserAttributes>[];
      json['userAttributes'].forEach((v) {
        userAttributes!.add(UserAttributes.fromJson(v));
      });
    }
    organisationDetails = json['organisationDetails'] != null
        ? OrganisationDetails.fromJson(json['organisationDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['role'] = role;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (userAttributes != null) {
      data['userAttributes'] = userAttributes!.map((v) => v.toJson()).toList();
    }
    if (organisationDetails != null) {
      data['organisationDetails'] = organisationDetails!.toJson();
    }
    return data;
  }
}

class Data {
  String? accessToken;
  int? expiresIn;
  String? idToken;
  String? refreshToken;
  String? tokenType;

  Data({
    this.accessToken,
    this.expiresIn,
    this.idToken,
    this.refreshToken,
    this.tokenType,
  });

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['AccessToken'];
    expiresIn = json['ExpiresIn'];
    idToken = json['IdToken'];
    refreshToken = json['RefreshToken'];
    tokenType = json['TokenType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AccessToken'] = accessToken;
    data['ExpiresIn'] = expiresIn;
    data['IdToken'] = idToken;
    data['RefreshToken'] = refreshToken;
    data['TokenType'] = tokenType;
    return data;
  }
}

class UserAttributes {
  String? name;
  String? value;

  UserAttributes({this.name, this.value});

  UserAttributes.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    value = json['Value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['Value'] = value;
    return data;
  }
}

class OrganisationDetails {
  List<OrgData>? orgData;
  List<Branches>? branches;

  OrganisationDetails({this.orgData, this.branches});

  OrganisationDetails.fromJson(Map<String, dynamic> json) {
    if (json['orgData'] != null) {
      orgData = <OrgData>[];
      json['orgData'].forEach((v) {
        orgData!.add(OrgData.fromJson(v));
      });
    }
    if (json['branches'] != null) {
      branches = <Branches>[];
      json['branches'].forEach((v) {
        branches!.add(Branches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (orgData != null) {
      data['orgData'] = orgData!.map((v) => v.toJson()).toList();
    }
    if (branches != null) {
      data['branches'] = branches!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrgData {
  String? theme;
  String? orgName;
  String? orgId;
  String? orgLogo;

  OrgData({this.theme, this.orgName, this.orgId, this.orgLogo});

  OrgData.fromJson(Map<String, dynamic> json) {
    theme = json['theme'];
    orgName = json['org_name'];
    orgId = json['org_id'];
    orgLogo = json['org_logo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['theme'] = theme;
    data['org_name'] = orgName;
    data['org_id'] = orgId;
    data['org_logo'] = orgLogo;
    return data;
  }
}

class Branches {
  String? branchId;
  String? orgId;
  String? phoneExt;
  String? branchName;
  String? timezone;
  String? address;
  String? phone;

  Branches({
    this.branchId,
    this.orgId,
    this.phoneExt,
    this.branchName,
    this.timezone,
    this.address,
    this.phone,
  });

  Branches.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    orgId = json['org_id'];
    phoneExt = json['phone_ext'];
    branchName = json['branch_name'];
    timezone = json['timezone'];
    address = json['address'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['org_id'] = orgId;
    data['phone_ext'] = phoneExt;
    data['branch_name'] = branchName;
    data['timezone'] = timezone;
    data['address'] = address;
    data['phone'] = phone;
    return data;
  }
}
