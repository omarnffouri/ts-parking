import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/params/otp_params.dart';
import '../../../domain/usecases/send_otp_usecase.dart';
import '../../../domain/usecases/verify_otp_usecase.dart';
import '../../../routes/app_pages.dart';

class OtpVerificationController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final VerifyOtpUsecase verifyOtpUsecase;
  final SendOtpUsecase sendOtpUsecase;
  final AuthService authService;

  OtpVerificationController({
    required this.verifyOtpUsecase,
    required this.sendOtpUsecase,
    required this.authService,
  });

  late final OtpVerificationArgs args;
  late String _currentRequestId;

  final formKey = GlobalKey<FormState>();
  final otpController = TextEditingController();

  late final AnimationController animationController;
  late final Animation<Offset> slideAnimation;
  late final Animation<double> fadeAnimation;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _resendCountdown = 0.obs;
  int get resendCountdown => _resendCountdown.value;
  bool get canResend => _resendCountdown.value == 0;

  Timer? _countdownTimer;

  String get maskedPhone {
    final phone = args.mobileNumber;
    if (phone.length <= 4) return phone;
    final visible = phone.substring(phone.length - 4);
    return '****$visible';
  }

  @override
  void onInit() {
    super.onInit();

    args = Get.arguments as OtpVerificationArgs;
    _currentRequestId = args.requestId;

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

    _startCountdown();
  }

  String? validateOtp(String? value) => Validators.validateOtp(value);

  void _startCountdown() {
    _resendCountdown.value = 60;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown.value > 0) {
        _resendCountdown.value--;
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendOtp() async {
    if (!canResend) return;

    _isLoading.value = true;

    try {
      final result = await sendOtpUsecase.execute(
        SendOtpParams(password: args.password, mobileNumber: args.mobileNumber),
      );

      result.fold(
        (failure) => ErrorHandler.showError('Resend Failed', failure.message),
        (newRequestId) {
          _currentRequestId = newRequestId;
          _startCountdown();
          ErrorHandler.showSuccess('OTP sent successfully');
        },
      );
    } catch (e) {
      ErrorHandler.showError('Error', 'Something went wrong');
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> verifyOtp() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    _isLoading.value = true;

    try {
      final result = await verifyOtpUsecase.execute(
        VerifyOtpParams(
          password: args.password,
          mobileNumber: args.mobileNumber,
          otpCode: otpController.text.trim(),
          requestId: _currentRequestId,
          isRegistration: args.isRegistration,
          firstName: args.firstName,
          lastName: args.lastName,
        ),
      );

      result.fold(
        (failure) =>
            ErrorHandler.showError('Verification Failed', failure.message),
        (response) {
          if (response.user != null) {
            authService.setCurrentUser(response.user!);
          }
          Get.offAllNamed(Routes.MAIN_SCREEN);
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
    otpController.dispose();
    animationController.dispose();
    _countdownTimer?.cancel();
    super.onClose();
  }
}
