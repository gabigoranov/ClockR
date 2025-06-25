import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import 'common/theme_colors.dart';

class AppColorsController extends GetxController {
  static AppColorsController get to => Get.find();
  AppColorsController(this._storage);

  final FlutterSecureStorage _storage;

  final Rx<ThemeColors> themeColors = ThemeColors().obs;

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  /// Initializes the controller by loading the theme colors from secure storage or using default values.
  Future<void> initialize() async {
    // Load initial theme colors from secure storage or use default
    final savedColors = await _storage.read(key: 'themeColors');
    if (savedColors != null) {
      themeColors.value = ThemeColors.fromJson(jsonDecode(savedColors));
    } else {
      themeColors.value = ThemeColors(); // Default colors
    }
  }

  /// Updates the theme colors and notifies the ThemeController to reload the theme and show the changes.
  Future<void> updateThemeColors(ThemeColors newThemeColors) async {
    themeColors.value = newThemeColors;
    await saveThemeColors();
  }

  ///Save the theme colors to secure storage.
  Future<void> saveThemeColors() async {
    final colorsJson = jsonEncode(themeColors.toJson());
    await _storage.write(key: 'themeColors', value: colorsJson);
  }
}
