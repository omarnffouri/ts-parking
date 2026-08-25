import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import 'package:ts_parking/app/modules/profile/views/widgets/menu_group_card.dart';
import 'package:ts_parking/app/modules/profile/views/widgets/profile_hero_card.dart';

import '../../../theme/app_spacing.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                ProfileHeroCard(
                  controller: controller,
                  isDark: isDark,
                  surfaceColor: context.surfaceColor,
                  textColor: context.primaryTextColor,
                  secondaryTextColor: context.secondaryTextColor,
                  onBack: () => Get.back(),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.lg,
                    0,
                    AppSpacing.lg,
                    MediaQuery.of(context).padding.bottom + AppSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      MenuGroupCard(
                        isDark: isDark,
                        surfaceColor: context.surfaceColor,
                        textColor: context.primaryTextColor,
                        secondaryTextColor: context.secondaryTextColor,
                        items: controller.primaryMenuItems,
                        onTap: controller.onMenuTap,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Obx(
                        () => MenuGroupCard(
                          isDark: isDark,
                          surfaceColor: context.surfaceColor,
                          textColor: context.primaryTextColor,
                          secondaryTextColor: context.secondaryTextColor,
                          items: controller.accountItems,
                          isLoading: controller.isLoggingOut,
                          onTap: controller.onMenuTap,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
