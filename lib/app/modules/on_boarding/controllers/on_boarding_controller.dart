import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/app_constants.dart';
import '../../../routes/app_pages.dart';

class OnBoardingController extends GetxController {
  final GetStorage storage;

  OnBoardingController({required this.storage});

  final pageController = PageController();
  final _currentPage = 0.obs;

  int get currentPage => _currentPage.value;
  bool get isLastPage => _currentPage.value == pages.length - 1;

  final pages = [
    OnBoardingPageData(
      imageAsset: 'assets/images/onboarding_one.png',
      title: 'Find Parking Easily',
      description:
          'Discover available parking spots near you in real-time. No more circling around looking for a space.',
    ),
    OnBoardingPageData(
      imageAsset: 'assets/images/onboarding_two.png',
      title: 'Book in Advance',
      description:
          'Reserve your parking spot ahead of time. Guaranteed availability when you arrive.',
    ),
    OnBoardingPageData(
      imageAsset: 'assets/images/onboarding_three.png',
      title: 'Safe & Secure',
      description:
          'All parking locations are verified and monitored. Your vehicle is in safe hands.',
    ),
  ];

  void onPageChanged(int index) {
    _currentPage.value = index;
  }

  void nextPage() {
    if (isLastPage) {
      completeOnboarding();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    completeOnboarding();
  }

  void completeOnboarding() {
    storage.write(AppConstants.onboardingCompleteKey, true);
    Get.offAllNamed(Routes.LOGIN);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class OnBoardingPageData {
  final String imageAsset;
  final String title;
  final String description;

  const OnBoardingPageData({
    required this.imageAsset,
    required this.title,
    required this.description,
  });
}
