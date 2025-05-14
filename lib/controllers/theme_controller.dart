import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;

  final _selectedTheme = 'light'.obs; // Default theme
  String get selectedTheme => _selectedTheme.value;

  final _themeMode = ThemeMode.light; // Default theme
  ThemeMode get themeMode => _themeMode;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    _loadTheme();
    super.onInit();
  }

  void _loadTheme() async {
    _selectedTheme.value = await _storage.read(key: 'theme') ?? 'light';
    _isDarkMode.value = _selectedTheme.value == 'dark';
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    _selectedTheme.value = _isDarkMode.value ? 'dark' : 'light';

    await _storage.write(key: 'theme', value: _selectedTheme.value);

    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: isDarkMode ? Colors.black : Colors.white,
      systemNavigationBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode ? Brightness.light : Brightness.dark,
    ));
  }

  void setTheme(String theme) async {
    _selectedTheme.value = theme;
    _isDarkMode.value = theme == 'dark';

    await _storage.write(key: 'theme', value: theme);

    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
