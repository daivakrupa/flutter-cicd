import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/views/privelige_entryform/selected_users_table.dart';
import 'package:visiq/controllers/prevelage_entry_controller.dart';

class PrevallagedEntryForm extends StatelessWidget {
   PrevallagedEntryForm({super.key});
   final PrevelageEntryController controller = Get.put(PrevelageEntryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () =>  Get.back(),
        ),
        title: const Text(
          "Privileged Entry",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/images/prevalage.jpg')),
            ElevatedButton(
              onPressed: () => controller.openUserSelector(context),
              child: const Text('Select Users'),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ( SingleChildScrollView(
                    child: SelectedUsersTable(
                      selectedUsers: controller.selectedUsers,
                      onDelete: controller.deleteUser,
                    ),
                  )),
            ),
            Obx(() {
              if (controller.selectedUsers.isEmpty) return const SizedBox.shrink();
              final firstUser = controller.selectedUsers.first;
              return ElevatedButton(
                onPressed: () => controller.submitForm(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: firstUser.isEntry == true ? Colors.red : Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Center(
                    child: Text(
                      firstUser.isEntry == true ? 'Check Out' : 'Check In',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
