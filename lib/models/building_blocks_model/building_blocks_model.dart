
class BuildingBlocksModel {
  int? statusCode;
  List<AreasOfBranch>? areasOfBranch;
  List<PuporseOfVisits>? puporseOfVisits;
  List<BranchAdmins>? branchAdmins;
  List<BranchAdmins>? securityAdmins;
  String? supportemail;
  List<Roles>? roles;

  BuildingBlocksModel(
      {this.statusCode,
      this.areasOfBranch,
      this.puporseOfVisits,
      this.branchAdmins,
      this.securityAdmins,
      this.supportemail,
      this.roles});

  BuildingBlocksModel.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['areasOfBranch'] != null) {
      areasOfBranch = <AreasOfBranch>[];
      json['areasOfBranch'].forEach((v) {
        areasOfBranch!.add(AreasOfBranch.fromJson(v));
      });
    }
    if (json['puporse_of_visits'] != null) {
      puporseOfVisits = <PuporseOfVisits>[];
      json['puporse_of_visits'].forEach((v) {
        puporseOfVisits!.add(PuporseOfVisits.fromJson(v));
      });
    }
    if (json['branchAdmins'] != null) {
      branchAdmins = <BranchAdmins>[];
      json['branchAdmins'].forEach((v) {
        branchAdmins!.add(BranchAdmins.fromJson(v));
      });
    }
    if (json['securityAdmins'] != null) {
      securityAdmins = <BranchAdmins>[];
      json['securityAdmins'].forEach((v) {
        securityAdmins!.add(BranchAdmins.fromJson(v));
      });
    }
    supportemail = json['supportemail'];
    if (json['roles'] != null) {
      roles = <Roles>[];
      json['roles'].forEach((v) {
        roles!.add(Roles.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (areasOfBranch != null) {
      data['areasOfBranch'] =
          areasOfBranch!.map((v) => v.toJson()).toList();
    }
    if (puporseOfVisits != null) {
      data['puporse_of_visits'] =
          puporseOfVisits!.map((v) => v.toJson()).toList();
    }
    if (branchAdmins != null) {
      data['branchAdmins'] = branchAdmins!.map((v) => v.toJson()).toList();
    }
    if (securityAdmins != null) {
      data['securityAdmins'] =
          securityAdmins!.map((v) => v.toJson()).toList();
    }
    data['supportemail'] = supportemail;
    if (roles != null) {
      data['roles'] = roles!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AreasOfBranch {
  String? branchId;
  String? areaId;
  String? areaName;

  AreasOfBranch({this.branchId, this.areaId, this.areaName});

  AreasOfBranch.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    areaId = json['area_id'];
    areaName = json['area_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['area_id'] = areaId;
    data['area_name'] = areaName;
    return data;
  }
}

class PuporseOfVisits {
  String? pov;

  PuporseOfVisits({this.pov});

  PuporseOfVisits.fromJson(Map<String, dynamic> json) {
    pov = json['pov'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['pov'] = pov;
    return data;
  }
}

class BranchAdmins {
  String? branchId;
  String? orgId;
  String? role;
  String? lastName;
  String? phoneExt;
  String? firstName;
  String? username;
  String? email;
  String? phone;

  BranchAdmins(
      {this.branchId,
      this.orgId,
      this.role,
      this.lastName,
      this.phoneExt,
      this.firstName,
      this.username,
      this.email,
      this.phone});

  BranchAdmins.fromJson(Map<String, dynamic> json) {
    branchId = json['branch_id'];
    orgId = json['org_id'];
    role = json['role'];
    lastName = json['last_name'];
    phoneExt = json['phone_ext'];
    firstName = json['first_name'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['branch_id'] = branchId;
    data['org_id'] = orgId;
    data['role'] = role;
    data['last_name'] = lastName;
    data['phone_ext'] = phoneExt;
    data['first_name'] = firstName;
    data['username'] = username;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}

class Roles {
  int? roleId;
  String? roleName;
  String? validateInDays;
  String? roleInDays;

  Roles({this.roleId, this.roleName, this.validateInDays, this.roleInDays});

  Roles.fromJson(Map<String, dynamic> json) {
    roleId = json['role_id'];
    roleName = json['role_name'];
    validateInDays = json['validateInDays'];
    roleInDays = json['roleInDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['role_id'] = roleId;
    data['role_name'] = roleName;
    data['validateInDays'] = validateInDays;
    data['roleInDays'] = roleInDays;
    return data;
  }
}