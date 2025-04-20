import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillzone/core/theme/app_colors.dart';

class ErrorHelper {
  static void showError({
    required String title,
    required String message,
    Duration? duration,
    SnackPosition? position,
    Widget? icon,
    VoidCallback? onTap,
  }) {
    Get.snackbar(
      title,
      message,
      backgroundColor: AppColors.errorColor,
      colorText: AppColors.backgroundColor,
      duration: duration ?? const Duration(seconds: 7),
      snackPosition: position ?? SnackPosition.TOP,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      isDismissible: true,
      dismissDirection: DismissDirection.horizontal,
      forwardAnimationCurve: Curves.easeOutBack,
      icon: icon,
      onTap: onTap != null ? (_) => onTap() : null,
      mainButton: onTap != null
          ? TextButton(
              onPressed: onTap,
              child: const Text(
                'Retry',
                style: TextStyle(
                  color: AppColors.backgroundColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : null,
    );
  }

  static void showNetworkError({
    VoidCallback? onRetry,
  }) {
    showError(
      title: 'Connection Error',
      message: 'Please check your internet connection and try again',
      icon: const Icon(
        Icons.wifi_off_rounded,
        color: AppColors.backgroundColor,
      ),
      onTap: onRetry,
    );
  }

  static void showValidationError({
    required String message,
  }) {
    showError(
      title: 'Invalid Input',
      message: message,
      icon: const Icon(
        Icons.warning_rounded,
        color: AppColors.backgroundColor,
      ),
    );
  }

  static void showServerError({
    String? message,
    VoidCallback? onRetry,
  }) {
    showError(
      title: 'Server Error',
      message: message ?? 'Something went wrong. Please try again later.',
      icon: const Icon(
        Icons.error_outline_rounded,
        color: AppColors.backgroundColor,
      ),
      onTap: onRetry,
    );
  }

  static void showAuthError({
    required String message,
    VoidCallback? onRetry,
  }) {
    showError(
      title: 'Authentication Error',
      message: message,
      icon: const Icon(
        Icons.lock_outline_rounded,
        color: AppColors.backgroundColor,
      ),
      onTap: onRetry,
    );
  }
}