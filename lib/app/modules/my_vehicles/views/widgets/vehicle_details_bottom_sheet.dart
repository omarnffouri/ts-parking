import 'package:flutter/material.dart';
import 'package:ts_parking/app/domain/entities/vehicle_entity.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';
import 'package:ts_parking/app/theme/app_colors.dart';
import 'package:ts_parking/app/theme/app_radius.dart';
import 'package:ts_parking/app/theme/app_spacing.dart';
import 'package:ts_parking/app/theme/app_typography.dart';

void showVehicleDetailsBottomSheet(
  BuildContext context,
  VehicleEntity vehicle,
) {
  final colorScheme = Theme.of(context).colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

  showModalBottomSheet<void>(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: AppRadius.xlargeTopRadius),
    backgroundColor: colorScheme.surface,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: AppRadius.pillRadius,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: AppRadius.largeRadius,
                ),
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Image.asset(vehicle.vehicleType.iconAsset),
              ),
              const SizedBox(height: AppSpacing.ms),
              Text(
                vehicle.identifier ?? vehicle.vehicleTypeName,
                style: AppTypography.h3.copyWith(color: colorScheme.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                vehicle.licensePlate,
                style: AppTypography.bodyLarge.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Divider(color: colorScheme.outlineVariant, height: 1),
              const SizedBox(height: AppSpacing.sm),
              _detailRow(
                icon: Icons.category_rounded,
                label: 'Type',
                value: vehicle.vehicleTypeName,
                isDark: isDark,
              ),
              if (vehicle.identifier != null &&
                  vehicle.identifier!.trim().isNotEmpty)
                _detailRow(
                  icon: Icons.badge_outlined,
                  label: 'Identifier',
                  value: vehicle.identifier!,
                  isDark: isDark,
                ),
              _detailRow(
                icon: Icons.pin_outlined,
                label: 'Plate',
                value: vehicle.licensePlate,
                isDark: isDark,
              ),
              _detailRow(
                icon: Icons.event_outlined,
                label: 'Added',
                value: vehicle.createdAt.year.toString(),
                isDark: isDark,
              ),
              _detailRow(
                icon: Icons.circle,
                label: 'Status',
                value: vehicle.isActive ? 'Active' : 'Inactive',
                isDark: isDark,
                valueColor: vehicle.isActive
                    ? AppColors.success
                    : AppColors.error,
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _detailRow({
  required IconData icon,
  required String label,
  required String value,
  required bool isDark,
  Color? valueColor,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.ms),
    child: Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark
              ? AppColors.darkTextTertiary
              : AppColors.lightTextTertiary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmallSemiBold.copyWith(
              color:
                  valueColor ??
                  (isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary),
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    ),
  );
}
