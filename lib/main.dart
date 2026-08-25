import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'app/core/constants/app_constants.dart';
import 'app/core/di/injection_container.dart' as di;
import 'app/core/services/notification_service.dart';
import 'app/core/services/theme_service.dart';
import 'app/routes/app_pages.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase and storage in parallel
  await Future.wait([Firebase.initializeApp(), GetStorage.init()]);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (AppConstants.stripePublishableKey.isNotEmpty) {
    Stripe.publishableKey = AppConstants.stripePublishableKey;
    await Stripe.instance.applySettings();
  }

  // Initialize dependencies
  await di.init();

  final themeService = di.sl<ThemeService>();
  Get.put<NotificationService>(di.sl<NotificationService>(), permanent: true);

  runApp(
    GetMaterialApp(
      key: const Key('app'),
      title: "TS Parking",
      theme: themeService.lightTheme,
      darkTheme: themeService.darkTheme,
      themeMode: themeService.themeMode,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  );
}
