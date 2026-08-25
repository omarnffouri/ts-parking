import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/entities/vehicle_type_entity.dart';
import '../../domain/params/add_vehicle_params.dart';
import '../../domain/params/update_vehicle_params.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasources/vehicle_remote_datasource.dart';

class VehicleRepositoryImpl implements IVehicleRepository {
  final IVehicleDataSource dataSource;

  VehicleRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<VehicleTypeEntity>>> getVehicleTypes() async {
    try {
      final types = await dataSource.getVehicleTypes();
      return Right(types);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<VehicleEntity>>> getVehicles() async {
    try {
      final vehicles = await dataSource.getVehicles();
      return Right(vehicles);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> addVehicle(
    AddVehicleParams params,
  ) async {
    try {
      final vehicle = await dataSource.addVehicle(params);
      return Right(vehicle);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, VehicleEntity>> updateVehicle(
    UpdateVehicleParams params,
  ) async {
    try {
      final vehicle = await dataSource.updateVehicle(params);
      return Right(vehicle);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteVehicle(String vehicleId) async {
    try {
      await dataSource.deleteVehicle(vehicleId);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }
}
