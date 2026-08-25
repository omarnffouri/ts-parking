import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/payment_method_repository.dart';

class AddCardUsecase {
  AddCardUsecase(this.repository);

  final PaymentMethodRepository repository;

  Future<Either<Failure, void>> execute(String paymentToken) async {
    return repository.addCard(paymentToken: paymentToken);
  }
}
