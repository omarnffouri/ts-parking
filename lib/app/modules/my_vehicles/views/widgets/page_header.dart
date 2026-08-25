import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: Get.back,
            borderRadius: BorderRadius.circular(26),
            child: Ink(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color.fromARGB(255, 46, 46, 47)
                    : const Color(0xFFF4F2F7),
                borderRadius: BorderRadius.circular(26),
                border: Border.all(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder.withValues(alpha: 0.9),
                ),
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
                size: 28,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My',
                style: AppTypography.h1.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Vehicles',
                style: AppTypography.h1.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
