import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/book_visit_model/countrycodes_model.dart';
import 'package:visiq/models/book_visit_model/get_list_of_branches_model.dart';
import 'package:visiq/models/building_blocks_model/building_blocks_model.dart';
import 'package:visiq/models/login_models/organisation_model.dart';
import 'package:intl/intl.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:visiq/utils/globals.dart';
import 'package:visiq/utils/overlay_loading_progress.dart';

import '../models/book_visit_model/book_visit_model.dart';

class BookVisitController extends GetxController {
  final formKey = GlobalKey<FormState>();
  DateTime? startDate;
  DateTime? endDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  GetBranches? selectedBranch;
  var selectedCountryCode = Rxn<CountryCodeData>();
  OrganisationModel? organisationModel;
  var purposeOfVisits = <PuporseOfVisits>[].obs;
  var branchAdmins = <BranchAdmins>[].obs;
  var securityAdmins = <BranchAdmins>[].obs;
  var roles = <Roles>[].obs;
  String? userRole;
  List<String> selectedPurposeOfVisits = [];
  String? selectedAdmin;
  var combinedAdmins = <String>[].obs;
  String? selectedPurposeOfVisit;
  String? selectedRole;
  Branches? selectedBranchId;
  Function(BuildContext, bool)? fetchVisitorsData;
  var countryCodes = <CountryCodeData>[].obs;
  Map<String, dynamic>? vehicleMaterialData;
  Map<String, dynamic>? groupBookingData;
  TextEditingController searchController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController branchController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController visitorOrganisationController =
      TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController purposeController = TextEditingController();
  final TextEditingController areasPermittedController =
      TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  var selectedAreas = <AreasOfBranch>[].obs;
  var areasOfPermit = <AreasOfBranch>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      var arguments = Get.arguments as Map<String, dynamic>?;
      selectedBranchId = arguments?['branchId'] as Branches?;
      fetchVisitorsData = arguments?['fetchVisitorsData'];
    }
    getUserRole();
    print(selectedBranchId?.branchId);
    fetchCountryCodes();
    fetchAreasOfPermit(selectedBranchId?.branchId);
  }

  postVisitFormAPI(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? orgID = prefs.getString('orgId');
    final String? orgName = prefs.getString('orgName');
    final String? userRole = prefs.getString('userRole');

    String? formattedStartDate = startDate != null
        ? DateFormat('dd-MM-yyyy').format(startDate!)
        : null;
    String? formattedEndDate = endDate != null
        ? DateFormat('dd-MM-yyyy').format(endDate!)
        : null;
    String? formattedStartTime = startTime != null
        ? formatTimeWith24Hour(startTime!)
        : null;
    String? formattedEndTime = endTime != null
        ? formatTimeWith24Hour(endTime!)
        : null;
    final visitRequestBody = {
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "purpose_of_visit": selectedPurposeOfVisit,
      "date_of_visit": formattedStartDate,
      "end_date_of_visit": formattedEndDate,
      "time_of_visit": formattedStartTime,
      "email": emailController.text,
      "branch_name": userRole == "2"
          ? selectedBranch?.branchName
          : selectedAdmin,
      "branch_id": userRole == "2"
          ? selectedBranch?.branchId
          : selectedBranchId?.branchId,
      "org_name": orgName,
      "org_id": orgID,
      "visit_duration": "",
      "visitorOrgName": visitorOrganisationController.text,
      "phNo": phoneController.text,
      "ph_ext": selectedCountryCode.value,
      "time_to_exit": formattedEndTime,
      "area_of_permit": selectedAreas
          .map((area) => {"area_id": area.areaId, "area_name": area.areaName})
          .toList(),
      "meetTo": selectedAdmin ?? "",
      "role": selectedRole,
      "reason": reasonController.text,
      "vm_bool": vehicleMaterialData != null,
      "mm_bool": vehicleMaterialData != null,
      "vm_details": vehicleMaterialData?["vm_details"] ?? [],
      "mm_details": vehicleMaterialData?["mm_details"] ?? [],
      "grp_book_bool": groupBookingData != null,
      "grp_details": groupBookingData?["grp_details"] ?? [],
    };

    print("visit request body ${jsonEncode(visitRequestBody)}");
    final api = NetworkManager<BookVisitPostModel>(baseUrl);
    final result = await api.post(
      "/api/org/bookAVisit",
      visitRequestBody,
      (data) => BookVisitPostModel.fromJson(data),
      null,
      (statusCode) {
        if (statusCode != 200 && statusCode != 201) {
          print("Request failed with status code: $statusCode");
        }
      },
    );
    OverlayLoadingProgress.stop();
    if (result != null &&
        (result.statusCode == 200 || result.statusCode == 201)) {
      print("Visit booked successfully: $result");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Visit Booked Successfully'),
            content: const Text(
              'If you want to change or edit timings, please contact the admin.',
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                  fetchVisitorsData!(context, false);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      final errorMessage = result?.message ?? 'Something went wrong.';
      print("Warning: $errorMessage");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Warning'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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

  fetchAreasOfPermit(String? branchId) async {
    print("Branch ID in areas: $branchId");
    final api = NetworkManager<BuildingBlocksModel>(baseUrl);
    final result = await api.post(
      "/api/org/AreasByBranchId",
      {"branch_id": branchId},
      (data) => BuildingBlocksModel.fromJson(data),
      null,
      (statusCode) {
        if (statusCode != 200) {
          print(
            "Failed to fetch areas_of_permit with status code: $statusCode",
          );
          return;
        }
      },
    );

    if (result != null && result.areasOfBranch != null) {
      if (result.areasOfBranch != null) {
        areasOfPermit.value = result.areasOfBranch!;
        print("Areas of Permit: $areasOfPermit");
      }
      if (result.puporseOfVisits != null) {
        purposeOfVisits.value = result.puporseOfVisits!;
        print("Purpose of Visits: $purposeOfVisits");
      }
      if (result.branchAdmins != null) {
        branchAdmins.value = result.branchAdmins!;
        print("Branch Admins: $branchAdmins");
      }
      if (result.securityAdmins != null) {
        securityAdmins.value = result.securityAdmins!;
        print("Security Admins: $securityAdmins");
      }
      if (result.roles != null) {
        roles.value = result.roles!;
        print("Roles: $roles");
      }
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  showListOfBranchesForOrgAdmin(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? orgId = prefs.getString('orgId');
    final String? role = prefs.getString('userRole');

    final requestbody = {"org_id": orgId, "role": role, "branch_id": ''};
    final smartLotoRest = NetworkManager<GetListofBranchesModel>(baseUrl);
    final result = await smartLotoRest.post(
      "/api/org/getBranchesByOrgId",
      requestbody,
      (data) {
        return GetListofBranchesModel.fromJson(data);
      },
      null,
      (code) {
        debugPrint(code.toString());
      },
    );
    final List<GetBranches> branches =
        result?.organisationDetails?.branches ?? [];

    Get.dialog(
      AlertDialog(
        title: const Text("Select Branch"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: branches.map((branch) {
              return ListTile(
                title: Text(branch.branchName ?? ''),
                onTap: () {
                  selectedBranch = branch;
                  branchController.text = branch.branchName ?? '';
                  areasPermittedController.clear();
                  fetchAreasOfPermit(selectedBranchId!.branchId);
                  Get.back();
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Format TimeOfDay as hh:mm in 24-hour format
  String formatTimeWith24Hour(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Helper function to compare TimeOfDay
  int compareTimeOfDay(TimeOfDay start, TimeOfDay end) {
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    return startMinutes.compareTo(endMinutes);
  }

  // void handleSubmit() {
  //   final selectedCountryCode = countryCodeController.text;
  //   print('Selected Country Code: $selectedCountryCode');
  //   // Add logic to submit these values to your API
  // }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  getUserRole() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userRole = prefs.getString('userRole');
    if (userRole == "2") {
      fetchAreasOfPermit(selectedBranchId?.branchId);
    } else {
      branchController.text = selectedBranchId?.branchName ?? "";
      fetchAreasOfPermit(selectedBranchId?.branchId);
    }
  }

  void showListOfAreasOfPermit() {
    // Reactive flags
    RxList<bool> selectedAreaFlags = List<bool>.filled(
      areasOfPermit.length,
      false,
    ).obs;
    RxBool isAllSelected = (selectedAreas.length == areasOfPermit.length).obs;

    // Initialize already selected areas
    areasOfPermit.asMap().forEach((i, area) {
      final String? areaId = area.areaId;
      if (selectedAreas.any((selectedArea) => selectedArea.areaId == areaId)) {
        selectedAreaFlags[i] = true;
      }
    });

    Get.dialog(
      AlertDialog(
        title: const Text("Select Areas of Permit"),
        content: SingleChildScrollView(
          child: Obx(
            () => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 🔹 Select All Checkbox
                CheckboxListTile(
                  title: const Text(
                    "Select All",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  value: isAllSelected.value,
                  onChanged: (bool? value) {
                    isAllSelected.value = value ?? false;
                    selectedAreaFlags.fillRange(
                      0,
                      selectedAreaFlags.length,
                      isAllSelected.value,
                    );

                    if (isAllSelected.value) {
                      selectedAreas.value = areasOfPermit
                          .map(
                            (area) => AreasOfBranch(
                              areaId: area.areaId,
                              areaName: area.areaName,
                            ),
                          )
                          .toList();
                    } else {
                      selectedAreas.clear();
                    }
                  },
                ),

                // 🔹 Individual Area Checkboxes
                ...areasOfPermit.asMap().entries.map((entry) {
                  int index = entry.key;
                  var area = entry.value;

                  return CheckboxListTile(
                    title: Text(area.areaName ?? ''),
                    value: selectedAreaFlags[index],
                    onChanged: (bool? value) {
                      selectedAreaFlags[index] = value ?? false;

                      final String? areaId = area.areaId;
                      final String areaName = area.areaName ?? '';

                      if (value == true) {
                        if (!selectedAreas.any(
                          (selectedArea) => selectedArea.areaId == areaId,
                        )) {
                          selectedAreas.add(
                            AreasOfBranch(areaId: areaId, areaName: areaName),
                          );
                        }
                      } else {
                        selectedAreas.removeWhere(
                          (selectedArea) => selectedArea.areaId == areaId,
                        );
                      }

                      isAllSelected.value =
                          selectedAreas.length == areasOfPermit.length;
                    },
                  );
                }),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("Cancel"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              areasPermittedController.text = selectedAreas
                  .map((area) => area.areaName)
                  .join(', ');
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
