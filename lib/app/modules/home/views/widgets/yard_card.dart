import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

import '../../../../domain/entities/yard_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class YardCard extends StatelessWidget {
  final YardEntity yard;
  final VoidCallback onTap;

  const YardCard({super.key, required this.yard, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: context.surfaceColor,
          borderRadius: AppRadius.largeRadius,
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroImage(isDark: isDark),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: _buildInfo(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroImage({required bool isDark}) {
    final imageUrl = yard.imageUrl;

    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppRadius.large),
        topRight: Radius.circular(AppRadius.large),
      ),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightSurfaceVariant,
                ),
                child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            _YardImageFallback(isDark: isDark),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return _YardImageFallback(isDark: isDark);
                        },
                      )
                    : _YardImageFallback(isDark: isDark),
              ),
            ),
            if (imageUrl != null)
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.06),
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.20),
                      ],
                    ),
                  ),
                ),
              ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.08),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.32),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.45),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.space_dashboard_outlined,
                      color: Colors.white,
                      size: 14,
                    ),
                    AppSpacing.horizontalSpaceXs,
                    Text(
                      '${yard.availableSlots}/${yard.capacityTotal}',
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              right: AppSpacing.sm,
              bottom: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: yard.status == 'approved'
                      ? AppColors.success.withValues(alpha: 0.85)
                      : AppColors.warning.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  yard.status,
                  style: AppTypography.bodySmall.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          yard.name,
          style: AppTypography.h3.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        AppSpacing.verticalSpaceSm,
        Row(
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 20,
              color: AppColors.secondary,
            ),
            AppSpacing.horizontalSpaceXs,
            Expanded(
              child: Text(
                yard.address,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.secondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _YardImageFallback extends StatelessWidget {
  const _YardImageFallback({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.local_parking_rounded,
        size: 36,
        color: isDark
            ? AppColors.darkTextTertiary
            : AppColors.lightTextTertiary,
      ),
    );
  }
}
