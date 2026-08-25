import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/invoice_entity.dart';
import '../repositories/subscription_repository.dart';

class GetInvoiceByIdUsecase {
  final SubscriptionRepository repository;

  GetInvoiceByIdUsecase(this.repository);

  Future<Either<Failure, InvoiceEntity>> execute(int id) {
    return repository.getInvoiceById(id);
  }
}
