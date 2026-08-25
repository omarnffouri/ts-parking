import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../home/views/home_view.dart';
import '../../map/views/map_view.dart';
import '../../profile/views/profile_view.dart';
import '../controllers/main_screen_controller.dart';

class MainScreenView extends GetView<MainScreenController> {
  const MainScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    const pages = [HomeView(), MapView(), ProfileView()];

    return Scaffold(
      extendBody: true,
      body: Obx(() {
        final index = controller.currentIndex.value;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeInOut,
          switchOutCurve: Curves.easeInOut,
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: KeyedSubtree(key: ValueKey(index), child: pages[index]),
        );
      }),
      bottomNavigationBar: _buildBottomNav(context, isDark),
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Container(
        height: 60,
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceVariant : AppColors.secondary,
          borderRadius: BorderRadius.circular(39),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.24 : 0.14),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ExcludeSemantics(
          child: Obx(() {
            final inactiveColor = isDark
                ? AppColors.darkTextSecondary
                : Colors.white.withValues(alpha: 0.92);

            const iconAssets = [
              'assets/svgs/nav_home.svg',
              'assets/svgs/nav_map.svg',
              'assets/svgs/nav_profile.svg',
            ];

            return Row(
              children: List.generate(iconAssets.length, (index) {
                final isSelected = controller.currentIndex.value == index;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      controller.changePage(index);
                    },
                    child: Center(
                      child: _AnimatedNavIcon(
                        assetPath: iconAssets[index],
                        isSelected: isSelected,
                        activeColor: AppColors.primary,
                        inactiveColor: inactiveColor,
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }
}

class _AnimatedNavIcon extends StatelessWidget {
  final String assetPath;
  final bool isSelected;
  final Color activeColor;
  final Color inactiveColor;

  const _AnimatedNavIcon({
    required this.assetPath,
    required this.isSelected,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutBack,
      scale: isSelected ? 1.12 : 1.0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        offset: isSelected ? const Offset(0, -0.08) : Offset.zero,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          opacity: isSelected ? 1 : 0.85,
          child: SvgPicture.asset(
            assetPath,
            width: 28,
            height: 28,
            colorFilter: ColorFilter.mode(
              isSelected ? activeColor : inactiveColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
