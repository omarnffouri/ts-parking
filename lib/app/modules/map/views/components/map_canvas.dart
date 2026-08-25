import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/modules/map/views/components/dense_zone_label.dart';
import 'package:ts_parking/app/modules/map/views/components/positioned_slot.dart';
import 'package:ts_parking/app/modules/map/views/widgets/custom_parking_map_painter.dart';
import 'package:ts_parking/app/modules/map/views/widgets/truck_arrival_widget.dart';
import 'package:ts_parking/app/modules/map/views/widgets/zone_overlay.dart';

import '../../controllers/map_controller.dart';
import '../../models/floorplan_config.dart';

class MapCanvas extends GetView<MapController> {
  const MapCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.ensureViewport(constraints.biggest);
        });

        return Obx(() {
          final config = controller.activeMapConfig;
          final focusedZoneId = controller.focusedZoneId;
          final focusedLayoutKey = controller.focusedZone?.layoutKey;
          return Stack(
            children: [
              ClipRect(
                child: InteractiveViewer(
                  transformationController: controller.transformationController,
                  minScale: controller.minInteractiveScale,
                  maxScale: controller.maxInteractiveScale,
                  boundaryMargin: const EdgeInsets.all(320),
                  clipBehavior: Clip.none,
                  interactionEndFrictionCoefficient: 0.000013,
                  constrained: false,
                  child: SizedBox(
                    width: config.designSize.width,
                    height: config.designSize.height,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: CustomParkingMapPainter(
                              config: config,
                              focusedZoneId: focusedZoneId,
                            ),
                          ),
                        ),
                        for (final zone in config.zones)
                          Positioned.fill(
                            child: ClipPath(
                              clipper: _ZoneInteractionClipper(
                                path: buildZoneInteractionPath(zone: zone),
                              ),
                              child: GestureDetector(
                                key: ValueKey('parking_zone_${zone.id}'),
                                behavior: HitTestBehavior.opaque,
                                onTap: () => controller.focusZone(zone),
                                child: IgnorePointer(
                                  child: ZoneOverlay(
                                    isFocused: focusedZoneId == zone.id,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        for (final zone in config.zones)
                          if (!controller.isDenseZone(zone))
                            for (final slot in zone.slots)
                              PositionedSlot(
                                slotConfig: slot,
                                slot: slot.slot,
                                fillColor: controller.fillColorForSlot(slot),
                                isFocused: focusedZoneId == zone.id,
                                isSelected: controller.isSelectedSlot(slot),
                                onTap: () {
                                  if (controller.canSelectSlot(zone)) {
                                    controller.handleSlotTap(
                                      context,
                                      zone,
                                      slot,
                                    );
                                    return;
                                  }

                                  controller.focusZone(zone);
                                },
                              ),
                        for (final zone in config.zones)
                          if (controller.shouldShowDenseZoneLabel(zone))
                            DenseZoneLabel(
                              zone: controller.denseLayoutZoneFor(zone),
                              isFocused: focusedLayoutKey == zone.layoutKey,
                              onTap: () =>
                                  controller.openZoneSlotsSheet(context, zone),
                            ),
                        if (controller.truckRect case final truckRect?)
                          AnimatedPositioned.fromRect(
                            key: const ValueKey('slot_arrival_truck'),
                            duration: MapController.truckTravelDuration,
                            curve: Curves.easeOutCubic,
                            rect: truckRect,
                            child: IgnorePointer(
                              child: AnimatedOpacity(
                                duration: MapController.truckFadeDuration,
                                opacity: controller.truckVisible ? 1 : 0,
                                child: AnimatedScale(
                                  duration: MapController.truckTravelDuration,
                                  curve: Curves.easeOutBack,
                                  scale: controller.truckVisible ? 1 : 0.92,
                                  child: Transform.rotate(
                                    angle: controller.truckRotation,
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.16,
                                            ),
                                            blurRadius: 16,
                                            offset: const Offset(0, 8),
                                          ),
                                        ],
                                      ),
                                      child: TruckArrivalWidget(
                                        useTopView:
                                            controller.truckArrivalVisual ==
                                            TruckArrivalVisual.topDown,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0, -0.2),
                        radius: 1.15,
                        colors: [
                          Colors.transparent,
                          const Color(0x0E0F172A),
                          const Color(0x180F172A),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

class _ZoneInteractionClipper extends CustomClipper<Path> {
  const _ZoneInteractionClipper({required this.path});

  final Path path;

  @override
  Path getClip(Size size) => path;

  @override
  bool shouldReclip(covariant _ZoneInteractionClipper oldClipper) {
    return oldClipper.path != path;
  }
}
