import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppLinearProgress extends StatelessWidget {
  final bool isLoading;

  const AppLinearProgress({super.key, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LinearProgressIndicator(
        minHeight: 5,
        backgroundColor: Get.isDarkMode ? null : Colors.white,
      );
    }
    return const SizedBox.shrink();
  }
}
