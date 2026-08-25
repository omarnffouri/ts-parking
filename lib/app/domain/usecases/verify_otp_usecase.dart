import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/login_response.dart';
import '../params/otp_params.dart';
import '../repositories/auth_repository.dart';

class VerifyOtpUsecase {
  final AuthRepository repository;

  VerifyOtpUsecase(this.repository);

  Future<Either<Failure, LoginResponse>> execute(VerifyOtpParams params) async {
    return await repository.verifyOtp(params);
  }
}
