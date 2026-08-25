import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/notifications_controller.dart';
import 'widgets/notification_tile.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.md,
                AppSpacing.screenHorizontal,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: AppRadius.smallRadius,
                      child: const Padding(
                        padding: EdgeInsets.all(4),
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'Notifications',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Obx(() {
                    if (!controller.hasUnread) {
                      return const SizedBox.shrink();
                    }
                    return Material(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppRadius.smallRadius,
                      child: InkWell(
                        onTap: controller.markAllAsRead,
                        borderRadius: AppRadius.smallRadius,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.ms,
                            vertical: AppSpacing.xs,
                          ),
                          child: Text(
                            'Read All',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: context.backgroundColor,
                borderRadius: AppRadius.xlargeTopRadius,
              ),
              child: Obx(() {
                if (controller.isLoading) {
                  return const Center(child: LoadingWidget(size: 40));
                }

                if (controller.notifications.isEmpty) {
                  return const EmptyState(
                    icon: Icons.notifications_off_outlined,
                    title: 'No notifications',
                    message: "You're all caught up!",
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadNotifications,
                  color: AppColors.primary,
                  child: ListView.separated(
                    controller: controller.scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    itemCount:
                        controller.notifications.length +
                        (controller.isLoadingMore ? 1 : 0),
                    separatorBuilder: (_, __) => Divider(
                      height: 1,
                      indent: AppSpacing.md + 40 + AppSpacing.ms,
                      endIndent: AppSpacing.md,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.06),
                    ),
                    itemBuilder: (context, index) {
                      if (index == controller.notifications.length) {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.lg),
                          child: Center(child: LoadingWidget(size: 24)),
                        );
                      }

                      final notification = controller.notifications[index];
                      return NotificationTile(
                        key: ValueKey(notification.id),
                        notification: notification,
                        onTap: () => controller.onNotificationTap(notification),
                      );
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
