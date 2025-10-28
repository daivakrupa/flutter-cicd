import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';

class DataCenterAccessPoliciesController extends GetxController {
  File? capturedPicture;
  dynamic selectedBranchId; 
  bool allowNDA = false;
  int statusCode = 0;
  dynamic fileModel;
  String policies = '';

  String? pdfPath;
  var isLoading = true.obs;
  int? totalPages; 
  int currentPage = 0; 
  var isLastPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      capturedPicture = arguments['capturedPicture'];
      selectedBranchId = arguments['selectedBranchId'];
      allowNDA = arguments['allowNDA'] ?? false;
      statusCode = arguments['statusCode'] ?? 0;
      fileModel = arguments['fileModel'];
      policies = arguments['policies'] ?? '';
    }
    preparePdf();
  }

  Future<void> preparePdf() async {
    try {
      if (policies.isEmpty) {
        print('Policies data is empty');
        pdfPath = null;
      } else if (policies.startsWith('http') && policies.endsWith('.pdf')) {
        print('Downloading PDF from URL: $policies');
        pdfPath = await downloadPdf(policies);
      } else {
        try {
          print('Saving PDF from Base64 data.');
          pdfPath = await saveBase64Pdf(policies);
        } catch (e) {
          print('Invalid Base64 data: $e');
          pdfPath = null;
        }
      }
    } catch (e) {
      print('Error preparing PDF: $e');
      pdfPath = null;
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> downloadPdf(String url) async {
    final httpClient = HttpClient();
    final request = await httpClient.getUrl(Uri.parse(url));
    final response = await request.close();

    if (response.statusCode == 200) {
      final bytes = await consolidateHttpClientResponseBytes(response);
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/policies.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);
      return filePath;
    } else {
      throw Exception(
        'Failed to download PDF. Status code: ${response.statusCode}',
      );
    }
  }

  Future<String> saveBase64Pdf(String base64Content) async {
    final bytes = base64Decode(base64Content);
    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/policies.pdf';
    final file = File(filePath);
    await file.writeAsBytes(bytes);
    return filePath;
  }

  void onRender(int? pages) {
    totalPages = pages ?? 0;
    isLastPage.value = (totalPages == 1);
  }

  void onPageChanged(int? page, int? total) {
    currentPage = page ?? 0;
    isLastPage.value = total != null && currentPage == (total - 1);
  }

 navigateToPopulateUserInfo() {
    Get.overlayContext?.loaderOverlay.hide();
    final arguments = {
      'length': 6,
      'dynamicModel': fileModel,
    };
    Get.toNamed('/populateuserdetails', arguments: arguments);
  }

  void onAgreeButtonPressed() {
    if (statusCode == 200) {
      navigateToPopulateUserInfo();
    } else {
      final arguments = {
       'capturedPicture': capturedPicture,
       'selectedBranchId': selectedBranchId,
       'allowNDA': allowNDA,
       'fileModel': fileModel,
    };
    Get.toNamed('/entryform', arguments: arguments);
    }
  }
}
