import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/domain/entities/payment_transaction_entity.dart';
import 'package:ts_parking/app/domain/entities/user_card_entity.dart';
import 'package:ts_parking/app/domain/usecases/add_card_usecase.dart';
import 'package:ts_parking/app/domain/usecases/delete_card_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_transactions_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_user_cards_usecase.dart';
import 'package:ts_parking/app/domain/usecases/set_default_card_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  // ---------------------------------------------------------------------------
  // AddCardUsecase
  // ---------------------------------------------------------------------------
  group('AddCardUsecase', () {
    late MockPaymentMethodRepository mockRepo;
    late AddCardUsecase usecase;

    setUp(() {
      mockRepo = MockPaymentMethodRepository();
      usecase = AddCardUsecase(mockRepo);
    });

    test('delegates to repository.addCard and returns result', () async {
      when(
        mockRepo.addCard(paymentToken: 'tok_test_123'),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute('tok_test_123');

      result.fold(
        (failure) => fail('expected Right but got Left($failure)'),
        (_) => expect(true, isTrue),
      );
      verify(mockRepo.addCard(paymentToken: 'tok_test_123')).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('card add failed');
      when(
        mockRepo.addCard(paymentToken: 'tok_bad'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute('tok_bad');

      expect(result, const Left(failure));
      verify(mockRepo.addCard(paymentToken: 'tok_bad')).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // DeleteCardUsecase
  // ---------------------------------------------------------------------------
  group('DeleteCardUsecase', () {
    late MockPaymentMethodRepository mockRepo;
    late DeleteCardUsecase usecase;

    setUp(() {
      mockRepo = MockPaymentMethodRepository();
      usecase = DeleteCardUsecase(mockRepo);
    });

    test('delegates to repository.deleteCard and returns result', () async {
      when(
        mockRepo.deleteCard(cardId: 'card_42'),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute('card_42');

      result.fold(
        (failure) => fail('expected Right but got Left($failure)'),
        (_) => expect(true, isTrue),
      );
      verify(mockRepo.deleteCard(cardId: 'card_42')).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('delete failed');
      when(
        mockRepo.deleteCard(cardId: 'card_42'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute('card_42');

      expect(result, const Left(failure));
      verify(mockRepo.deleteCard(cardId: 'card_42')).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetUserCardsUsecase
  // ---------------------------------------------------------------------------
  group('GetUserCardsUsecase', () {
    late MockPaymentMethodRepository mockRepo;
    late GetUserCardsUsecase usecase;

    setUp(() {
      mockRepo = MockPaymentMethodRepository();
      usecase = GetUserCardsUsecase(mockRepo);
    });

    test('delegates to repository.getUserCards and returns result', () async {
      const expected = [
        UserCardEntity(
          id: 'c1',
          brand: 'visa',
          last4: '4242',
          expMonth: 12,
          expYear: 2026,
          isDefault: true,
        ),
      ];
      when(
        mockRepo.getUserCards(),
      ).thenAnswer((_) async => const Right(expected));

      final result = await usecase.execute();

      expect(result, const Right(expected));
      verify(mockRepo.getUserCards()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('cards fetch failed');
      when(
        mockRepo.getUserCards(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(mockRepo.getUserCards()).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // SetDefaultCardUsecase
  // ---------------------------------------------------------------------------
  group('SetDefaultCardUsecase', () {
    late MockPaymentMethodRepository mockRepo;
    late SetDefaultCardUsecase usecase;

    setUp(() {
      mockRepo = MockPaymentMethodRepository();
      usecase = SetDefaultCardUsecase(mockRepo);
    });

    test('delegates to repository.setDefaultCard and returns result', () async {
      when(
        mockRepo.setDefaultCard(cardId: 'card_7'),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute('card_7');

      result.fold(
        (failure) => fail('expected Right but got Left($failure)'),
        (_) => expect(true, isTrue),
      );
      verify(mockRepo.setDefaultCard(cardId: 'card_7')).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('set default failed');
      when(
        mockRepo.setDefaultCard(cardId: 'card_7'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute('card_7');

      expect(result, const Left(failure));
      verify(mockRepo.setDefaultCard(cardId: 'card_7')).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetTransactionsUsecase
  // ---------------------------------------------------------------------------
  group('GetTransactionsUsecase', () {
    late MockPaymentMethodRepository mockRepo;
    late GetTransactionsUsecase usecase;

    setUp(() {
      mockRepo = MockPaymentMethodRepository();
      usecase = GetTransactionsUsecase(mockRepo);
    });

    test(
      'delegates to repository.getTransactions and returns result',
      () async {
        const expected = [
          PaymentTransactionEntity(
            title: 'Parking Fee',
            subtitle: 'Zone A - Slot 1',
            timeLabel: '2 hours',
            amount: '25.00',
            isCredit: false,
            status: 'completed',
          ),
        ];
        when(
          mockRepo.getTransactions(),
        ).thenAnswer((_) async => const Right(expected));

        final result = await usecase.execute();

        result.fold(
          (failure) => fail('expected Right but got Left($failure)'),
          (transactions) => expect(transactions, expected),
        );
        verify(mockRepo.getTransactions()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('returns failure from repository', () async {
      const failure = ServerFailure('transactions fetch failed');
      when(
        mockRepo.getTransactions(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(mockRepo.getTransactions()).called(1);
    });
  });
}
