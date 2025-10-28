import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visiq/controllers/book_visit_controller.dart';

class FormFieldWidget extends StatelessWidget {
  const FormFieldWidget({
    super.key,
    required this.labelText,
    required this.inputType,
    required this.maincontroller,
    required this.controller,
    this.isEnabled = true,
  });
  final String labelText;
  final TextInputType inputType;
  final BookVisitController maincontroller;
  final TextEditingController controller;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: controller == maincontroller.branchController
          ? maincontroller.userRole !=
                "2" // Only userRole "2" can edit; others have this field disabled
          : controller == maincontroller.areasPermittedController
          ? true // Make Areas Permitted field read-only
          : false,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixText: labelText == 'Country Code'
            ? '+'
            : null, // Set '+' as a prefix
        suffixIcon: controller == maincontroller.branchController
            ? const Icon(
                Icons.arrow_drop_down,
              ) // Add dropdown icon for branch controller
            : null, // No suffix icon for other controllers
      ),
      keyboardType: inputType,
      inputFormatters: labelText == 'Country Code'
          ? [FilteringTextInputFormatter.digitsOnly]
          : [],
      onTap: () async {
        if (controller == maincontroller.branchController &&
            maincontroller.userRole == "2") {
          await maincontroller.showListOfBranchesForOrgAdmin(context);
        } else if (controller == maincontroller.areasPermittedController) {
          maincontroller.showListOfAreasOfPermit();
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText is required';
        }
        if (controller == maincontroller.areasPermittedController &&
            value.isEmpty) {
          return 'Areas Permitted is required';
        }
        if (labelText == 'Phone Number' && value.length > 10) {
          return 'Phone Number must be less than or equal to 10 digits';
        }
        if (labelText == 'Email' && !maincontroller.isValidEmail(value)) {
          return 'Enter a valid email address';
        }
        return null;
      },
      enabled: isEnabled,
    );
  }
}
