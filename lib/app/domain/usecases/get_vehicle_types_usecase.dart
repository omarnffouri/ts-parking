import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/vehicle_type_entity.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicleTypesUsecase {
  final IVehicleRepository repository;

  GetVehicleTypesUsecase(this.repository);

  Future<Either<Failure, List<VehicleTypeEntity>>> execute() async {
    return await repository.getVehicleTypes();
  }
}
