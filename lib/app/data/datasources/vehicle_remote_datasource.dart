import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../domain/params/add_vehicle_params.dart';
import '../../domain/params/update_vehicle_params.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_type_model.dart';

abstract class IVehicleDataSource {
  Future<List<VehicleTypeModel>> getVehicleTypes();
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel> addVehicle(AddVehicleParams params);
  Future<VehicleModel> updateVehicle(UpdateVehicleParams params);
  Future<void> deleteVehicle(String vehicleId);
}

class VehicleRemoteDataSourceImpl implements IVehicleDataSource {
  final DioClient dioClient;

  VehicleRemoteDataSourceImpl({required this.dioClient});

  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message'];
    if (statusCode == 401) {
      throw AuthException(message ?? 'Authentication failed');
    } else if (statusCode == 400) {
      throw ValidationException(message ?? 'Validation failed');
    } else if (statusCode == 404) {
      throw ServerException(message ?? 'Vehicle not found');
    }
    throw NetworkException(message ?? 'Network error occurred');
  }

  @override
  Future<List<VehicleTypeModel>> getVehicleTypes() async {
    try {
      final response = await dioClient.dio.get(AppConstants.vehicleTypes);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map(
            (json) => VehicleTypeModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to fetch vehicle types');
    }
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await dioClient.dio.get(AppConstants.vehicles);
      final data = response.data['data'] as List<dynamic>;
      return data
          .map((json) => VehicleModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to fetch vehicles');
    }
  }

  @override
  Future<VehicleModel> addVehicle(AddVehicleParams params) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.vehicles,
        data: params.toJson(),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return VehicleModel.fromJson(data);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to add vehicle');
    }
  }

  @override
  Future<VehicleModel> updateVehicle(UpdateVehicleParams params) async {
    try {
      final response = await dioClient.dio.put(
        '${AppConstants.vehicles}/${params.id}',
        data: params.toJson(),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return VehicleModel.fromJson(data);
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to update vehicle');
    }
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await dioClient.dio.delete('${AppConstants.vehicles}/$vehicleId');
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      throw ServerException('Failed to delete vehicle');
    }
  }
}
