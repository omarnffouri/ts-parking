import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/profile_controller.dart';

void showDeleteAccountSheet(ProfileController controller) {
  Get.bottomSheet(
    _DeleteAccountSheet(controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class _DeleteAccountSheet extends StatelessWidget {
  final ProfileController controller;

  const _DeleteAccountSheet({required this.controller});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRRect(
      borderRadius: AppRadius.xlargeTopRadius,
      child: Obx(() {
        final isDeleting = controller.isDeletingAccount;

        return Container(
          color: AppColors.error,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              decoration: BoxDecoration(
                color: context.panelColor,
                borderRadius: AppRadius.xlargeTopRadius,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: AppSpacing.md,
                  right: AppSpacing.md,
                  top: AppSpacing.md,
                  bottom: bottomPadding + AppSpacing.md,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon + Title row
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: AppRadius.mediumRadius,
                          ),
                          child: Icon(
                            Icons.delete_forever_rounded,
                            size: 22,
                            color: AppColors.error,
                          ),
                        ),
                        SizedBox(width: AppSpacing.ms),
                        Text(
                          'Delete Account',
                          style: AppTypography.h3.copyWith(
                            color: context.primaryTextColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppSpacing.ms),

                    // Description
                    Text(
                      'Your account, vehicles, subscriptions, and payment methods will be permanently removed.',
                      style: AppTypography.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: isDeleting ? null : () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: context.secondaryTextColor,
                              side: BorderSide(color: context.panelBorderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.mediumRadius,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.ms,
                              ),
                            ),
                            child: Text(
                              'Cancel',
                              style: AppTypography.buttonMedium,
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.ms),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isDeleting
                                ? null
                                : controller.deleteAccount,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: AppColors.error
                                  .withValues(alpha: 0.5),
                              disabledForegroundColor: Colors.white70,
                              shape: RoundedRectangleBorder(
                                borderRadius: AppRadius.mediumRadius,
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: AppSpacing.ms,
                              ),
                            ),
                            child: isDeleting
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    'Delete',
                                    style: AppTypography.buttonMedium,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
