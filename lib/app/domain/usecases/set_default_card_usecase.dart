import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/payment_method_repository.dart';

class SetDefaultCardUsecase {
  SetDefaultCardUsecase(this.repository);

  final PaymentMethodRepository repository;

  Future<Either<Failure, void>> execute(String cardId) async {
    return repository.setDefaultCard(cardId: cardId);
  }
}
