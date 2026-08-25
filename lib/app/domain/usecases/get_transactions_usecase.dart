import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/payment_transaction_entity.dart';
import '../repositories/payment_method_repository.dart';

class GetTransactionsUsecase {
  GetTransactionsUsecase(this.repository);

  final PaymentMethodRepository repository;

  Future<Either<Failure, List<PaymentTransactionEntity>>> execute() async {
    return repository.getTransactions();
  }
}
