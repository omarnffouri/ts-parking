import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../params/pay_invoice_params.dart';
import '../repositories/subscription_repository.dart';

class PayInvoiceUsecase {
  final SubscriptionRepository repository;

  PayInvoiceUsecase(this.repository);

  Future<Either<Failure, InvoiceEntity>> execute(
    PayInvoiceParams params,
  ) async {
    return await repository.payInvoice(params);
  }
}
