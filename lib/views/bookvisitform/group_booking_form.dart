import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/controllers/group_booking_controller.dart';
import 'package:visiq/models/building_blocks_model/building_blocks_model.dart';
import 'package:visiq/views/bookvisitform/country_code_dropdown.dart';

class GroupBookingForm extends StatelessWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final List<Roles> roles;

  GroupBookingForm({super.key, required this.onSubmit, required this.roles});

  final controller = Get.put(GroupBookingController());

  @override
  Widget build(BuildContext context) {
    controller.roles.assignAll(roles);

    return Scaffold(
      backgroundColor: Colors.white.withAlpha(245),
      appBar: AppBar(
        title: const Text("Group Booking"),
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildForm(),
            const SizedBox(height: 20),
            Obx(
              () => controller.members.isNotEmpty
                  ? _buildMembersTable()
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField(controller.nameController, "Member Name"),
          _buildTextField(
            controller.emailController,
            "Email",
            keyboardType: TextInputType.emailAddress,
          ),
          _buildDropdown(),
          CountryCodeDropdown(
            selectedCountryCode: controller.selectedCountryCode,
            countryCodes: controller.countryCodes,
          ),

          _buildTextField(
            controller.phoneController,
            "Phone Number",
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 10),
          _buildFileUpload(),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: controller.addMember,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(83, 213, 227, 1),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              "Add Member",
              style: TextStyle(
                color: Color.fromRGBO(72, 76, 175, 1),
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdown() {
    return Obx(
      () => DropdownButtonFormField<Roles>(
        value: controller.selectedRole.value,
        items: controller.roles
            .map(
              (role) => DropdownMenuItem(
                value: role,
                child: Text(role.roleName ?? ''),
              ),
            )
            .toList(),
        onChanged: (value) => controller.selectedRole.value = value,
        decoration: const InputDecoration(labelText: "Role Name"),
      ),
    );
  }

  Widget _buildFileUpload() {
    return Obx(
      () => Row(
        children: [
          ElevatedButton.icon(
            onPressed: controller.pickFile,
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: Colors.white.withAlpha(245),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
                side: const BorderSide(
                  color: Color.fromRGBO(72, 76, 175, 1),
                  width: 1,
                ),
              ),
            ),
            icon: const Icon(
              Icons.upload_file,
              color: Color.fromRGBO(72, 76, 175, 1),
            ),
            label: const Text(
              "Upload Proof",
              style: TextStyle(color: Color.fromRGBO(72, 76, 175, 1)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.uploadedFile.value ?? "No file selected",
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Members List",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () => DataTable(
              border: TableBorder.all(color: Colors.grey),
              columns: const [
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Email")),
                DataColumn(label: Text("Role")),
                DataColumn(label: Text("Country code")),
                DataColumn(label: Text("Phone")),
                DataColumn(label: Text("Proof")),
                DataColumn(label: Text("Action")),
              ],
              rows: List.generate(controller.members.length, (index) {
                final member = controller.members[index];
                return DataRow(
                  cells: [
                    DataCell(Text(member.grpUserName ?? '')),
                    DataCell(Text(member.grpUserEmail ?? '')),
                    DataCell(Text(member.grpUserRole ?? '')),
                    DataCell(Text(member.groupUserPhnExt ?? '')),
                    DataCell(Text(member.grpUserPhno ?? '')),
                    DataCell(
                      TextButton(
                        onPressed: () {
                          if (member.grpUserIdProof != null &&
                              member.grpUserIdProof!.isNotEmpty) {
                            Get.dialog(
                              AlertDialog(
                                title: const Text("Proof Image"),
                                content: Image.network(member.grpUserIdProof!),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text("Close"),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Get.snackbar("Error", "No proof available");
                          }
                        },
                        child: const Text("View"),
                      ),
                    ),
                    DataCell(
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => controller.editMember(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => controller.deleteMember(index),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => controller.submitGroup(onSubmit),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Colors.green,
          ),
          child: const Text("Submit Group"),
        ),
      ],
    );
  }
}
