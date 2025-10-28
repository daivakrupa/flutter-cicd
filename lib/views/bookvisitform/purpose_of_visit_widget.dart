import 'package:flutter/material.dart';
import 'package:visiq/controllers/book_visit_controller.dart';
import 'package:visiq/views/bookvisitform/form_field_widget.dart';

class PurposeOfVisitWidget extends StatelessWidget {
  const PurposeOfVisitWidget({super.key, required this.controller});
  final BookVisitController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(labelText: 'Purpose Of Visit'),
          items: controller.purposeOfVisits
              .map(
                (visit) => DropdownMenuItem(
                  value: visit.pov,
                  child: Text(
                    visit.pov!,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            controller.selectedPurposeOfVisit = value;
            if (value == 'Meetings') {
              controller.selectedPurposeOfVisits = ['Meetings'];
              controller.fetchAreasOfPermit("branchId");
            } else if (value == 'Others') {
              controller.selectedPurposeOfVisits = ['Others'];
            } else {
              controller.selectedPurposeOfVisits.clear();
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a purpose of visit';
            }
            return null;
          },
        ),
        if (controller.selectedPurposeOfVisits.contains('Meetings')) ...[
          _buildCombinedAdminDropdown(),
        ],
        if (controller.selectedPurposeOfVisits.contains('Others')) ...[
          FormFieldWidget(
            labelText: 'Reason',
            inputType: TextInputType.text,
            maincontroller: controller,
            controller: controller.reasonController,
          ),
        ],
      ],
    );
  }

  Widget _buildCombinedAdminDropdown() {
    // ignore: prefer_collection_literals
    controller.combinedAdmins.value = [
      ...controller.branchAdmins.map(
        (admin) => '${admin.username} (${admin.email})',
      ),
      ...controller.securityAdmins.map(
        (admin) => '${admin.username} (${admin.email})',
      ),
    ].toSet().toList();

    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(labelText: 'Person To Meet'),
      items: controller.combinedAdmins
          .map(
            (admin) => DropdownMenuItem<String>(
              value: admin,
              child: Text(
                admin,
                style: const TextStyle(fontWeight: FontWeight.normal),
              ),
            ),
          )
          .toList(),
      onChanged: (String? admin) {
        if (admin != null) {
          // Extract the email from the selected item
          final email = admin.substring(
            admin.indexOf('(') + 1,
            admin.indexOf(')'),
          );
          controller.selectedAdmin =
              email; // Store only the email for backend use
          print('Extracted Email: ${controller.selectedAdmin}');
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a person to meet';
        }
        return null;
      },
    );
  }
}
