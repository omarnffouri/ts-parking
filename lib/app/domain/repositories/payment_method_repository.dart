import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/payment_transaction_entity.dart';
import '../entities/user_card_entity.dart';

abstract class PaymentMethodRepository {
  Future<Either<Failure, void>> addCard({required String paymentToken});
  Future<Either<Failure, List<UserCardEntity>>> getUserCards();
  Future<Either<Failure, List<PaymentTransactionEntity>>> getTransactions();
  Future<Either<Failure, void>> setDefaultCard({required String cardId});
  Future<Either<Failure, void>> deleteCard({required String cardId});
}
