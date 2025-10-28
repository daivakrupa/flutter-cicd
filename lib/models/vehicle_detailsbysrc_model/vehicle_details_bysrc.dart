class VisitorDetailsBySrcModel {
  List<Visitors>? visitors;

  VisitorDetailsBySrcModel({this.visitors});

  VisitorDetailsBySrcModel.fromJson(Map<String, dynamic> json) {
    if (json['visitors'] != null) {
      visitors = <Visitors>[];
      json['visitors'].forEach((v) {
        visitors!.add(Visitors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (visitors != null) {
      data['visitors'] = visitors!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Visitors {
  String? purposeOfVisit;
  List<GrpDetails>? grpDetails;
  String? endDate;
  String? meetTo;
  String? email;
  String? visitorOrgName;
  String? visitorCode;
  String? orgId;
  String? visitDuration;
  String? phNo;
  bool? mmBool;
  String? endDateOfVisit;
  String? branchId;
  String? action;
  String? visitorId;
  String? areaOfPermit;
  bool? grpBookBool;
  String? reason;
  String? phExt;
  List<VmDetails>? vmDetails;
  String? bookingTime;
  bool? isVisited;
  String? role;
  String? lastName;
  String? startDate;
  String? dateOfVisit;
  String? firstName;
  String? timeOfVisit;
  bool? vmBool;
  String? timeToExit;

  Visitors(
      {this.purposeOfVisit,
      this.grpDetails,
      this.endDate,
      this.meetTo,
      this.email,
      this.visitorOrgName,
      this.visitorCode,
      this.orgId,
      this.visitDuration,
      this.phNo,
      this.mmBool,
      this.endDateOfVisit,
      this.branchId,
      this.action,
      this.visitorId,
      this.areaOfPermit,
      this.grpBookBool,
      this.reason,
      this.phExt,
      this.vmDetails,
      this.bookingTime,
      this.isVisited,
      this.role,
      this.lastName,
      this.startDate,
      this.dateOfVisit,
      this.firstName,
      this.timeOfVisit,
      this.vmBool,
      this.timeToExit});

  Visitors.fromJson(Map<String, dynamic> json) {
    purposeOfVisit = json['purpose_of_visit'];
    if (json['grp_details'] != null) {
      grpDetails = <GrpDetails>[];
      json['grp_details'].forEach((v) {
        grpDetails!.add(GrpDetails.fromJson(v));
      });
    }
    endDate = json['end_date'];
    meetTo = json['meetTo'];
    email = json['email'];
    visitorOrgName = json['visitorOrgName'];
    visitorCode = json['visitor_code'];
    orgId = json['org_id'];
    visitDuration = json['visit_duration'];
    phNo = json['phNo'];
    mmBool = json['mm_bool'];
    endDateOfVisit = json['end_date_of_visit'];
    branchId = json['branch_id'];
    action = json['action'];
    visitorId = json['visitor_id'];
    areaOfPermit = json['area_of_permit'];
    grpBookBool = json['grp_book_bool'];
    reason = json['reason'];
    phExt = json['ph_ext'];
    if (json['vm_details'] != null) {
      vmDetails = <VmDetails>[];
      json['vm_details'].forEach((v) {
        vmDetails!.add(VmDetails.fromJson(v));
      });
    }
    bookingTime = json['bookingTime'];
    isVisited = json['isVisited'];
    role = json['role'];
    lastName = json['last_name'];
    startDate = json['start_date'];
    dateOfVisit = json['date_of_visit'];
    firstName = json['first_name'];
    timeOfVisit = json['time_of_visit'];
    vmBool = json['vm_bool'];
    timeToExit = json['time_to_exit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purpose_of_visit'] = purposeOfVisit;
    if (grpDetails != null) {
      data['grp_details'] = grpDetails!.map((v) => v.toJson()).toList();
    }
    data['end_date'] = endDate;
    data['meetTo'] = meetTo;
    data['email'] = email;
    data['visitorOrgName'] = visitorOrgName;
    data['visitor_code'] = visitorCode;
    data['org_id'] = orgId;
    data['visit_duration'] = visitDuration;
    data['phNo'] = phNo;
    data['mm_bool'] = mmBool;
    data['end_date_of_visit'] = endDateOfVisit;
    data['branch_id'] = branchId;
    data['action'] = action;
    data['visitor_id'] = visitorId;
    data['area_of_permit'] = areaOfPermit;
    data['grp_book_bool'] = grpBookBool;
    data['reason'] = reason;
    data['ph_ext'] = phExt;
    if (vmDetails != null) {
      data['vm_details'] = vmDetails!.map((v) => v.toJson()).toList();
    }
    data['bookingTime'] = bookingTime;
    data['isVisited'] = isVisited;
    data['role'] = role;
    data['last_name'] = lastName;
    data['start_date'] = startDate;
    data['date_of_visit'] = dateOfVisit;
    data['first_name'] = firstName;
    data['time_of_visit'] = timeOfVisit;
    data['vm_bool'] = vmBool;
    data['time_to_exit'] = timeToExit;
    return data;
  }
}

class GrpDetails {
  String? grpUserPhext;
  String? grpUserEmail;
  bool? grpIsVisited;
  String? grpId;
  String? grpName;
  String? grpUserIdProof;
  String? grpUserName;
  String? grpUserUniqueId;
  String? grpUserRoleName;
  String? grpUserPhno;
  String? grpUserRole;

  GrpDetails(
      {this.grpUserPhext,
      this.grpUserEmail,
      this.grpIsVisited,
      this.grpId,
      this.grpName,
      this.grpUserIdProof,
      this.grpUserName,
      this.grpUserUniqueId,
      this.grpUserRoleName,
      this.grpUserPhno,
      this.grpUserRole});

  GrpDetails.fromJson(Map<String, dynamic> json) {
    grpUserPhext = json['grp_user_phext'];
    grpUserEmail = json['grp_user_email'];
    grpIsVisited = json['grp_is_visited'];
    grpId = json['grp_id'];
    grpName = json['grp_name'];
    grpUserIdProof = json['grp_user_id_proof'];
    grpUserName = json['grp_user_name'];
    grpUserUniqueId = json['grp_user_unique_id'];
    grpUserRoleName = json['grp_user_role_name'];
    grpUserPhno = json['grp_user_phno'];
    grpUserRole = json['grp_user_role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grp_user_phext'] = grpUserPhext;
    data['grp_user_email'] = grpUserEmail;
    data['grp_is_visited'] = grpIsVisited;
    data['grp_id'] = grpId;
    data['grp_name'] = grpName;
    data['grp_user_id_proof'] = grpUserIdProof;
    data['grp_user_name'] = grpUserName;
    data['grp_user_unique_id'] = grpUserUniqueId;
    data['grp_user_role_name'] = grpUserRoleName;
    data['grp_user_phno'] = grpUserPhno;
    data['grp_user_role'] = grpUserRole;
    return data;
  }
}

class VmDetails {
  String? driverId;
  String? insuranceProvider;
  String? insuranceNo;
  String? vehicleType;
  String? rcNo;
  String? driverLicence;
  String? vehicleId;
  String? vehicleComments;
  String? vehicleName;
  bool? isApproved;
  List<MmDetails>? mmDetails;

  VmDetails(
      {this.driverId,
      this.insuranceProvider,
      this.insuranceNo,
      this.vehicleType,
      this.rcNo,
      this.driverLicence,
      this.vehicleId,
      this.vehicleComments,
      this.vehicleName,
      this.isApproved,
      this.mmDetails});

  VmDetails.fromJson(Map<String, dynamic> json) {
    driverId = json['driver_id'];
    insuranceProvider = json['insurance_provider'];
    insuranceNo = json['insurance_no'];
    vehicleType = json['vehicle_type'];
    rcNo = json['rc_no'];
    driverLicence = json['driver_licence'];
    vehicleId = json['vehicle_id'];
    vehicleComments = json['vehicle_comments'];
    isApproved = json['isApproved'];
    vehicleName = json['vehicle_name'];
    if (json['mm_details'] != null) {
      mmDetails = <MmDetails>[];
      json['mm_details'].forEach((v) {
        mmDetails!.add(MmDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['driver_id'] = driverId;
    data['insurance_provider'] = insuranceProvider;
    data['insurance_no'] = insuranceNo;
    data['vehicle_type'] = vehicleType;
    data['rc_no'] = rcNo;
    data['driver_licence'] = driverLicence;
    data['vehicle_id'] = vehicleId;
    data['vehicle_comments'] = vehicleComments;
    data['isApproved'] = isApproved;
    data['vehicle_name'] = vehicleName;
    if (mmDetails != null) {
      data['mm_details'] = mmDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MmDetails {
  String? materialSN;
  String? materialComments;
  String? materialId;
  String? materialNoOfUnits;
  String? materialVehicleId;
  String? materialName;
  String? materialRackNo;
  String? materialDeviceModel;
  String? materialDescription;
  String? materialQuantity;
  bool? isApproved;

  MmDetails(
      {this.materialSN,
      this.materialComments,
      this.materialId,
      this.materialNoOfUnits,
      this.materialVehicleId,
      this.materialName,
      this.materialRackNo,
      this.materialDeviceModel,
      this.materialDescription,
      this.materialQuantity,
      this.isApproved});

  MmDetails.fromJson(Map<String, dynamic> json) {
    materialSN = json['material_s_n'];
    materialComments = json['material_comments'];
    materialId = json['material_id'];
    materialNoOfUnits = json['material_no_of_units'];
    materialVehicleId = json['material_vehicle_id'];
    materialName = json['material_name'];
    materialRackNo = json['material_rack_no'];
    materialDeviceModel = json['material_device_model'];
    materialDescription = json['material_description'];
    materialQuantity = json['material_quantity'];
    isApproved = json['isApproved'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['material_s_n'] = materialSN;
    data['material_comments'] = materialComments;
    data['material_id'] = materialId;
    data['material_no_of_units'] = materialNoOfUnits;
    data['material_vehicle_id'] = materialVehicleId;
    data['material_name'] = materialName;
    data['material_rack_no'] = materialRackNo;
    data['material_device_model'] = materialDeviceModel;
    data['material_description'] = materialDescription;
    data['material_quantity'] = materialQuantity;
    data['isApproved'] = isApproved;
    return data;
  }
}
