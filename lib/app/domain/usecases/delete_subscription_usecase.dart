import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/subscription_repository.dart';

class DeleteSubscriptionUsecase {
  final SubscriptionRepository repository;

  DeleteSubscriptionUsecase(this.repository);

  Future<Either<Failure, void>> execute(int id) {
    return repository.deleteSubscription(id);
  }
}
