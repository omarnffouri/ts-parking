import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/vehicle_entity.dart';
import '../entities/vehicle_type_entity.dart';
import '../params/add_vehicle_params.dart';
import '../params/update_vehicle_params.dart';

abstract class IVehicleRepository {
  Future<Either<Failure, List<VehicleTypeEntity>>> getVehicleTypes();

  Future<Either<Failure, List<VehicleEntity>>> getVehicles();

  Future<Either<Failure, VehicleEntity>> addVehicle(AddVehicleParams params);

  Future<Either<Failure, VehicleEntity>> updateVehicle(
    UpdateVehicleParams params,
  );

  Future<Either<Failure, void>> deleteVehicle(String vehicleId);
}
