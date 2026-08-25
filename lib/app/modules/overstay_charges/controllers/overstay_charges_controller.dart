import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../core/services/stripe_card_token_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/add_card_bottom_sheet.dart';
import '../../../domain/entities/user_card_entity.dart';
import '../../../domain/entities/vehicle_charge_entity.dart';
import '../../../domain/params/pay_overstay_charge_params.dart';
import '../../../domain/usecases/add_card_usecase.dart';
import '../../../domain/usecases/get_user_cards_usecase.dart';
import '../../../domain/usecases/get_vehicle_charges_usecase.dart';
import '../../../domain/usecases/pay_overstay_charge_usecase.dart';

class OverstayChargesController extends GetxController {
  final GetVehicleChargesUsecase getVehicleChargesUsecase;
  final PayOverstayChargeUsecase payOverstayChargeUsecase;
  final GetUserCardsUsecase getUserCardsUsecase;
  final AddCardUsecase addCardUsecase;
  final StripeCardTokenService stripeCardTokenService;

  OverstayChargesController({
    required this.getVehicleChargesUsecase,
    required this.payOverstayChargeUsecase,
    required this.getUserCardsUsecase,
    required this.addCardUsecase,
    required this.stripeCardTokenService,
  });

  static const double _loadMoreThreshold = 300.0;

  // List state
  final scrollController = ScrollController();
  final _charges = <VehicleChargeEntity>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _hasMore = false.obs;

  List<VehicleChargeEntity> get charges => _charges;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMore => _hasMore.value;

  int _currentPage = 1;

  // Payment state
  final cards = <UserCardEntity>[].obs;
  final selectedCardId = Rxn<String>();
  final paymentMethod = PayOverstayChargeParams.methodCard.obs;
  final _isPaying = false.obs;
  final _isLoadingCards = true.obs;

  bool get isPaying => _isPaying.value;
  bool get isLoadingCards => _isLoadingCards.value;
  bool get isCash => paymentMethod.value == PayOverstayChargeParams.methodCash;
  bool get canPay => (isCash || selectedCardId.value != null) && !isPaying;

  // Add card form state
  final cardholderNameController = TextEditingController();
  final cardEditController = CardEditController();
  final _isCardComplete = false.obs;
  final _isAddingCard = false.obs;

  bool get isCardComplete => _isCardComplete.value;
  bool get isSubmitting => _isAddingCard.value;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    Future.wait([loadCharges(), _loadCards()]);
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    cardholderNameController.dispose();
    cardEditController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // List pagination
  // ---------------------------------------------------------------------------

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < _loadMoreThreshold) {
      loadMore();
    }
  }

  Future<void> loadCharges() async {
    if (_isLoading.value) return;
    _isLoading.value = true;
    _currentPage = 1;
    final result = await getVehicleChargesUsecase.execute(page: 1);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _charges.assignAll(response.data);
      _hasMore.value = _charges.length < response.meta.total;
    });
    _isLoading.value = false;
    _checkIfNeedsMore();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore.value || _isLoading.value || !_hasMore.value) return;
    _isLoadingMore.value = true;
    final nextPage = _currentPage + 1;
    final result = await getVehicleChargesUsecase.execute(page: nextPage);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _charges.addAll(response.data);
      _currentPage = nextPage;
      _hasMore.value = _charges.length < response.meta.total;
    });
    _isLoadingMore.value = false;
  }

  void _checkIfNeedsMore() {
    if (!_hasMore.value) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      if (scrollController.position.extentAfter < _loadMoreThreshold) {
        loadMore();
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Card loading
  // ---------------------------------------------------------------------------

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

  void selectPaymentMethod(String method) {
    paymentMethod.value = method;
  }

  // ---------------------------------------------------------------------------
  // Payment
  // ---------------------------------------------------------------------------

  Future<void> payCharge(VehicleChargeEntity charge) async {
    if (!canPay) return;
    _isPaying.value = true;

    try {
      final params = PayOverstayChargeParams(
        chargeId: charge.id,
        paymentMethod: paymentMethod.value,
        paymentToken: isCash ? null : selectedCardId.value!,
      );
      final result = await payOverstayChargeUsecase.execute(params);

      result.fold(
        (failure) => ErrorHandler.showError('Payment Failed', failure.message),
        (_) {
          ErrorHandler.showSuccess('Payment successful');
          loadCharges();
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

  // ---------------------------------------------------------------------------
  // Add card
  // ---------------------------------------------------------------------------

  void onCardChanged(CardFieldInputDetails? details) {
    _isCardComplete.value = details?.complete ?? false;
  }

  void _resetAddCardForm() {
    cardholderNameController.clear();
    if (cardEditController.hasCardField) {
      cardEditController.clear();
    }
    _isCardComplete.value = false;
    _isAddingCard.value = false;
  }

  Future<void> _submitAddCard() async {
    if (!isCardComplete || isSubmitting) return;
    _isAddingCard.value = true;

    try {
      final paymentMethodId = await stripeCardTokenService
          .createCardPaymentMethodId(
            cardholderName: cardholderNameController.text.trim(),
          );

      final result = await addCardUsecase.execute(paymentMethodId);

      result.fold(
        (failure) => ErrorHandler.showError(
          'Add card failed',
          ErrorHandler.getErrorMessage(failure),
        ),
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

  void openAddCardSheet() {
    _resetAddCardForm();
    showAddCardBottomSheet(
      cardholderNameController: cardholderNameController,
      cardEditController: cardEditController,
      isCardComplete: _isCardComplete,
      isSubmitting: _isAddingCard,
      onCardChanged: onCardChanged,
      onSubmit: _submitAddCard,
    );
  }
}
