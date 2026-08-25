import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class DeleteAccountUsecase {
  final AuthRepository repository;

  DeleteAccountUsecase(this.repository);

  Future<Either<Failure, void>> execute(int userId) {
    return repository.deleteAccount(userId);
  }
}
