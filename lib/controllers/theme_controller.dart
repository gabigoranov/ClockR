import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/app_colors_controller.dart';

import 'common/themes.dart';

/// Responsible for managing the app's theme settings.
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  ThemeController(this._storage);

  final FlutterSecureStorage _storage;
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  final Rx<ThemeData> themeData = buildTheme(ThemeMode.light).obs;

  @override
  void onInit() {
    super.onInit();

    initialize();

    AppColorsController.to.themeColors.listen((newColors) {
      themeData.value = buildTheme(themeMode.value);
    });
  }

  /// Loads the saved theme from secure storage and applies it.
  Future<void> initialize() async {
    final savedTheme = await _storage.read(key: 'theme') ?? 'light';
    themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    themeData.value = buildTheme(themeMode.value);
    _updateSystemUI();
  }

  /// Toggles the theme between light and dark modes.
  Future<void> toggleTheme() async {
    themeMode.value = themeMode.value == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    themeData.value =buildTheme(themeMode.value);

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
    themeData.value =buildTheme(themeMode.value);

    await _storage.write(key: 'theme', value: theme);
    _updateSystemUI();
  }

  /// Updates the system UI to match the current theme.
  void _updateSystemUI() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));
  }

  bool get isDarkMode => themeMode.value == ThemeMode.dark;
}