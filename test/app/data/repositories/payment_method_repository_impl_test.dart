import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/payment_method_remote_datasource.dart';
import 'package:ts_parking/app/data/models/payment_transaction_model.dart';
import 'package:ts_parking/app/data/models/user_card_model.dart';
import 'package:ts_parking/app/data/repositories/payment_method_repository_impl.dart';

class FakePaymentMethodRemoteDataSource
    implements PaymentMethodRemoteDataSource {
  Exception? addCardError;
  bool addCardCalled = false;
  List<UserCardModel>? getUserCardsResult;
  Exception? getUserCardsError;
  List<PaymentTransactionModel>? getTransactionsResult;
  Exception? getTransactionsError;
  Exception? setDefaultCardError;
  String? setDefaultCardId;
  Exception? deleteCardError;
  String? deletedCardId;

  @override
  Future<void> addCard({required String paymentToken}) async {
    addCardCalled = true;
    if (addCardError != null) throw addCardError!;
  }

  @override
  Future<List<UserCardModel>> getUserCards() async {
    if (getUserCardsError != null) throw getUserCardsError!;
    return getUserCardsResult!;
  }

  @override
  Future<List<PaymentTransactionModel>> getTransactions() async {
    if (getTransactionsError != null) throw getTransactionsError!;
    return getTransactionsResult!;
  }

  @override
  Future<void> setDefaultCard({required String cardId}) async {
    setDefaultCardId = cardId;
    if (setDefaultCardError != null) throw setDefaultCardError!;
  }

  @override
  Future<void> deleteCard({required String cardId}) async {
    deletedCardId = cardId;
    if (deleteCardError != null) throw deleteCardError!;
  }
}

const _card1 = UserCardModel(
  id: 'card_1',
  brand: 'visa',
  last4: '4242',
  expMonth: 12,
  expYear: 2028,
  isDefault: true,
);
const _card2 = UserCardModel(
  id: 'card_2',
  brand: 'mastercard',
  last4: '5555',
  expMonth: 6,
  expYear: 2027,
);
const _transaction = PaymentTransactionModel(
  title: 'Payment',
  subtitle: 'Online - Paid',
  timeLabel: 'Mar 20, 02:30 PM',
  amount: r'-$25.00',
  isCredit: false,
  status: 'paid',
);

void main() {
  late FakePaymentMethodRemoteDataSource fakeDataSource;
  late PaymentMethodRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakePaymentMethodRemoteDataSource();
    repository = PaymentMethodRepositoryImpl(dataSource: fakeDataSource);
  });

  group('addCard', () {
    test('returns Right(void) on success', () async {
      final result = await repository.addCard(paymentToken: 'pm_test');
      expect(result, isA<Right>());
      expect(fakeDataSource.addCardCalled, true);
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.addCardError = const ServerException('add failed');
      final result = await repository.addCard(paymentToken: 'pm_test');
      expect(result, const Left(ServerFailure('add failed')));
    });
    test('returns Left(AuthFailure) on AuthException', () async {
      fakeDataSource.addCardError = const AuthException('unauthorized');
      final result = await repository.addCard(paymentToken: 'pm_test');
      expect(result, const Left(AuthFailure('unauthorized')));
    });
    test('returns Left(ValidationFailure) on ValidationException', () async {
      fakeDataSource.addCardError = const ValidationException('invalid token');
      final result = await repository.addCard(paymentToken: 'pm_test');
      expect(result, const Left(ValidationFailure('invalid token')));
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.addCardError = const NetworkException('no connection');
      final result = await repository.addCard(paymentToken: 'pm_test');
      expect(result, const Left(NetworkFailure('no connection')));
    });
    test('returns Left(UnexpectedFailure) on unknown exception', () async {
      fakeDataSource.addCardError = Exception('oops');
      final result = await repository.addCard(paymentToken: 'pm_test');
      expect(
        result,
        const Left(UnexpectedFailure('An unexpected error occurred')),
      );
    });
  });

  group('getUserCards', () {
    test('returns Right(list) on success', () async {
      fakeDataSource.getUserCardsResult = [_card1, _card2];
      final result = await repository.getUserCards();
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (cards) {
        expect(cards.length, 2);
        expect(cards.first.id, 'card_1');
      });
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.getUserCardsError = const ServerException('fetch failed');
      final result = await repository.getUserCards();
      expect(result, const Left(ServerFailure('fetch failed')));
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.getUserCardsError = const NetworkException('offline');
      final result = await repository.getUserCards();
      expect(result, const Left(NetworkFailure('offline')));
    });
  });

  group('getTransactions', () {
    test('returns Right(list) on success', () async {
      fakeDataSource.getTransactionsResult = [_transaction];
      final result = await repository.getTransactions();
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (txns) {
        expect(txns.length, 1);
        expect(txns.first.title, 'Payment');
      });
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.getTransactionsError = const ServerException('txn failed');
      final result = await repository.getTransactions();
      expect(result, const Left(ServerFailure('txn failed')));
    });
    test('returns Left(AuthFailure) on AuthException', () async {
      fakeDataSource.getTransactionsError = const AuthException(
        'not authenticated',
      );
      final result = await repository.getTransactions();
      expect(result, const Left(AuthFailure('not authenticated')));
    });
  });

  group('setDefaultCard', () {
    test('returns Right(void) on success', () async {
      final result = await repository.setDefaultCard(cardId: 'card_1');
      expect(result, isA<Right>());
      expect(fakeDataSource.setDefaultCardId, 'card_1');
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.setDefaultCardError = const ServerException(
        'default failed',
      );
      final result = await repository.setDefaultCard(cardId: 'card_1');
      expect(result, const Left(ServerFailure('default failed')));
    });
  });

  group('deleteCard', () {
    test('returns Right(void) on success', () async {
      final result = await repository.deleteCard(cardId: 'card_2');
      expect(result, isA<Right>());
      expect(fakeDataSource.deletedCardId, 'card_2');
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.deleteCardError = const ServerException('delete failed');
      final result = await repository.deleteCard(cardId: 'card_2');
      expect(result, const Left(ServerFailure('delete failed')));
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.deleteCardError = const NetworkException('offline');
      final result = await repository.deleteCard(cardId: 'card_2');
      expect(result, const Left(NetworkFailure('offline')));
    });
  });
}
