import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart' show CardFieldInputDetails;
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/domain/entities/payment_transaction_entity.dart';
import 'package:ts_parking/app/domain/entities/user_card_entity.dart';
import 'package:ts_parking/app/modules/payment_method/controllers/payment_method_controller.dart';

import '../../../../helpers/mocks.mocks.dart';

const _card1 = UserCardEntity(
  id: 'card_1',
  brand: 'visa',
  last4: '4242',
  expMonth: 12,
  expYear: 2028,
  isDefault: true,
);
const _card2 = UserCardEntity(
  id: 'card_2',
  brand: 'mastercard',
  last4: '5555',
  expMonth: 6,
  expYear: 2027,
);
const _transaction = PaymentTransactionEntity(
  title: 'Payment',
  subtitle: 'Online',
  timeLabel: 'Mar 20',
  amount: r'-$25.00',
  isCredit: false,
  status: 'paid',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAddCardUsecase mockAddCard;
  late MockDeleteCardUsecase mockDeleteCard;
  late MockGetTransactionsUsecase mockGetTransactions;
  late MockGetUserCardsUsecase mockGetUserCards;
  late MockSetDefaultCardUsecase mockSetDefaultCard;
  late MockStripeCardTokenService mockStripeService;
  late PaymentMethodController controller;

  setUp(() {
    Get.testMode = true;
    mockAddCard = MockAddCardUsecase();
    mockDeleteCard = MockDeleteCardUsecase();
    mockGetTransactions = MockGetTransactionsUsecase();
    mockGetUserCards = MockGetUserCardsUsecase();
    mockSetDefaultCard = MockSetDefaultCardUsecase();
    mockStripeService = MockStripeCardTokenService();

    controller = PaymentMethodController(
      addCardUsecase: mockAddCard,
      deleteCardUsecase: mockDeleteCard,
      getTransactionsUsecase: mockGetTransactions,
      getUserCardsUsecase: mockGetUserCards,
      setDefaultCardUsecase: mockSetDefaultCard,
      stripeCardTokenService: mockStripeService,
    );
  });

  group('fetchUserCards', () {
    test('populates cards list on success', () async {
      when(
        mockGetUserCards.execute(),
      ).thenAnswer((_) async => const Right([_card1, _card2]));

      await controller.fetchUserCards();

      expect(controller.cards.length, 2);
      expect(controller.cards.first.id, 'card_1');
      expect(controller.isLoadingCards.value, false);
      verify(mockGetUserCards.execute()).called(1);
    });

    test('sets isLoadingCards to false on failure', () async {
      when(
        mockGetUserCards.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('fetch failed')));

      await controller.fetchUserCards();

      expect(controller.cards, isEmpty);
      expect(controller.isLoadingCards.value, false);
      verify(mockGetUserCards.execute()).called(1);
    });
  });

  group('fetchTransactions', () {
    test('populates transactions list on success', () async {
      when(
        mockGetTransactions.execute(),
      ).thenAnswer((_) async => const Right([_transaction]));

      await controller.fetchTransactions();

      expect(controller.transactions.length, 1);
      expect(controller.transactions.first.title, 'Payment');
      expect(controller.isLoadingTransactions.value, false);
      verify(mockGetTransactions.execute()).called(1);
    });

    test('sets isLoadingTransactions to false on failure', () async {
      when(
        mockGetTransactions.execute(),
      ).thenAnswer((_) async => const Left(ServerFailure('fetch failed')));

      await controller.fetchTransactions();

      expect(controller.transactions, isEmpty);
      expect(controller.isLoadingTransactions.value, false);
      verify(mockGetTransactions.execute()).called(1);
    });
  });

  group('submitAddCard', () {
    test('calls stripe then addCardUsecase on success', () async {
      controller.onCardChanged(const CardFieldInputDetails(complete: true));
      when(
        mockStripeService.createCardPaymentMethodId(
          cardholderName: anyNamed('cardholderName'),
        ),
      ).thenAnswer((_) async => 'pm_test_123');
      when(
        mockAddCard.execute('pm_test_123'),
      ).thenAnswer((_) async => const Right(null));
      when(mockGetUserCards.execute()).thenAnswer((_) async => const Right([]));

      await controller.submitAddCard();

      verify(
        mockStripeService.createCardPaymentMethodId(
          cardholderName: anyNamed('cardholderName'),
        ),
      ).called(1);
      verify(mockAddCard.execute('pm_test_123')).called(1);
      expect(controller.isSubmitting, false);
    });

    test('does not call addCard when stripe fails', () async {
      controller.onCardChanged(const CardFieldInputDetails(complete: true));
      when(
        mockStripeService.createCardPaymentMethodId(
          cardholderName: anyNamed('cardholderName'),
        ),
      ).thenThrow(Exception('Stripe error'));

      await controller.submitAddCard();

      verify(
        mockStripeService.createCardPaymentMethodId(
          cardholderName: anyNamed('cardholderName'),
        ),
      ).called(1);
      verifyNever(mockAddCard.execute(any));
      expect(controller.isSubmitting, false);
    });

    test('resets isSubmitting on failure from repository', () async {
      controller.onCardChanged(const CardFieldInputDetails(complete: true));
      when(
        mockStripeService.createCardPaymentMethodId(
          cardholderName: anyNamed('cardholderName'),
        ),
      ).thenAnswer((_) async => 'pm_test');
      when(
        mockAddCard.execute('pm_test'),
      ).thenAnswer((_) async => const Left(ServerFailure('add failed')));

      await controller.submitAddCard();

      expect(controller.isSubmitting, false);
      verify(mockAddCard.execute('pm_test')).called(1);
    });

    test('does nothing when card is not complete', () async {
      await controller.submitAddCard();

      verifyZeroInteractions(mockStripeService);
      verifyZeroInteractions(mockAddCard);
    });
  });

  group('setDefaultCard', () {
    test('updates cards list locally on success', () async {
      controller.cards.assignAll([_card1, _card2]);
      when(
        mockSetDefaultCard.execute('card_2'),
      ).thenAnswer((_) async => const Right(null));

      await controller.setDefaultCard('card_2');

      final defaultCard = controller.cards.firstWhere((c) => c.isDefault);
      expect(defaultCard.id, 'card_2');
      verify(mockSetDefaultCard.execute('card_2')).called(1);
    });

    test('skips empty cardId', () async {
      controller.cards.assignAll([_card1]);

      await controller.setDefaultCard('');

      verifyZeroInteractions(mockSetDefaultCard);
    });
  });

  group('deleteCard', () {
    test('removes card from list on success', () async {
      controller.cards.assignAll([_card1, _card2]);
      when(
        mockDeleteCard.execute('card_2'),
      ).thenAnswer((_) async => const Right(null));

      final deleted = await controller.deleteCard('card_2');

      expect(deleted, true);
      expect(controller.cards.length, 1);
      expect(controller.cards.first.id, 'card_1');
      verify(mockDeleteCard.execute('card_2')).called(1);
    });

    test('returns false on failure', () async {
      controller.cards.assignAll([_card1, _card2]);
      when(
        mockDeleteCard.execute('card_2'),
      ).thenAnswer((_) async => const Left(ServerFailure('delete failed')));

      final deleted = await controller.deleteCard('card_2');

      expect(deleted, false);
      expect(controller.cards.length, 2);
      verify(mockDeleteCard.execute('card_2')).called(1);
    });

    test('returns false for empty cardId', () async {
      final deleted = await controller.deleteCard('');

      expect(deleted, false);
      verifyZeroInteractions(mockDeleteCard);
    });
  });

  group('onCardChanged', () {
    test('updates isCardComplete when details are complete', () {
      controller.onCardChanged(const CardFieldInputDetails(complete: true));
      expect(controller.isCardComplete, true);
    });

    test('updates isCardComplete to false when not complete', () {
      controller.onCardChanged(const CardFieldInputDetails(complete: false));
      expect(controller.isCardComplete, false);
    });

    test('handles null details', () {
      controller.onCardChanged(null);
      expect(controller.isCardComplete, false);
    });
  });

  group('canSubmitCard', () {
    test('is false when card is not complete', () {
      expect(controller.canSubmitCard, false);
    });

    test('is true when card is complete and not submitting', () {
      controller.onCardChanged(const CardFieldInputDetails(complete: true));
      expect(controller.canSubmitCard, true);
    });
  });
}
