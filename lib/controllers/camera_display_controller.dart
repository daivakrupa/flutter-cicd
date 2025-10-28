import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
import 'package:visiq/models/login_models/organisation_model.dart';
import 'package:visiq/utils/globals.dart';

class CameraDisplayController extends GetxController {
  Branches? selectedBranchId;
  Rx<File?> capturedImage = Rxn();
  Rxn<CheckFaceModel> fileModel = Rxn<CheckFaceModel>();

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Branches?;
    if (arguments != null) {
      selectedBranchId = arguments;
    }
  }

  checkFaceAPI() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    final String? orgID = prefs.getString('orgId');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print(appDocPath);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/faces/check-face'),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        capturedImage.value?.path ?? '',
      ),
    );
    request.fields.addAll({'org_id': orgID ?? "", 'branch_id': branchId ?? ""});

    print('i got ORGID $orgID');
    print('i got BranchID $branchId');

    http.StreamedResponse response = await request.send();
    final result = await response.stream.bytesToString();
    print('i got face result $result');

    Map<String, dynamic> data = jsonDecode(result);
    fileModel.value = CheckFaceModel.fromJson(data); // Correct assignment
    print('file model ${fileModel.value}');

    print('i got response from api ${response.statusCode}');

    if (response.statusCode == 502) {
      showMyDialog("Oops got 502 Bad gateway. Please try again");
    } else if (response.statusCode == 500) {
      showMyDialog("Oops something went wrong. Please try again");
    } else if (response.statusCode == 200) {
      print('allownda : ${fileModel.value?.data?.userDetails?.allowNDA}');
      if (fileModel.value?.data?.userDetails?.isEntry == true) {
        navigateToPopulateUserInfo();
      } else {
        if (fileModel.value?.data?.userDetails?.allowNDA == true) {
          navigateToEntryForm(response.statusCode);
        } else {
          navigateToPopulateUserInfo();
        }
      }
    } else {
      if (fileModel.value?.message == 'No matching face found') {
        navigateToEntryForm(response.statusCode);
      } else {
        showMyDialog(
          fileModel.value?.message ?? "Oops something went wrong. Please try again",
        );
      }
    }
  }

  navigateToEntryForm(int statusCode) {
    Get.overlayContext?.loaderOverlay.hide();
    final arguments = {
      'capturedPicture': capturedImage.value,
      'selectedBranchId': selectedBranchId,
      'statusCode': statusCode,
      'fileModel': fileModel.value,
      'allowNDA': fileModel.value?.data?.userDetails?.allowNDA ?? false,
    };

    print("Navigating with arguments: $arguments");

    Get.toNamed('/termsandconditions', arguments: arguments);
  }

  navigateToPopulateUserInfo() {
    Get.overlayContext?.loaderOverlay.hide();
    final arguments = {
      'length': 6,
      'dynamicModel': fileModel.value,
    };
    Get.toNamed('/populateuserdetails', arguments: arguments);
  }

  showMyDialog(String text) async {
    return Get.dialog(
      AlertDialog(
        title: const Text('Message'),
        content: SingleChildScrollView(
          child: ListBody(children: <Widget>[Text(text)]),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.overlayContext?.loaderOverlay.hide();
              Get.back();
            },
            style: TextButton.styleFrom(
              side: const BorderSide(
                color: Color.fromRGBO(98, 70, 175, 1),
                width: 2,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
            ),
            child: const Text('Ok'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
