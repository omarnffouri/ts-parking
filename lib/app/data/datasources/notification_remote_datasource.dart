import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../domain/params/notification_params.dart';
import '../models/notification_model.dart';
import '../models/paginated_response.dart';

abstract class NotificationRemoteDataSource {
  Future<PaginatedResponse<NotificationModel>> getNotifications(
    NotificationFilterParams params,
  );
  Future<void> markAsRead(int id);
  Future<void> markAllAsRead();
  Future<int> getUnreadCount();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final DioClient dioClient;

  NotificationRemoteDataSourceImpl({required this.dioClient});

  Never _handleDioError(DioException e) {
    final message = e.response?.data?['message'];
    final statusCode = e.response?.statusCode;

    if (statusCode == 400 || statusCode == 422) {
      throw ValidationException(message?.toString() ?? 'Validation failed');
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
  Future<PaginatedResponse<NotificationModel>> getNotifications(
    NotificationFilterParams params,
  ) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.driverNotifications,
        queryParameters: params.toQueryParams(),
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        NotificationModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> markAsRead(int id) async {
    try {
      await dioClient.dio.put('${AppConstants.driverNotifications}/$id/read');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await dioClient.dio.put(AppConstants.driverNotificationsReadAll);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.driverNotificationsUnreadCount,
      );
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return (data['data'] as num?)?.toInt() ??
            (data['count'] as num?)?.toInt() ??
            0;
      }
      return 0;
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
