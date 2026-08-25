import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/pricing_plan_entity.dart';
import '../repositories/yard_repository.dart';

class GetPricingPlansUsecase {
  final IYardRepository repository;

  GetPricingPlansUsecase(this.repository);

  Future<Either<Failure, List<PricingPlanEntity>>> execute() async {
    return await repository.getPricingPlans();
  }
}
