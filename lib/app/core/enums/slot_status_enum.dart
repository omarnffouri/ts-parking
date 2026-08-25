import 'package:flutter/material.dart';
import 'package:ts_parking/app/theme/app_colors.dart';

enum SlotStatus {
  available,
  booked;

  static SlotStatus? tryParse(String? raw) {
    if (raw == null) return null;
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) return null;
    switch (normalized) {
      case 'available':
        return SlotStatus.available;
      case 'booked':
      case 'occupied':
      case 'hold':
      case 'active':
        return SlotStatus.booked;
      default:
        return null;
    }
  }
}

extension SlotStatusExtension on SlotStatus {
  String get title {
    switch (this) {
      case SlotStatus.available:
        return 'Available';
      case SlotStatus.booked:
        return 'Occupied';
    }
  }

  Color get color {
    switch (this) {
      case SlotStatus.available:
        return AppColors.success;
      case SlotStatus.booked:
        return AppColors.error;
    }
  }
}
