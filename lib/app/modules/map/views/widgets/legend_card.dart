import 'package:flutter/material.dart';

import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import 'glass_panel.dart';

class LegendCard extends StatelessWidget {
  const LegendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      key: const ValueKey('seat_map_legend'),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      borderRadius: BorderRadius.circular(22),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.xs,
        children: const [
          _LegendItem(
            label: 'Open',
            colors: [Color(0xFF4B5258), Color(0xFF2E3338)],
            borderColor: Color(0xFFDCE3EA),
          ),
          _LegendItem(
            label: 'Driver',
            colors: [Color(0xFF2E74FF), Color(0xFF1E429A)],
            borderColor: Color(0xFFD6E4FF),
          ),
          _LegendItem(
            label: 'Owner operator',
            colors: [Color(0xFF8A4C4A), Color(0xFF5F3433)],
            borderColor: Color(0xFFBE8A86),
          ),
          _LegendItem(
            label: 'VIP',
            colors: [Color(0xFF8A6D1E), Color(0xFF5A4512)],
            borderColor: Color(0xFFE0B84A),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.colors,
    required this.borderColor,
  });

  final String label;
  final List<Color> colors;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: colors,
            ),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: borderColor.withValues(alpha: 0.18),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: const Color(0xFF485468),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
