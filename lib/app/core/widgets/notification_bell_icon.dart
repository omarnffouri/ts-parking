import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_pages.dart';
import '../services/notification_service.dart';

class NotificationBellIcon extends StatelessWidget {
  final Color iconColor;
  final double iconSize;

  const NotificationBellIcon({
    super.key,
    this.iconColor = Colors.white,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<NotificationService>()) {
      return Icon(
        Icons.notifications_outlined,
        color: iconColor,
        size: iconSize,
      );
    }

    final service = Get.find<NotificationService>();

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
      child: Obx(() {
        final count = service.unreadCount.value;
        return Badge(
          isLabelVisible: count > 0,
          label: Text(
            count > 99 ? '99+' : '$count',
            style: const TextStyle(fontSize: 10),
          ),
          child: Icon(
            Icons.notifications_outlined,
            color: iconColor,
            size: iconSize,
          ),
        );
      }),
    );
  }
}
