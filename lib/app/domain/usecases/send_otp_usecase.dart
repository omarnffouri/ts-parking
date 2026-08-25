import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../params/otp_params.dart';
import '../repositories/auth_repository.dart';

class SendOtpUsecase {
  final AuthRepository repository;

  SendOtpUsecase(this.repository);

  Future<Either<Failure, String>> execute(SendOtpParams params) async {
    return await repository.sendOtp(params);
  }
}
