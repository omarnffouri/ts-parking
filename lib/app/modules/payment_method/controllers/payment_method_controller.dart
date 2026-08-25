import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../core/services/stripe_card_token_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../domain/entities/payment_transaction_entity.dart';
import '../../../domain/entities/user_card_entity.dart';
import '../../../domain/usecases/add_card_usecase.dart';
import '../../../domain/usecases/delete_card_usecase.dart';
import '../../../domain/usecases/get_transactions_usecase.dart';
import '../../../domain/usecases/get_user_cards_usecase.dart';
import '../../../domain/usecases/set_default_card_usecase.dart';

class PaymentMethodController extends GetxController
    with GetSingleTickerProviderStateMixin {
  PaymentMethodController({
    required this.addCardUsecase,
    required this.deleteCardUsecase,
    required this.getTransactionsUsecase,
    required this.getUserCardsUsecase,
    required this.setDefaultCardUsecase,
    required this.stripeCardTokenService,
  });

  final AddCardUsecase addCardUsecase;
  final DeleteCardUsecase deleteCardUsecase;
  final GetTransactionsUsecase getTransactionsUsecase;
  final GetUserCardsUsecase getUserCardsUsecase;
  final SetDefaultCardUsecase setDefaultCardUsecase;
  final StripeCardTokenService stripeCardTokenService;

  final pageController = PageController(viewportFraction: 0.86);
  final cardholderNameController = TextEditingController();
  final cardEditController = CardEditController();

  final RxList<UserCardEntity> cards = <UserCardEntity>[].obs;
  final RxList<PaymentTransactionEntity> transactions =
      <PaymentTransactionEntity>[].obs;
  final isLoadingCards = false.obs;
  final isLoadingTransactions = false.obs;
  final isSettingDefault = false.obs;
  final isDeletingCard = false.obs;

  late final AnimationController bounceController;
  late final Animation<double> bounceOffset;
  int _bounceCount = 0;
  final _currentCardIndex = 0.obs;
  final isCardCompleteRx = false.obs;
  final isSubmittingRx = false.obs;

  int get currentCardIndex => _currentCardIndex.value;
  bool get isCardComplete => isCardCompleteRx.value;
  bool get isSubmitting => isSubmittingRx.value;
  bool get canSubmitCard => !isSubmittingRx.value && isCardCompleteRx.value;
  List<PaymentTransactionEntity> get recentTransactions =>
      transactions.take(5).toList();
  bool get hasMoreTransactions => transactions.length > 5;

  @override
  void onInit() {
    super.onInit();
    bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    bounceOffset = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0,
          end: -10,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 45,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: -10,
          end: 0,
        ).chain(CurveTween(curve: Curves.bounceOut)),
        weight: 55,
      ),
    ]).animate(bounceController);
    bounceController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _bounceCount++;
        if (_bounceCount < 4) {
          bounceController.forward(from: 0);
        }
      }
    });
    bounceController.forward();
    fetchUserCards();
    fetchTransactions();
  }

  Future<void> fetchUserCards() async {
    isLoadingCards.value = true;
    final result = await getUserCardsUsecase.execute();
    result.fold(
      (failure) => _showError('Cards', ErrorHandler.getErrorMessage(failure)),
      (data) => cards.assignAll(data),
    );
    isLoadingCards.value = false;
  }

  Future<void> fetchTransactions() async {
    isLoadingTransactions.value = true;
    final result = await getTransactionsUsecase.execute();
    result.fold(
      (failure) =>
          _showError('Transactions', ErrorHandler.getErrorMessage(failure)),
      (data) => transactions.assignAll(data),
    );
    isLoadingTransactions.value = false;
  }

  void onCardPageChanged(int index) {
    _currentCardIndex.value = index;
  }

  void onCardChanged(CardFieldInputDetails? details) {
    isCardCompleteRx.value = details?.complete ?? false;
  }

  void resetAddCardForm() {
    cardholderNameController.clear();
    if (cardEditController.hasCardField) {
      cardEditController.clear();
    }
    isCardCompleteRx.value = false;
    isSubmittingRx.value = false;
  }

  Future<void> submitAddCard() async {
    if (!isCardComplete || isSubmitting) {
      return;
    }

    isSubmittingRx.value = true;

    try {
      final paymentMethodId = await stripeCardTokenService
          .createCardPaymentMethodId(
            cardholderName: cardholderNameController.text.trim(),
          );

      final result = await addCardUsecase.execute(paymentMethodId);

      result.fold(
        (failure) {
          _showError('Add card failed', ErrorHandler.getErrorMessage(failure));
        },
        (_) {
          Get.back();
          _showSuccess('Card added successfully.');
          fetchUserCards();
        },
      );
    } catch (error) {
      _showError(
        'Card setup failed',
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      isSubmittingRx.value = false;
    }
  }

  Future<void> setDefaultCard(String cardId) async {
    if (cardId.isEmpty) return;
    isSettingDefault.value = true;
    final result = await setDefaultCardUsecase.execute(cardId);
    result.fold(
      (failure) => _showError(
        'Set default failed',
        ErrorHandler.getErrorMessage(failure),
      ),
      (_) {
        final updated = cards
            .map((c) => c.copyWith(isDefault: c.id == cardId))
            .toList();
        cards.assignAll(updated);
        _showSuccess('Default card updated.');
      },
    );
    isSettingDefault.value = false;
  }

  Future<bool> deleteCard(
    String cardId, {
    bool showSuccessMessage = true,
  }) async {
    if (cardId.isEmpty || isDeletingCard.value) {
      return false;
    }

    isDeletingCard.value = true;
    final result = await deleteCardUsecase.execute(cardId);
    var isDeleted = false;

    result.fold(
      (failure) => _showError(
        'Delete card failed',
        ErrorHandler.getErrorMessage(failure),
      ),
      (_) {
        cards.removeWhere((card) => card.id == cardId);
        if (showSuccessMessage) {
          _showSuccess('Card deleted successfully.');
        }
        isDeleted = true;
      },
    );

    isDeletingCard.value = false;
    return isDeleted;
  }

  void _showError(String title, String message) {
    if (Get.context == null) {
      return;
    }
    ErrorHandler.showError(title, message);
  }

  void _showSuccess(String message) {
    if (Get.context == null) {
      return;
    }
    ErrorHandler.showSuccess(message);
  }

  @override
  void onClose() {
    cardholderNameController.dispose();
    cardEditController.dispose();
    pageController.dispose();
    bounceController.dispose();
    super.onClose();
  }
}
