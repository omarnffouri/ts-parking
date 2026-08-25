import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/widgets/loading_widget.dart';
import 'package:ts_parking/app/core/enums/profile_menu_item.dart';
import 'package:ts_parking/app/theme/app_colors.dart';
import 'package:ts_parking/app/theme/app_spacing.dart';
import 'package:ts_parking/app/theme/app_typography.dart';

class MenuGroupCard extends StatelessWidget {
  const MenuGroupCard({
    super.key,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.items,
    required this.onTap,
    this.isLoading = false,
  });

  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryTextColor;
  final List<ProfileMenuItem> items;
  final ValueChanged<ProfileMenuItem> onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.05),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: List.generate(items.length, (index) {
          final item = items[index];
          final showDivider = index != items.length - 1;

          return Column(
            children: [
              _ProfileMenuItem(
                item: item,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDark: isDark,
                isLoading: isLoading,
                onTap: () => onTap(item),
              ),
              if (showDivider)
                Divider(
                  height: 1,
                  indent: 72,
                  endIndent: 20,
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
            ],
          );
        }),
      ),
    );
  }
}

class _ProfileMenuItem extends StatelessWidget {
  const _ProfileMenuItem({
    required this.item,
    required this.textColor,
    required this.secondaryTextColor,
    required this.isDark,
    required this.isLoading,
    required this.onTap,
  });

  final ProfileMenuItem item;
  final Color textColor;
  final Color secondaryTextColor;
  final bool isDark;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDestructive = item.isDestructive;
    final showLoading = item == ProfileMenuItem.logout && isLoading;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isDestructive
                    ? AppColors.error.withValues(alpha: 0.12)
                    : AppColors.primary.withValues(alpha: isDark ? 0.22 : 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                item.icon,
                color: isDestructive ? AppColors.error : AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                item.title,
                style: AppTypography.bodyLargeSemiBold.copyWith(
                  color: isDestructive ? AppColors.error : textColor,
                ),
              ),
            ),
            if (isDestructive)
              if (showLoading)
                const LoadingWidget(size: 20, color: AppColors.error)
              else
                const SizedBox.shrink()
            else
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceVariant
                      : const Color(0xFFF4F2F7),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: secondaryTextColor,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
