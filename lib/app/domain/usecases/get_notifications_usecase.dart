import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/notification_entity.dart';
import '../params/notification_params.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUsecase {
  final INotificationRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<Either<Failure, PaginatedResponse<NotificationEntity>>> execute({
    int page = 1,
    int limit = 20,
  }) {
    return repository.getNotifications(
      NotificationFilterParams(page: page, limit: limit),
    );
  }
}
