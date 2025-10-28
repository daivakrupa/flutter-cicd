import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/login_models/organisation_model.dart';
import 'package:visiq/network_manager/crypto_helper.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:visiq/utils/globals.dart';

class LoginController extends GetxController {
  SharedPreferences? prefs;
  var showUsernamePasswordFields = true.obs;
  List<String>? empty = [];
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  OrganisationModel? organisationModel;
  int? statusCode;
  Branches? selectedBranchId;
  var isPasswordVisible = false.obs;

  @override
  void onInit() {
    setUpAppPreference();
    super.onInit();
  }

  setUpAppPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  signInAPI() async {
    if (userNameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.context!.loaderOverlay.hide();
      Fluttertoast.showToast(
        msg: "Please provide username and password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }
    print(userNameController.text);
    print(passwordController.text);

    final dataToBeEncrypted = {
      'username': userNameController.text,
      'password': passwordController.text,
    };
    final encrypted = await encrypt(dataToBeEncrypted);
    print('request body $encrypted');
    // final requestBody = {"encryptedData":encrypted};
    final smartLotoRest = NetworkManager<OrganisationModel>(baseUrl);
    final result = await smartLotoRest.post(
      "/api/auth/signin",
      dataToBeEncrypted,
      (data) => OrganisationModel.fromJson(data),
      null,
      (code) {
        debugPrint(statusCode.toString());
        statusCode = code;
        print(code);
      },
    );
    if (statusCode == 401) {
    Get.context!.loaderOverlay.hide();
      Fluttertoast.showToast(
        msg: "Please provide valid username and password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return;
    }
    if (statusCode == 200) {
      Get.context!.loaderOverlay.hide();
      // Store branch names and  branch id's in user defaults
      final brancheNames = result!.organisationDetails!.branches!
          .map((e) => e.branchName)
          .where((name) => name != null)
          .map((name) => name!)
          .toList();
      final branchIds = result.organisationDetails!.branches!
          .map((e) => e.branchId)
          .where((name) => name != null)
          .map((name) => name!)
          .toList();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      print(brancheNames);
      prefs.setStringList('orgBranchNames', brancheNames);
      prefs.setStringList('orgBranchIds', branchIds);
        organisationModel = result;
        showUsernamePasswordFields.value = !showUsernamePasswordFields.value;
      print(result);

      if (organisationModel?.role != null) {
        await prefs.setString('userRole', result.role ?? "");
      }
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // final decryptedString = await decrypt(result.encryptedData ?? "");
      //  Map<String, dynamic> jsonMap = jsonDecode(decryptedString);
      //organisationModel = OrganisationModel.fromJson(result);
    } else {
      print(result);
      Get.context!.loaderOverlay.hide();
      Fluttertoast.showToast(
        msg: "Oops something went wrong .Please try again later",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
    }
  }

  Future<String> encrypt(Map<String, dynamic> data) async {
    final cryptoHelper = CryptoHelper();
    final jsonString = jsonEncode(data);
    // Encrypt the data
    final encryptedData = await cryptoHelper.encryptData(jsonString);
    print('Encrypted Data: $encryptedData');
    // Decrypt the data
    return encryptedData;
  }

  Future<String> decrypt(String data) async {
    final cryptoHelper = CryptoHelper();
    final decryptedData = await cryptoHelper.decryptData(data);
    print('Decrypted Data: $decryptedData');
    return decryptedData;
  }
}
