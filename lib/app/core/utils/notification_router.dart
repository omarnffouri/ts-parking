import 'package:get/get.dart';

import '../enums/notification_type.dart';
import '../../routes/app_pages.dart';

class NotificationRouter {
  NotificationRouter._();

  static void handleNotificationTap(
    NotificationType type,
    Map<String, dynamic>? data,
  ) {
    if (type.isSubscriptionType) {
      Get.toNamed(Routes.SUBSCRIPTIONS);
      return;
    }

    switch (type) {
      case NotificationType.invoicePaid:
        final invoiceId = data?['id']?.toString();
        if (invoiceId != null) {
          Get.toNamed(Routes.INVOICE_DETAIL, arguments: invoiceId);
        } else {
          Get.toNamed(Routes.INVOICES);
        }
      default:
        break;
    }
  }
}
