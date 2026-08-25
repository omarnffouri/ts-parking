import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/notification_repository.dart';

class GetUnreadCountUsecase {
  final INotificationRepository repository;

  GetUnreadCountUsecase(this.repository);

  Future<Either<Failure, int>> execute() {
    return repository.getUnreadCount();
  }
}
