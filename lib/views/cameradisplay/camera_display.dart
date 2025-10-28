import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:visiq/SDK/FaceRecognisationSDK/face_camera.dart';
import 'package:visiq/SDK/FaceRecognisationSDK/res/enums.dart';
import 'package:visiq/SDK/FaceRecognisationSDK/smart_face_camera.dart';
import 'package:visiq/controllers/camera_display_controller.dart';

class CameraDisplay extends StatelessWidget {
  CameraDisplay({super.key});

  bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = sqrt(size.width * size.width + size.height * size.height);
    return diagonal > 1100;
  }

  final CameraDisplayController controller = Get.put(CameraDisplayController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoaderOverlay(
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
              'Capture Your Image',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          body: Obx(() {
            final File? capturedImage = controller.capturedImage.value;
            if (capturedImage != null) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    isTablet(context)
                        ? SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 2,
                            child: Image.file(
                              capturedImage,
                              width: double.maxFinite,
                              fit: BoxFit.contain,
                            ),
                          )
                        : Image.file(
                            capturedImage,
                            width: double.maxFinite,
                            fit: BoxFit.contain,
                          ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0, top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () =>
                                controller.capturedImage.value = null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Capture Again',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(83, 213, 227, 1),
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton(
                            onPressed: () {
                              context.loaderOverlay.show();
                              controller.checkFaceAPI();
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
                            child: const Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Powered By',
                      style: TextStyle(color: Colors.black, fontSize: 12),
                    ),
                    const SizedBox(height: 15),
                    Image.asset(
                      'assets/images/logo.jpg',
                      height: 22,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              );
            }
            return SmartFaceCamera(
              showCameraLensControl: false,
              showFlashControl: false,
              orientation: CameraOrientation.portraitUp,
              indicatorShape: IndicatorShape.none,
              showControls: true,
              autoCapture: false,
              defaultCameraLens: CameraLens.front,
              onCapture: (File? image) {
                controller.capturedImage.value = image;
              },
              onFaceDetected: (Face? face) {},
              messageBuilder: (context, face) => const SizedBox.shrink(),
            );
          }),
        ),
      ),
    );
  }
}
