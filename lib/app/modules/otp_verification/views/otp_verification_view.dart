import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../../core/widgets/app_button.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/otp_verification_controller.dart';

class OtpVerificationView extends GetView<OtpVerificationController> {
  const OtpVerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: Column(
        children: [
          // Header section
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.md,
                AppSpacing.screenHorizontal,
                AppSpacing.md,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: AppRadius.smallRadius,
                      ),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.ms),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verify OTP',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Code sent to ${controller.maskedPhone}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Form section
          Expanded(
            child: SlideTransition(
              position: controller.slideAnimation,
              child: FadeTransition(
                opacity: controller.fadeAnimation,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: AppRadius.xlargeTopRadius,
                  ),
                  child: Column(
                    children: [
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenHorizontal,
                            vertical: AppSpacing.lg,
                          ),
                          child: Form(
                            key: controller.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Lock icon
                                Center(
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.1,
                                      ),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.lock_outline_rounded,
                                      size: 28,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),

                                SizedBox(height: AppSpacing.ms),

                                // Instruction text
                                Text(
                                  'Enter verification code',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  'We sent a 4-digit code to ${controller.maskedPhone}',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                                ),

                                SizedBox(height: AppSpacing.lg),

                                // OTP pinput
                                Center(
                                  child: Pinput(
                                    controller: controller.otpController,
                                    length: 4,
                                    validator: controller.validateOtp,
                                    autofocus: true,
                                    separatorBuilder: (_) =>
                                        SizedBox(width: AppSpacing.md),
                                    defaultPinTheme: PinTheme(
                                      width: 64,
                                      height: 64,
                                      textStyle: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      decoration: BoxDecoration(
                                        color: colorScheme
                                            .surfaceContainerHighest
                                            .withValues(alpha: 0.3),
                                        borderRadius: AppRadius.mediumRadius,
                                        border: Border.all(
                                          color: colorScheme.outlineVariant,
                                        ),
                                      ),
                                    ),
                                    focusedPinTheme: PinTheme(
                                      width: 64,
                                      height: 64,
                                      textStyle: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: AppRadius.mediumRadius,
                                        border: Border.all(
                                          color: AppColors.primary,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                    submittedPinTheme: PinTheme(
                                      width: 64,
                                      height: 64,
                                      textStyle: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.08,
                                        ),
                                        borderRadius: AppRadius.mediumRadius,
                                        border: Border.all(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                    errorPinTheme: PinTheme(
                                      width: 64,
                                      height: 64,
                                      textStyle: theme.textTheme.headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.error,
                                          ),
                                      decoration: BoxDecoration(
                                        color: colorScheme.error.withValues(
                                          alpha: 0.05,
                                        ),
                                        borderRadius: AppRadius.mediumRadius,
                                        border: Border.all(
                                          color: colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    onCompleted: (_) => controller.verifyOtp(),
                                    hapticFeedbackType:
                                        HapticFeedbackType.lightImpact,
                                  ),
                                ),

                                SizedBox(height: AppSpacing.md),

                                // Resend OTP
                                Center(
                                  child: Obx(
                                    () => TextButton(
                                      onPressed: controller.canResend
                                          ? controller.resendOtp
                                          : null,
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: AppSpacing.md,
                                          vertical: AppSpacing.sm,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (controller.canResend)
                                            Padding(
                                              padding: EdgeInsets.only(
                                                right: AppSpacing.xs,
                                              ),
                                              child: Icon(
                                                Icons.refresh_rounded,
                                                size: 18,
                                                color: colorScheme.primary,
                                              ),
                                            ),
                                          Text(
                                            controller.canResend
                                                ? 'Resend OTP'
                                                : 'Resend in ${controller.resendCountdown}s',
                                            style: theme.textTheme.bodyMedium
                                                ?.copyWith(
                                                  color: controller.canResend
                                                      ? colorScheme.primary
                                                      : colorScheme.onSurface
                                                            .withValues(
                                                              alpha: 0.4,
                                                            ),
                                                  fontWeight:
                                                      controller.canResend
                                                      ? FontWeight.w600
                                                      : FontWeight.normal,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Pinned verify button
                      SafeArea(
                        top: false,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            AppSpacing.screenHorizontal,
                            AppSpacing.sm,
                            AppSpacing.screenHorizontal,
                            AppSpacing.md,
                          ),
                          child: Obx(
                            () => AppButton.primary(
                              label: 'Verify',
                              icon: Icons.check_circle_outline_rounded,
                              isLoading: controller.isLoading,
                              useGlow: false,
                              onPressed: controller.isLoading
                                  ? null
                                  : controller.verifyOtp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
