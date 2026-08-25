import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../../domain/entities/pricing_plan_entity.dart';
import '../../domain/entities/slot_entity.dart';
import '../../domain/entities/yard_entity.dart';
import '../../domain/entities/zone_entity.dart';
import '../../domain/repositories/yard_repository.dart';
import '../datasources/yard_datasource.dart';

class YardRepositoryImpl implements IYardRepository {
  final IYardDataSource dataSource;

  YardRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, PaginatedResponse<YardEntity>>> getYards({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final yards = await dataSource.getYards(page: page, limit: limit);
      return Right(yards);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<PricingPlanEntity>>> getPricingPlans() async {
    try {
      final plans = await dataSource.getPricingPlans();
      return Right(plans);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<SlotEntity>>> getYardSlots({
    required String yardId,
    int page = 1,
    int limit = 500,
  }) async {
    try {
      final slots = await dataSource.getYardSlots(
        yardId: yardId,
        page: page,
        limit: limit,
      );
      return Right(slots);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, List<ZoneEntity>>> getYardZones(String yardId) async {
    try {
      final zones = await dataSource.getYardZones(yardId);
      return Right(zones);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }
}
