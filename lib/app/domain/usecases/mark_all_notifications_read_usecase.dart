import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/notification_repository.dart';

class MarkAllNotificationsReadUsecase {
  final INotificationRepository repository;

  MarkAllNotificationsReadUsecase(this.repository);

  Future<Either<Failure, void>> execute() {
    return repository.markAllAsRead();
  }
}
