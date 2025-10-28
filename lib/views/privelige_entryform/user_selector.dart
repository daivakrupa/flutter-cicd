import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/controllers/user_selector_controller.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';

class UserSelector extends StatelessWidget {
  final List<UserDetails> users;
  final List<UserDetails> initiallySelected;
  final UserSelectionMode selectionMode;
  final bool enableSearch;

  const UserSelector({
    super.key,
    required this.users,
    this.initiallySelected = const [],
    required this.selectionMode,
    required this.enableSearch,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      UserSelectorController(
        users: users,
        initiallySelected: initiallySelected,
        selectionMode: selectionMode,
        enableSearch: enableSearch,
      ),
    );

    final isMultiple = selectionMode == UserSelectionMode.multiple;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                isMultiple ? "Select Users" : "Select a User",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (enableSearch)
                TextField(
                  onChanged: controller.onSearchChanged,
                  decoration: const InputDecoration(
                    labelText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              const SizedBox(height: 10),
              Expanded(
                child: Obx(() => ListView.builder(
                      controller: scrollController,
                      itemCount: controller.filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = controller.filteredUsers[index];
                        final isSelected = controller.selected.any((u) => u.userId == user.userId);

                        return ListTile(
                          title: Text(controller.getDisplayName(user)),
                          subtitle: user.emailId != null ? Text(user.emailId!) : null,
                          trailing: isMultiple
                              ? Obx(() => Checkbox(
                                    value: isSelected,
                                    onChanged: (_) => controller.toggleMultiSelect(user),
                                  ))
                              : null,
                          onTap: () {
                            isMultiple
                                ? controller.toggleMultiSelect(user)
                                : controller.onSingleSelect(context, user);
                          },
                        );
                      },
                    )),
              ),
              if (isMultiple) ...[
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, controller.selected),
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  child: const Text("Save Selected Users"),
                ),
              ]
            ],
          ),
        );
      },
    );
  }
}

enum UserSelectionMode { single, multiple }