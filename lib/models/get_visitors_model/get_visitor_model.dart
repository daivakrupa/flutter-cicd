class GetVisitorsModel {
  String? message;
  List<VisitorsList>? visitorsList;
  bool? noShowVisitorsDate;
  int? expectedVisitors;
  int? totalBranches;
  int? totalCheckIns;
  int? totalCheckOuts;
  int? totalEntries;
  int? arrivedVisitors;
  List<ArrivedVisitorsList>? arrivedVisitorsList;

  GetVisitorsModel(
      {this.message,
      this.visitorsList,
      this.noShowVisitorsDate,
      this.expectedVisitors,
      this.totalBranches,
      this.totalCheckIns,
      this.totalCheckOuts,
      this.totalEntries,
      this.arrivedVisitors,
      this.arrivedVisitorsList});

  GetVisitorsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['visitors_List'] != null) {
      visitorsList = <VisitorsList>[];
      json['visitors_List'].forEach((v) {
        visitorsList!.add(VisitorsList.fromJson(v));
      });
    }
    noShowVisitorsDate = json['noShowVisitorsDate'];
    expectedVisitors = json['expectedVisitors'];
    totalBranches = json['totalBranches'];
    totalCheckIns = json['totalCheckIns'];
    totalCheckOuts = json['totalCheckOuts'];
    totalEntries = json['totalEntries'];
    arrivedVisitors = json['arrivedVisitors'];
    if (json['arrivedVisitorsList'] != null) {
      arrivedVisitorsList = <ArrivedVisitorsList>[];
      json['arrivedVisitorsList'].forEach((v) {
        arrivedVisitorsList!.add(ArrivedVisitorsList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (visitorsList != null) {
      data['visitors_List'] =
          visitorsList!.map((v) => v.toJson()).toList();
    }
    data['noShowVisitorsDate'] = noShowVisitorsDate;
    data['expectedVisitors'] = expectedVisitors;
    data['totalBranches'] = totalBranches;
    data['totalCheckIns'] = totalCheckIns;
    data['totalCheckOuts'] = totalCheckOuts;
    data['totalEntries'] = totalEntries;
    data['arrivedVisitors'] = arrivedVisitors;
    if (arrivedVisitorsList != null) {
      data['arrivedVisitorsList'] =
          arrivedVisitorsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitorsList {
  String? purposeOfVisit;
  String? endDateOfVisit;
  String? branchId;
  String? action;
  String? visitorId;
  String? endDate;
  String? meetTo;
  String? areaOfPermit;
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
  String? roleName;

  VisitorsList(
      {this.purposeOfVisit,
      this.endDateOfVisit,
      this.branchId,
      this.action,
      this.visitorId,
      this.endDate,
      this.meetTo,
      this.areaOfPermit,
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
      this.roleName});

  VisitorsList.fromJson(Map<String, dynamic> json) {
    purposeOfVisit = json['purpose_of_visit'];
    endDateOfVisit = json['end_date_of_visit'];
    branchId = json['branch_id'];
    action = json['action'];
    visitorId = json['visitor_id'];
    endDate = json['end_date'];
    meetTo = json['meetTo'];
    areaOfPermit = json['area_of_permit'];
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
    roleName = json ['role_name'];
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purpose_of_visit'] = purposeOfVisit;
    data['end_date_of_visit'] = endDateOfVisit;
    data['branch_id'] = branchId;
    data['action'] = action;
    data['visitor_id'] = visitorId;
    data['end_date'] = endDate;
    data['meetTo'] = meetTo;
    data['area_of_permit'] = areaOfPermit;
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
    data['role_name'] = roleName;
    return data;
  }
}

class ArrivedVisitorsList {
  String? purposeOfVisit;
  String? endDateOfVisit;
  String? branchId;
  String? action;
  String? visitorId;
  String? endDate;
  String? meetTo;
  String? areaOfPermit;
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
  String? firstName;
  String? timeOfVisit;
  String? phNo;
  String? timeToExit;
  String? visitorDuration;
  String? roleName;

  ArrivedVisitorsList(
      {this.purposeOfVisit,
      this.endDateOfVisit,
      this.branchId,
      this.action,
      this.visitorId,
      this.endDate,
      this.meetTo,
      this.areaOfPermit,
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
      this.firstName,
      this.timeOfVisit,
      this.phNo,
      this.timeToExit,
      this.visitorDuration,
      this.roleName});

  ArrivedVisitorsList.fromJson(Map<String, dynamic> json) {
    purposeOfVisit = json['purpose_of_visit'];
    endDateOfVisit = json['end_date_of_visit'];
    branchId = json['branch_id'];
    action = json['action'];
    visitorId = json['visitor_id'];
    endDate = json['end_date'];
    meetTo = json['meetTo'];
    areaOfPermit = json['area_of_permit'];
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
    firstName = json['first_name'];
    timeOfVisit = json['time_of_visit'];
    phNo = json['phNo'];
    timeToExit = json['time_to_exit'];
    visitorDuration = json['visitor_duration'];
    roleName = json['role_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['purpose_of_visit'] = purposeOfVisit;
    data['end_date_of_visit'] = endDateOfVisit;
    data['branch_id'] = branchId;
    data['action'] = action;
    data['visitor_id'] = visitorId;
    data['end_date'] = endDate;
    data['meetTo'] = meetTo;
    data['area_of_permit'] = areaOfPermit;
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
    data['first_name'] = firstName;
    data['time_of_visit'] = timeOfVisit;
    data['phNo'] = phNo;
    data['time_to_exit'] = timeToExit;
    data['visitor_duration'] = visitorDuration;
    data['role_name'] = roleName;
    return data;
  }
}