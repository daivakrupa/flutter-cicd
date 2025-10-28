import 'dart:io';

import 'package:get/get.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
import 'package:visiq/models/login_models/organisation_model.dart';

class EntryFormController extends GetxController {
  File? capturedPicture;
  Branches? selectedBranchId;
  var allowNDA = false.obs;
  CheckFaceModel? fileModel;

  @override
  void onInit() {
    final Map<String, dynamic>? arguments = Get.arguments;
    if (arguments != null) {
      capturedPicture = arguments['capturedPicture'];
      selectedBranchId = arguments['selectedBranchId'];
      allowNDA.value = arguments['allowNDA'] ?? false;
      fileModel = arguments['fileModel'];
    }
    super.onInit();
  }
}
