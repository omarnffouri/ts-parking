import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_remote_datasource.dart';

class SettingsRepositoryImpl implements ISettingsRepository {
  final ISettingsRemoteDataSource remoteDataSource;

  SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final settings = await remoteDataSource.getSettings();
      return Right(settings);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to fetch settings'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadProfileImage(String imagePath) async {
    try {
      await remoteDataSource.uploadProfileImage(imagePath);
      return const Right(null);
    } on ServerException catch (e) {
      print(e);
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      print(e);
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('Failed to upload profile image'));
    }
  }
}
