import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/notification_repository.dart';

class MarkNotificationReadUsecase {
  final INotificationRepository repository;

  MarkNotificationReadUsecase(this.repository);

  Future<Either<Failure, void>> execute(int id) {
    return repository.markAsRead(id);
  }
}
