import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/gen/assets.gen.dart';
import '../../../../domain/entities/vehicle_entity.dart';
import '../../../../core/enums/parking_vehicle_type.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/my_vehicles_controller.dart';
import '../components/curved_road.dart';

class VehicleBoard extends GetView<MyVehiclesController> {
  final ValueChanged<VehicleEntity> onTap;
  final double roadWidth;

  const VehicleBoard({super.key, required this.onTap, required this.roadWidth});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final vehicles = controller.orderedVehicles;

      return Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, AppSpacing.md),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              final isLeft = index.isEven;

              return Column(
                children: [
                  if (index > 0)
                    const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: AppColors.secondaryLight,
                    ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      6,
                      AppSpacing.md,
                      6,
                    ),
                    child: Align(
                      alignment: isLeft
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: FractionallySizedBox(
                        widthFactor: 0.46,
                        child: _VehicleSortableCard(
                          vehicle: vehicle,
                          index: index,
                          isLeft: isLeft,
                          onTap: () => onTap(vehicle),
                          onAcceptDrop: (draggedVehicleId) =>
                              controller.swapVehicles(draggedVehicleId, index),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: SizedBox(width: roadWidth, child: const CurvedRoad()),
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _VehicleSortableCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final int index;
  final bool isLeft;
  final VoidCallback onTap;
  final ValueChanged<String> onAcceptDrop;

  const _VehicleSortableCard({
    required this.vehicle,
    required this.index,
    required this.isLeft,
    required this.onTap,
    required this.onAcceptDrop,
  });

  @override
  Widget build(BuildContext context) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => details.data != vehicle.id,
      onAcceptWithDetails: (details) => onAcceptDrop(details.data),
      builder: (context, candidateData, rejectedData) {
        final isTargeted = candidateData.isNotEmpty;

        return LongPressDraggable<String>(
          data: vehicle.id,
          dragAnchorStrategy: pointerDragAnchorStrategy,
          feedback: SizedBox(
            width: 150,
            child: _VehicleGalleryCard(
              vehicle: vehicle,
              index: index,
              isLeft: isLeft,
              onTap: () {},
              isDraggingGhost: true,
              isTargeted: false,
            ),
          ),
          childWhenDragging: Opacity(
            opacity: 0.28,
            child: _VehicleGalleryCard(
              vehicle: vehicle,
              index: index,
              isLeft: isLeft,
              onTap: onTap,
              isDraggingGhost: true,
              isTargeted: false,
            ),
          ),
          child: _VehicleGalleryCard(
            vehicle: vehicle,
            index: index,
            isLeft: isLeft,
            onTap: onTap,
            isDraggingGhost: false,
            isTargeted: isTargeted,
          ),
        );
      },
    );
  }
}

class _VehicleGalleryCard extends StatelessWidget {
  final VehicleEntity vehicle;
  final int index;
  final bool isLeft;
  final VoidCallback onTap;
  final bool isDraggingGhost;
  final bool isTargeted;

  const _VehicleGalleryCard({
    required this.vehicle,
    required this.index,
    required this.isLeft,
    required this.onTap,
    this.isDraggingGhost = false,
    this.isTargeted = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final badge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      width: Get.size.width * 0.2,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        vehicle.identifier ?? vehicle.licensePlate,
        maxLines: 1,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          height: 1.0,
        ),
      ),
    );

    final rawImage = Image.asset(
      Assets.images.truckPlaceholder.path,
      width: 100,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(
        vehicle.vehicleType.icon,
        size: 50,
        color: theme.colorScheme.primary,
      ),
    );

    final truckImage = isLeft
        ? Transform.flip(flipX: true, child: rawImage)
        : rawImage;

    return _StaggeredCardReveal(
      index: index,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          scale: isTargeted
              ? 0.97
              : isDraggingGhost
              ? 0.985
              : 1,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isDraggingGhost ? 0.96 : 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [badge, const SizedBox(height: 4), truckImage],
            ),
          ),
        ),
      ),
    );
  }
}

class _StaggeredCardReveal extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredCardReveal({required this.index, required this.child});

  @override
  State<_StaggeredCardReveal> createState() => _StaggeredCardRevealState();
}

class _StaggeredCardRevealState extends State<_StaggeredCardReveal>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future<void>.delayed(Duration(milliseconds: 150 * widget.index), () {
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
