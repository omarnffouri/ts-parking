import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/zone_entity.dart';
import '../repositories/yard_repository.dart';

class GetYardZonesUsecase {
  final IYardRepository repository;

  GetYardZonesUsecase(this.repository);

  Future<Either<Failure, List<ZoneEntity>>> execute(String yardId) async {
    return await repository.getYardZones(yardId);
  }
}
