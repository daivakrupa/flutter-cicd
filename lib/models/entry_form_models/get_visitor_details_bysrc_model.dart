class GetVisitorDetailsBySRC {
  int? statusCode;
  List<VisitorData>? visitorData;

  GetVisitorDetailsBySRC({this.statusCode, this.visitorData});

  GetVisitorDetailsBySRC.fromJson(Map<String, dynamic> json) {
    statusCode = json['statusCode'];
    if (json['visitorData'] != null) {
      visitorData = <VisitorData>[];
      json['visitorData'].forEach((v) {
        visitorData!.add(VisitorData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['statusCode'] = statusCode;
    if (visitorData != null) {
      data['visitorData'] = visitorData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitorData {
  String? endDateOfVisit;
  String? purposeOfVisit;
  String? branchId;
  String? action;
  String? visitorId;
  String? endDate;
  String? email;
  String? visitorOrgName;
  String? visitorCode;
  String? phExt;
  String? orgId;
  String? bookingTime;
  bool? isVisited;
  String? lastName;
  String? dateOfVisit;
  String? startDate;
  String? visitDuration;
  String? timeOfVisit;
  String? firstName;
  String? phNo;
  String? timeToExit;
  String? areaPermitted;
  String? role;
  String? roleName;
  int? decatAreaCount;

  VisitorData({
    this.endDateOfVisit,
    this.purposeOfVisit,
    this.branchId,
    this.action,
    this.visitorId,
    this.endDate,
    this.email,
    this.visitorOrgName,
    this.visitorCode,
    this.phExt,
    this.orgId,
    this.bookingTime,
    this.isVisited,
    this.lastName,
    this.dateOfVisit,
    this.startDate,
    this.visitDuration,
    this.timeOfVisit,
    this.firstName,
    this.phNo,
    this.timeToExit,
    this.areaPermitted,
    this.role,
    this.roleName,
    this.decatAreaCount,
  });

  VisitorData.fromJson(Map<String, dynamic> json) {
    endDateOfVisit = json['end_date_of_visit'];
    purposeOfVisit = json['purpose_of_visit'];
    branchId = json['branch_id'];
    action = json['action'];
    visitorId = json['visitor_id'];
    endDate = json['end_date'];
    email = json['email'];
    visitorOrgName = json['visitorOrgName'];
    visitorCode = json['visitor_code'];
    phExt = json['ph_ext'];
    orgId = json['org_id'];
    bookingTime = json['bookingTime'];
    isVisited = json['isVisited'];
    lastName = json['last_name'];
    dateOfVisit = json['date_of_visit'];
    startDate = json['start_date'];
    visitDuration = json['visit_duration'];
    timeOfVisit = json['time_of_visit'];
    firstName = json['first_name'];
    phNo = json['phNo'];
    timeToExit = json['time_to_exit'];
    areaPermitted = json['area_of_permit'];
    role = json['role'];
    roleName = json['role_name'];
    decatAreaCount = json['decatAreaCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['end_date_of_visit'] = endDateOfVisit;
    data['purpose_of_visit'] = purposeOfVisit;
    data['branch_id'] = branchId;
    data['action'] = action;
    data['visitor_id'] = visitorId;
    data['end_date'] = endDate;
    data['email'] = email;
    data['visitorOrgName'] = visitorOrgName;
    data['visitor_code'] = visitorCode;
    data['ph_ext'] = phExt;
    data['org_id'] = orgId;
    data['bookingTime'] = bookingTime;
    data['isVisited'] = isVisited;
    data['last_name'] = lastName;
    data['date_of_visit'] = dateOfVisit;
    data['start_date'] = startDate;
    data['visit_duration'] = visitDuration;
    data['time_of_visit'] = timeOfVisit;
    data['first_name'] = firstName;
    data['phNo'] = phNo;
    data['time_to_exit'] = timeToExit;
    data['area_of_permit'] = areaPermitted;
    data['role'] = role;
    data['role_name'] = roleName;
    data['decatAreaCount'] = decatAreaCount;
    return data;
  }
}
