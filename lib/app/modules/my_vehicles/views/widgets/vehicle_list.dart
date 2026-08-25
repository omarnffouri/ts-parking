import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/gen/assets.gen.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

import '../../../../domain/entities/vehicle_entity.dart';
import '../../../../core/enums/parking_vehicle_type.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/my_vehicles_controller.dart';

class VehicleList extends GetView<MyVehiclesController> {
  const VehicleList({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Obx(() {
      final vehicles = controller.orderedVehicles;

      return ListView.separated(
        key: const ValueKey('vehicle-list'),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.xs,
          AppSpacing.md,
          controller.isClient ? 120 : 32,
        ),
        itemCount: vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return _VehicleListCard(
            vehicle: vehicle,
            index: index,
            isDark: isDark,
          );
        },
      );
    });
  }
}

class _VehicleListCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final int index;
  final bool isDark;

  const _VehicleListCard({
    required this.vehicle,
    required this.index,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurface;
    final cardBorderColor = isDark
        ? AppColors.darkBorder.withValues(alpha: 0.9)
        : AppColors.lightBorder;
    final primaryText = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final secondaryText = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final statusColor = vehicle.isActive ? AppColors.success : AppColors.error;

    return _StaggeredListReveal(
      index: index,
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: AppRadius.xlargeRadius,
            border: Border.all(color: cardBorderColor),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -9,
                top: -16,
                child: Container(
                  width: 132,
                  height: 132,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withValues(
                      alpha: isDark ? 0.12 : 0.16,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.secondary.withValues(
                                    alpha: isDark ? 0.85 : 0.92,
                                  ),
                                  borderRadius: AppRadius.pillRadius,
                                ),
                                child: Text(
                                  vehicle.vehicleType.label.toUpperCase(),
                                  style: AppTypography.overline.copyWith(
                                    color: Colors.white,
                                    height: 1,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(
                                    alpha: isDark ? 0.18 : 0.1,
                                  ),
                                  borderRadius: AppRadius.pillRadius,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: statusColor,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      vehicle.isActive ? 'Active' : 'Inactive',
                                      style: AppTypography.bodySmallSemiBold
                                          .copyWith(color: statusColor),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            vehicle.identifier?.trim().isNotEmpty == true
                                ? vehicle.identifier!.trim()
                                : vehicle.licensePlate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTypography.h3.copyWith(
                              color: primaryText,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Plate ${vehicle.licensePlate}',
                            style: AppTypography.bodyMedium.copyWith(
                              color: secondaryText,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Wrap(
                            spacing: AppSpacing.sm,
                            runSpacing: AppSpacing.sm,
                            children: [
                              _InfoPill(
                                icon: Icons.badge_outlined,
                                label:
                                    vehicle.identifier?.trim().isNotEmpty ==
                                        true
                                    ? 'Unit ${vehicle.identifier!.trim()}'
                                    : 'No identifier',
                                textColor: primaryText,
                                backgroundColor: AppColors.primary.withValues(
                                  alpha: isDark ? 0.12 : 0.1,
                                ),
                              ),
                              _InfoPill(
                                icon: Icons.calendar_today_rounded,
                                label: 'Added ${vehicle.createdAt.year}',
                                textColor: secondaryText,
                                backgroundColor: AppColors.secondary.withValues(
                                  alpha: isDark ? 0.14 : 0.08,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Column(
                      children: [
                        Container(
                          width: 118,
                          height: 118,

                          alignment: Alignment.center,
                          child: Image.asset(
                            Assets.images.truckPlaceholder.path,
                            width: 96,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                              vehicle.vehicleType.icon,
                              size: 48,
                              color: AppColors.primaryDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color textColor;
  final Color backgroundColor;

  const _InfoPill({
    required this.icon,
    required this.label,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.pillRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTypography.bodySmallSemiBold.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}

class _StaggeredListReveal extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredListReveal({required this.index, required this.child});

  @override
  State<_StaggeredListReveal> createState() => _StaggeredListRevealState();
}

class _StaggeredListRevealState extends State<_StaggeredListReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future<void>.delayed(Duration(milliseconds: 90 * widget.index), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}
