import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: AppTypography.bodySmall.copyWith(
        color: colorScheme.onSurface.withValues(alpha: 0.4),
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }
}
