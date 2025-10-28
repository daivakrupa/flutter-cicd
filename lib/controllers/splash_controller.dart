import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/login_models/organisation_model.dart';
import 'package:visiq/models/splash_models/populate_form_details_model.dart';

class SplashController extends GetxController {
  var timer = 0.obs;

  String? branchId;
  String? branchName;
  var selectedBranch = Rxn<Branches>();
  final dynamicFormData = [
    PopulateFormDetailsModel(
      placeholderText: 'First Name:',
      valuetext: '9:54 AM',
    ),
    PopulateFormDetailsModel(placeholderText: 'Last Name:', valuetext: 'FU123'),
    PopulateFormDetailsModel(
      placeholderText: 'Email ID:',
      valuetext: 'Manager',
    ),
    PopulateFormDetailsModel(
      placeholderText: 'Phone number',
      valuetext: 'Visiting ',
    ),
    PopulateFormDetailsModel(
      placeholderText: 'Purpose of Visit:',
      valuetext: 'Manager',
    ),
    PopulateFormDetailsModel(
      placeholderText: 'Emirate ID number :',
      valuetext: 'Visiting ',
    ),
  ];
  var isAdminLoggedIn = Rxn<bool>();
  var userRole = ''.obs;

  @override
  void onInit() {
    super.onInit();
    timer.value = 3;
    setUpAppPreference();
  }

  setUpAppPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getString('selectedBranchId');
    branchName = prefs.getString('selectedBranchName');
    selectedBranch.value = Branches(branchId: branchId, branchName: branchName);
    isAdminLoggedIn.value = prefs.getBool('isAdminLoggedIn');
    userRole.value = prefs.getString('userRole') ?? '';
    debugPrint('isAdminLoggedIn ${isAdminLoggedIn.value}');
    navigateFromSplashScreen();
  }

  navigateFromSplashScreen() {
    Future.delayed(Duration(seconds: timer.value), () {
      (isAdminLoggedIn.value != true)
          ? Get.offAllNamed('/login')
          : Get.offAllNamed(
              '/getStarted',
              arguments: Branches(
                branchId: branchId,
                branchName: branchName,
              ),
            );
    });
  }
}
