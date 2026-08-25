import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/modules/register/views/widgets/company_license_field.dart';
import 'package:ts_parking/app/theme/app_colors.dart';
import '../../../core/utils/input_formatters.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_floating_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Column(
        children: [
          ColoredBox(
            color: AppColors.primary,
            child: SafeArea(
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
                    Material(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: AppRadius.smallRadius,
                      child: InkWell(
                        onTap: () => Get.back(),
                        borderRadius: AppRadius.smallRadius,
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.ms),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create Account',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Fill in your details to register',
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
          ),

          Expanded(
            child: ColoredBox(
              color: AppColors.primary,
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
                            const SectionHeader(label: 'Personal Information'),
                            SizedBox(height: AppSpacing.ms),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: AppFloatingField(
                                    label: 'First Name',
                                    controller: controller.firstNameController,
                                    validator: controller.validateFirstName,
                                    textInputAction: TextInputAction.next,
                                    prefixIcon: const Icon(
                                      Icons.person_outline_rounded,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.ms),
                                Expanded(
                                  child: AppFloatingField(
                                    label: 'Last Name',
                                    controller: controller.lastNameController,
                                    validator: controller.validateLastName,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: AppSpacing.formFieldSpacing),
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
                            AppFloatingField(
                              label: 'Email',
                              controller: controller.emailController,
                              validator: controller.validateEmail,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            SizedBox(height: AppSpacing.formFieldSpacing),
                            AppFloatingField.password(
                              controller: controller.passwordController,
                              validator: controller.validatePassword,
                              textInputAction: TextInputAction.next,
                            ),
                            SizedBox(height: AppSpacing.formFieldSpacing),
                            AppFloatingField(
                              label: 'SSN (Optional)',
                              controller: controller.ssnController,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(9),
                              ],
                              prefixIcon: const Icon(Icons.badge_outlined),
                            ),
                            SizedBox(height: AppSpacing.xl),
                            const SectionHeader(label: 'Company Information'),
                            SizedBox(height: AppSpacing.ms),
                            AppFloatingField(
                              label: 'Company Name',
                              controller: controller.companyNameController,
                              validator: controller.validateCompanyName,
                              textInputAction: TextInputAction.done,
                              prefixIcon: const Icon(Icons.business_outlined),
                              textCapitalization: TextCapitalization.words,
                              onSubmitted: (_) => controller.register(),
                            ),
                            SizedBox(height: AppSpacing.formFieldSpacing),
                            CompanyLicenseField(controller: controller),

                            SizedBox(height: AppSpacing.xl),
                            Obx(
                              () => AppButton.primary(
                                label: 'Create Account',
                                icon: Icons.person_add_rounded,
                                isLoading: controller.isLoading,
                                backgroundColor: AppColors.secondary,
                                useGlow: false,
                                onPressed: controller.isLoading
                                    ? null
                                    : controller.register,
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Already have an account?',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.6,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () => Get.back(),
                                  borderRadius: AppRadius.smallRadius,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: AppSpacing.sm,
                                      vertical: AppSpacing.xs,
                                    ),
                                    child: Text(
                                      'Login',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).padding.bottom +
                                  AppSpacing.md,
                            ),
                          ],
                        ),
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
