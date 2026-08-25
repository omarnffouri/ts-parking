import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/create_subscription_response_entity.dart';
import '../params/create_subscription_params.dart';
import '../repositories/subscription_repository.dart';

class CreateSubscriptionsUsecase {
  final SubscriptionRepository repository;

  CreateSubscriptionsUsecase(this.repository);

  Future<Either<Failure, CreateSubscriptionResponseEntity>> execute(
    CreateSubscriptionParams params,
  ) async {
    return await repository.createSubscriptions(params);
  }
}
