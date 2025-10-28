import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
import 'package:visiq/models/create_face_model/create_face_model.dart';
import 'package:visiq/models/privelage_entrymodels/permanent_staff_users_model.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:visiq/utils/globals.dart';
import 'package:visiq/utils/overlay_loading_progress.dart';
import 'package:visiq/views/privelige_entryform/user_selector.dart';

class PrevelageEntryController extends GetxController {
  var selectedUsers = <UserDetails>[].obs;
  var pStaffUsers = Rxn<PermanentStaffUsers>();

  void deleteUser(UserDetails user) {
    selectedUsers.remove(user);
  }

  void openUserSelector(BuildContext context) async {
    if (pStaffUsers.value?.permanentStaffUsers?.isEmpty ?? true) {
      showMyDialog(context, "No Users were found. Please contact admin.", false);
      return;
    }

    final result = await showModalBottomSheet<List<UserDetails>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => UserSelector(
        users: pStaffUsers.value?.permanentStaffUsers ?? [],
        initiallySelected: selectedUsers,
        selectionMode: UserSelectionMode.single,
        enableSearch: true,
      ),
    );

    if (result != null) {
      selectedUsers.assignAll(result);
    }
  }

  void submitForm(BuildContext context) {
    for (var user in selectedUsers) {
      debugPrint('Saving user: ${user.firstName} ${user.lastName}');
    }
    checkInCheckOutAPI(context);
  }

  Future<void> checkInCheckOutAPI(BuildContext context) async {
    if (selectedUsers.isEmpty) return;
    final selectedUser = selectedUsers.first;

    OverlayLoadingProgress.start(context);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    final String? orgID = prefs.getString('orgId');

    final checkInRequestBody = {
      "org_id": orgID,
      "branch_id": branchId,
      "isCheckedIn": selectedUser.isEntry == true ? false : true,
      "visitor_code": selectedUser.srq,
      "user_id": selectedUser.userId,
      "email": selectedUser.emailId,
      "signature": selectedUser.signature,
      "allowNDA": selectedUser.allowNDA,
      "role": selectedUser.role,
    };
    print("Check-in request body $checkInRequestBody");

    final api = NetworkManager<CreateFaceModel>(baseUrl);
    await api.post('/api/faces/checkInsOuts', checkInRequestBody, (data) {
      final resultModel = CreateFaceModel.fromJson(data);
      print(resultModel.status);
      OverlayLoadingProgress.stop();
      showMyDialog(
        context,
        resultModel.message ?? "OOPS something went wrong. Please try again.",
        resultModel.statusCode == 200 ? true : false,
      );
      return resultModel;
    }, null, (statusCode) {});
  }

  Future<void> showMyDialog(BuildContext context, String message, bool popToRoot) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(message)]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                popToRoot
                    ? Navigator.popUntil(context, (route) => route.isFirst)
                    :  Get.back();
              },
              style: TextButton.styleFrom(
                side: const BorderSide(color: Color.fromRGBO(98, 70, 175, 1), width: 2),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              ),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  Future<void> getPermenantStaffDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? orgID = prefs.getString('orgId');
    final String? branchId = prefs.getString('selectedBranchId');

    if (orgID == null) {
      print('Organization ID is null.');
      return;
    }

    final requestBody = {'org_id': orgID, 'branch_id': branchId};
    print('permanant staff request body $requestBody');

    final api = NetworkManager<PermanentStaffUsers>(baseUrl);
    final response = await api.post(
      '/api/org/roleUsersList',
      requestBody,
      (json) => PermanentStaffUsers.fromJson(json),
      null,
      (statusCode) {
        print('Status code: $statusCode');
      },
    );

    pStaffUsers.value = response;
    print(response);
  }
}
