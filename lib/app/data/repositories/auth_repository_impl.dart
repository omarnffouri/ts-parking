import 'package:dartz/dartz.dart';
import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/login_response.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/params/driver_params.dart';
import '../../domain/params/otp_params.dart';
import '../../domain/params/register_params.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, LoginResponse>> login(LoginParams params) async {
    try {
      final response = await remoteDataSource.login(params);

      if (response.verified && response.accessToken != null) {
        await localDataSource.cacheToken(response.accessToken!);
        if (response.user != null) {
          await localDataSource.cacheUser(response.user! as UserModel);
        }
      }

      return Right(response);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp(SendOtpParams params) async {
    try {
      final requestId = await remoteDataSource.sendOtp(params);
      return Right(requestId);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, LoginResponse>> verifyOtp(
    VerifyOtpParams params,
  ) async {
    try {
      final response = await remoteDataSource.verifyOtp(params);

      if (response.verified && response.accessToken != null) {
        await localDataSource.cacheToken(response.accessToken!);
        if (response.user != null) {
          await localDataSource.cacheUser(response.user! as UserModel);
        }
      }

      return Right(response);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> register(RegisterParams params) async {
    try {
      await remoteDataSource.register(params);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {
      // Continue even if remote logout fails
    }

    try {
      await localDataSource.clearCachedAuthData();
      return const Right(null);
    } catch (e) {
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(int userId) async {
    try {
      await remoteDataSource.deleteAccount(userId);
      await localDataSource.clearCachedAuthData();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      if (!await localDataSource.hasValidToken()) {
        return const Right(null);
      }
      final cachedUser = await localDataSource.getCachedUser();
      return Right(cachedUser);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to load cached user'));
    }
  }
}
