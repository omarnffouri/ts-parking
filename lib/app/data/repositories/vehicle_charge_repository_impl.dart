import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/vehicle_charge_entity.dart';
import '../../domain/params/pay_overstay_charge_params.dart';
import '../../domain/repositories/vehicle_charge_repository.dart';
import '../datasources/vehicle_charge_remote_datasource.dart';
import '../models/paginated_response.dart';

class VehicleChargeRepositoryImpl implements IVehicleChargeRepository {
  final IVehicleChargeDataSource dataSource;

  VehicleChargeRepositoryImpl({required this.dataSource});

  Future<Either<Failure, T>> _safe<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<VehicleChargeEntity>>>
  getVehicleCharges({int page = 1, int limit = 20}) =>
      _safe(() => dataSource.getVehicleCharges(page: page, limit: limit));

  @override
  Future<Either<Failure, void>> payOverstayCharge(
    PayOverstayChargeParams params,
  ) => _safe(() => dataSource.payOverstayCharge(params));
}
