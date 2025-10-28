import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/book_visit_model/GroupMemberModel.dart';
import 'package:visiq/models/book_visit_model/IdUploadModel.dart';
import 'package:visiq/models/book_visit_model/countrycodes_model.dart';
import 'package:visiq/models/building_blocks_model/building_blocks_model.dart';
import 'package:visiq/network_manager/network_manager.dart';
import '../../utils/globals.dart';

class GroupBookingController extends GetxController {
  final roles = <Roles>[].obs;
  final members = <GroupMemberModel>[].obs;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  var selectedRole = Rxn<Roles>();
  var selectedCountryCode = ''.obs;
  var uploadedFile = RxnString();
  var uploadedFileUrl = ''.obs;

  var isEditing = false.obs;
  var editingIndex = RxnInt();
  var randomGroupId = ''.obs;

  var countryCodes = <CountryCodeData>[].obs; // Reactive list

  IdUploadModel? idUploadModel;

  @override
  void onInit() {
    super.onInit();
    randomGroupId.value = generateGroupId();
    fetchCountryCodes(); // fetch country codes from API
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  String generateGroupId() {
    final random = Random();
    return "G${random.nextInt(999999).toString().padLeft(6, '0')}";
  }

  fetchCountryCodes() async {
    final api = NetworkManager<CountryCodesModel>(baseUrl);
    final response = await api.get(
      'api/org/listOfCountriesExt',
      (json) => CountryCodesModel.fromJson(json),
    );

    if (response != null &&
        response.data != null &&
        response.data!.isNotEmpty) {
      countryCodes.assignAll(response.data!);
      print("country codes $countryCodes");
      print('Fetched country codes successfully.');
    } else {
      print('No country codes available.');
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? pickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (pickerResult == null) return;

    uploadedFile.value = pickerResult.files.single.name;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    final String? orgID = prefs.getString('orgId');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${baseUrl}api/org/uploadImage'),
    );

    final filePath = pickerResult.files.single.path!;
    final fileExt = filePath.split('.').last.toLowerCase();
    MediaType contentType;
    if (fileExt == 'png') {
      contentType = MediaType('image', 'png');
    } else if (fileExt == 'jpg' || fileExt == 'jpeg') {
      contentType = MediaType('image', 'jpeg');
    } else {
      contentType = MediaType('application', 'octet-stream');
    }

    request.files.add(
      await http.MultipartFile.fromPath(
        'images',
        filePath,
        contentType: contentType,
      ),
    );

    request.fields.addAll({'org_id': orgID ?? "", 'branch_id': branchId ?? ""});

    http.StreamedResponse response = await request.send();
    final result = await response.stream.bytesToString();
    Map<String, dynamic> data = jsonDecode(result);
    idUploadModel = IdUploadModel.fromJson(data);

    if (response.statusCode == 200) {
      uploadedFileUrl.value = idUploadModel?.uploadedImagePaths?.first ?? '';
      Get.snackbar('Success', 'ID uploaded successfully');
    } else {
      Get.snackbar('Error', 'File upload failed');
    }
  }

  void clearFields() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    selectedRole.value = null;
    selectedCountryCode.value = '';
    uploadedFile.value = null;
    uploadedFileUrl.value = '';
  }

  void addMember() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedRole.value == null ||
        selectedCountryCode.value.isEmpty) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }

    if (isEditing.value && editingIndex.value != null) {
      members[editingIndex.value!] = GroupMemberModel(
        grpId: members[editingIndex.value!].grpId,
        grpName: '',
        grpUserRoleName: selectedRole.value?.roleName,
        grpUserUniqueId: members[editingIndex.value!].grpUserUniqueId,
        groupUserPhnExt: selectedCountryCode.value,
        grpUserName: nameController.text,
        grpUserEmail: emailController.text,
        grpUserRole: selectedRole.value?.roleName,
        grpUserPhno: phoneController.text,
        grpUserIdProof: uploadedFileUrl.value,
      );
    } else {
      members.add(
        GroupMemberModel(
          grpId: randomGroupId.value,
          grpName: '',
          grpUserRoleName: selectedRole.value?.roleName,
          grpUserUniqueId: generateGroupId(),
          groupUserPhnExt: selectedCountryCode.value,
          grpUserName: nameController.text,
          grpUserEmail: emailController.text,
          grpUserRole: selectedRole.value?.roleName,
          grpUserPhno: phoneController.text,
          grpUserIdProof: uploadedFileUrl.value,
        ),
      );
    }

    isEditing.value = false;
    editingIndex.value = null;
    clearFields();
  }

  void editMember(int index) {
    if (index >= members.length) {
      Get.snackbar('Error', 'This member is no longer available');
      return;
    }

    final member = members[index];
    isEditing.value = true;
    editingIndex.value = index;

    nameController.text = member.grpUserName ?? '';
    emailController.text = member.grpUserEmail ?? '';
    phoneController.text = member.grpUserPhno ?? '';
    selectedCountryCode.value = member.groupUserPhnExt ?? '';
    uploadedFileUrl.value = member.grpUserIdProof ?? '';
    uploadedFile.value =
        member.grpUserIdProof != null && member.grpUserIdProof!.isNotEmpty
        ? "Uploaded"
        : null;

    if (roles.isNotEmpty) {
      selectedRole.value = roles.firstWhere(
        (role) => role.roleName == member.grpUserRoleName,
        orElse: () => roles.first,
      );
    } else {
      selectedRole.value = null;
    }
  }

  void deleteMember(int index) {
    if (index >= members.length) return;
    members.removeAt(index);
    isEditing.value = false;
    editingIndex.value = null;
    clearFields();
  }

  void submitGroup(Function(Map<String, dynamic>) onSubmit) {
    if (members.isEmpty) {
      Get.snackbar('Error', 'Please add at least one member');
      return;
    }

    final groupData = {
      "grp_book_bool": members.isEmpty,
      "grp_details": members.map((e) => e.toJson()).toList(),
    };

    onSubmit(groupData);
    Get.back();
  }
}
