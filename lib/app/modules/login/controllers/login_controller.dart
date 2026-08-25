import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/params/driver_params.dart';
import '../../../domain/params/otp_params.dart';
import '../../../domain/usecases/login_usecase.dart';
import '../../../domain/usecases/send_otp_usecase.dart';
import '../../../routes/app_pages.dart';

class LoginController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final LoginUsecase loginUsecase;
  final SendOtpUsecase sendOtpUsecase;
  final AuthService authService;

  LoginController({
    required this.loginUsecase,
    required this.sendOtpUsecase,
    required this.authService,
  });

  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController(
    text: kDebugMode ? '374-82-6066' : '',
  );
  final mobileController = TextEditingController(
    text: kDebugMode ? '734-575-8003' : '',
  );

  late final AnimationController animationController;
  late final Animation<Offset> slideAnimation;
  late final Animation<double> fadeAnimation;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.forward();
  }

  String? validatePassword(String? value) => Validators.validatePassword(value);
  String? validateMobile(String? value) =>
      Validators.validateMobileNumber(value);

  Future<void> login() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    _isLoading.value = true;

    try {
      final password = passwordController.text;
      final mobile = mobileController.text.replaceAll('-', '').trim();
      final fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

      final result = await loginUsecase.execute(
        LoginParams(
          password: password,
          mobileNumber: mobile,
          fcmToken: fcmToken,
        ),
      );

      final shouldContinue = result.fold(
        (failure) {
          ErrorHandler.showError('Login Failed', failure.message);
          return false;
        },
        (response) {
          if (response.verified) {
            if (response.user != null) {
              authService.setCurrentUser(response.user!);
            }
            Get.find<NotificationService>().initializeForUser();
            Get.offAllNamed(Routes.MAIN_SCREEN);
            return false;
          }
          return true;
        },
      );

      if (!shouldContinue) return;

      final otpResult = await sendOtpUsecase.execute(
        SendOtpParams(password: password, mobileNumber: mobile),
      );

      otpResult.fold(
        (failure) => ErrorHandler.showError('Send OTP Failed', failure.message),
        (requestId) {
          Get.toNamed(
            Routes.OTP_VERIFICATION,
            arguments: OtpVerificationArgs(
              password: password,
              mobileNumber: mobile,
              requestId: requestId,
            ),
          );
        },
      );
    } catch (e) {
      ErrorHandler.showError('Error', 'Something went wrong');
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    mobileController.dispose();
    animationController.dispose();
    super.onClose();
  }
}
