import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_shadows.dart';

/// LoadingWidget - Loading indicators with DriveFlow branding
/// Follows design system specifications
class LoadingWidget extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;

  const LoadingWidget({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2.5,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget loadingIndicator = SizedBox(
      width: size,
      height: size,
      child: SpinKitSpinningLines(color: color ?? AppColors.primary),
    );

    if (message != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          loadingIndicator,
          SizedBox(height: AppSpacing.md),
          Text(
            message!,
            style: AppTypography.bodyMedium.copyWith(
              color: theme.brightness == Brightness.dark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return loadingIndicator;
  }
}

/// Full Screen Loading Overlay
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final bool showBackground;

  const FullScreenLoading({
    super.key,
    this.message,
    this.showBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      color: showBackground
          ? Colors.black.withValues(alpha: 0.7)
          : Colors.transparent,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightBackground,
            borderRadius: AppRadius.largeRadius,
            boxShadow: AppShadows.getShadow(
              size: 'large',
              brightness: Theme.of(context).brightness,
            ),
          ),
          child: LoadingWidget(size: 48, message: message ?? 'Loading...'),
        ),
      ),
    );
  }
}

/// Loading Overlay for wrapping widgets
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingMessage;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading) FullScreenLoading(message: loadingMessage),
      ],
    );
  }
}

/// Shimmer Loading Effect (for skeleton screens)
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color? baseColor;
  final Color? highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    required this.isLoading,
    this.baseColor,
    this.highlightColor,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    final isDark = context.isDark;
    final shimmerColors = AppColors.getShimmerColors(isDark);
    final baseColor = widget.baseColor ?? shimmerColors[0];
    final highlightColor = widget.highlightColor ?? shimmerColors[1];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                baseColor,
                baseColor,
                highlightColor,
                baseColor,
                baseColor,
              ],
              stops: [
                0.0,
                _max(0.0, _animation.value - 0.3),
                _animation.value,
                _min(1.0, _animation.value + 0.3),
                1.0,
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcATop,
          child: widget.child,
        );
      },
    );
  }

  double _max(double a, double b) => a > b ? a : b;
  double _min(double a, double b) => a < b ? a : b;
}

/// Skeleton Box for shimmer loading
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double? borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.small),
      ),
    );
  }
}

/// Circular skeleton for avatars
class SkeletonCircle extends StatelessWidget {
  final double size;

  const SkeletonCircle({super.key, this.size = 48});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        shape: BoxShape.circle,
      ),
    );
  }
}
