import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../domain/params/pay_overstay_charge_params.dart';
import '../models/paginated_response.dart';
import '../models/vehicle_charge_model.dart';

abstract class IVehicleChargeDataSource {
  Future<PaginatedResponse<VehicleChargeModel>> getVehicleCharges({
    int page = 1,
    int limit = 20,
  });

  Future<void> payOverstayCharge(PayOverstayChargeParams params);
}

class VehicleChargeRemoteDataSourceImpl implements IVehicleChargeDataSource {
  final DioClient dioClient;

  VehicleChargeRemoteDataSourceImpl({required this.dioClient});

  Never _handleDioError(DioException e) {
    final message = e.response?.data?['message'];
    final statusCode = e.response?.statusCode;

    if (statusCode == 400 || statusCode == 422) {
      throw ValidationException(message?.toString() ?? 'Invalid request data');
    }
    if (statusCode == 401) {
      throw AuthException(message?.toString() ?? 'Authentication failed');
    }
    if (statusCode == 404) {
      throw ServerException(message?.toString() ?? 'Resource not found');
    }
    throw NetworkException(message?.toString() ?? 'Network error');
  }

  @override
  Future<PaginatedResponse<VehicleChargeModel>> getVehicleCharges({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.vehicleCharges,
        queryParameters: {'page': page, 'per_page': limit},
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        VehicleChargeModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> payOverstayCharge(PayOverstayChargeParams params) async {
    try {
      await dioClient.dio.post(
        '${AppConstants.overstayPay}/${params.chargeId}',
        data: params.toJson(),
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
