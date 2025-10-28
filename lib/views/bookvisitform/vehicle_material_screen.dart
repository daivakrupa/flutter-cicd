import 'dart:math';
import 'package:flutter/material.dart';
import 'package:visiq/models/book_visit_model/PostMmDetails.dart';
import 'package:visiq/models/book_visit_model/PostVmDetails.dart';

class VehicleAndMaterialScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  const VehicleAndMaterialScreen({super.key, required this.onSubmit});

  @override
  State<VehicleAndMaterialScreen> createState() =>
      _VehicleAndMaterialScreenState();
}

class _VehicleAndMaterialScreenState extends State<VehicleAndMaterialScreen> {
  final _vehicleFormKey = GlobalKey<FormState>();
  final _materialFormKey = GlobalKey<FormState>();

  final TextEditingController vehicleNameController = TextEditingController();
  final TextEditingController vehicleTypeController = TextEditingController();
  final TextEditingController drivingLicenseController =
      TextEditingController();
  final TextEditingController insuranceNumberController =
      TextEditingController();
  final TextEditingController insuranceProviderController =
      TextEditingController();
  final TextEditingController rcNumberController = TextEditingController();
  final TextEditingController vehicleCommentsController =
      TextEditingController();
  final TextEditingController materialNameController = TextEditingController();
  final TextEditingController materialDescController = TextEditingController();
  final TextEditingController deviceModelController = TextEditingController();
  final TextEditingController noOfUnitsController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  PostVmDetails materialVehicle = PostVmDetails();
  final TextEditingController materialCommentsController =
      TextEditingController();
  List<PostVmDetails> vehicles = [];
  List<PostMmDetails> materials = [];

  bool showMaterialForm = false;

  @override
  void dispose() {
    vehicleNameController.dispose();
    vehicleTypeController.dispose();
    drivingLicenseController.dispose();
    insuranceNumberController.dispose();
    insuranceProviderController.dispose();
    rcNumberController.dispose();
    vehicleCommentsController.dispose();
    materialNameController.dispose();
    materialDescController.dispose();
    deviceModelController.dispose();
    noOfUnitsController.dispose();
    quantityController.dispose();
    materialCommentsController.dispose();
    super.dispose();
  }

  String generateVehicleId() {
    final random = Random();
    return "V${random.nextInt(999999).toString().padLeft(6, '0')}";
  }

  void _addVehicle() {
    if (_vehicleFormKey.currentState?.validate() ?? false) {
      FocusScope.of(context).unfocus();
      setState(() {
        vehicles.add(
          PostVmDetails(
            vehicleId: generateVehicleId(),
            vehicleName: vehicleNameController.text,
            vehicleType: vehicleTypeController.text,
            driverId: "",
            driverLicense: drivingLicenseController.text,
            insuranceProvider: insuranceProviderController.text,
            insuranceNo: insuranceNumberController.text,
            rcNo: rcNumberController.text,
            vehicleComments: vehicleCommentsController.text,
          ),
        );
        vehicleNameController.clear();
        vehicleTypeController.clear();
        drivingLicenseController.clear();
        insuranceNumberController.clear();
        insuranceProviderController.clear();
        rcNumberController.clear();
        vehicleCommentsController.clear();
      });
    }
  }

  String generateMaterialId() {
    final random = Random();
    return "M${random.nextInt(999999).toString().padLeft(6, '0')}";
  }

  void _addMaterial() {
    if (_materialFormKey.currentState?.validate() ?? false) {
      setState(() {
        showMaterialForm = false;
        materials.add(
          PostMmDetails(
            materialId: generateMaterialId(),
            materialName: materialNameController.text,
            materialDescription: materialDescController.text,
            materialDeviceModel: deviceModelController.text,
            materialNoOfUnits: noOfUnitsController.text,
            materialQuantity: quantityController.text,
            materialRackNo: "",
            materialSerialNumber: '',
            materialVehicleId: materialVehicle.vehicleId,
            materialComments: materialCommentsController.text,
          ),
        );
        materialVehicle = PostVmDetails();
        materialNameController.clear();
        materialDescController.clear();
        deviceModelController.clear();
        noOfUnitsController.clear();
        quantityController.clear();
        materialCommentsController.clear();
      });
    }
  }

  void _submitAll() {
    if (vehicles.isEmpty && materials.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Add at least one vehicle or material")),
      );
      return;
    }

    final data = {
      "vm_bool": vehicles.isNotEmpty,
      "mm_bool": materials.isNotEmpty,
      "vm_details": vehicles.map((v) {
        return v.toJson();
      }).toList(),
      "mm_details": materials.map((m) {
        return m.toJson();
      }).toList(),
    };

