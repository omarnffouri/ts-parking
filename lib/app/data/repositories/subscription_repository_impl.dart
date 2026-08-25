import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/create_subscription_response_entity.dart';
import '../../domain/entities/invoice_entity.dart';
import '../../domain/entities/subscription_entity.dart';
import '../../domain/params/create_subscription_params.dart';
import '../models/paginated_response.dart';
import '../../domain/params/pay_invoice_params.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../datasources/subscription_remote_datasource.dart';

class SubscriptionRepositoryImpl implements SubscriptionRepository {
  final SubscriptionRemoteDataSource dataSource;

  SubscriptionRepositoryImpl({required this.dataSource});

  Future<Either<Failure, T>> _safe<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<SubscriptionEntity>>>
  getSubscriptions({int page = 1, int limit = 6}) =>
      _safe(() => dataSource.getSubscriptions(page: page, limit: limit));

  @override
  Future<Either<Failure, CreateSubscriptionResponseEntity>> createSubscriptions(
    CreateSubscriptionParams params,
  ) => _safe(() => dataSource.createSubscriptions(params));

  @override
  Future<Either<Failure, InvoiceEntity>> payInvoice(PayInvoiceParams params) =>
      _safe(() => dataSource.payInvoice(params));

  @override
  Future<Either<Failure, PaginatedResponse<InvoiceEntity>>> getInvoices({
    int page = 1,
    int limit = 10,
  }) => _safe(() => dataSource.getInvoices(page: page, limit: limit));

  @override
  Future<Either<Failure, InvoiceEntity>> getInvoiceById(int id) =>
      _safe(() => dataSource.getInvoiceById(id));

  @override
  Future<Either<Failure, void>> deleteSubscription(int id) =>
      _safe(() => dataSource.deleteSubscription(id));
}
