import '../entities/pricing_plan_entity.dart';
import '../entities/zone_entity.dart';
import '../../core/enums/parking_vehicle_type.dart';

class SlotSelectionArgs {
  final String yardId;
  final String yardName;
  final ZoneEntity zone;
  final ParkingVehicleType vehicleType;
  final List<PricingPlanEntity> plans;

  const SlotSelectionArgs({
    required this.yardId,
    required this.yardName,
    required this.zone,
    required this.vehicleType,
    this.plans = const [],
  });
}
