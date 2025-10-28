import 'package:flutter/material.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
class SelectedUsersTable extends StatelessWidget {
  final List<UserDetails> selectedUsers;
  final Function(UserDetails) onDelete;

  const SelectedUsersTable({
    super.key,
    required this.selectedUsers,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedUsers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text("No users selected."),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('Photo')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Email')),
          DataColumn(label: Text('Phone')),
          DataColumn(label: Text('Role')),
          DataColumn(label: Text('Action')),
        ],
        rows: selectedUsers.map((user) {
          return DataRow(
            cells: [
              DataCell(
                user.photo != null && user.photo!.isNotEmpty
                     ? CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(user.photo!),
                      )
                    : const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.account_circle, size: 40),
                      ),
              ),
              DataCell(Text('${user.firstName ?? ''} ${user.lastName ?? ''}')),
              DataCell(Text(user.emailId ?? '-')),
              DataCell(Text(user.phNo ?? '-')),
              DataCell(Text(user.roleName ?? '-')),
              DataCell(
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onDelete(user),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}