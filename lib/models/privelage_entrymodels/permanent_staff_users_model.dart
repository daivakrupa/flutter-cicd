import 'package:visiq/models/check_face_models/check_face_model.dart';

class PermanentStaffUsers {
  List<UserDetails>? permanentStaffUsers;

  PermanentStaffUsers({this.permanentStaffUsers});

  PermanentStaffUsers.fromJson(Map<String, dynamic> json) {
    if (json['permanent_staff_users'] != null) {
      permanentStaffUsers = <UserDetails>[];
      json['permanent_staff_users'].forEach((v) {
        permanentStaffUsers!.add(UserDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.permanentStaffUsers != null) {
      data['permanent_staff_users'] =
          this.permanentStaffUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}