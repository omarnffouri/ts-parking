import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  final AuthService authService;
  final GetStorage storage;

  SplashController({required this.authService, required this.storage});

  @override
  void onReady() {
    super.onReady();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    final hasCompletedOnboarding =
        storage.read<bool>(AppConstants.onboardingCompleteKey) ?? false;

    if (!hasCompletedOnboarding) {
      Get.offAllNamed(Routes.ON_BOARDING);
    } else if (authService.isLoggedIn) {
      Get.find<NotificationService>().initializeForUser();
      Get.offAllNamed(Routes.MAIN_SCREEN);
    } else {
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
