import 'package:flutter/material.dart';

class StatusCardsWidget extends StatelessWidget {
  final String title;
  final int count;

  const StatusCardsWidget({
    super.key,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 8, left: 12),
      child: Card(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: Color.fromRGBO(
                          83, 213, 227, 1,), // Set your desired border color here
            width: 1.5, // Set the border width if necessary
          ),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          width: 120.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8.0),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(26, 32, 44, 1),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                '$count',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(
                          83, 213, 227, 1,)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
