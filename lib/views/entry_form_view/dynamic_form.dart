import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/models/check_face_models/check_face_model.dart';
import 'package:visiq/models/create_face_model/create_face_model.dart';
import 'package:visiq/models/entry_form_models/dynamic_form_model.dart';
import 'package:visiq/models/entry_form_models/get_visitor_details_bysrc_model.dart';
import 'package:visiq/models/entry_form_models/ocr_results_model.dart';
import 'package:visiq/models/entry_form_models/user_identified_model.dart';
import 'package:visiq/network_manager/network_manager.dart';
import 'package:visiq/utils/chip_input_field.dart';
import 'package:visiq/utils/globals.dart';
import 'package:visiq/views/entry_form_view/entry_form_view.dart';
import 'package:visiq/views/entry_form_view/image_upload_view.dart';
import 'package:visiq/views/populateuserdetailsview/signature_widet.dart';

class DynamicForm extends StatefulWidget {
  final int length;
  final Function(DynamicFormActionType) onAction;
  final List<DynamicFormModel> dynamicModel;
  final Function(List<String>) onDataFilled;
  final File? capturedPicture;
  final bool allowNDA;
  final CheckFaceModel? fileModel;
  const DynamicForm({
    super.key,
    required this.length,
    required this.onAction,
    required this.dynamicModel,
    required this.onDataFilled,
    this.capturedPicture,
    required this.allowNDA,
    this.fileModel,
  });

  @override
  DynamicFormState createState() => DynamicFormState();
}

class DynamicFormState extends State<DynamicForm> {
  late List<TextEditingController> controllers;
  OCRResults? ocrResults;
  final TextEditingController idVerificationController =
      TextEditingController();
  final TextEditingController decatTextController = TextEditingController();
  String selectedDocType = '';
  String? uploadedDoc;
  VisitorData? visitor;
  GetVisitorDetailsBySRC? visitorDetailsBySRC;

