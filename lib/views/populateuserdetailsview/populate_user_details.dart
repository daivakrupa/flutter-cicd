import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:visiq/controllers/populate_user_details_controller.dart';
import 'package:visiq/views/entry_form_view/entry_form_view.dart';
import 'package:visiq/views/populateuserdetailsview/signature_widet.dart';

class PopulateUserDetails extends StatelessWidget {
  PopulateUserDetails({super.key});

  final PopulateUserDetailsController controller = Get.put(
    PopulateUserDetailsController(),
  );

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            'User Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BG Image.png'),
                fit: BoxFit.fill,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'Review the details below',
                    style: TextStyle(fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 25),
                  Obx(() {
                    return CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.blue,
                      backgroundImage: NetworkImage(
                        controller.checkFaceModel.value?.data?.userDetails?.photo ?? "",
                      ),
                    );
                  }),
                  const SizedBox(height: 15),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: controller.dynamicFormData.length,
                    itemBuilder: (context, index) {
                      if (controller.dynamicFormData[index].placeholderText == 'Access Reference Code :') {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    topRight: Radius.circular(8),
                                  ),
                                  border: const Border(
                                    bottom: BorderSide(color: Colors.white),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 6.0,
                                    horizontal: 8.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Access Reference Code:',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 28,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: controller.srqController,
                                                maxLength: 6,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                  LengthLimitingTextInputFormatter(6),
                                                ],
                                                decoration: const InputDecoration(
                                                  hintStyle: TextStyle(
                                                    color: Color.fromRGBO(83, 213, 227, 1),
                                                  ),
                                                  border: InputBorder.none,
                                                  counterText: "",
                                                ),
                                                style: const TextStyle(
                                                  color: Color.fromRGBO(83, 213, 227, 1),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                onChanged: (value) {
                                                  controller.dynamicFormData[index].valuetext = value;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              border: const Border(
                                bottom: BorderSide(color: Colors.white),
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(8),
                                topRight: Radius.circular(8),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.dynamicFormData[index].placeholderText,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    controller.dynamicFormData[index].valuetext,
                                    style: const TextStyle(
                                      color: Color.fromRGBO(83, 213, 227, 1),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SignatureWidget(
                      signatureGlobalKey: signatureGlobalKey,
                      labelText: "Signature",
                      buttonLabel: "Clear",
                      height: 100,
                      backgroundColor: Colors.white,
                      strokeColor: Colors.black,
                    ),
                  ),
                  Obx(() {
                    bool isEntry = controller.checkFaceModel.value?.data?.userDetails?.isEntry ?? false;
                    bool allowNDA = controller.checkFaceModel.value?.data?.userDetails?.allowNDA ?? controller.alwaysAllowNDA.value;
                    return Row(
                      children: [
                        if (!isEntry)
                          Checkbox(
                            checkColor: Colors.green,
                            value: allowNDA,
                            onChanged: (value) {
                              controller.alwaysAllowNDA.value = value ?? false;
                              if (controller.checkFaceModel.value?.data?.userDetails != null) {
                                controller.checkFaceModel.value!.data!.userDetails!.allowNDA = controller.alwaysAllowNDA.value;
                              }
                            },
                          ),
                        if (!isEntry)
                          const Expanded(
                            child: Text(
                              'Allow NDA for every visit',
                              style: TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ),
                      ],
                    );
                  }),
                  Obx(() {
                    bool isEntry = controller.checkFaceModel.value?.data?.userDetails?.isEntry ?? false;
                    String lastEntry = controller.checkFaceModel.value?.data?.userDetails?.lastEntry ?? "";
                    String lastExit = controller.checkFaceModel.value?.data?.userDetails?.lastExit ?? "";
                    return isEntry
                        ? Text(
                            'Your last entry time  $lastEntry',
                            style: const TextStyle(color: Colors.white),
                          )
                        : Text(
                            'Your last exit time $lastExit',
                            style: const TextStyle(color: Colors.white),
                          );
                  }),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: Obx(() {
                      bool isEntry = controller.checkFaceModel.value?.data?.userDetails?.isEntry ?? false;
                      return ElevatedButton(
                        onPressed: () {
                          controller.checkInCheckOutAPI();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isEntry ? Colors.red : Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: Center(
                            child: Text(
                              isEntry ? 'Check Out' : 'Check In',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}