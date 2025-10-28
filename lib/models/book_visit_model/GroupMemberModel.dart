class GroupMemberModel {
  String? grpId;
  String? grpName;
  String? grpUserEmail;
  String? grpUserIdProof;
  String? grpUserName;
  String? grpUserPhno;
  String? groupUserPhnExt;
  String? grpUserRole;
  String? grpUserRoleName;
  String? grpUserUniqueId;

  GroupMemberModel(
      {this.grpId,
      this.grpName,
      this.grpUserEmail,
      this.grpUserIdProof,
      this.grpUserName,
      this.grpUserPhno,
      this.groupUserPhnExt,
      this.grpUserRole,
      this.grpUserRoleName,
      this.grpUserUniqueId});

  GroupMemberModel.fromJson(Map<String, dynamic> json) {
    grpId = json['grp_id'];
    grpName = json['grp_name'];
    grpUserEmail = json['grp_user_email'];
    grpUserIdProof = json['grp_user_id_proof'];
    grpUserName = json['grp_user_name'];
    grpUserPhno = json['grp_user_phno'];
    groupUserPhnExt = json['grp_user_phext'];
    grpUserRole = json['grp_user_role'];
    grpUserRoleName = json['grp_user_role_name'];
    grpUserUniqueId = json['grp_user_unique_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['grp_id'] = grpId;
    data['grp_name'] = grpName;
    data['grp_user_email'] = grpUserEmail;
    data['grp_user_id_proof'] = grpUserIdProof;
    data['grp_user_name'] = grpUserName;
    data['grp_user_phext'] = groupUserPhnExt;
    data['grp_user_phno'] = grpUserPhno;
    data['grp_user_role'] = grpUserRole;
    data['grp_user_role_name'] = grpUserRoleName;
    data['grp_user_unique_id'] = grpUserUniqueId;
    return data;
  }
}
