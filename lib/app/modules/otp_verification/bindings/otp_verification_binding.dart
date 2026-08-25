import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpVerificationController>(
      () => OtpVerificationController(
        verifyOtpUsecase: sl(),
        sendOtpUsecase: sl(),
        authService: sl(),
      ),
    );
  }
}
