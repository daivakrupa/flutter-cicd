import 'package:flutter/material.dart';

class CustomTitleValueWidget extends StatelessWidget {
  const CustomTitleValueWidget({super.key, required this.title, required this.value});
  final String title;
  final String value;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}