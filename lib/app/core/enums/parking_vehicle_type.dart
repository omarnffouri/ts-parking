import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/gen/assets.gen.dart';

enum ParkingVehicleType { truck, trailer, bobtail, unknown }

extension ParkingVehicleTypeX on ParkingVehicleType {
  static ParkingVehicleType fromApiName(String apiVehicleTypeName) {
    final normalized = apiVehicleTypeName.toLowerCase();
    if (normalized.contains('truck')) return ParkingVehicleType.truck;
    if (normalized.contains('trailer')) return ParkingVehicleType.trailer;
    if (normalized.contains('bobtail')) return ParkingVehicleType.bobtail;
    return ParkingVehicleType.unknown;
  }

  int get apiId {
    return switch (this) {
      ParkingVehicleType.truck => 1,
      ParkingVehicleType.trailer => 2,
      ParkingVehicleType.bobtail => 3,
      ParkingVehicleType.unknown => 0,
    };
  }

  String get label {
    return switch (this) {
      ParkingVehicleType.truck => 'Truck',
      ParkingVehicleType.trailer => 'Trailer',
      ParkingVehicleType.bobtail => 'Bobtail',
      ParkingVehicleType.unknown => 'Vehicle',
    };
  }

  String get code {
    return switch (this) {
      ParkingVehicleType.truck => 'T',
      ParkingVehicleType.trailer => 'R',
      ParkingVehicleType.bobtail => 'B',
      ParkingVehicleType.unknown => '?',
    };
  }

  IconData get icon {
    return switch (this) {
      ParkingVehicleType.truck => Icons.local_shipping_rounded,
      ParkingVehicleType.trailer => Icons.rv_hookup_rounded,
      ParkingVehicleType.bobtail => Icons.airport_shuttle_rounded,
      ParkingVehicleType.unknown => Icons.directions_car_rounded,
    };
  }

  String get iconAsset {
    return switch (this) {
      ParkingVehicleType.truck => Assets.images.truck.path,
      ParkingVehicleType.trailer => Assets.images.trailer.path,
      ParkingVehicleType.bobtail => Assets.images.bobtail.path,
      ParkingVehicleType.unknown => Assets.images.truck.path,
    };
  }
}
