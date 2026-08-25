import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class CityChips extends StatelessWidget {
  final List<String> availableCities;
  final String selectedCity;
  final ValueChanged<String> onCitySelected;

  const CityChips({
    super.key,
    required this.availableCities,
    required this.selectedCity,
    required this.onCitySelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    // "All" + each available city
    final items = ['All', ...availableCities];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: items.length,
        separatorBuilder: (_, __) => AppSpacing.horizontalSpaceSm,
        itemBuilder: (context, index) {
          final city = items[index];
          final isAll = city == 'All';
          final isSelected = isAll
              ? selectedCity.isEmpty
              : selectedCity == city;

          return GestureDetector(
            onTap: () => onCitySelected(isAll ? '' : city),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.xs,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accent
                    : isDark
                    ? AppColors.darkSurface
                    : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accent
                      : isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                ),
              ),
              child: Text(
                city,
                style: AppTypography.buttonSmall.copyWith(
                  color: isSelected
                      ? Colors.white
                      : isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
