import 'package:flutter/material.dart';
import 'package:visiq/models/vehicle_detailsbysrc_model/vehicle_details_bysrc.dart';
import 'package:visiq/views/vehicle_verification/custom_table.dart';
import 'package:visiq/views/vehicle_verification/customtitle_widget.dart';
import 'package:visiq/views/vehicle_verification/material_reject_dialog.dart';
import 'package:visiq/views/vehicle_verification/rejection_dialog.dart';

class VehicleDetailsCard extends StatelessWidget {
  const VehicleDetailsCard({
    super.key,
    required this.vehicleDetails,
    required this.onVehicleVerification,
    required this.onMaterialVerification, required this.materialDetails,
  });
  final List<VmDetails> vehicleDetails;
  final List<MmDetails> materialDetails;
  final Function(VmDetails, bool, String?) onVehicleVerification;
  final Function(MmDetails, bool, String?) onMaterialVerification;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: const Text(
            "Vehicle Details",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(83, 213, 227, 1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${vehicleDetails.length} ${vehicleDetails.length == 1 ? 'Vehicle' : 'Vehicles'}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color.fromRGBO(72, 76, 175, 1),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.4 +
              80 +
              vehicleDetails.fold<int>(
                  0,
                  (sum, vehicle) =>
                      sum + (vehicle.mmDetails?.length ?? 0) * 50),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vehicleDetails.length,
            itemBuilder: (context, vehicleIndex) {
              final vehicle = vehicleDetails[vehicleIndex];
              final cardHeight = MediaQuery.of(context).size.height * 0.4 +
                  80 +
                  (vehicle.mmDetails?.length ?? 0) * 50;
              final fields = [
                {
                  "title": "Vehicle Name",
                  "value": vehicle.vehicleName ?? "N/A"
                },
                {
                  "title": "Vehicle Type",
                  "value": vehicle.vehicleType ?? "N/A"
                },
                {
                  "title": "Driver License No",
                  "value": vehicle.driverLicence ?? "N/A"
                },
                {
                  "title": "Insurance Provider",
                  "value": vehicle.insuranceProvider ?? "N/A"
                },
                {
                  "title": "Insurance Number",
                  "value": vehicle.insuranceNo ?? "N/A"
                },
                {"title": "RC Number", "value": vehicle.rcNo ?? "N/A"},
              ];
              return Container(
                height: cardHeight,
                width: MediaQuery.of(context).size.width * 0.85,
                margin: EdgeInsets.only(
                    left: vehicleDetails.length == 1 ? 24 : 8,
                    right: 8,
                    bottom: 12),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: fields.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 8,
                              childAspectRatio: 2.5,
                            ),
                            itemBuilder: (context, fieldIndex) {
                              final field = fields[fieldIndex];
                              return CustomTitleValueWidget(
                                title: field["title"] as String,
                                value: field["value"] as String,
                              );
                            },
                          ),
                          (vehicle.isApproved == true)
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: Colors.green),
                                    ),
                                    child: const Text(
                                      "Vehicle Approved",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 100,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  83, 213, 227, 1)),
                                        ),
                                        onPressed: () {
                                          showvehicleRejectDialog(
                                            onVehicleVerification,
                                            vehicle: vehicle,
                                          );
                                        },
                                        child: const Text(
                                          "Reject",
                                          style: TextStyle(
                                            color:
                                                Color.fromRGBO(83, 213, 227, 1),
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 120,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromRGBO(72, 76, 175, 1),
                                        ),
                                        onPressed: () {
                                          onVehicleVerification(
                                              vehicle, true, "");
                                        },
                                        child: const Text(
                                          "Approve",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                        ],
                      ), ),
                      vehicle.mmDetails?.isNotEmpty ?? false
                      ? Expanded(
                         child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: MediaQuery.of(context).size.width * 0.85),
                              child: SizedBox(
                                height: 250,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: CustomTable(
                                    columnNames: ['Material Id',
                                    'Material Name',
                                    'Description',
                                    'Device Model',
                                    'Units',
                                    'Quantity',
                                    'RackNumber',
                                    'Serial Number',
                                    'Vehicle ID',
                                    'Comments',
                                    'Actions'
                                    ],
                                    data: vehicle.mmDetails!.map((material) {
                                      return DataRow(
                                        cells: [
                                          _buildCell(material.materialId ?? 'N/A', 100),
                                          _buildCell(material.materialName ?? 'N/A', 120),
                                          _buildCell(material.materialDescription ?? 'N/A', 150),
                                          _buildCell(material.materialDeviceModel ?? 'N/A', 120),
                                          _buildCell(material.materialNoOfUnits ?? 'N/A', 80),
                                          _buildCell(material.materialQuantity ?? 'N/A', 80),
                                          _buildCell(material.materialRackNo ?? 'N/A', 80),
                                          _buildCell(material.materialSN ?? 'N/A', 100),
                                          _buildCell(material.materialVehicleId ?? 'N/A', 100),
                                          _buildCell(material.materialComments ?? 'N/A', 150),
                                          DataCell(
                                            (material.isApproved == false)
                                            ? Row(children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                              color: Color.fromRGBO(
                                                  83, 213, 227, 1)),
                                      ),
                                      onPressed: () {
                                        showMaterialRejectDialog(
                                          onMaterialVerification,
                                          material: material,
                                        );
                                      },
                                      child: const Text(
                                        'Reject',
                                        style: TextStyle(
                                            color:
                                                Color.fromRGBO(83, 213, 227, 1),
                                            fontWeight: FontWeight.w700,
                                          ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color.fromRGBO(72, 76, 175, 1),),
                                      onPressed: () {
                                        onMaterialVerification(
                                            material, true, null);
                                      },
                                      child: const Text(
                                        'Approve',
                                        style: TextStyle(color: Colors.white,  fontWeight: FontWeight.w800,),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.green),
                                  ),
                                  child: const Text(
                                    "Material Approved",
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                        )
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      )
    : const SizedBox.shrink(),
                    
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
  DataCell _buildCell(String text, double maxWidth) {
    return DataCell(
      ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}