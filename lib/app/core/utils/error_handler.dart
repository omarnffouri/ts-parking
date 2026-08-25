import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../errors/failures.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';

class ErrorHandler {
  /// Handles Either result and shows appropriate snackbar for failures
  static void handleEither<T>(
    Either<Failure, T> result, {
    Function(T)? onSuccess,
    Function(Failure)? onFailure,
    String? successMessage,
    bool showSuccessSnackbar = false,
  }) {
    result.fold(
      (failure) {
        // _showErrorSnackbar(failure);
        onFailure?.call(failure);
      },
      (success) {
        if (showSuccessSnackbar && successMessage != null) {
          _showSuccessSnackbar(successMessage);
        }
        onSuccess?.call(success);
      },
    );
  }

  /// Handles Either result specifically for async operations
  static Future<void> handleEitherAsync<T>(
    Future<Either<Failure, T>> futureResult, {
    Function(T)? onSuccess,
    Function(Failure)? onFailure,
    String? successMessage,
    bool showSuccessSnackbar = false,
    bool showLoadingIndicator = false,
  }) async {
    if (showLoadingIndicator) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    }

    try {
      final result = await futureResult;

      if (showLoadingIndicator && Get.isDialogOpen == true) {
        Get.back();
      }

      handleEither(
        result,
        onSuccess: onSuccess,
        onFailure: onFailure,
        successMessage: successMessage,
        showSuccessSnackbar: showSuccessSnackbar,
      );
    } catch (e) {
      if (showLoadingIndicator && Get.isDialogOpen == true) {
        Get.back();
      }
      _showErrorSnackbar(UnexpectedFailure('An unexpected error occurred: $e'));
      onFailure?.call(UnexpectedFailure(e.toString()));
    }
  }

  /// Maps exceptions to failures
  static Failure mapExceptionToFailure(dynamic exception) {
    if (exception is Failure) {
      return exception;
    }

    final message = exception.toString();

    if (message.contains('network') || message.contains('connection')) {
      return NetworkFailure('Network connection failed');
    } else if (message.contains('timeout')) {
      return NetworkFailure('Request timeout');
    } else if (message.contains('unauthorized') || message.contains('401')) {
      return AuthFailure('Authentication failed');
    } else if (message.contains('validation') || message.contains('invalid')) {
      return ValidationFailure('Validation failed');
    } else {
      return UnexpectedFailure(message);
    }
  }

  /// Wraps a function in try-catch and returns Either
  static Either<Failure, T> wrapInEither<T>(T Function() function) {
    try {
      final result = function();
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  /// Wraps an async function in try-catch and returns Either
  static Future<Either<Failure, T>> wrapInEitherAsync<T>(
    Future<T> Function() function,
  ) async {
    try {
      final result = await function();
      return Right(result);
    } catch (e) {
      return Left(mapExceptionToFailure(e));
    }
  }

  /// Gets user-friendly error message from failure
  static String getErrorMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return 'Network connection failed. Please check your internet connection.';
      case AuthFailure _:
        return 'Authentication failed. Please login again.';
      case ValidationFailure _:
        return failure.message;
      case ServerFailure _:
        return 'Server error occurred. Please try again later.';
      case CacheFailure _:
        return 'Local storage error. Please restart the app.';
      default:
        return failure.message.isNotEmpty
            ? failure.message
            : 'An unexpected error occurred.';
    }
  }

  /// Shows error snackbar with proper styling
  static void _showErrorSnackbar(Failure failure) {
    _showSnackbar(
      title: _getErrorTitle(failure),
      message: getErrorMessage(failure),
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
      position: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
    );
  }

  /// Shows success snackbar with proper styling
  static void _showSuccessSnackbar(String message) {
    _showSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  /// Gets appropriate title for error type
  static String _getErrorTitle(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure _:
        return 'Connection Error';
      case AuthFailure _:
        return 'Authentication Error';
      case ValidationFailure _:
        return 'Validation Error';
      case ServerFailure _:
        return 'Server Error';
      case CacheFailure _:
        return 'Storage Error';
      default:
        return 'Error';
    }
  }

  static void showInfo(String title, String message) {
    final colorScheme = Theme.of(Get.context!).colorScheme;
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: colorScheme.surfaceContainerHighest,
      textColor: colorScheme.onSurface,
      icon: Icons.info_outline,
      iconColor: AppColors.primary,
      borderColor: AppColors.primary,
    );
  }

  static void showError(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline,
    );
  }

  static void showSuccess(String message) {
    _showSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline,
    );
  }

  static void showWarning(String title, String message) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: AppColors.warning,
      textColor: Colors.black,
      icon: Icons.warning_outlined,
    );
  }

  /// Central snackbar method — all snackbars go through here
  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color? textColor,
    Color? iconColor,
    Color? borderColor,
    SnackPosition position = SnackPosition.TOP,
    Duration duration = const Duration(seconds: 3),
  }) {
    final resolvedTextColor = textColor ?? Colors.white;
    final resolvedIconColor = iconColor ?? resolvedTextColor;
    Get.snackbar(
      title,
      message,
      snackPosition: position,
      backgroundColor: backgroundColor,
      colorText: resolvedTextColor,
      borderColor: borderColor,
      borderWidth: borderColor != null ? 1.5 : 0,
      duration: duration,
      margin: EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.small,
      icon: Icon(icon, color: resolvedIconColor),
      shouldIconPulse: false,
    );
  }
}
