class PostVmDetails {
  PostVmDetails({
    this.vehicleId,
    this.vehicleName,
    this.vehicleType,
    this.driverId,
    this.driverLicense,
    this.insuranceProvider,
    this.insuranceNo,
    this.rcNo,
    this.vehicleComments,
  });

  String? vehicleId;
  String? vehicleName;
  String? vehicleType;
  String? driverId;
  String? driverLicense;
  String? insuranceProvider;
  String? insuranceNo;
  String? rcNo;
  String? vehicleComments;

  Map<String, dynamic> toJson() {
    return {
      "vehicle_id": vehicleId,
      "vehicle_name": vehicleName,
      "vehicle_type": vehicleType,
      "driver_id": driverId,
      "driver_licence": driverLicense,
      "insurance_provider": insuranceProvider,
      "insurance_no": insuranceNo,
      "rc_no": rcNo,
      "vehicle_comments": vehicleComments,
    };
  }

   factory PostVmDetails.fromJson(Map<String, dynamic> json) {
    return PostVmDetails(
      vehicleId: json["vehicle_id"],
      vehicleName: json["vehicle_name"],
      vehicleType: json["vehicle_type"],
      driverId: json["driver_id"],
      driverLicense: json["driver_licence"],
      insuranceProvider: json["insurance_provider"],
      insuranceNo: json["insurance_no"],
      rcNo: json["rc_no"],
      vehicleComments: json["vehicle_comments"],
    );
  }
}
