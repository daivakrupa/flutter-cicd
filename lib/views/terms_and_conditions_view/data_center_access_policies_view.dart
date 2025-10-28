import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:visiq/controllers/data_center_access_policies_controller.dart';

class DataCenterAccessPolicies extends StatelessWidget {
  DataCenterAccessPolicies({
    super.key,
  });

  final DataCenterAccessPoliciesController controller = Get.put(DataCenterAccessPoliciesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GDH Data Center Guidelines')),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.pdfPath == null || controller.pdfPath!.isEmpty
            ? Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/policies.png'),
                      const SizedBox(height: 20),
                      const Text(
                        'No Guidelines Available',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Please contact the admin for assistance with check-in.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              )
            : PDFView(
                filePath: controller.pdfPath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageSnap: true,
                fitPolicy: FitPolicy.WIDTH,
                onRender: controller.onRender, // Get total pages when loaded
                onPageChanged: controller.onPageChanged, // Track page changes
                onError: (error) {
                  print("Error loading PDF: $error");
                },
                onPageError: (page, error) {
                  print("Error loading page $page: $error");
                },
              ),
      ),
      bottomNavigationBar: Obx(
        () => Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: controller.isLastPage.value
                  ? const Color.fromRGBO(83, 213, 227, 1)
                  : Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: (controller.pdfPath == null || controller.pdfPath!.isEmpty)
                ? null
                : controller.isLastPage.value
                ? controller.onAgreeButtonPressed
                : null,
            child: const SizedBox(
              height: 40,
              child: Center(
                child: Text('Agree', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
