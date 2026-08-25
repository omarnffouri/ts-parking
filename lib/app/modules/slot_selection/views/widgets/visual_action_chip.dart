import 'package:flutter/material.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class VisualActionChip extends StatelessWidget {
  const VisualActionChip({super.key, required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.ms,
        vertical: 11,
      ),
      decoration: BoxDecoration(
        color: context.panelColor,
        borderRadius: AppRadius.pillRadius,
        border: Border.all(color: context.panelBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: context.secondaryTextColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmallSemiBold.copyWith(
              color: context.primaryTextColor,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}
