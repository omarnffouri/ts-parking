import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../domain/usecases/get_subscriptions_usecase.dart';

class SubscriptionsController extends GetxController {
  final GetSubscriptionsUsecase getSubscriptionsUsecase;

  SubscriptionsController({required this.getSubscriptionsUsecase});

  static const double _loadMoreThreshold = 300.0;

  final scrollController = ScrollController();
  final _subscriptions = <SubscriptionEntity>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _hasMore = false.obs;

  List<SubscriptionEntity> get subscriptions => _subscriptions;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMore => _hasMore.value;

  int _currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    loadSubscriptions();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (scrollController.position.extentAfter < _loadMoreThreshold) {
      loadMore();
    }
  }

  Future<void> loadSubscriptions() async {
    _isLoading.value = true;
    _currentPage = 1;
    final result = await getSubscriptionsUsecase.execute(page: 1);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _subscriptions.assignAll(response.data);
      _hasMore.value = _subscriptions.length < response.meta.total;
    });
    _isLoading.value = false;
    _checkIfNeedsMore();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMore.value) return;
    _isLoadingMore.value = true;
    final nextPage = _currentPage + 1;
    final result = await getSubscriptionsUsecase.execute(page: nextPage);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _subscriptions.addAll(response.data);
      _currentPage = nextPage;
      _hasMore.value = _subscriptions.length < response.meta.total;
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
}
