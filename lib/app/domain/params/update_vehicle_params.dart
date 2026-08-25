class UpdateVehicleParams {
  final String id;
  final int? vehicleTypeId;
  final String? licensePlate;
  final String? nickname;
  final String? model;
  final String? color;
  final int? year;

  const UpdateVehicleParams({
    required this.id,
    this.vehicleTypeId,
    this.licensePlate,
    this.nickname,
    this.model,
    this.color,
    this.year,
  });

  Map<String, dynamic> toJson() => {
    if (vehicleTypeId != null) 'vehicle_type_id': vehicleTypeId,
    if (licensePlate != null) 'license_plate': licensePlate,
    'attributes': {
      if (nickname != null) 'nick_name': nickname,
      if (model != null) 'model': model,
      if (color != null) 'color': color,
      if (year != null) 'year': year,
    },
  };
}
