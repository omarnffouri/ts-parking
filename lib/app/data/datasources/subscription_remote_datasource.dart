import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../../domain/params/create_subscription_params.dart';
import '../../domain/params/pay_invoice_params.dart';
import '../models/create_subscription_response_model.dart';
import '../models/invoice_model.dart';
import '../models/paginated_response.dart';
import '../models/subscription_model.dart';

abstract class SubscriptionRemoteDataSource {
  Future<PaginatedResponse<SubscriptionModel>> getSubscriptions({
    int page = 1,
    int limit = 6,
  });

  Future<CreateSubscriptionResponseModel> createSubscriptions(
    CreateSubscriptionParams params,
  );

  Future<InvoiceModel> payInvoice(PayInvoiceParams params);

  Future<PaginatedResponse<InvoiceModel>> getInvoices({
    int page = 1,
    int limit = 10,
  });

  Future<InvoiceModel> getInvoiceById(int id);

  Future<void> deleteSubscription(int id);
}

class SubscriptionRemoteDataSourceImpl implements SubscriptionRemoteDataSource {
  final DioClient dioClient;

  SubscriptionRemoteDataSourceImpl({required this.dioClient});

  Never _handleDioError(DioException e) {
    final message = e.response?.data?['message'];
    final statusCode = e.response?.statusCode;

    if (statusCode == 400 || statusCode == 422) {
      throw ValidationException(
        message?.toString() ?? 'Invalid subscription data',
      );
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
  Future<PaginatedResponse<SubscriptionModel>> getSubscriptions({
    int page = 1,
    int limit = 6,
  }) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.subscriptions,
        queryParameters: {'page': page, 'per_page': limit},
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        SubscriptionModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<CreateSubscriptionResponseModel> createSubscriptions(
    CreateSubscriptionParams params,
  ) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.subscriptions,
        data: params.toJson(),
      );
      return CreateSubscriptionResponseModel.fromJson(
        response.data as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<InvoiceModel> payInvoice(PayInvoiceParams params) async {
    try {
      final response = await dioClient.dio.post(
        AppConstants.payInvoice,
        data: params.toJson(),
      );
      final data = response.data['data'] as Map<String, dynamic>;
      return InvoiceModel.fromJson(data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<PaginatedResponse<InvoiceModel>> getInvoices({
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await dioClient.dio.get(
        AppConstants.invoices,
        queryParameters: {'page': page, 'per_page': limit},
      );
      return PaginatedResponse.fromJson(
        response.data as Map<String, dynamic>,
        InvoiceModel.fromJson,
      );
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<InvoiceModel> getInvoiceById(int id) async {
    try {
      final response = await dioClient.dio.get('${AppConstants.invoices}/$id');
      final data = response.data['data'] as Map<String, dynamic>;
      return InvoiceModel.fromJson(data);
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  @override
  Future<void> deleteSubscription(int id) async {
    try {
      await dioClient.dio.delete('${AppConstants.subscriptions}/$id');
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
