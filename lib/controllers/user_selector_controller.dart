import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
import 'package:visiq/views/privelige_entryform/user_selector.dart';

class UserSelectorController extends GetxController {
  final List<UserDetails> users;
  final UserSelectionMode selectionMode;
  final bool enableSearch;

  RxList<UserDetails> filteredUsers = <UserDetails>[].obs;
  RxList<UserDetails> selected = <UserDetails>[].obs;
  RxString search = "".obs;

  UserSelectorController({
    required this.users,
    required List<UserDetails> initiallySelected,
    required this.selectionMode,
    required this.enableSearch,
  }) {
    filteredUsers.value = users;
    selected.value = initiallySelected;
  }

  void onSearchChanged(String value) {
    search.value = value.toLowerCase();
    filteredUsers.value = users.where((user) {
      final name = '${user.firstName ?? ''} ${user.lastName ?? ''}'.toLowerCase();
      return name.contains(search.value);
    }).toList();
  }

  void onSingleSelect(BuildContext context, UserDetails user) {
    Navigator.pop(context, [user]);
  }

  void toggleMultiSelect(UserDetails user) {
    if (selected.any((u) => u.userId == user.userId)) {
      selected.removeWhere((u) => u.userId == user.userId);
    } else {
      selected.add(user);
    }
  }

  String getDisplayName(UserDetails user) {
    final fullName = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
    return fullName.isNotEmpty ? fullName : user.emailId ?? user.userId ?? 'Unknown';
  }
}