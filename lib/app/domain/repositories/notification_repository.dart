import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/notification_entity.dart';
import '../params/notification_params.dart';

abstract class INotificationRepository {
  Future<Either<Failure, PaginatedResponse<NotificationEntity>>>
  getNotifications(NotificationFilterParams params);
  Future<Either<Failure, void>> markAsRead(int id);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, int>> getUnreadCount();
}
