import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/create_subscription_response_entity.dart';
import '../entities/subscription_entity.dart';
import '../entities/invoice_entity.dart';
import '../params/create_subscription_params.dart';
import '../params/pay_invoice_params.dart';

abstract class SubscriptionRepository {
  Future<Either<Failure, PaginatedResponse<SubscriptionEntity>>>
  getSubscriptions({int page = 1, int limit = 6});

  Future<Either<Failure, CreateSubscriptionResponseEntity>> createSubscriptions(
    CreateSubscriptionParams params,
  );

  Future<Either<Failure, InvoiceEntity>> payInvoice(PayInvoiceParams params);

  Future<Either<Failure, PaginatedResponse<InvoiceEntity>>> getInvoices({
    int page = 1,
    int limit = 10,
  });

  Future<Either<Failure, InvoiceEntity>> getInvoiceById(int id);

  Future<Either<Failure, void>> deleteSubscription(int id);
}
