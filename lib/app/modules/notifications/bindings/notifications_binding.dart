import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
      () => NotificationsController(
        getNotificationsUsecase: sl(),
        markNotificationReadUsecase: sl(),
        markAllNotificationsReadUsecase: sl(),
        notificationService: sl(),
      ),
    );
  }
}
