import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/payment_method_repository.dart';

class DeleteCardUsecase {
  DeleteCardUsecase(this.repository);

  final PaymentMethodRepository repository;

  Future<Either<Failure, void>> execute(String cardId) async {
    return repository.deleteCard(cardId: cardId);
  }
}
