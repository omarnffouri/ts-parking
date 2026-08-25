import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../home/controllers/yard_discovery_controller.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  static void show() {
    Get.bottomSheet(
      const FilterBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late final YardDiscoveryController _ctrl;
  late String _sortMode;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<YardDiscoveryController>();
    _sortMode = _ctrl.sortMode.value;
  }

  void _apply() {
    _ctrl.sortMode.value = _sortMode;
    Get.back();
  }

  void _reset() {
    setState(() {
      _sortMode = 'all';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: AppRadius.xlargeTopRadius,
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: bottomPadding + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHandle(isDark),
          AppSpacing.verticalSpaceMd,
          _buildHeader(isDark),
          AppSpacing.verticalSpaceLg,
          _buildSortSection(isDark),
          AppSpacing.verticalSpaceLg,
          _buildApplyButton(),
        ],
      ),
    );
  }

  Widget _buildHandle(bool isDark) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          borderRadius: AppRadius.pillRadius,
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filters',
          style: AppTypography.h3.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        GestureDetector(
          onTap: _reset,
          child: Text(
            'Reset',
            style: AppTypography.buttonMedium.copyWith(color: AppColors.accent),
          ),
        ),
      ],
    );
  }

  Widget _buildSortSection(bool isDark) {
    final options = [('all', 'Default'), ('name', 'Name (A-Z)')];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SORT BY',
          style: AppTypography.label.copyWith(
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
        AppSpacing.verticalSpaceSm,
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((entry) {
              final (value, label) = entry;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _chip(
                  label: label,
                  isSelected: _sortMode == value,
                  isDark: isDark,
                  onTap: () => setState(() => _sortMode = value),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _apply,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        ),
        child: Text(
          'Apply Filters',
          style: AppTypography.buttonMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _chip({
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent
              : isDark
              ? AppColors.darkSurface
              : Colors.white,
          borderRadius: AppRadius.pillRadius,
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        child: Text(
          label,
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
  }
}
