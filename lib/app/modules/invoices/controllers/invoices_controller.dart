import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../domain/usecases/get_invoices_usecase.dart';

class InvoicesController extends GetxController {
  final GetInvoicesUsecase getInvoicesUsecase;

  InvoicesController({required this.getInvoicesUsecase});

  static const double _loadMoreThreshold = 300.0;

  final scrollController = ScrollController();
  final _invoices = <InvoiceEntity>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _hasMore = false.obs;

  List<InvoiceEntity> get invoices => _invoices;
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
    loadInvoices();
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

  Future<void> loadInvoices() async {
    if (_isLoading.value) return;
    _isLoading.value = true;
    _currentPage = 1;
    final result = await getInvoicesUsecase.execute(page: 1);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _invoices.assignAll(response.data);
      _hasMore.value = _invoices.length < response.meta.total;
    });
    _isLoading.value = false;
    _checkIfNeedsMore();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore.value || _isLoading.value || !_hasMore.value) return;
    _isLoadingMore.value = true;
    final nextPage = _currentPage + 1;
    final result = await getInvoicesUsecase.execute(page: nextPage);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _invoices.addAll(response.data);
      _currentPage = nextPage;
      _hasMore.value = _invoices.length < response.meta.total;
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
