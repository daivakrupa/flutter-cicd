import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:visiq/controllers/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.find<SplashController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => (controller.timer.value != 0)
            ? Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/BG Image.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Center(
                    child: Lottie.asset(
                      'assets/images/face.json',
                      width: 300,
                      height: 300,
                    ),
                  ),
                ],
              )
            : SizedBox(),
      ),
    );
  }
}
