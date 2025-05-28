import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// Responsible for managing the app's theme settings.
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  ThemeController(this._storage);

  final FlutterSecureStorage _storage;
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  /// Loads the saved theme from secure storage and applies it.
  Future<void> initialize() async {
    final savedTheme = await _storage.read(key: 'theme') ?? 'light';
    themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _updateSystemUI();
  }

  /// Toggles the theme between light and dark modes.
  Future<void> toggleTheme() async {
    themeMode.value = themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    await _storage.write(
      key: 'theme',
      value: themeMode.value == ThemeMode.dark ? 'dark' : 'light',
    );

    _updateSystemUI();
  }

  /// Sets the theme explicitly to light or dark.
  Future<void> setTheme(String theme) async {
    if(theme != 'light' && theme != 'dark') {
      throw ArgumentError('Theme must be either "light" or "dark".');
    }
    themeMode.value = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    await _storage.write(key: 'theme', value: theme);
    _updateSystemUI();
  }

  /// Updates the system UI to match the current theme.
  void _updateSystemUI() {
    final isDark = themeMode.value == ThemeMode.dark;

    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDark ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
    ));
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}