import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../params/register_params.dart';
import '../repositories/auth_repository.dart';

class RegisterUsecase {
  final AuthRepository repository;

  RegisterUsecase(this.repository);

  Future<Either<Failure, void>> execute(RegisterParams params) async {
    return await repository.register(params);
  }
}
