import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:visiq/controllers/book_visit_controller.dart';
import 'package:visiq/utils/overlay_loading_progress.dart';
import 'package:visiq/views/bookvisitform/GroupBookingForm.dart';
import 'package:visiq/views/bookvisitform/country_code_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:visiq/views/bookvisitform/form_field_widget.dart';
import 'package:visiq/views/bookvisitform/purpose_of_visit_widget.dart';
import 'package:visiq/views/bookvisitform/vehicle_material_screen.dart';

// ignore: must_be_immutable
class BookAVisitForm extends StatelessWidget {
  BookAVisitForm({super.key});

  final BookVisitController controller = Get.put(BookVisitController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book A Visit Form'),
        scrolledUnderElevation: 0,
      ),
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                children: [
                  FormFieldWidget(
                    controller: controller.firstNameController,
                    inputType: TextInputType.text,
                    labelText: 'First Name',
                    maincontroller: controller,
                  ),
                  FormFieldWidget(
                    controller: controller.lastNameController,
                    inputType: TextInputType.text,
                    labelText: 'Last Name',
                    maincontroller: controller,
                  ),
                  FormFieldWidget(
                    controller: controller.visitorOrganisationController,
                    inputType: TextInputType.text,
                    labelText: 'Visitor Organisation',
                    maincontroller: controller,
                  ),
                  FormFieldWidget(
                    controller: controller.branchController,
                    inputType: TextInputType.text,
                    labelText: 'Select Branch',
                    maincontroller: controller,
                    isEnabled: controller.userRole == "2" ? true : false,
                  ),
                  FormFieldWidget(
                    controller: controller.areasPermittedController,
                    inputType: TextInputType.text,
                    labelText: 'Areas Permitted',
                    maincontroller: controller,
                    isEnabled: controller.branchController.text != ""
                        ? true
                        : false,
                  ),
                  // CountryCodeDropdown(
                  //   selectedCountryCode: controller.selectedCountryCode?.code,
                  //   countryCodes: controller.countryCodes.toList(),
                  //   onSelction: (value) {
                  //     controller.selectedCountryCode = controller.countryCodes
                  //         .firstWhere((element) => element.code == value);
                  //   },
                  // ),
                  FormFieldWidget(
                    controller: controller.phoneController,
                    inputType: TextInputType.phone,
                    labelText: 'Phone Number',
                    maincontroller: controller,
                  ),
                  FormFieldWidget(
                    controller: controller.emailController,
                    inputType: TextInputType.emailAddress,
                    labelText: 'Email',
                    maincontroller: controller,
                  ),
                  PurposeOfVisitWidget(controller: controller),
                  _buildRolesDropdown(),
                  buildDatePicker(
                    'Start Date',
                    (date) => controller.startDate = date,
                    controller.startDateController,
                    controller,
                    context,
                  ),
                  buildDatePicker(
                    'End Date',
                    (date) => controller.endDate = date,
                    controller.endDateController,
                    controller,
                    context,
                  ),
                  buildTimePicker(
                    'Start Time',
                    (time) => controller.startTime = time,
                    controller.startTime,
                    controller.startTimeController,
                    context,
                  ),
                  buildTimePicker(
                    'End Time',
                    (time) => controller.endTime = time,
                    controller.endTime,
                    controller.endTimeController,
                    context,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Opacity(
                          opacity:
                              (controller.selectedBranch?.vmBoolean ?? false)
                              ? 1
                              : 0.3,
                          child: ElevatedButton(
                            onPressed: () {
                              (controller.selectedBranch?.vmBoolean ?? false)
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            VehicleAndMaterialScreen(
                                              onSubmit: (data) {
                                                controller.vehicleMaterialData =
                                                    data;
                                                const JsonEncoder encoder =
                                                    JsonEncoder.withIndent(
                                                      '  ',
                                                    );
                                                String prettyJson = encoder
                                                    .convert(
                                                      controller
                                                          .vehicleMaterialData,
                                                    );

                                                print("vehicles:\n$prettyJson");
                                              },
                                            ),
                                      ),
                                    )
                                  : Fluttertoast.showToast(
                                      msg:
                                          'Vehicle momment is not Enabled for the Selected Branch',
                                      backgroundColor: Colors.red,
                                    );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text("Vehicle/Material"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => GroupBookingForm(
                                  // countryCodes: controller.countryCodes
                                  // .toList(),
                                  onSubmit: (data) {
                                    controller.groupBookingData = data;
                                    const JsonEncoder encoder =
                                        JsonEncoder.withIndent('  ');
                                    String prettyJson = encoder.convert(
                                      controller.groupBookingData,
                                    );
                                    print("group details:\n$prettyJson");
                                  },
                                  roles: controller.roles.toList(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            side: const BorderSide(
                              color: Colors.black,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text("Group Booking"),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.formKey.currentState?.validate() ??
                          false) {
                        OverlayLoadingProgress.start(context);
                        controller.postVisitFormAPI(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(83, 213, 227, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const SizedBox(
                      width: 200,
                      height: 40,
                      child: Center(
                        child: Text(
                          'Book Visit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker(
    String label,
    ValueChanged<DateTime?> onDateSelected,
    TextEditingController controller,
    BookVisitController maincontroller,
    BuildContext context,
  ) {
    return TextFormField(
      readOnly: true,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select date',
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        DateTime? selected = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2101),
        );
        if (selected != null) {
          controller.text = DateFormat('dd-MM-yyyy').format(selected);
          onDateSelected(selected);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        if (label == 'End Date' && maincontroller.startDate != null) {
          DateTime selectedEndDate = DateFormat('dd-MM-yyyy').parse(value);
          if (selectedEndDate.isBefore(maincontroller.startDate!)) {
            return 'End Date must be after Start Date';
          }
        }
        return null;
      },
    );
  }

  Widget buildTimePicker(
    String label,
    ValueChanged<TimeOfDay?> onTimeSelected,
    TimeOfDay? selectedTime,
    TextEditingController timeController,
    BuildContext context,
  ) {
    return TextFormField(
      readOnly: true,
      controller: timeController,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Select time',
        suffixIcon: const Icon(Icons.access_time),
      ),
      onTap: () async {
        TimeOfDay? selected = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          initialEntryMode: TimePickerEntryMode.input,
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            );
          },
        );
        if (selected != null) {
          onTimeSelected(selected);
          timeController.text = controller.formatTimeWith24Hour(selected);
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        if (label == 'End Time' &&
            controller.startDate != null &&
            controller.endDate != null &&
            controller.startDate == controller.endDate) {
          if (controller.startTime != null && controller.endTime != null) {
            if (controller.compareTimeOfDay(
                  controller.startTime!,
                  controller.endTime!,
                ) >=
                0) {
              return 'End Time should be after Start Time';
            }
          }
        }
        return null;
      },
    );
  }

  Widget _buildRolesDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Category'),
      value: controller.selectedRole,
      items: controller.roles.map((role) {
        return DropdownMenuItem<String>(
          value: role.roleName.toString(), // Use role ID as value
          child: Text(
            role.roleInDays ?? 'Unknown Role',
            style: const TextStyle(fontWeight: FontWeight.normal),
          ), // Display role name
        );
      }).toList(),
      onChanged: (value) {
        controller.selectedRole = value; // Update selected role
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Role is required';
        }
        return null;
      },
    );
  }

  List<Map<String, String?>> selectedAreas = [];

  void showListOfAreasOfPermit(BuildContext context) {
    List<bool> selectedAreaFlags = List<bool>.filled(
      controller.areasOfPermit.length,
      false,
    );
    bool isAllSelected =
        selectedAreas.length == controller.areasOfPermit.length;

    controller.areasOfPermit.asMap().forEach((i, area) {
      String areaId = area.areaId ?? '';
      if (selectedAreas.any(
        (selectedArea) => selectedArea['areaId'] == areaId,
      )) {
        selectedAreaFlags[i] = true;
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text("Select Areas of Permit"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: const Text(
                        "Select All",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      value: isAllSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          isAllSelected = value ?? false;
                          selectedAreaFlags.fillRange(
                            0,
                            selectedAreaFlags.length,
                            isAllSelected,
                          );
                          if (isAllSelected) {
                            selectedAreas = controller.areasOfPermit.map((
                              area,
                            ) {
                              return {
                                'areaId': area.areaId,
                                'areaName': area.areaName,
                              };
                            }).toList();
                          } else {
                            selectedAreas.clear();
                          }
                        });
                      },
                    ),
                    ...controller.areasOfPermit.asMap().entries.map((entry) {
                      int index = entry.key;
                      var area = entry.value;
                      return CheckboxListTile(
                        title: Text(area.areaName ?? ''),
                        value: selectedAreaFlags[index],
                        onChanged: (bool? value) {
                          setState(() {
                            selectedAreaFlags[index] = value ?? false;
                            String areaName = area.areaName ?? '';
                            String? areaId = area.areaId;

                            if (value == true) {
                              if (!selectedAreas.any(
                                (selectedArea) =>
                                    selectedArea['areaId'] == areaId,
                              )) {
                                selectedAreas.add({
                                  'areaId': areaId,
                                  'areaName': areaName,
                                });
                              }
                            } else {
                              selectedAreas.removeWhere(
                                (selectedArea) =>
                                    selectedArea['areaId'] == areaId,
                              );
                            }
                            isAllSelected =
                                selectedAreas.length ==
                                controller.areasOfPermit.length;
                          });
                        },
                      );
                    }).toList(),
                  ],
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
                    controller.areasPermittedController.text = selectedAreas
                        .map((area) => area['areaName'])
                        .join(', ');
                    Get.back();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
