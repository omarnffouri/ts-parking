class AddVehicleParams {
  final int vehicleTypeId;
  final String licensePlate;
  final String? nickname;
  final String? model;
  final String? color;
  final int? year;
  final String status;

  const AddVehicleParams({
    required this.vehicleTypeId,
    required this.licensePlate,
    this.nickname,
    this.model,
    this.color,
    this.year,
    this.status = 'active',
  });

  Map<String, dynamic> toJson() => {
    'vehicle_type_id': vehicleTypeId,
    'license_plate': licensePlate,
    'status': status,
    'attributes': {
      if (nickname != null) 'nick_name': nickname,
      if (model != null) 'model': model,
      if (color != null) 'color': color,
      if (year != null) 'year': year,
    },
  };
}
