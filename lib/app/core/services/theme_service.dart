import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../theme/app_theme.dart';
import '../di/injection_container.dart';

/// Theme Service
/// Manages app theme (dark/light) with persistent storage
class ThemeService extends GetxController {
  static ThemeService get instance => sl<ThemeService>();

  final GetStorage _storage;
  static const String _themeKey = 'theme_mode';

  // Observable theme mode
  late final Rx<ThemeMode> _themeMode;

  ThemeService({GetStorage? storage}) : _storage = storage ?? GetStorage() {
    final savedTheme = _storage.read<String>(_themeKey);
    _themeMode = (savedTheme == 'light' ? ThemeMode.light : ThemeMode.dark).obs;
  }

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode.value;

  /// Check if current theme is dark
  bool get isDarkMode => _themeMode.value == ThemeMode.dark;

  /// Check if current theme is light
  bool get isLightMode => _themeMode.value == ThemeMode.light;

  /// Save theme to storage
  void _saveThemeToStorage() {
    _storage.write(
      _themeKey,
      _themeMode.value == ThemeMode.dark ? 'dark' : 'light',
    );
  }

  /// Toggle between dark and light theme
  void toggleTheme() {
    _themeMode.value = _themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    _saveThemeToStorage();

    // Apply theme change
    Get.changeThemeMode(_themeMode.value);
  }

  /// Set theme to dark
  void setDarkTheme() {
    if (_themeMode.value != ThemeMode.dark) {
      _themeMode.value = ThemeMode.dark;
      _saveThemeToStorage();
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  /// Set theme to light
  void setLightTheme() {
    if (_themeMode.value != ThemeMode.light) {
      _themeMode.value = ThemeMode.light;
      _saveThemeToStorage();
      Get.changeThemeMode(ThemeMode.light);
    }
  }

  /// Get dark theme data
  ThemeData get darkTheme => AppTheme.dark();

  /// Get light theme data
  ThemeData get lightTheme => AppTheme.light();
}
