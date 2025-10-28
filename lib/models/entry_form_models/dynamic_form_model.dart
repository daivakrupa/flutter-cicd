import 'package:flutter/material.dart';

enum DynamicFormActionType { text, dropdown, number }

class DynamicFormModel {
  String placeholderText;
  IconData? icon;
  DynamicFormActionType actionType;
  InputBorder? enabledBorder;
  InputBorder? focusedBorder;
  int? digitLimit;
  List<String>? dropdownItems;
  String? selectedDropdownValue;
  bool isVisible = false;
  bool? isRequired = true;

  DynamicFormModel({
    required this.placeholderText,
    this.icon,
    required this.actionType,
    required this.enabledBorder,
    required this.focusedBorder,
    this.digitLimit,
    this.dropdownItems,
    this.selectedDropdownValue,
    this.isRequired,
  });
}
