import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:visiq/models/login_models/organisation_model.dart';

class GetStartedController extends GetxController {
  Branches? selectedBranchId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      selectedBranchId = Get.arguments as Branches?;
      print('printing data in get started ${selectedBranchId?.branchId}');
    }
  }

  final LocalAuthentication auth = LocalAuthentication();

  authenticateUser() async {
    bool isAuthenticated = false;
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    bool isDeviceSupported = await auth.isDeviceSupported();

    if (Platform.isAndroid) {
      bool hasStrongAuth = await auth.isDeviceSupported();
      if (!hasStrongAuth) {
        _showErrorDialog(
          'No PIN or password setup detected. Please enable security settings to proceed.',
        );
        return false;
      }
    }

    if (!isDeviceSupported && !canCheckBiometrics) {
      _showErrorDialog(
        'Your device does not support security authentication. Please enable PIN, password, or biometric settings to proceed.',
      );
      return false;
    }
    if (canCheckBiometrics) {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate using biometrics',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    }
    if (!isAuthenticated) {
      isAuthenticated = await auth.authenticate(
        localizedReason: 'Please authenticate using PIN or Password',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
    }

    if (!isAuthenticated) {
      _showErrorDialog(
        'Authentication failed. Please go to settings and enable security settings.',
      );
    }

    return isAuthenticated;
  }

  void _showErrorDialog(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Authentication Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
