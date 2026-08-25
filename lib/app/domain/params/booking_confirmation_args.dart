import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';

import '../entities/slot_entity.dart';
import '../entities/zone_entity.dart';

class BookingConfirmationArgs {
  final String yardId;
  final String yardName;
  final String yardAddress;
  final ZoneEntity zone;
  final ParkingVehicleType vehicleType;
  final List<SlotEntity> selectedSlots;

  const BookingConfirmationArgs({
    required this.yardId,
    required this.yardName,
    this.yardAddress = '',
    required this.zone,
    required this.vehicleType,
    required this.selectedSlots,
  });
}
