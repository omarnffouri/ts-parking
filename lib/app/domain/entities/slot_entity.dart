import 'package:equatable/equatable.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';

import '../../core/enums/user_type.dart';

class SlotEntity extends Equatable {
  final int id;
  final int zoneId;
  final String slotCode;
  final int? row;
  final int? column;
  final SlotStatus status;
  final String backendStatus;
  final int vehicleTypeId;
  final String vehicleTypeName;
  final double vehicleTypePrice;
  final String zoneName;
  final String? zoneDirection;
  final int zoneHorizontalCapacity;
  final int zoneVerticalCapacity;
  final int planId;
  final String planName;
  final double planPrice;
  final double price;
  final double priceBeforeDiscount;
  final double discount;
  final SlotActiveSubscriptionUserEntity? activeSubscriptionUser;

  const SlotEntity({
    required this.id,
    required this.zoneId,
    required this.slotCode,
    this.row,
    this.column,
    required this.status,
    this.backendStatus = '',
    required this.vehicleTypeId,
    required this.vehicleTypeName,
    this.vehicleTypePrice = 0,
    required this.zoneName,
    this.zoneDirection,
    this.zoneHorizontalCapacity = 0,
    this.zoneVerticalCapacity = 0,
    required this.planId,
    required this.planName,
    required this.planPrice,
    required this.price,
    required this.priceBeforeDiscount,
    required this.discount,
    this.activeSubscriptionUser,
  });

  bool get isVip => planName.trim().toLowerCase() == 'vip';
  bool get hasDiscount => discount > 0;
  bool get isBookable =>
      status == SlotStatus.available && activeSubscriptionUser == null;

  @override
  List<Object?> get props => [
    id,
    zoneId,
    slotCode,
    row,
    column,
    status,
    backendStatus,
    vehicleTypeId,
    vehicleTypeName,
    vehicleTypePrice,
    zoneName,
    zoneDirection,
    zoneHorizontalCapacity,
    zoneVerticalCapacity,
    planId,
    planName,
    planPrice,
    price,
    priceBeforeDiscount,
    discount,
    activeSubscriptionUser,
  ];
}

extension SlotEntityX on SlotEntity {
  ParkingVehicleType get vehicleType =>
      ParkingVehicleTypeX.fromApiName(vehicleTypeName);

  String get zoneDisplayLabel {
    switch (zoneDirection?.trim().toLowerCase()) {
      case 'north':
        return 'North';
      case 'east':
        return 'East';
      case 'south':
        return 'South';
      case 'west':
        return 'West';
      case 'middle':
        return 'Middle';
      default:
        return zoneName;
    }
  }
}

class SlotActiveSubscriptionUserEntity extends Equatable {
  final int id;
  final String name;
  final String? email;
  final String mobileNumber;
  final int? userableId;
  final String? userableType;
  final String userType;
  final int? vehicleId;
  final String? vehicleNumber;
  final String? vehicleIdentifier;

  const SlotActiveSubscriptionUserEntity({
    required this.id,
    required this.name,
    this.email,
    required this.mobileNumber,
    this.userableId,
    this.userableType,
    this.userType = 'unknown',
    this.vehicleId,
    this.vehicleNumber,
    this.vehicleIdentifier,
  });

  String get userTypeLabel => UserTypeX.fromApiName(userType).label;

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    mobileNumber,
    userableId,
    userableType,
    userType,
    vehicleId,
    vehicleNumber,
    vehicleIdentifier,
  ];
}
