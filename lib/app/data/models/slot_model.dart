import 'package:ts_parking/app/core/enums/slot_status_enum.dart';

import '../../domain/entities/slot_entity.dart';

class SlotModel extends SlotEntity {
  const SlotModel({
    required super.id,
    required super.zoneId,
    required super.slotCode,
    super.row,
    super.column,
    required super.status,
    super.backendStatus,
    required super.vehicleTypeId,
    required super.vehicleTypeName,
    required super.vehicleTypePrice,
    required super.zoneName,
    super.zoneDirection,
    required super.zoneHorizontalCapacity,
    required super.zoneVerticalCapacity,
    required super.planId,
    required super.planName,
    required super.planPrice,
    required super.price,
    required super.priceBeforeDiscount,
    required super.discount,
    super.activeSubscriptionUser,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    final vehicleType = json['vehicle_type'] is Map<String, dynamic>
        ? SlotVehicleType.fromJson(json['vehicle_type'] as Map<String, dynamic>)
        : const SlotVehicleType(id: 0, name: '', price: 0.0);

    final zone = json['zone'] is Map<String, dynamic>
        ? SlotZone.fromJson(json['zone'] as Map<String, dynamic>)
        : const SlotZone(
            id: 0,
            name: '',
            horizontalCapacity: 0,
            verticalCapacity: 0,
          );

    final plan = json['plan'] is Map<String, dynamic>
        ? SlotPlan.fromJson(json['plan'] as Map<String, dynamic>)
        : const SlotPlan(id: 0, subscriptionType: '', price: 0.0);
    final subscriptionType = plan.subscriptionType.isNotEmpty
        ? plan.subscriptionType
        : (json['subscription_type'] as String?)?.trim() ?? '';

    final slotPrice = double.tryParse(json['price']?.toString() ?? '') ?? 0.0;
    final rawStatus = (json['status'] as String?)?.trim().toLowerCase() ?? '';
    final activeSubscriptionUser =
        json['active_subscription_user'] is Map<String, dynamic>
        ? SlotActiveSubscriptionUserModel.fromJson(
            json['active_subscription_user'] as Map<String, dynamic>,
          )
        : null;

    return SlotModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      zoneId: (json['zone_id'] as num?)?.toInt() ?? 0,
      slotCode: (json['slot_code'] as String?)?.trim() ?? '',
      row: (json['row'] as num?)?.toInt(),
      column: (json['column'] as num?)?.toInt(),
      status: _parseStatus(rawStatus),
      backendStatus: rawStatus,
      vehicleTypeId: (json['vehicle_type_id'] as num?)?.toInt() ?? 0,
      vehicleTypeName: vehicleType.name,
      vehicleTypePrice: vehicleType.price,
      zoneName: zone.name,
      zoneDirection: zone.direction,
      zoneHorizontalCapacity: zone.horizontalCapacity,
      zoneVerticalCapacity: zone.verticalCapacity,
      planId: plan.id,
      planName: subscriptionType,
      planPrice: plan.price,
      price: slotPrice,
      priceBeforeDiscount:
          double.tryParse(json['price_before_discount']?.toString() ?? '') ??
          slotPrice,
      discount:
          double.tryParse(json['owner_operator_discount']?.toString() ?? '') ??
          0.0,
      activeSubscriptionUser: activeSubscriptionUser,
    );
  }

  static SlotStatus _parseStatus(String status) =>
      SlotStatus.tryParse(status) ?? SlotStatus.booked;
}

// ---------------------------------------------------------------------------
// Nested JSON objects
// ---------------------------------------------------------------------------

class SlotVehicleType {
  final int id;
  final String name;
  final double price;

  const SlotVehicleType({
    required this.id,
    required this.name,
    required this.price,
  });

  factory SlotVehicleType.fromJson(Map<String, dynamic> json) {
    return SlotVehicleType(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
    );
  }
}

class SlotZone {
  final int id;
  final String name;
  final String? direction;
  final int horizontalCapacity;
  final int verticalCapacity;

  const SlotZone({
    required this.id,
    required this.name,
    this.direction,
    required this.horizontalCapacity,
    required this.verticalCapacity,
  });

  factory SlotZone.fromJson(Map<String, dynamic> json) {
    return SlotZone(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
      direction: json['direction']?.toString(),
      horizontalCapacity: (json['horizontal_capacity'] as num?)?.toInt() ?? 0,
      verticalCapacity: (json['vertical_capacity'] as num?)?.toInt() ?? 0,
    );
  }
}

class SlotPlan {
  final int id;
  final String subscriptionType;
  final double price;

  const SlotPlan({
    required this.id,
    required this.subscriptionType,
    required this.price,
  });

  factory SlotPlan.fromJson(Map<String, dynamic> json) {
    return SlotPlan(
      id: (json['id'] as num?)?.toInt() ?? 0,
      subscriptionType: (json['subscription_type'] as String?)?.trim() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0.0,
    );
  }
}

class SlotActiveSubscriptionUserModel extends SlotActiveSubscriptionUserEntity {
  const SlotActiveSubscriptionUserModel({
    required super.id,
    required super.name,
    super.email,
    required super.mobileNumber,
    super.userableId,
    super.userableType,
    super.userType,
    super.vehicleId,
    super.vehicleNumber,
    super.vehicleIdentifier,
  });

  factory SlotActiveSubscriptionUserModel.fromJson(Map<String, dynamic> json) {
    return SlotActiveSubscriptionUserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?)?.trim() ?? '',
      email: json['email']?.toString(),
      mobileNumber: (json['mobile_number'] as String?)?.trim() ?? '',
      userableId: (json['userable_id'] as num?)?.toInt(),
      userableType: json['userable_type']?.toString(),
      userType: json['user_type']?.toString() ?? 'unknown',
      vehicleId: (json['vehicle_id'] as num?)?.toInt(),
      vehicleNumber: json['vehicle_number']?.toString(),
      vehicleIdentifier: json['vehicle_identifier']?.toString(),
    );
  }
}