    widget.onSubmit(data);
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Submitted Successfully")));
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    String? Function(String?)? validator,
    Function? onTap,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: onTap != null,
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      keyboardType: (label == 'Quantity')
          ? TextInputType.number
          : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: onTap != null ? const Icon(Icons.arrow_drop_down) : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          title: const Text("Vehicle & Material Form"),
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Form(
                  key: _vehicleFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Vehicle Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Vehicle Name",
                        vehicleNameController,
                        (v) => v!.isEmpty ? "Required" : null,
                        null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Vehicle Type",
                        vehicleTypeController,
                        (v) => v!.isEmpty ? "Required" : null,
                        null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Driving License",
                        drivingLicenseController,
                        (v) => v!.isEmpty ? "Required" : null,
                        null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Insurance Number",
                        insuranceNumberController,
                        (v) => v!.isEmpty ? "Required" : null,
                        null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Insurance Provider",
                        insuranceProviderController,
                        (v) => v!.isEmpty ? "Required" : null,
                        null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "RC Number",
                        rcNumberController,
                        (v) => v!.isEmpty ? "Required" : null,
                        null,
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        "Vehicle Comments",
                        vehicleCommentsController,
                        null,
                        null,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _addVehicle,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(83, 213, 227, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Add Vehicle to Table",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (vehicles.isNotEmpty) ...[
                const Text(
                  "Vehicles Added",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    border: TableBorder.all(color: Colors.black38),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: const [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("ID")),
                      DataColumn(label: Text("Type")),
                      DataColumn(label: Text("License")),
                      DataColumn(label: Text("Insurance No")),
                      DataColumn(label: Text("Insurance Provider")),
                      DataColumn(label: Text("RC No")),
                      DataColumn(label: Text("Comments")),
                    ],
                    rows: vehicles.map((v) {
                      return DataRow(
                        cells: [
                          DataCell(Text(v.vehicleName ?? "")),
                          DataCell(Text(v.vehicleId ?? "")),
                          DataCell(Text(v.vehicleType ?? "")),
                          DataCell(Text(v.driverLicense ?? "")),
                          DataCell(Text(v.insuranceNo ?? "")),
                          DataCell(Text(v.insuranceProvider ?? "")),
                          DataCell(Text(v.rcNo ?? "")),
                          DataCell(Text(v.vehicleComments ?? "")),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
              if (vehicles.isNotEmpty) ...[
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() => showMaterialForm = true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(83, 213, 227, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Add Materials",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (showMaterialForm)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Form(
                    key: _materialFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Material Details",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          "Material Name",
                          materialNameController,
                          (v) => v!.isEmpty ? "Required" : null,
                          null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          "Material Description",
                          materialDescController,
                          (v) => v!.isEmpty ? "Required" : null,
                          null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          "Device Model",
                          deviceModelController,
                          (v) => v!.isEmpty ? "Required" : null,
                          null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          "Quantity",
                          quantityController,
                          (v) => v!.isEmpty ? "Required" : null,
                          null,
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          "Vehicle Number",
                          TextEditingController(
                            text: materialVehicle.vehicleName ?? '',
                          ),
                          (v) => v!.isEmpty ? "Required" : null,
                          () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Vehicle Number"),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      children: vehicles.map((vehicle) {
                                        return ListTile(
                                          title: Text(
                                            vehicle.vehicleName ?? '',
                                          ),
                                          onTap: () {
                                            setState(() {
                                              materialVehicle = vehicle;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildTextField(
                          "Comments",
                          materialCommentsController,
                          null,
                          null,
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _addMaterial,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromRGBO(83, 213, 227, 1),
                          ),
                          child: const Text(
                            "Add Material",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              if (materials.isNotEmpty) ...[
                const Text(
                  "Materials Added",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    border: TableBorder.all(color: Colors.black38),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    columns: const [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Description")),
                      DataColumn(label: Text("Model")),
                      DataColumn(label: Text("Quantity")),
                      DataColumn(label: Text("Vehicle Name")),
                      DataColumn(label: Text("Comments")),
                    ],
                    rows: materials.map((m) {
                      return DataRow(
                        cells: [
                          DataCell(Text(m.materialName ?? "")),
                          DataCell(Text(m.materialDescription ?? "")),
                          DataCell(Text(m.materialDeviceModel ?? "")),
                          DataCell(Text(m.materialQuantity ?? "")),
                          DataCell(
                            Text(
                              vehicles
                                      .firstWhere(
                                        (e) =>
                                            e.vehicleId == m.materialVehicleId,
                                        orElse: () =>
                                            PostVmDetails(vehicleName: ''),
                                      )
                                      .vehicleName ??
                                  '',
                            ),
                          ),
                          DataCell(Text(m.materialComments ?? "")),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(83, 213, 227, 1),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _submitAll,
                child: const Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
