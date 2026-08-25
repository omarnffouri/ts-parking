import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import 'package:get/get.dart';

import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/notification_bell_icon.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../main_screen/controllers/main_screen_controller.dart';
import '../controllers/home_controller.dart';
import '../controllers/yard_discovery_controller.dart';
import 'widgets/yard_card.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final yardDiscovery = Get.find<YardDiscoveryController>();

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      body: Column(
        children: [
          _buildHeader(context, isDark),
          Expanded(
            child: RefreshIndicator(
              onRefresh: controller.refreshHome,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(context, isDark),
                  ),
                  _buildYardList(context, isDark, yardDiscovery),
                  SliverToBoxAdapter(
                    child: _buildPaginationControls(isDark, yardDiscovery),
                  ),
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.xl),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + AppSpacing.md,
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color.fromARGB(255, 202, 137, 6)
            : AppColors.accent,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xlarge),
          bottomRight: Radius.circular(AppRadius.xlarge),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(
                      () => Text(
                        'Hola, ${controller.userName.value} \u{1F44B}',
                        style: AppTypography.h2.copyWith(color: Colors.white),
                      ),
                    ),
                    AppSpacing.verticalSpaceXs,
                    Text(
                      'Find a parking yard near you',
                      style: AppTypography.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: AppRadius.mediumRadius,
                ),
                child: const NotificationBellIcon(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Nearby Parking Yards',
            style: AppTypography.h3.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          GestureDetector(
            onTap: () {
              try {
                final mainCtrl = Get.find<MainScreenController>();
                mainCtrl.changePage(1);
              } catch (_) {
                // MainScreenController not available in standalone route context
              }
            },
            child: Text(
              'View on map',
              style: AppTypography.bodySmallSemiBold.copyWith(
                color: AppColors.accent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYardList(
    BuildContext context,
    bool isDark,
    YardDiscoveryController yardDiscovery,
  ) {
    return Obx(() {
      if (yardDiscovery.isLoading) {
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: LoadingWidget(message: 'Loading yards...')),
        );
      }

      final yards = yardDiscovery.filteredYards;

      if (yards.isEmpty) {
        return SliverToBoxAdapter(child: _buildEmptyState(isDark));
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final yard = yards[index];
          return YardCard(
            yard: yard,
            onTap: () => Get.toNamed(Routes.SLOT_SELECTION, arguments: yard),
          );
        }, childCount: yards.length),
      );
    });
  }

  Widget _buildPaginationControls(
    bool isDark,
    YardDiscoveryController yardDiscovery,
  ) {
    return Obx(() {
      if (yardDiscovery.isLoading || yardDiscovery.totalPages <= 1) {
        return const SizedBox.shrink();
      }

      return Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          0,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: AppRadius.mediumRadius,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: yardDiscovery.hasPreviousPage
                    ? yardDiscovery.goToPreviousPage
                    : null,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  'Page ${yardDiscovery.currentPage} of ${yardDiscovery.totalPages} (${yardDiscovery.totalItems} total)',
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
              IconButton(
                onPressed: yardDiscovery.hasNextPage
                    ? yardDiscovery.goToNextPage
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildEmptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxl,
        horizontal: AppSpacing.xl,
      ),
      child: Column(
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 72,
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          AppSpacing.verticalSpaceMd,
          Text(
            'No yards found',
            style: AppTypography.h3.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            'Try adjusting your filters or search terms',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
