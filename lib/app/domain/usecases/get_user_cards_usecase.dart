import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/user_card_entity.dart';
import '../repositories/payment_method_repository.dart';

class GetUserCardsUsecase {
  GetUserCardsUsecase(this.repository);

  final PaymentMethodRepository repository;

  Future<Either<Failure, List<UserCardEntity>>> execute() async {
    return repository.getUserCards();
  }
}
