import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../repositories/vehicle_repository.dart';

class DeleteVehicleUsecase {
  final IVehicleRepository repository;

  DeleteVehicleUsecase(this.repository);

  Future<Either<Failure, void>> execute(String vehicleId) async {
    return await repository.deleteVehicle(vehicleId);
  }
}
