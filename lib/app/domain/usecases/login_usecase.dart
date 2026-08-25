import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../params/driver_params.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, LoginResponse>> execute(LoginParams params) {
    return repository.login(params);
  }
}
