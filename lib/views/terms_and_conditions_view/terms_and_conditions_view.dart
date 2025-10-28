import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:get/get.dart';
import 'package:visiq/controllers/terms_and_conditions_controller.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  TermsAndConditionsScreen({super.key});

  final TermsAndConditionsController controller = Get.put(
    TermsAndConditionsController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
        backgroundColor: const Color.fromRGBO(91, 143, 246, 1),
      ),
      body: FutureBuilder<File?>(
        future: controller.pdfFile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error loading PDF: ${snapshot.error}'),
              );
            }
            if (snapshot.data != null) {
              return
              //  SfPdfViewer.file(
              //   snapshot.data!,
              //   controller: PdfViewerController(),
              // );
              PDFView(
                filePath: snapshot.data!.path,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: false,
                pageSnap: true,
                fitPolicy: FitPolicy.WIDTH,
                onError: (error) {
                  print('Error in PDFView: $error');
                },
                onPageChanged: controller.onPageChanged,
                onRender: controller.onRender,
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/nda.png',
                        width: 250,
                        height: 250,
                      ),
                      const SizedBox(height: 8.0),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Please contact the administrator to provide the NDA for further processing.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: Obx(
  () => Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!(controller.fileModel?.data?.userDetails?.allowNDA ?? false))
          Row(
            children: [
              Checkbox(
                value: controller.alwaysallowNDA.value,
                onChanged: (value) {
                  controller.alwaysallowNDA.value = value ?? false;
                },
              ),
              const Expanded(
                child: Text(
                  'Allow NDA for every visit.',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: controller.isLastPage.value
              ? controller.onAgreeButtonPressed
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.isLastPage.value
                ? const Color.fromRGBO(83, 213, 227, 1)
                : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const SizedBox(
            height: 40,
            child: Center(
              child: Text(
                'Agree Terms and Conditions',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
),
    );
  }
}
