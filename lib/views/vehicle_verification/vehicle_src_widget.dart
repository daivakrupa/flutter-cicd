import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class VehicleSrcWidget extends StatelessWidget {
  const VehicleSrcWidget({
    super.key,
    required this.srcCodeController,
    required this.onSubmit,
  });

  final TextEditingController srcCodeController;
  final Function(String) onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 3,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min, 
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Image.asset(
              'assets/images/Truck_image.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Vehicle & Material Verification',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
              color: Color.fromRGBO(72, 76, 175, 1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Enter your access reference code to view vehicle and material details',
            style: TextStyle(
              fontSize: 14,
              color: Color.fromRGBO(102, 102, 102, 1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Access Reference Code',
            style: TextStyle(
              fontSize: 16,
              color: Color.fromRGBO(72, 76, 175, 1),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: srcCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                    color: Color.fromRGBO(83, 213, 227, 1), width: 2.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                    color: Color.fromRGBO(83, 213, 227, 1), width: 2.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(
                    color: Color.fromRGBO(83, 213, 227, 1), width: 2.0),
              ),
              hintText: 'Enter access code (e.g. ACC-2024-001)',
              hintStyle: const TextStyle(
                color: Color.fromRGBO(0, 0, 0, 0.46),
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromRGBO(83, 213, 227, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () {
                onSubmit(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                );
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromRGBO(72, 76, 175, 1),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
