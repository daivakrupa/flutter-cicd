import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:visiq/controllers/entry_form_controller.dart';
import 'package:visiq/models/entry_form_models/dynamic_form_model.dart';
import 'package:visiq/views/entry_form_view/dynamic_form.dart';

final GlobalKey<SfSignaturePadState> signatureGlobalKey = GlobalKey();

class EntryFormWidget extends StatelessWidget {
  EntryFormWidget({
    super.key,
  });

  final EntryFormController controller = Get.put(EntryFormController());

  @override
  Widget build(BuildContext context) {
    const borderLine = OutlineInputBorder(
      borderSide: BorderSide(width: 1, color: Colors.grey),
    );
    final dynamicFormData = [
      DynamicFormModel(
        placeholderText: 'Document Type',
        actionType: DynamicFormActionType.dropdown,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
        dropdownItems: ['Emirate ID', 'Passport', 'Driving Licence'],
        selectedDropdownValue: '',
      ),
      DynamicFormModel(
        placeholderText: 'Access Reference Code *',
        actionType: DynamicFormActionType.number,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
        digitLimit: 7,
      ),
      DynamicFormModel(
        placeholderText: 'Email ID *',
        actionType: DynamicFormActionType.text,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
      ),
      DynamicFormModel(
        placeholderText: 'Name *',
        actionType: DynamicFormActionType.text,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
      ),
      // DynamicFormModel(
      //     placeholderText: 'Country Code *',
      //     actionType: DynamicFormActionType.number,
      //     enabledBorder: borderLine,
      //     focusedBorder: borderLine,
      //     digitLimit: 10),
      DynamicFormModel(
        placeholderText: 'Phone number *',
        actionType: DynamicFormActionType.number,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
        digitLimit: 10,
      ),
      DynamicFormModel(
        placeholderText: 'Purpose Of Visit',
        actionType: DynamicFormActionType.text,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
        isRequired: false,
      ),
      DynamicFormModel(
        placeholderText: 'Area permitted',
        actionType: DynamicFormActionType.text,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
        isRequired: false,
      ),
      DynamicFormModel(
        placeholderText: 'Category',
        actionType: DynamicFormActionType.text,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
        isRequired: false,
      ),
      DynamicFormModel(
        placeholderText: 'Mention if you are carrying any devices?',
        actionType: DynamicFormActionType.text,
        enabledBorder: borderLine,
        focusedBorder: borderLine,
        isRequired: false,
      ),
    ];

    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Get.until((route) => route.isFirst);
            },
          ),
          title: const Text(
            'User Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BG Image.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/entryimg.png',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'New Entry',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color.fromRGBO(83, 213, 227, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please Enter Access Reference Code',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 25),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(
                      File(controller.capturedPicture!.path),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DynamicForm(
                    capturedPicture: controller.capturedPicture,
                    dynamicModel: dynamicFormData,
                    length: dynamicFormData.length,
                    onAction: (DynamicFormActionType result) {
                      result == DynamicFormActionType.dropdown ? null : null;
                    },
                    allowNDA: controller.allowNDA.value,
                    fileModel: controller.fileModel,
                    onDataFilled: handleFormFilledData,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void handleFormFilledData(List<String> filledData) {
    print(filledData);
  }
}
