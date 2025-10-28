import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
import 'package:visiq/models/login_models/organisation_model.dart';
import 'package:visiq/models/nda_response_model/nda_response_model.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:visiq/utils/globals.dart';

class TermsAndConditionsController extends GetxController {
  File? capturedPicture;
  Branches? selectedBranchId;
  int statusCode = 0;
  CheckFaceModel? fileModel;
  bool allowNDA = false;
  late Future<File?> pdfFile;
  var alwaysallowNDA = false.obs;
  String? policies;
  int? totalPages;
  int currentPage = 0;
  var isLastPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    capturedPicture = arguments['capturedPicture'] as File?;
    selectedBranchId = arguments['selectedBranchId'] as Branches?;
    statusCode = arguments['statusCode'] as int;
    fileModel = arguments['fileModel'] as CheckFaceModel?;
    allowNDA = fileModel?.data?.userDetails?.allowNDA ?? false;

    alwaysallowNDA.value = allowNDA;
    pdfFile = _fetchNDADocument();
  }

  Future<File?> _fetchNDADocument() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? orgID = prefs.getString('orgId');
    final String? branchId = prefs.getString('selectedBranchId');

    if (orgID == null) {
      print('Organization ID is null.');
      return null;
    }
    final requestBody = {'org_id': orgID, 'branch_id': branchId};

    print('nda request body: $requestBody');
    final api = NetworkManager<NDAResponse>(baseUrl);
    final response = await api.post(
      '/api/org/getNDADoc',
      requestBody,
      (json) => NDAResponse.fromJson(json),
      null,
      (statusCode) {
        print('Status code: $statusCode');
      },
    );

    if (response != null && response.ndaDoc.isNotEmpty) {
      print('NDA Document URL: ${response.ndaDoc}');

      policies = response.policies;

      return await downloadPdf(response.ndaDoc);
    } else {
      print('No NDA document available.');
    }
    return null;
  }

  void onPageChanged(int? page, int? total) {
    currentPage = page ?? 0;
    print('Current page: $currentPage');
    isLastPage.value = totalPages != null && currentPage == (totalPages! - 1);
  }

  Future<File?> downloadPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/temp_nda.pdf';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return file;
      } else {
        print('Failed to download PDF.');
      }
    } catch (e) {
      print('Error downloading PDF: $e');
    }
    return null;
  }

  void onRender(int? pages) {
    totalPages = pages ?? 0;
    isLastPage.value = (totalPages == 1);
  }

  void onAgreeButtonPressed() {
  Get.toNamed(
    '/datacenterpolicies', 
    arguments: {
      'capturedPicture': capturedPicture,
      'selectedBranchId': selectedBranchId,
      'allowNDA': allowNDA,
      'statusCode': statusCode,
      'fileModel': fileModel,
      'policies': policies,
    },
  );
}

}
