import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class HeaderChips extends StatelessWidget {
  final int vehicleCount;
  final bool isListView;
  final VoidCallback onToggleView;

  const HeaderChips({
    super.key,
    required this.vehicleCount,
    required this.isListView,
    required this.onToggleView,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.ms,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? const Color.fromARGB(255, 46, 46, 47)
                : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$vehicleCount ${vehicleCount == 1 ? 'Vehicle' : 'Vehicles'}',
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onToggleView,
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 52,
              height: 48,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 46, 46, 47)
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isListView
                      ? AppColors.secondary.withValues(
                          alpha: isDark ? 0.32 : 0.24,
                        )
                      : Colors.transparent,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Icon(
                  isListView
                      ? Icons.grid_view_rounded
                      : Icons.view_agenda_rounded,
                  key: ValueKey(isListView),
                  size: 20,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
