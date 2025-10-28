import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/vehicle_detailsbysrc_model/vehicle_details_bysrc.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:visiq/utils/globals.dart';

class VehicleVerificationController extends GetxController {
  final TextEditingController srcCodeController = TextEditingController();
  final scrollKey = GlobalKey();
  final ScrollController scrollController = ScrollController();
  var vehicleDetails = <VmDetails>[].obs;
  var materialDetails = <MmDetails>[].obs;
  var srcCode = ''.obs;

  getVisitorDetailsBySRC() async {
    vehicleDetails.clear();
    final prefs = await SharedPreferences.getInstance();
    final branchId = prefs.getString('selectedBranchId');
    final orgId = prefs.getString('orgId');
    final dateOfVisit = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final visiqRest = NetworkManager<VisitorDetailsBySrcModel>(baseUrl);

    final response = await visiqRest.get(
      '/api/org/getVisitorBySrc?visitor_code=${srcCodeController.text}&branch_id=$branchId&org_id=$orgId&date_of_visit=$dateOfVisit',
      (data) {
        if (data['message'] != null) {
          Fluttertoast.showToast(
              msg: data['message'], backgroundColor: Colors.red);
        }
        return VisitorDetailsBySrcModel.fromJson(data);
      },
    );

    if (response != null) {
      srcCode.value = srcCodeController.text;
      vehicleDetails.clear();
      if (response.visitors != null) {
        for (var visitor in response.visitors!) {
          if (visitor.vmDetails != null) {
            vehicleDetails.addAll(visitor.vmDetails!);
          }
        }
      }
    }
  }

 vehicleTwoStepVerification(
      VmDetails details, bool isApproved, String? rejectedReason) async {
    final prefs = await SharedPreferences.getInstance();
    final branchId = prefs.getString("selectedBranchId");
    final visiqRest = NetworkManager(baseUrl);

    await visiqRest.post(
      '/api/faces/twoStepVerification',
      {
        "branch_id": branchId,
        "vm_boolean": true,
        "vehicle_details": [
          {
            "vehicle_id": details.vehicleId,
            "driver_licence": details.driverLicence,
            "insurance_no": details.insuranceNo,
            "rc_no": details.rcNo,
            "vehicle_name": details.vehicleName,
            "vehicle_in_src": srcCodeController.text,
            "isApproved": isApproved,
            "rejected_reason": rejectedReason,
            "driver_id": details.driverId,
            "insurance_provider": details.insuranceProvider,
            "vehicle_comments": details.vehicleComments,
            "vehicle_type": details.vehicleType
          }
        ]
      },
      (data) {
        print(data);
      },
      null,
      (statusCode) {
        print('statusCode: $statusCode');
      },
    );

    isApproved ? print('Vehicle approved') : print('Vehicle rejected');
    await getVisitorDetailsBySRC();
  }

  void scrollToMaterialTable() {
    final context = scrollKey.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut);
    }
  }

  materialTwoStepVerification(
      MmDetails materialDetails, bool isApproved, String? rejectedReason) async {
    final visiqRest = NetworkManager(baseUrl);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final branchId = prefs.getString("selectedBranchId");
    final response = await visiqRest.post(
      '/api/faces/twoStepVerification',
      {
        "branch_id": branchId,
        "mm_boolean": true,
        "material_details": [
          {
            "material_id": materialDetails.materialId,
            "material_name": materialDetails.materialName,
            "material_in_src": srcCodeController.text,
            "material_quantity": materialDetails.materialQuantity,
            "material_device_model": materialDetails.materialDeviceModel,
            "material_in_user_id": "",
            "material_in_vehicle_id": materialDetails.materialVehicleId,
            "material_no_of_units": materialDetails.materialNoOfUnits,
            "material_rack_no": materialDetails.materialRackNo,
            "isApproved": isApproved,
            "rejected_reason": rejectedReason,
            "material_comments": materialDetails.materialComments,
            "material_description": materialDetails.materialDescription,
            "material_s_n": materialDetails.materialSN,
          }
        ]
      },
       (data) {
        print(data);
      },
      null,
      (statusCode) {
        print('statusCode: $statusCode');
      },
    );
    print(response);
    isApproved ? print('Material approved') : print('Material rejected');
    await getVisitorDetailsBySRC();
  }
}
