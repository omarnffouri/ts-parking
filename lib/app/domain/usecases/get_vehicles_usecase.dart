import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/vehicle_entity.dart';
import '../repositories/vehicle_repository.dart';

class GetVehiclesUsecase {
  final IVehicleRepository repository;

  GetVehiclesUsecase(this.repository);

  Future<Either<Failure, List<VehicleEntity>>> execute() async {
    return await repository.getVehicles();
  }
}
