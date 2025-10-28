import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:visiq/models/entry_form_models/ocr_results_model.dart';
import 'package:visiq/utils/globals.dart';

class ImageUploadScreenWidget extends StatelessWidget {
  final String imagePath;
  final Function(OCRResults) ocrResults;
  final String docType;
  final String userImage;
  const ImageUploadScreenWidget({
    super.key,
    required this.imagePath,
    required this.ocrResults,
    required this.docType,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(title: const Text('Selected Image')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: isTablet(context)
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height / 2,
                        child: Image.file(File(imagePath), fit: BoxFit.cover),
                      )
                    : Image.file(File(imagePath), fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 20.0,
                  bottom: 30,
                  left: 10,
                  right: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.loaderOverlay.show();
                    ocrApi(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(83, 213, 227, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: Center(
                      child: Text(
                        'Done',
                        style: TextStyle(color: Colors.white),
                      ),
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

  bool isTablet(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final size = mediaQuery.size;
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    return diagonal > 1100;
  }

  ocrApi(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/faces/imageVerifyById'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', userImage));
    request.files.add(await http.MultipartFile.fromPath('idImage', imagePath));
    request.fields.addAll({
      'branch_id': branchId ?? "",
      'doc_type': docType == 'Emirate ID'
          ? 'EM'
          : docType == 'Passport'
          ? 'PP'
          : 'DL',
    });
    print('i got BranchID $branchId');
    http.StreamedResponse response = await request.send();
    final result = await response.stream.bytesToString();
    print('i got face result $result');
    Map<String, dynamic> data = jsonDecode(result);
    final fileModel = OCRResults.fromJson(data);
    ocrResults(fileModel);
    print(fileModel.userData?.passport);
    if (response.statusCode == 200) {
      if (context.mounted) {
         Get.back();
        context.loaderOverlay.hide();
      }
    }
    if (response.statusCode == 502) {
      if (context.mounted) {
        context.loaderOverlay.hide();
        _showMyDialog(
          "Oops got 502 Bad gateway.Please try again later",
          false,
          context,
        );
      }
    }
    if (response.statusCode == 500) {
      if (context.mounted) {
        context.loaderOverlay.hide();
        _showMyDialog(
          "Unable to read the document.Please fill up all the details manually or try uploading new document.",
          false,
          context,
        );
      }
    }
    if (response.statusCode == 400) {
      if (context.mounted) {
        context.loaderOverlay.hide();
        _showMyDialog(
          fileModel.message ??
              "Unable to read the document.Please fill up all the details manually or try uploading new document.",
          false,
          context,
        );
      }
    }
  }

  Future<void> _showMyDialog(
    String message,
    bool isRoot,
    BuildContext context,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(message)]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                 Get.back();
               // Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromRGBO(98, 70, 175, 1),
                  width: 2,
                ), 
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ), 
              ),
              child:  Text('Ok'),
            ),
          ],
        );
      },
    );
  }
}
