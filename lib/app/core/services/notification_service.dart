import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../enums/notification_type.dart';
import '../../domain/usecases/get_unread_count_usecase.dart';
import '../utils/notification_router.dart';

class NotificationService extends GetxController {
  final GetUnreadCountUsecase getUnreadCountUsecase;

  NotificationService({required this.getUnreadCountUsecase});

  final unreadCount = 0.obs;
  bool _isInitializing = false;
  bool _localNotificationsInitialized = false;

  static const _channelId = 'ts_parking_notifications';
  static const _channelName = 'TS Parking Notifications';
  static const _channelDescription =
      'Notifications for subscriptions, invoices, payments, and bookings';

  static const _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;

  Future<void> initializeForUser() async {
    if (_isInitializing) return;
    _isInitializing = true;
    try {
      await Future.wait([_requestPermission(), _initLocalNotifications()]);
      _setupMessageHandlers();
      await refreshUnreadCount();
    } catch (e) {
      debugPrint('NotificationService init error: $e');
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> clearForUser() async {
    try {
      await _cancelSubscriptions();
      unreadCount.value = 0;
    } catch (e) {
      debugPrint('NotificationService clear error: $e');
    }
  }

  void decrementUnread() {
    if (unreadCount.value > 0) unreadCount.value--;
  }

  void resetUnread() {
    unreadCount.value = 0;
  }

  Future<void> refreshUnreadCount() async {
    final result = await getUnreadCountUsecase.execute();
    result.fold((_) {}, (count) => unreadCount.value = count);
  }

  Future<void> _cancelSubscriptions() async {
    await _onMessageSub?.cancel();
    _onMessageSub = null;
    await _onMessageOpenedAppSub?.cancel();
    _onMessageOpenedAppSub = null;
  }

  Future<void> _requestPermission() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> _initLocalNotifications() async {
    if (_localNotificationsInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    await _localNotifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    final androidPlugin = _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin != null) {
      await androidPlugin.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: _channelDescription,
          importance: Importance.high,
        ),
      );
    }

    _localNotificationsInitialized = true;
  }

  void _setupMessageHandlers() {
    _onMessageSub?.cancel();
    _onMessageSub = FirebaseMessaging.onMessage.listen(
      _handleForegroundMessage,
    );

    _onMessageOpenedAppSub?.cancel();
    _onMessageOpenedAppSub = FirebaseMessaging.onMessageOpenedApp.listen(
      _handleNotificationTap,
    );

    _handleInitialMessage();
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    unreadCount.value++;

    await _localNotifications.show(
      id: message.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: _notificationDetails,
      payload: jsonEncode(message.data),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    final type = NotificationTypeX.fromData(message.data);
    NotificationRouter.handleNotificationTap(type, message.data);
  }

  Future<void> _handleInitialMessage() async {
    final message = await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotificationTap(message);
      });
    }
  }

  void _onNotificationTap(NotificationResponse response) {
    if (response.payload == null) return;
    try {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      final type = NotificationTypeX.fromData(data);
      NotificationRouter.handleNotificationTap(type, data);
    } catch (e) {
      debugPrint('NotificationService: failed to handle tap: $e');
    }
  }

  @override
  void onClose() {
    _cancelSubscriptions();
    super.onClose();
  }
}
