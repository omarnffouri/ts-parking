import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/subscription_entity.dart';
import '../repositories/subscription_repository.dart';

class GetSubscriptionsUsecase {
  final SubscriptionRepository repository;

  GetSubscriptionsUsecase(this.repository);

  Future<Either<Failure, PaginatedResponse<SubscriptionEntity>>> execute({
    int page = 1,
    int limit = 6,
  }) {
    return repository.getSubscriptions(page: page, limit: limit);
  }
}
