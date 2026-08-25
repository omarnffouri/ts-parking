import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/payment_transaction_entity.dart';
import '../../domain/entities/user_card_entity.dart';
import '../../domain/repositories/payment_method_repository.dart';
import '../datasources/payment_method_remote_datasource.dart';

class PaymentMethodRepositoryImpl implements PaymentMethodRepository {
  PaymentMethodRepositoryImpl({required this.dataSource});

  final PaymentMethodRemoteDataSource dataSource;

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
  Future<Either<Failure, void>> addCard({required String paymentToken}) =>
      _safe(() => dataSource.addCard(paymentToken: paymentToken));

  @override
  Future<Either<Failure, void>> setDefaultCard({required String cardId}) =>
      _safe(() => dataSource.setDefaultCard(cardId: cardId));

  @override
  Future<Either<Failure, void>> deleteCard({required String cardId}) =>
      _safe(() => dataSource.deleteCard(cardId: cardId));

  @override
  Future<Either<Failure, List<UserCardEntity>>> getUserCards() =>
      _safe(() => dataSource.getUserCards());

  @override
  Future<Either<Failure, List<PaymentTransactionEntity>>> getTransactions() =>
      _safe(() => dataSource.getTransactions());
}
