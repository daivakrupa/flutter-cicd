import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visiq/controllers/get_started_controller.dart';
import 'package:visiq/views/cameradisplay/camera_display.dart';

class GetStartedWidget extends StatelessWidget {
  GetStartedWidget({super.key});
  final GetStartedController controller = Get.put(GetStartedController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/BG Image.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              left: 20,
              right: 20,
              bottom: 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, right: 50, left: 20),
                  child: Lottie.asset('assets/images/face.json'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: 'Face ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextSpan(
                            text: 'Unlock',
                            style: TextStyle(
                              color: Color.fromRGBO(83, 213, 227, 1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'VisiQ utilizes facial detection technology to identify individuals and display associated stored information.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                  child: Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setUpAppPreference();
                          Get.to(
                            () => CameraDisplay(),
                            arguments: controller.selectedBranchId,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            83,
                            213,
                            227,
                            1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const SizedBox(
                          width: 240,
                          height: 35,
                          child: Center(
                            child: Text(
                              'GET STARTED',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      //SizedBox(height: 10,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final isAuthenticated = await controller
                                  .authenticateUser();
                              if (isAuthenticated) {
                                print(
                                  "Branch ID: ${controller.selectedBranchId?.branchId}",
                                );
                                print(
                                  "Branch Name: ${controller.selectedBranchId?.branchName}",
                                );
                                Get.toNamed(
                                  '/bookVisitForm',
                                  arguments: {
                                    'branchId':
                                        controller.selectedBranchId,
                                    'branchName':
                                        controller.selectedBranchId?.branchName,
                                    'fetchVisitorsData': null,
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: const Color.fromRGBO(83, 213, 227, 1),
                                  width: 2,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'BOOK A VISIT',
                                style: TextStyle(
                                  color: Color.fromRGBO(83, 213, 227, 1),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () async {
                              final isAuthenticated = await controller
                                  .authenticateUser();
                              if (isAuthenticated) {
                                print(
                                  controller.selectedBranchId?.branchId ?? "",
                                );
                                print(controller.selectedBranchId?.branchName);
                                Get.toNamed('/viewvisitors');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color: const Color.fromRGBO(
                                    83,
                                    213,
                                    227,
                                    1,
                                  ), // Set the border color here
                                  width: 2, // Set the border width here
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'VIEW VISITORS',
                                style: TextStyle(
                                  color: Color.fromRGBO(83, 213, 227, 1),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final isAuthenticated = await controller
                              .authenticateUser();
                          if (isAuthenticated) {
                            Get.toNamed('/privelegeEntryform');
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(
                            83,
                            213,
                            227,
                            1,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const SizedBox(
                          width: 240,
                          height: 35,
                          child: Center(
                            child: Text(
                              'PRIVILEGE ENTRY',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: const Color.fromRGBO(
                            83,
                            213,
                            227,
                            1,
                          ),
                        ),
                        onPressed: () async {
                            final isAuthenticated = await controller
                                  .authenticateUser();
                              if (isAuthenticated) {
                                print(
                                  controller.selectedBranchId?.branchId ?? "",
                                );
                                print(controller.selectedBranchId?.branchName);
                                Get.toNamed('/vehicleverificationscreen');
                              }
                        },
                        child: const Text(
                          'Verify Vehicle entry',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            height: 2,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            decorationColor: Color.fromRGBO(83, 213, 227, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  setUpAppPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? branchId = prefs.getString('selectedBranchId');
    print(branchId);
  }
}
