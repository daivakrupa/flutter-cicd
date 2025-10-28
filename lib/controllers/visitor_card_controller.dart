

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/get_visitors_model/get_visitor_model.dart';
import 'package:visiq/models/login_models/organisation_model.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:visiq/utils/globals.dart';
import 'package:intl/intl.dart';

class VisitorCardController extends GetxController {
 var selectedDate = DateTime.now().obs;
  var formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).obs;

  var visitorList = <VisitorsList>[].obs;
  var arrivedVisitorList = <ArrivedVisitorsList>[].obs;

  var totalBranches = 0.obs;
  var totalEntries = 0.obs;
  var totalCheckIns = 0.obs;
  var totalCheckOuts = 0.obs;
  var expectedVisitors = 0.obs;
  var arrivedVisitors = 0.obs;
  var noShowVisitorsDate = false.obs;
  Branches? selectedBranchId;
  String? selectedBranchName;
  String? selectedOrgId;

  @override
  void onInit() {
    super.onInit();
    loadSelectedBranch();
  }

  Future<void> loadSelectedBranch() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    final String? branchName = prefs.getString('selectedBranchName');
    final String? orgID = prefs.getString('orgId');

    if (branchId != null) {
      selectedBranchId = Branches(branchId: branchId, branchName: branchName);
      selectedBranchName = branchName;
      selectedOrgId = orgID;

      fetchVisitorsData(false);
    }
  }

 pickDate(BuildContext context) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );
    if (newDate != null) {
      selectedDate.value = newDate;
      formattedDate.value = DateFormat('yyyy-MM-dd').format(newDate);
      fetchVisitorsData(false);
    }
  }
  fetchVisitorsData(bool showIndicator) async {
    showIndicator ? Get.context?.loaderOverlay.show()
    // OverlayLoadingProgress.start(context)
     : print("do nothing");
    final smartLotoRest = NetworkManager<GetVisitorsModel>(baseUrl);
    final payload = {
      "org_id": selectedOrgId,
      "branch_id": selectedBranchId!.branchId,
      "role": "",
      "data_of_visit": formattedDate.value,
    };
    print('payload $payload');
    final result = await smartLotoRest.post(
      "/api/org/getAllVisitors",
      payload,
      (data) => GetVisitorsModel.fromJson(data),
      null,
      (statusCode) {
        print('visitor data statuscode $statusCode');
      },
    );
    visitorList.value = result?.visitorsList ?? [];
    arrivedVisitorList.value = result?.arrivedVisitorsList ?? [];
    totalBranches.value = result?.totalBranches ?? 0;
    totalEntries.value = result?.totalEntries ?? 0;
    totalCheckIns.value = result?.totalCheckIns ?? 0;
    totalCheckOuts.value = result?.totalCheckOuts ?? 0;
    expectedVisitors.value = result?.expectedVisitors ?? 0;
    arrivedVisitors.value = result?.arrivedVisitors ?? 0;
    noShowVisitorsDate.value = result?.noShowVisitorsDate ?? false;
      showIndicator = false;
  
       Get.context?.loaderOverlay.hide();
  }
}