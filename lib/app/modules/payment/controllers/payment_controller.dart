import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../core/services/stripe_card_token_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/add_card_bottom_sheet.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/entities/user_card_entity.dart';
import '../../../domain/params/pay_invoice_params.dart';
import '../../../domain/params/payment_args.dart';
import '../../../domain/params/payment_success_args.dart';
import '../../../domain/usecases/add_card_usecase.dart';
import '../../../domain/usecases/get_user_cards_usecase.dart';
import '../../../domain/usecases/pay_invoice_usecase.dart';
import '../views/widgets/payment_success_view.dart';

class PaymentController extends GetxController {
  final PayInvoiceUsecase payInvoiceUsecase;
  final GetUserCardsUsecase getUserCardsUsecase;
  final AddCardUsecase addCardUsecase;
  final StripeCardTokenService stripeCardTokenService;

  PaymentController({
    required this.payInvoiceUsecase,
    required this.getUserCardsUsecase,
    required this.addCardUsecase,
    required this.stripeCardTokenService,
  });

  late final InvoiceEntity invoice;
  late final List<SubscriptionEntity> subscriptions;
  late final String yardName;

  final cards = <UserCardEntity>[].obs;
  final selectedCardId = Rxn<String>();
  final _isLoadingCards = true.obs;
  final _isPaying = false.obs;
  final paymentMethod = PayInvoiceParams.methodCard.obs;

  bool get isLoadingCards => _isLoadingCards.value;
  bool get isPaying => _isPaying.value;
  bool get isCash => paymentMethod.value == PayInvoiceParams.methodCash;
  bool get canPay => (isCash || selectedCardId.value != null) && !isPaying;

  void selectPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  // ---------------------------------------------------------------------------
  // Add card form state
  // ---------------------------------------------------------------------------

  final cardholderNameController = TextEditingController();
  final cardEditController = CardEditController();
  final _isCardComplete = false.obs;
  final _isAddingCard = false.obs;

  bool get isCardComplete => _isCardComplete.value;
  bool get isSubmitting => _isAddingCard.value;
  bool get canSubmitCard => !_isAddingCard.value && _isCardComplete.value;

  void onCardChanged(CardFieldInputDetails? details) {
    _isCardComplete.value = details?.complete ?? false;
  }

  void resetAddCardForm() {
    cardholderNameController.clear();
    if (cardEditController.hasCardField) {
      cardEditController.clear();
    }
    _isCardComplete.value = false;
    _isAddingCard.value = false;
  }

  Future<void> submitAddCard() async {
    if (!isCardComplete || isSubmitting) return;
    _isAddingCard.value = true;

    try {
      final paymentMethodId = await stripeCardTokenService
          .createCardPaymentMethodId(
            cardholderName: cardholderNameController.text.trim(),
          );

      final result = await addCardUsecase.execute(paymentMethodId);

      result.fold(
        (failure) {
          ErrorHandler.showError(
            'Add card failed',
            ErrorHandler.getErrorMessage(failure),
          );
        },
        (_) {
          Get.back();
          ErrorHandler.showSuccess('Card added successfully.');
          _loadCards();
        },
      );
    } catch (error) {
      ErrorHandler.showError(
        'Card setup failed',
        error.toString().replaceFirst('Exception: ', ''),
      );
    } finally {
      _isAddingCard.value = false;
    }
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as PaymentArgs;
    invoice = args.response.invoice!;
    subscriptions = args.response.subscriptions;
    yardName = args.yardName;
    _loadCards();
  }

  @override
  void onClose() {
    cardholderNameController.dispose();
    cardEditController.dispose();
    super.onClose();
  }

  Future<void> _loadCards() async {
    _isLoadingCards.value = true;
    final result = await getUserCardsUsecase.execute();
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      list,
    ) {
      cards.assignAll(list);
      final defaultCard = list.where((c) => c.isDefault).firstOrNull;
      if (defaultCard != null) {
        selectedCardId.value = defaultCard.id;
      } else if (list.isNotEmpty) {
        selectedCardId.value = list.first.id;
      }
    });
    _isLoadingCards.value = false;
  }

  void selectCard(String cardId) {
    selectedCardId.value = cardId;
  }

  Future<void> onPay() async {
    if (!canPay) return;
    _isPaying.value = true;

    try {
      final params = PayInvoiceParams(
        invoiceId: invoice.id,
        paymentMethod: paymentMethod.value,
        paymentToken: isCash ? null : selectedCardId.value!,
      );
      final result = await payInvoiceUsecase.execute(params);

      result.fold(
        (failure) => ErrorHandler.showError('Payment Failed', failure.message),
        (paidInvoice) {
          Get.off(
            () => const PaymentSuccessView(),
            arguments: PaymentSuccessArgs(
              subscriptions: subscriptions,
              invoice: paidInvoice,
            ),
          );
        },
      );
    } catch (_) {
      ErrorHandler.showError(
        'Error',
        'Something went wrong. Please try again.',
      );
    } finally {
      _isPaying.value = false;
    }
  }

  void openAddCardSheet() {
    resetAddCardForm();
    showAddCardBottomSheet(
      cardholderNameController: cardholderNameController,
      cardEditController: cardEditController,
      isCardComplete: _isCardComplete,
      isSubmitting: _isAddingCard,
      onCardChanged: onCardChanged,
      onSubmit: submitAddCard,
    );
  }
}
