import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/widgets/loading_widget.dart';
import 'package:ts_parking/app/modules/map/views/components/map_canvas.dart';
import 'package:ts_parking/app/modules/map/views/widgets/ambient_glow.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/map_controller.dart';

import 'widgets/legend_card.dart';
import 'widgets/zoom_controls.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF5E7B55),
      body: Obx(
        () => LoadingOverlay(
          isLoading: controller.isLoading,
          loadingMessage: 'Loading slots...',
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF86A96B), Color(0xFF5C774F)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Stack(
                children: [
                  const Positioned.fill(child: AmbientBackdrop()),
                  const Positioned.fill(child: MapCanvas()),
                  const Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(height: AppSpacing.md),
                        IgnorePointer(child: Align(child: LegendCard())),
                      ],
                    ),
                  ),
                  Positioned(
                    right: AppSpacing.md,
                    bottom: bottomInset + 30,
                    child: const ZoomControls(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