  List<String> userEntries = [];
  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      widget.length,
      (index) => TextEditingController(),
    );
  }

  bool validateForm() {
    for (int i = 0; i < controllers.length; i++) {
      if (widget.dynamicModel[i].isRequired == true) {
        if (widget.dynamicModel[i].actionType ==
            DynamicFormActionType.dropdown) {
          if (widget.dynamicModel[i].selectedDropdownValue == null ||
              widget.dynamicModel[i].selectedDropdownValue!.isEmpty) {
            return false;
          }
        } else {
          if (controllers[i].text.isEmpty) {
            return false;
          }
        }
      }
      if (idVerificationController.text.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.length,
            itemBuilder: (context, index) {
              final model = widget.dynamicModel[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: model.actionType == DynamicFormActionType.dropdown
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButtonFormField<String>(
                            hint: Text(
                              widget.dynamicModel[index].placeholderText,
                              style: TextStyle(color: Colors.white),
                            ),
                            value: model.selectedDropdownValue!.isEmpty
                                ? null
                                : model.selectedDropdownValue,
                            onChanged: (value) {
                              setState(() {
                                selectedDocType = value ?? "";
                                model.selectedDropdownValue = value ?? '';
                                model.isVisible = true;
                                showOptionsBottomSheet(context, index);
                                widget.onAction(model.actionType);
                              });
                            },
                            items: model.dropdownItems
                                ?.map(
                                  (item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                            dropdownColor: const Color.fromRGBO(35, 55, 182, 1),
                            iconEnabledColor: Colors.white,
                            decoration: InputDecoration(
                              hintText:
                                  widget.dynamicModel[index].placeholderText,
                              hintStyle: const TextStyle(color: Colors.white),
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.1),
                              suffixIcon: Icon(
                                widget.dynamicModel[index].icon,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          model.isVisible
                              ? const SizedBox(height: 30)
                              : const SizedBox(height: 0),
                          if (model.isVisible)
                            TextFormField(
                              // enabled: false,
                              style: const TextStyle(color: Colors.white),
                              controller: idVerificationController,
                              decoration: InputDecoration(
                                // hintText: '${model.selectedDropdownValue}',
                                hintStyle: const TextStyle(color: Colors.white),
                                label: RichText(
                                  text: TextSpan(
                                    text: '${model.selectedDropdownValue}',
                                    style: const TextStyle(color: Colors.white),
                                    children: const [
                                      TextSpan(
                                        text: ' *',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.1),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 10,
                                ),
                                suffixIcon: Icon(
                                  widget.dynamicModel[index].icon,
                                  color: Colors.white,
                                ),
                              ),
                              readOnly: false,
                            ),
                        ],
                      )
                    : TextFormField(
                        controller: controllers[index],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(color: Colors.white),
                          labelText: model.placeholderText,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 10,
                          ),
                          // Show the forward arrow icon only for controllers[2]
                          suffixIcon: index == 2
                              ? Material(
                                  color: Colors
                                      .transparent, // Keep the material color transparent
                                  child: InkWell(
                                    onTap: () {
                                      getVisitorDetails();
                                      print("Forward arrow tapped!");
                                    },
                                    splashColor: Colors.white.withOpacity(
                                      0.3,
                                    ), // Color when tapped
                                    highlightColor: Colors.white.withOpacity(
                                      0.3,
                                    ), // Highlight color
                                    child: const Icon(
                                      Icons.arrow_forward, // Forward arrow icon
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : null, // No icon for other controllers
                        ),
                        readOnly:
                            index == 3 ||
                                index == 4 ||
                                index == 5 ||
                                index == 6 ||
                                index == 7
                            ? true
                            : widget.dynamicModel[index].actionType ==
                                  DynamicFormActionType.dropdown,
                        keyboardType:
                            widget.dynamicModel[index].actionType ==
                                DynamicFormActionType.text
                            ? TextInputType.text
                            : TextInputType.number,
                        inputFormatters:
                            widget.dynamicModel[index].actionType ==
                                DynamicFormActionType.number
                            ? [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(
                                  widget.dynamicModel[index].digitLimit ?? 10,
                                ),
                              ]
                            : null,
                      ),
              );
            },
          ),
          ChipInputField(
            label: 'Enter Decat Number',
            icon: Icons.verified_user,
            controller: decatTextController,
            getChipEntries: getChipEntries,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SignatureWidget(
              signatureGlobalKey: signatureGlobalKey,
              labelText: "Signature",
              buttonLabel: "Clear",
              height: 100, // Custom height if needed
              backgroundColor: Colors.white, // Custom background color
              strokeColor: Colors.black, // Custom stroke color
            ),
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
                if (validateForm()) {
                  handleSaveButtonPressed(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all the fields.'),
                    ),
                  );
                }
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
                  child: Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  getChipEntries(List<String> entries) {
    setState(() {
      userEntries = entries;
    });
  }

  void handleSaveButtonPressed(BuildContext context) async {
    print(userEntries.length);
    print(userEntries.length > visitor!.decatAreaCount!);
    print(userEntries.length == visitor!.decatAreaCount!);
    //  if (userEntries.length != visitor!.decatAreaCount) {
    //   Fluttertoast.showToast(msg: "Please enter the DECAT numbers relevant to your area for the scheduled visit.",
    //   toastLength: Toast.LENGTH_SHORT,
    //   gravity: ToastGravity.BOTTOM,
    //   backgroundColor: Colors.red,
    //   textColor: Colors.white,
    //   fontSize: 16); return;
    //  }

    if ((visitor?.decatAreaCount ?? 0) > 0 && userEntries.isEmpty) {
      Fluttertoast.showToast(
        msg:
            "Please enter the DECAT numbers relevant to your area for the scheduled visit.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16,
      );
      return;
    }

    context.loaderOverlay.show();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    final String? orgID = prefs.getString('orgId');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    final image = await signatureGlobalKey.currentState!.toImage(
      pixelRatio: 3.0,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    if (isSignatureDone == false) {
      stopOverlay();
      _showMyDialog("Please provide your signature to proceed.", false);
      signatureGlobalKey.currentState?.clear();
      return;
    }
    File file = File('$appDocPath/sample_image.png');
    await file.writeAsBytes(pngBytes);
    print('Signature saved to: ${file.path}');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/api/faces/create-face'),
    );
    request.fields.addAll({
      'first_name':
          // ocrResults?.userData != null
          //     ? ocrResults?.userData?.firstName != ""
          //         ? '${ocrResults?.userData?.firstName} ${ocrResults?.userData?.lastName}'
          //         : controllers[3].text
          //     :
          controllers[3].text,
      'last_name': '',
      'email': controllers[2].text,
      'ph_no': visitorDetailsBySRC?.visitorData?.first.phNo ?? "",
      'ph_ext': visitorDetailsBySRC?.visitorData?.first.phExt ?? "",
      'purpose_of_visit':
          visitorDetailsBySRC?.visitorData?.first.purposeOfVisit ?? "",
      'emirate_id': '',
      'photo': '',
      'org_id': orgID ?? "",
      'branch_id': branchId ?? "",
      'visitor_code': controllers[1].text,
      'kyc_id': ocrResults?.userData != null
          ? ocrResults?.userData?.passport != ""
                ? '${ocrResults?.userData?.passport}'
                : idVerificationController.text
          : idVerificationController.text,
      'kyc_type': selectedDocType,
      'asset': controllers[8].text,
      'area_of_permit':
          visitorDetailsBySRC?.visitorData?.first.areaPermitted ?? "",
      'allowNDA': widget.allowNDA.toString(),
      'role': visitor?.role ?? "",
      'area_decat_numbers': userEntries.join(','),
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        widget.capturedPicture?.path ?? "",
      ),
    );
    request.files.add(
      await http.MultipartFile.fromPath('signature', file.path),
    );
    uploadedDoc != null
        ? request.files.add(
            await http.MultipartFile.fromPath('idImage', uploadedDoc ?? ""),
          )
        : request.fields.addAll({'idImage': ""});
    print("I got request body: ${request.fields}");
    http.StreamedResponse response = await request.send();
    // stopOverlay();
    if (response.statusCode == 200) {
      final result = await response.stream.bytesToString();
      print("result $result");
      Map<String, dynamic> data = jsonDecode(result);
      UserIdentifiedModel userModel = UserIdentifiedModel.fromJson(data);
      print('usermode: $userModel');
      final checkInRequestBody = {
        "org_id": userModel.orgId,
        "branch_id": userModel.branchId,
        "isCheckedIn": true,
        "visitor_code": userModel.visitorCode,
        "user_id": userModel.userId,
        "email": userModel.email,
        "allowNDA": widget.allowNDA.toString(),
        "signature": file.path,
        "role":
            visitor?.role ??
            "", //widget.fileModel?.data?.userDetails?.role ?? '',
      };
      print('check in request body: $checkInRequestBody');
      final api = NetworkManager<CreateFaceModel>(baseUrl);
      await api.post(
        '/api/faces/checkInsOuts',
        checkInRequestBody,
        (data) {
          final resultModel = CreateFaceModel.fromJson(data);
          stopOverlay();
          isSignatureDone = false;
          _showMyDialog(resultModel.message ?? "", true);
          return resultModel;
        },
        null,
        (statusCode) {},
      );
    } else {
      stopOverlay();
      final result = await response.stream.bytesToString();
      print("result $result");
      Map<String, dynamic> data = jsonDecode(result);
      CreateFaceModel fileModel = CreateFaceModel.fromJson(data);
      print('file model $fileModel');
      _showMyDialog(fileModel.message ?? "", false);
    }
  }

  popToRoot() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  stopOverlay() {
    context.loaderOverlay.hide();
  }

  void showOptionsBottomSheet(BuildContext context, int index) async {
    final BuildContext parentContext = context;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Open Camera'),
                onTap: () async {
                   Get.back();
                  showDialog(
                    context: parentContext,
                    builder: (dialogContext) => AlertDialog(
                      title: const Text("Message"),
                      content: const Text(
                        "Your ID proof is required for security verification only. We do not store or retain your personal data. This information is used solely to ensure your safety and compliance with our security protocols.",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(dialogContext);
                            final ImagePicker picker = ImagePicker();
                            final XFile? image = await picker.pickImage(
                              source: ImageSource.camera,
                            );

                            if (image != null && parentContext.mounted) {
                              Navigator.of(parentContext).push(
                                MaterialPageRoute(
                                  builder: (_) => ImageUploadScreenWidget(
                                    imagePath: image.path,
                                    ocrResults: (results) {
                                      if (parentContext.mounted) {
                                        (parentContext as Element)
                                            .markNeedsBuild();
                                        uploadedDoc = image.path;
                                        idVerificationController.text =
                                            results.userData?.passport ?? "";
                                        ocrResults = results;
                                      }
                                    },
                                    docType: selectedDocType,
                                    userImage:
                                        widget.capturedPicture?.path ?? "",
                                  ),
                                ),
                              );
                            }
                          },
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showMyDialog(String message, bool isRoot) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Message'),
          content: SingleChildScrollView(
            child: ListBody(children: <Widget>[Text(message)]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                isRoot ? popToRoot() : Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromRGBO(98, 70, 175, 1),
                  width: 2,
                ), // Border color and width
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0), // Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ), 
              ),
              child: const Text('Ok'),
            ),
          ],
        );
      },
    );
  }

  getVisitorDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    print("Selected Branch ID: $branchId");
    final requestBody = {
      'branch_id': branchId,
      'email': controllers[2].text,
      'visitor_code': controllers[1].text,
    };
    final api = NetworkManager<GetVisitorDetailsBySRC>(baseUrl);
    await api.post(
      '/api/org/VisitorData',
      requestBody,
      (data) {
        final resultModel = GetVisitorDetailsBySRC.fromJson(data);
        print("Response Data: ${resultModel.toJson()}");
        if (resultModel.visitorData != null &&
            resultModel.visitorData!.isNotEmpty) {
          visitor = resultModel.visitorData!.first;
          if (visitor?.role != null) {
            prefs.setString('visitorRole', visitor?.role ?? "");
            print("visitor Role Stored: ${visitor?.role ?? ""}");
          }
          setState(() {
            visitorDetailsBySRC = resultModel;
            controllers[3].text = visitor?.firstName ?? '';
            // controllers[4].text = visitor?.phExt ?? '';
            controllers[4].text =
                '${visitor?.phExt ?? ''} ${visitor?.phNo ?? ''}';
            controllers[5].text = visitor?.purposeOfVisit ?? '';
            controllers[6].text = visitor?.areaPermitted ?? '';
            controllers[7].text = visitor?.role ?? '';
          });
        } else {
          Fluttertoast.showToast(
            msg: "Please provide valid Email ID and Access Reference Code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
        stopOverlay();
        return resultModel;
      },
      null,
      (statusCode) {
        print('Status Code: $statusCode');
      },
    );
  }
}
