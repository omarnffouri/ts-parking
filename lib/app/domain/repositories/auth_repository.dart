import 'package:dartz/dartz.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import '../entities/login_response.dart';
import '../entities/user_entity.dart';
import '../params/driver_params.dart';
import '../params/otp_params.dart';
import '../params/register_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResponse>> login(LoginParams params);
  Future<Either<Failure, String>> sendOtp(SendOtpParams params);
  Future<Either<Failure, LoginResponse>> verifyOtp(VerifyOtpParams params);

  Future<Either<Failure, void>> register(RegisterParams params);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, void>> deleteAccount(int userId);
  Future<Either<Failure, UserEntity?>> getCachedUser();
}
