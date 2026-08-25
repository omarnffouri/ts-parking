import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/utils/notification_router.dart';
import '../../../domain/entities/notification_entity.dart';
import '../../../domain/usecases/get_notifications_usecase.dart';
import '../../../domain/usecases/mark_all_notifications_read_usecase.dart';
import '../../../domain/usecases/mark_notification_read_usecase.dart';

class NotificationsController extends GetxController {
  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkNotificationReadUsecase markNotificationReadUsecase;
  final MarkAllNotificationsReadUsecase markAllNotificationsReadUsecase;
  final NotificationService notificationService;

  NotificationsController({
    required this.getNotificationsUsecase,
    required this.markNotificationReadUsecase,
    required this.markAllNotificationsReadUsecase,
    required this.notificationService,
  });

  static const double _loadMoreThreshold = 300.0;

  final scrollController = ScrollController();
  final _notifications = <NotificationEntity>[].obs;
  final _isLoading = false.obs;
  final _isLoadingMore = false.obs;
  final _hasMore = false.obs;

  List<NotificationEntity> get notifications => _notifications;
  bool get isLoading => _isLoading.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMore => _hasMore.value;
  bool get hasUnread => notificationService.unreadCount.value > 0;

  int _currentPage = 1;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(_onScroll);
  }

  @override
  void onReady() {
    super.onReady();
    loadNotifications();
  }

  @override
  void onClose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (!scrollController.hasClients) return;
    if (_isLoadingMore.value || !_hasMore.value) return;
    if (scrollController.position.extentAfter < _loadMoreThreshold) {
      loadMore();
    }
  }

  Future<void> loadNotifications() async {
    _isLoading.value = true;
    _currentPage = 1;
    final result = await getNotificationsUsecase.execute(page: 1);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _notifications.assignAll(response.data);
      _hasMore.value = response.meta.hasMore;
    });
    _isLoading.value = false;
    _checkIfNeedsMore();
  }

  Future<void> loadMore() async {
    if (_isLoadingMore.value || !_hasMore.value) return;
    _isLoadingMore.value = true;
    final nextPage = _currentPage + 1;
    final result = await getNotificationsUsecase.execute(page: nextPage);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      response,
    ) {
      _notifications.addAll(response.data);
      _currentPage = nextPage;
      _hasMore.value = response.meta.hasMore;
    });
    _isLoadingMore.value = false;
  }

  Future<void> markAsRead(NotificationEntity notification) async {
    if (notification.isRead) return;

    final index = _notifications.indexWhere((n) => n.id == notification.id);
    if (index == -1) return;

    _notifications[index] = notification.copyWith(isRead: true);
    notificationService.decrementUnread();

    final result = await markNotificationReadUsecase.execute(notification.id);
    result.fold((failure) {
      final rollbackIndex = _notifications.indexWhere(
        (n) => n.id == notification.id,
      );
      if (rollbackIndex != -1) {
        _notifications[rollbackIndex] = notification;
      }
      notificationService.refreshUnreadCount();
    }, (_) {});
  }

  Future<void> markAllAsRead() async {
    final unreadEntries = <int, NotificationEntity>{};
    for (var i = 0; i < _notifications.length; i++) {
      if (!_notifications[i].isRead) {
        unreadEntries[i] = _notifications[i];
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    }
    if (unreadEntries.isEmpty) return;

    final previousCount = notificationService.unreadCount.value;
    notificationService.resetUnread();

    final result = await markAllNotificationsReadUsecase.execute();
    result.fold((failure) {
      for (final entry in unreadEntries.entries) {
        _notifications[entry.key] = entry.value;
      }
      notificationService.unreadCount.value = previousCount;
      ErrorHandler.showError('Error', failure.message);
    }, (_) {});
  }

  void onNotificationTap(NotificationEntity notification) {
    markAsRead(notification);
    NotificationRouter.handleNotificationTap(
      notification.type,
      notification.payload,
    );
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
