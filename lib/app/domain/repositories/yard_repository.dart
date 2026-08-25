import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/pricing_plan_entity.dart';
import '../entities/slot_entity.dart';
import '../entities/yard_entity.dart';
import '../entities/zone_entity.dart';

abstract class IYardRepository {
  /// Returns yards with pagination metadata.
  Future<Either<Failure, PaginatedResponse<YardEntity>>> getYards({
    int page = 1,
    int limit = 20,
  });

  /// Returns all pricing plans.
  Future<Either<Failure, List<PricingPlanEntity>>> getPricingPlans();

  /// Returns paginated slots for a specific yard.
  Future<Either<Failure, PaginatedResponse<SlotEntity>>> getYardSlots({
    required String yardId,
    int page = 1,
    int limit = 500,
  });

  /// Returns zones for a specific yard.
  Future<Either<Failure, List<ZoneEntity>>> getYardZones(String yardId);
}
