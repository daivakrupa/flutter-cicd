class GetListofBranchesModel {
  OrganisationDetails? organisationDetails;

  GetListofBranchesModel({this.organisationDetails});

  GetListofBranchesModel.fromJson(Map<String, dynamic> json) {
    organisationDetails = json['organisationDetails'] != null
        ? OrganisationDetails.fromJson(json['organisationDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (organisationDetails != null) {
      data['organisationDetails'] = organisationDetails!.toJson();
    }
    return data;
  }
}

class OrganisationDetails {
  List<OrgData>? orgData;
  List<GetBranches>? branches;

  OrganisationDetails({this.orgData, this.branches});

  OrganisationDetails.fromJson(Map<String, dynamic> json) {
    if (json['orgData'] != null) {
      orgData = <OrgData>[];
      json['orgData'].forEach((v) {
        orgData!.add(OrgData.fromJson(v));
      });
    }
    if (json['branches'] != null) {
      branches = <GetBranches>[];
      json['branches'].forEach((v) {
        branches!.add(GetBranches.fromJson(v));
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
  String? orgAdminEmail;

  OrgData({
    this.theme,
    this.orgName,
    this.orgId,
    this.orgLogo,
    this.orgAdminEmail,
  });

  OrgData.fromJson(Map<String, dynamic> json) {
    theme = json['theme'];
    orgName = json['org_name'];
    orgId = json['org_id'];
    orgLogo = json['org_logo'];
    orgAdminEmail = json['org_admin_email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['theme'] = theme;
    data['org_name'] = orgName;
    data['org_id'] = orgId;
    data['org_logo'] = orgLogo;
    data['org_admin_email'] = orgAdminEmail;
    return data;
  }
}

class GetBranches {
  String? address;
  String? branchId;
  String? branchName;
  String? currRefCode;
  String? orgId;
  String? phone;
  String? phoneExt;
  String? refStartCode;
  String? supportemail;
  String? timezone;
  bool? vmBoolean;
  bool? mmBoolean;

  GetBranches({
    this.address,
    this.branchId,
    this.branchName,
    this.currRefCode,
    this.orgId,
    this.phone,
    this.phoneExt,
    this.refStartCode,
    this.supportemail,
    this.timezone,
    this.vmBoolean,
    this.mmBoolean,
  });

  GetBranches.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    branchId = json['branch_id'];
    branchName = json['branch_name'];
    currRefCode = json['curr_ref_code'];
    orgId = json['org_id'];
    phone = json['phone'];
    phoneExt = json['phone_ext'];
    refStartCode = json['ref_start_code'];
    supportemail = json['supportemail'];
    timezone = json['timezone'];
    vmBoolean = json['vm_boolean'];
    mmBoolean = json['mm_boolean'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['branch_id'] = branchId;
    data['branch_name'] = branchName;
    data['curr_ref_code'] = currRefCode;
    data['org_id'] = orgId;
    data['phone'] = phone;
    data['phone_ext'] = phoneExt;
    data['ref_start_code'] = refStartCode;
    data['supportemail'] = supportemail;
    data['timezone'] = timezone;
    data['vm_boolean'] = vmBoolean;
    data['mm_boolean'] = mmBoolean;
    return data;
  }
}
