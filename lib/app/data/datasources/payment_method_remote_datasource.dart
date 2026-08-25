import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/exceptions.dart';
import '../../core/network/dio_client.dart';
import '../models/payment_transaction_model.dart';
import '../models/user_card_model.dart';

abstract class PaymentMethodRemoteDataSource {
  Future<void> addCard({required String paymentToken});
  Future<List<UserCardModel>> getUserCards();
  Future<List<PaymentTransactionModel>> getTransactions();
  Future<void> setDefaultCard({required String cardId});
  Future<void> deleteCard({required String cardId});
}

class PaymentMethodRemoteDataSourceImpl
    implements PaymentMethodRemoteDataSource {
  PaymentMethodRemoteDataSourceImpl({required this.dioClient});

  final DioClient dioClient;

  Never _handleDioError(DioException e) {
    final message = e.response?.data['message'];
    final statusCode = e.response?.statusCode;

    if (statusCode == 400 || statusCode == 422) {
      throw ValidationException(message ?? 'Invalid payment token');
    }

    if (statusCode == 401) {
      throw AuthException(message ?? 'Authentication failed');
    }

    throw NetworkException(message ?? 'Network error occurred');
  }

  @override
  Future<void> addCard({required String paymentToken}) async {
    try {
      await dioClient.dio.post(
        AppConstants.addCard,
        data: {'payment_token': paymentToken},
      );
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw const ServerException('Failed to add card');
    }
  }

  @override
  Future<void> setDefaultCard({required String cardId}) async {
    try {
      await dioClient.dio.get('${AppConstants.setDefaultCard}/$cardId');
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw const ServerException('Failed to set default card');
    }
  }

  @override
  Future<void> deleteCard({required String cardId}) async {
    final path = '${AppConstants.deleteCard}/$cardId';

    try {
      await dioClient.dio.delete(path);
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        try {
          await dioClient.dio.get(path);
          return;
        } on DioException catch (fallbackError) {
          _handleDioError(fallbackError);
        } catch (_) {
          throw const ServerException('Failed to delete card');
        }
      }
      _handleDioError(e);
    } catch (_) {
      throw const ServerException('Failed to delete card');
    }
  }

  @override
  Future<List<UserCardModel>> getUserCards() async {
    try {
      final response = await dioClient.dio.get(AppConstants.userCards);
      final cardsJson = response.data['data']['cards'] as List<dynamic>;
      return cardsJson
          .map((json) => UserCardModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw const ServerException('Failed to fetch cards');
    }
  }

  @override
  Future<List<PaymentTransactionModel>> getTransactions() async {
    try {
      final response = await dioClient.dio.get(AppConstants.transactions);
      final transactionsJson =
          response.data['data'] as List<dynamic>? ?? const [];
      return transactionsJson
          .map(
            (json) =>
                PaymentTransactionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (_) {
      throw const ServerException('Failed to fetch transactions');
    }
  }
}
