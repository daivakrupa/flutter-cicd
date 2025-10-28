class PostMmDetails{
  PostMmDetails({
    this.materialId,
    this.materialName,
    this.materialDescription,
    this.materialDeviceModel,
    this.materialNoOfUnits,
    this.materialQuantity,
    this.materialRackNo,
    this.materialSerialNumber,
    this.materialVehicleId,
    this.materialComments,
  });

  String? materialId;
  String? materialName;
  String? materialDescription;
  String? materialDeviceModel;
  String? materialNoOfUnits;
  String? materialQuantity;
  String? materialRackNo;
  String? materialSerialNumber;
  String? materialVehicleId;
  String? materialComments;

  Map<String, dynamic> toJson() {
    return {
      "material_id": materialId,
      "material_name": materialName,
      "material_description": materialDescription,
      "material_device_model": materialDeviceModel,
      "material_no_of_units": materialNoOfUnits,
      "material_quantity": materialQuantity,
      "material_rack_no": materialRackNo,
      "material_s_n": materialSerialNumber,
      "material_vehicle_id": materialVehicleId,
      "material_comments": materialComments,
    };
  }
}