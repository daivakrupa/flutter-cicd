import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
import 'package:visiq/models/create_face_model/create_face_model.dart';
import 'package:visiq/models/populate_user_details_model/populate_user_details_model.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:visiq/utils/globals.dart';
import 'package:visiq/utils/overlay_loading_progress.dart';
import 'package:visiq/views/entry_form_view/entry_form_view.dart';
import 'package:visiq/views/populateuserdetailsview/signature_widet.dart';

class PopulateUserDetailsController extends GetxController {
  Rxn<CheckFaceModel> checkFaceModel = Rxn<CheckFaceModel>();
  List<PopulateFormDetailsModel> dynamicFormData = [];
  TextEditingController srqController = TextEditingController();
  RxBool alwaysAllowNDA = false.obs;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    if (args != null && args['dynamicModel'] != null) {
      checkFaceModel.value = args['dynamicModel'] as CheckFaceModel;
      srqController.text = checkFaceModel.value?.data?.userDetails?.srq ?? "";
      alwaysAllowNDA.value = checkFaceModel.value?.data?.userDetails?.allowNDA ?? false;
    }

    dynamicFormData = [
      PopulateFormDetailsModel(
        placeholderText: 'Name',
        valuetext: checkFaceModel.value?.data?.userDetails?.firstName ?? "",
      ),
      PopulateFormDetailsModel(
        placeholderText: 'Email ID',
        valuetext: checkFaceModel.value?.data?.userDetails?.emailId ?? "",
      ),
      PopulateFormDetailsModel(
        placeholderText: 'Phone number',
        valuetext:
            "${checkFaceModel.value?.data?.userDetails?.phExt ?? ""} ${checkFaceModel.value?.data?.userDetails?.phNo ?? ""}",
      ),
      PopulateFormDetailsModel(
        placeholderText: 'Purpose of Visit',
        valuetext: checkFaceModel.value?.data?.userDetails?.purposeOfVisit ?? "",
      ),
      PopulateFormDetailsModel(
        placeholderText: 'Category',
        valuetext: checkFaceModel.value?.data?.userDetails?.roleName ?? "",
      ),
      PopulateFormDetailsModel(
        placeholderText: checkFaceModel.value?.data?.userDetails?.kycType ?? "",
        valuetext: checkFaceModel.value?.data?.userDetails?.kycId ?? "",
      ),
      PopulateFormDetailsModel(
        placeholderText: 'Access Reference Code',
        valuetext: checkFaceModel.value?.data?.userDetails?.srq ?? "",
      ),
    ];
  }

  Future<String?> getSignaturePath() async {
    final signature = signatureGlobalKey.currentState;
    if (signature == null) {
      print("Signature pad is not initialized.");
      return null;
    }

    final image = await signature.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData?.buffer.asUint8List();

    if (!isSignatureDone || pngBytes == null || pngBytes.length <= 1735) {
      print("Please provide signature");
      signature.clear();
      return null;
    }

    final appDocDir = await getApplicationDocumentsDirectory();
    final file = File('${appDocDir.path}/signature.png');
    await file.writeAsBytes(pngBytes);
    print('Signature saved to: ${file.path}');
    return file.path;
  }

  checkInCheckOutAPI() async {
    final prefs = await SharedPreferences.getInstance();
    final branchId = prefs.getString('selectedBranchId');
    final orgID = prefs.getString('orgId');

    final signaturePath = await getSignaturePath();
    if (signaturePath == null) {
      OverlayLoadingProgress.stop();
      showMyDialog("Please provide your signature to proceed.", false);
      return;
    }

    final checkInRequestBody = {
      "org_id": orgID,
      "branch_id": branchId,
      "isCheckedIn": checkFaceModel.value?.data?.userDetails?.isEntry == true
          ? false
          : true,
      "visitor_code": srqController.text,
      "user_id": checkFaceModel.value?.data?.userDetails?.userId,
      "email": checkFaceModel.value?.data?.userDetails?.emailId,
      "signature": signaturePath,
      'allowNDA': checkFaceModel.value?.data?.userDetails?.allowNDA == true
          ? true
          : alwaysAllowNDA.value,
      "role": checkFaceModel.value?.data?.userDetails?.role,
    };

    print("check in request body $checkInRequestBody");

    final api = NetworkManager<CreateFaceModel>(baseUrl);
    await api.post(
      '/api/faces/checkInsOuts',
      checkInRequestBody,
      (data) {
        final resultModel = CreateFaceModel.fromJson(data);
        print(resultModel.status);
        OverlayLoadingProgress.stop();
        isSignatureDone = false;
        showMyDialog(
          resultModel.message ?? "OOPS something went wrong please try again.",
          resultModel.statusCode == 200,
        );
        return resultModel;
      },
      null,
      (statusCode) {},
    );
  }

  Future<void> showMyDialog(String message, bool popToRoot) async {
    Get.defaultDialog(
      title: 'Message',
      content: SingleChildScrollView(child: ListBody(children: <Widget>[Text(message)])),
      textConfirm: 'Ok',
      confirmTextColor: const Color.fromRGBO(98, 70, 175, 1),
      barrierDismissible: false,
      onConfirm: () {
        if (popToRoot) {
          Get.offAllNamed('/');
        } else {
          Get.back();
        }
      },
    );
  }
}
