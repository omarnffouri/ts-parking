import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/map_controller.dart';
import 'glass_panel.dart';

class ZoomControls extends GetView<MapController> {
  const ZoomControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isZoneFocused = controller.focusedZone != null;

      return GlassPanel(
        padding: const EdgeInsets.all(4),
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ZoomButton(
              icon: Icons.add_rounded,
              onTap: controller.zoomIn,
              semanticLabel: 'Zoom in',
            ),
            const SizedBox(height: 8),
            _ZoomButton(
              icon: Icons.remove_rounded,
              onTap: controller.zoomOut,
              semanticLabel: 'Zoom out',
            ),
            const SizedBox(height: 8),
            _ZoomButton(
              icon: isZoneFocused
                  ? Icons.arrow_back_rounded
                  : Icons.center_focus_strong_rounded,
              onTap: isZoneFocused
                  ? controller.showOverview
                  : controller.resetZoom,
              semanticLabel: isZoneFocused ? 'Back to overview' : 'Reset zoom',
            ),
          ],
        ),
      );
    });
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFFFFF), Color(0xFFF3F6FB)],
        ),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFDCE3EE)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        tooltip: semanticLabel,
        onPressed: onTap,
        icon: Icon(icon, color: const Color(0xFF0F172A)),
        style: IconButton.styleFrom(
          minimumSize: const Size.square(44),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
