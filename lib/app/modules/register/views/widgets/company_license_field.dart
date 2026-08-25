import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/theme/app_colors.dart';
import 'package:ts_parking/app/theme/app_radius.dart';
import 'package:ts_parking/app/theme/app_spacing.dart';
import 'package:ts_parking/app/theme/app_typography.dart';

import '../../controllers/register_controller.dart';

class CompanyLicenseField extends StatelessWidget {
  const CompanyLicenseField({super.key, required this.controller});

  final RegisterController controller;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final fileName = controller.licenseFileName;

      if (fileName != null) {
        return GestureDetector(
          onTap: controller.pickLicense,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: AppRadius.mediumRadius,
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.15),
                    borderRadius: AppRadius.smallRadius,
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.ms),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fileName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tap to change',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: controller.removeLicense,
                    customBorder: const CircleBorder(),
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: Icon(
                        Icons.close_rounded,
                        color: colorScheme.error,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return GestureDetector(
        onTap: controller.pickLicense,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mediumRadius,
            border: Border.all(
              color: AppColors.secondaryLight.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_upload_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text.rich(
                TextSpan(
                  text: 'Upload License ',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                  children: [
                    TextSpan(
                      text: '(Optional)',
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Camera, gallery, PDF, JPG, or PNG',
                style: AppTypography.bodySmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.35),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
