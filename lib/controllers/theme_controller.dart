import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _storage = const FlutterSecureStorage();
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  @override
  void onInit() {
    _loadTheme();
    super.onInit();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await _storage.read(key: 'theme') ?? 'light';
    themeMode.value = savedTheme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    _updateSystemUI();
  }

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

  Future<void> setTheme(String theme) async {
    themeMode.value = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    await _storage.write(key: 'theme', value: theme);
    _updateSystemUI();
  }

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