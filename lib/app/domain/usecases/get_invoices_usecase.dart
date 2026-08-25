import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/invoice_entity.dart';
import '../repositories/subscription_repository.dart';

class GetInvoicesUsecase {
  final SubscriptionRepository repository;

  GetInvoicesUsecase(this.repository);

  Future<Either<Failure, PaginatedResponse<InvoiceEntity>>> execute({
    int page = 1,
    int limit = 10,
  }) {
    return repository.getInvoices(page: page, limit: limit);
  }
}
