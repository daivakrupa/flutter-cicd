import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/models/vehicle_detailsbysrc_model/vehicle_details_bysrc.dart';

showMaterialRejectDialog(
  Function(MmDetails, bool, String?) onVerification, {
  required MmDetails material,
}) {
  final reasonController = TextEditingController();

  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Reject Request",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color.fromRGBO(72, 76, 175, 1),
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(
                    Icons.close,
                    color: Colors.black87,
                    weight: 2,
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),

            const Text(
              "Reason / Comment",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(72, 76, 175, 1), // purple text
              ),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Enter reason",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF4AD5E3), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF4AD5E3)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () => Get.back(),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Color(0xFF4AD5E3),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(72, 76, 175, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  onPressed: () {
                    final reason = reasonController.text.trim();
                    if (reason.length < 10) {
                      Get.snackbar(
                        "Invalid Reason",
                        "Reason must be at least 10 characters long",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    } else {
                      Get.back(); // close dialog
                      onVerification(material, false, reason);
                    }
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ),
    barrierDismissible: false,
  );
}
