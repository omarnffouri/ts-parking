import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/gen/assets.gen.dart';
import 'package:ts_parking/app/core/services/theme_service.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/widgets/loading_widget.dart';
import 'package:ts_parking/app/theme/app_colors.dart';
import 'package:ts_parking/app/theme/app_radius.dart';
import 'package:ts_parking/app/theme/app_spacing.dart';
import 'package:ts_parking/app/theme/app_typography.dart';

import '../../controllers/profile_controller.dart';

class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({
    super.key,
    required this.controller,
    required this.isDark,
    required this.surfaceColor,
    required this.textColor,
    required this.secondaryTextColor,
    required this.onBack,
  });

  final ProfileController controller;
  final bool isDark;
  final Color surfaceColor;
  final Color textColor;
  final Color secondaryTextColor;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.primary;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 228,
              decoration: const BoxDecoration(),
              clipBehavior: Clip.hardEdge,
              child: Obx(
                () => Stack(
                  fit: StackFit.expand,
                  children: [
                    Image(
                      image: controller.coverPhotoProvider,
                      fit: BoxFit.cover,
                    ),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.black.withValues(
                                  alpha: isDark ? 0.10 : 0.04,
                                ),
                                Colors.black.withValues(
                                  alpha: isDark ? 0.22 : 0.08,
                                ),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.lg,
                        0,
                        AppSpacing.lg,
                        0,
                      ),
                      child: Row(
                        children: [
                          _AnimatedThemeToggle(
                            isDark: isDark,
                            onTap: ThemeService.instance.toggleTheme,
                            onCover: true,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: AppSpacing.lg,
                      bottom: AppSpacing.xl,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: controller.onCoverPhotoTap,
                          customBorder: const CircleBorder(),
                          child: Ink(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.22),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -22),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.lg,
                  70,
                  AppSpacing.lg,
                  0,
                ),
                child: Column(
                  children: [
                    Text(
                      controller.userName,
                      style: AppTypography.h2.copyWith(color: textColor),
                      textAlign: TextAlign.center,
                    ),
                    if (controller.userEmail != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        controller.userEmail!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: secondaryTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    // const SizedBox(height: AppSpacing.lg),
                    // AppButton.primary(
                    //   label: 'Edit Profile',
                    //   width: Get.size.width * 0.5,
                    //   onPressed: controller.onEditProfileTap,
                    //   useGlow: false,
                    //   borderRadius: AppRadius.xlargeRadius,
                    //   backgroundColor: AppColors.primary,
                    //   textColor: Colors.white,
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 160,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 115,
                  height: 115,
                  // padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 4),
                    color: AppColors.darkTextPrimary,
                  ),
                  alignment: Alignment.center,
                  child: Obx(
                    () => ClipOval(
                      child: _buildProfileAvatar(
                        localImagePath: controller.activeProfileImagePath,
                        remoteImageUrl:
                            controller.activeProfileImagePath == null
                            ? controller.remoteProfileImageUrl
                            : null,
                        isUploading: controller.isUploadingProfileImage,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: -8,
                  bottom: 4,
                  child: GestureDetector(
                    onTap: controller.onEditProfileTap,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileAvatar({
    required String? localImagePath,
    required String? remoteImageUrl,
    required bool isUploading,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _buildAvatarContent(
          localImagePath: localImagePath,
          remoteImageUrl: remoteImageUrl,
        ),
        if (isUploading) _buildAvatarLoader(0.35),
      ],
    );
  }

  Widget _buildAvatarContent({
    required String? localImagePath,
    required String? remoteImageUrl,
  }) {
    if (localImagePath != null && localImagePath.isNotEmpty) {
      return Image.file(File(localImagePath), fit: BoxFit.cover);
    }

    if (remoteImageUrl != null && remoteImageUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: remoteImageUrl,
        fit: BoxFit.cover,
        fadeInDuration: const Duration(milliseconds: 180),
        placeholder: (context, url) => _buildAvatarLoader(0.18),
        errorWidget: (context, url, error) => _buildAvatarPlaceholder(),
      );
    }

    return _buildAvatarPlaceholder();
  }

  Widget _buildAvatarPlaceholder() {
    return Image.asset(Assets.images.truckDriver.path, fit: BoxFit.cover);
  }

  Widget _buildAvatarLoader(double opacity) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: SizedBox(
          width: 28,
          height: 28,
          child: LoadingWidget(strokeWidth: 2.6, color: Colors.white),
        ),
      ),
    );
  }
}

class _AnimatedThemeToggle extends StatelessWidget {
  const _AnimatedThemeToggle({
    required this.isDark,
    required this.onTap,
    this.onCover = false,
  });

  final bool isDark;
  final VoidCallback onTap;
  final bool onCover;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDarkMode = ThemeService.instance.isDarkMode;
      final icon = isDarkMode
          ? Icons.dark_mode_rounded
          : Icons.wb_sunny_rounded;
      final iconColor = onCover
          ? (isDark ? Colors.white : AppColors.primary)
          : (isDarkMode ? AppColors.darkTextSecondary : AppColors.primary);
      final backgroundColor = onCover
          ? (isDark
                ? Colors.black.withValues(alpha: 0.28)
                : Colors.white.withValues(alpha: 0.90))
          : (isDark ? AppColors.darkSurfaceVariant : Colors.white);

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.mediumRadius,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 360),
                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    child: child,
                    builder: (context, animatedChild) {
                      final t = animation.value.clamp(0.0, 1.0);
                      final fade = Curves.easeOut.transform(t);
                      final scale = 0.82 + (fade * 0.18);
                      final angle = (1 - fade) * 0.35;

                      return Opacity(
                        opacity: fade,
                        child: Transform.rotate(
                          angle: angle,
                          child: Transform.scale(
                            scale: scale,
                            child: animatedChild,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Icon(
                  icon,
                  key: ValueKey<bool>(isDarkMode),
                  size: 20,
                  color: iconColor,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
