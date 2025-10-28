import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visiq/controllers/vehicle_verification_controller.dart';
import 'package:visiq/views/vehicle_verification/vehicle_details_card.dart';
import 'package:visiq/views/vehicle_verification/vehicle_src_widget.dart';

class VehicleVerificationScreen extends StatelessWidget {
  VehicleVerificationScreen({super.key});

  final VehicleVerificationController controller = Get.put(VehicleVerificationController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white.withAlpha(245),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text(
            'Vehicle Verification',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: VehicleSrcWidget(
                  srcCodeController: controller.srcCodeController,
                  onSubmit: (date) {
                    controller.getVisitorDetailsBySRC();
                    FocusScope.of(context).unfocus();
                    controller.scrollToMaterialTable();
                  },
                ),
              ),
              const SizedBox(height: 16),
              Obx(() => controller.vehicleDetails.isNotEmpty
                  ? VehicleDetailsCard(
                      vehicleDetails: controller.vehicleDetails,
                      onVehicleVerification:
                          controller.vehicleTwoStepVerification,
                      onMaterialVerification: controller.materialTwoStepVerification, materialDetails: controller.materialDetails, 
                    )
                  : const Text("No vehicle details found")),
              const SizedBox(height: 16),
              SizedBox(key: controller.scrollKey, height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
