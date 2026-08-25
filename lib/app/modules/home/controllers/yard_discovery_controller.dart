import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/paginated_response.dart';
import '../../../domain/entities/yard_entity.dart';
import '../../../domain/usecases/get_yards_usecase.dart';

class YardDiscoveryController extends GetxController {
  final GetYardsUsecase getYardsUsecase;

  YardDiscoveryController({required this.getYardsUsecase});

  // ---------------------------------------------------------------------------
  // Reactive state
  // ---------------------------------------------------------------------------

  final _allYards = <YardEntity>[].obs;
  final _isLoading = false.obs;
  final _rawSearchQuery = ''.obs;
  final searchQuery = ''.obs;
  final sortMode = 'all'.obs;
  final _currentPage = 1.obs;
  final _limit = 20.obs;
  final _total = 0.obs;
  final _totalPages = 1.obs;
  final _hasMorePages = false.obs;

  // Search bar controller — disposed in onClose
  final searchTextController = TextEditingController();

  // ---------------------------------------------------------------------------
  // Computed getters
  // ---------------------------------------------------------------------------

  bool get isLoading => _isLoading.value;
  RxList<YardEntity> get allYardsRx => _allYards;
  int get currentPage => _currentPage.value;
  int get pageLimit => _limit.value;
  int get totalItems => _total.value;
  int get totalPages => _totalPages.value;
  bool get hasMorePages => _hasMorePages.value;
  bool get hasPreviousPage => _currentPage.value > 1;
  bool get hasNextPage =>
      _currentPage.value < _totalPages.value || _hasMorePages.value;

  List<YardEntity> get filteredYards {
    List<YardEntity> yards = List<YardEntity>.from(_allYards);

    // Apply search filter
    final query = searchQuery.value.trim().toLowerCase();
    if (query.isNotEmpty) {
      yards = yards
          .where(
            (y) =>
                y.name.toLowerCase().contains(query) ||
                y.address.toLowerCase().contains(query),
          )
          .toList();
    }

    // Apply sort
    if (sortMode.value == 'name') {
      yards.sort((a, b) => a.name.compareTo(b.name));
    }

    return yards;
  }

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();

    // Sync searchTextController → _rawSearchQuery, debounce into searchQuery
    searchTextController.addListener(() {
      _rawSearchQuery.value = searchTextController.text;
    });
    debounce(
      _rawSearchQuery,
      (val) => searchQuery.value = val,
      time: const Duration(milliseconds: 300),
    );

    _loadYards();
  }

  @override
  void onClose() {
    searchTextController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Private methods
  // ---------------------------------------------------------------------------

  Future<void> _loadYards({int page = 1, int? limit}) async {
    _isLoading.value = true;
    final result = await getYardsUsecase.execute(
      page: page,
      limit: limit ?? _limit.value,
    );
    result.fold(
      (failure) {
        _isLoading.value = false;
        ErrorHandler.showError('Error', failure.message);
      },
      (yardsResponse) {
        _allYards.assignAll(yardsResponse.data);
        _applyPaginationMeta(yardsResponse.meta);
        _isLoading.value = false;
      },
    );
  }

  void _applyPaginationMeta(PaginationMeta meta) {
    _currentPage.value = meta.page;
    _limit.value = meta.limit;
    _total.value = meta.total;
    _totalPages.value = meta.totalPages > 0 ? meta.totalPages : 1;
    _hasMorePages.value = meta.hasMore;
  }

  // ---------------------------------------------------------------------------
  // Public methods
  // ---------------------------------------------------------------------------

  void clearFilters() {
    sortMode.value = 'all';
    searchQuery.value = '';
    searchTextController.clear();
  }

  Future<void> refreshYards() async {
    await _loadYards(page: _currentPage.value, limit: _limit.value);
  }

  Future<void> goToNextPage() async {
    if (!hasNextPage || _isLoading.value) return;
    await _loadYards(page: _currentPage.value + 1, limit: _limit.value);
  }

  Future<void> goToPreviousPage() async {
    if (!hasPreviousPage || _isLoading.value) return;
    await _loadYards(page: _currentPage.value - 1, limit: _limit.value);
  }
}
