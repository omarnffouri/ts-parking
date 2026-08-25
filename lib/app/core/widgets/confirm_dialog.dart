import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmDialog {
  ConfirmDialog._();

  static Future<bool> show({
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool destructive = false,
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: destructive
                ? TextButton.styleFrom(
                    foregroundColor: Get.theme.colorScheme.error,
                  )
                : null,
            child: Text(confirmLabel),
          ),
        ],
      ),
    );
    return result == true;
  }
}
