import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/pricing_plan_model.dart';
import '../models/yard_model.dart';
import '../models/slot_model.dart';
import '../models/zone_model.dart';
import '../models/paginated_response.dart';

abstract class IYardDataSource {
  /// Returns yards with pagination metadata.
  Future<PaginatedResponse<YardModel>> getYards({int page = 1, int limit = 20});

  /// Returns all pricing plans.
  Future<List<PricingPlanModel>> getPricingPlans();

  /// Returns paginated slots for a specific yard.
  Future<PaginatedResponse<SlotModel>> getYardSlots({
    required String yardId,
    int page = 1,
    int limit = 500,
  });

  /// Returns zones for a specific yard.
  Future<List<ZoneModel>> getYardZones(String yardId);
}

class YardDataSourceImpl implements IYardDataSource {
  final DioClient dioClient;

  YardDataSourceImpl({required this.dioClient});

  Never _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message = e.response?.data?['message']?.toString();

    if (statusCode == 401) {
      throw AuthException(message ?? 'Authentication failed');
    } else if (statusCode == 400) {
      throw ValidationException(message ?? 'Validation failed');
    } else if (statusCode == 404) {
      throw ServerException(message ?? 'Yard not found');
    }
    throw NetworkException(message ?? 'Network error occurred');
  }

  @override
  Future<PaginatedResponse<YardModel>> getYards({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.yards,
        queryParameters: {'page': page, 'limit': limit},
      );
      return PaginatedResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
        YardModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw ServerException('Failed to fetch yards');
    }
  }

  @override
  Future<List<PricingPlanModel>> getPricingPlans() async {
    try {
      final response = await dioClient.dio.get(AppConstants.plans);
      final data = response.data['data'] as List<dynamic>? ?? const [];
      return data
          .map(
            (json) => PricingPlanModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw ServerException('Failed to fetch pricing plans');
    }
  }

  @override
  Future<PaginatedResponse<SlotModel>> getYardSlots({
    required String yardId,
    int page = 1,
    int limit = 500,
  }) async {
    try {
      final response = await dioClient.dio.get(
        '${AppConstants.yards}/$yardId/slots',
        queryParameters: {'page': page, 'per_page': limit},
      );
      return PaginatedResponse.fromJson(
        Map<String, dynamic>.from(response.data as Map),
        SlotModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw ServerException('Failed to fetch yard slots');
    }
  }

  @override
  Future<List<ZoneModel>> getYardZones(String yardId) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.yardZones,
        queryParameters: {'yard_id': yardId},
      );
      final data = response.data['data'] as List<dynamic>? ?? const [];
      return data
          .map((json) => ZoneModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw ServerException('Failed to fetch yard zones');
    }
  }
}
