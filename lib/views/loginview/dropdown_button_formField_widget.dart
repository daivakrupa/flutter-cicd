import 'package:flutter/material.dart';

class DropdownButtonFormFieldWidget extends StatefulWidget {
  final void Function(String?)? onChanged;
  final List<String?>? branches;

  const DropdownButtonFormFieldWidget({
    super.key,
    this.onChanged,
    required this.branches,
  });

  @override
  State<DropdownButtonFormFieldWidget> createState() =>
      _DropdownButtonFormFieldWidgetState();
}

class _DropdownButtonFormFieldWidgetState
    extends State<DropdownButtonFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30),
      child: GestureDetector(
        onTap: () {
          print("Available branches: ${widget.branches}");
        },
        child: DropdownButtonFormField<String>(
          dropdownColor: Colors.black.withOpacity(0.8),
          items: widget.branches?.map((String? value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value ?? "",
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            labelText: 'Select Branch',
            labelStyle: const TextStyle(color: Colors.white),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            filled: true,
            fillColor: Colors.white.withOpacity(0.1),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 10,
            ),
          ),
        ),
      ),
    );
  }
}
