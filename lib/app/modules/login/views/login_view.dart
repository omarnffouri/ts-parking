import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/theme/app_colors.dart';

import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_floating_field.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        children: [
          SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.screenHorizontal,
                AppSpacing.md,
                AppSpacing.screenHorizontal,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Sign in with your password',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SlideTransition(
              position: controller.slideAnimation,
              child: FadeTransition(
                opacity: controller.fadeAnimation,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: context.backgroundColor,
                    borderRadius: AppRadius.xlargeTopRadius,
                  ),
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
                          AppFloatingField(
                            label: 'Mobile Number',
                            controller: controller.mobileController,
                            validator: controller.validateMobile,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(Icons.phone_outlined),
                            inputFormatters: [MobileInputFormatter()],
                          ),

                          SizedBox(height: AppSpacing.formFieldSpacing),

                          AppFloatingField.password(
                            controller: controller.passwordController,
                            validator: controller.validatePassword,
                            textInputAction: TextInputAction.done,
                            onSubmitted: (_) => controller.login(),
                          ),

                          SizedBox(height: AppSpacing.xl),

                          Obx(
                            () => AppButton.primary(
                              label: 'Login',
                              icon: Icons.arrow_forward_rounded,
                              isLoading: controller.isLoading,
                              useGlow: false,
                              onPressed: controller.isLoading
                                  ? null
                                  : controller.login,
                            ),
                          ),

                          SizedBox(height: AppSpacing.buttonSpacing),

                          AppButton.secondary(
                            label: 'Create Account',
                            icon: Icons.person_add_outlined,
                            onPressed: () => Get.toNamed(Routes.REGISTER),
                          ),
                        ],
                      ),
                    ),
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
