
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

/// Responsible for managing the app's color scheme settings.
class ColorSchemeController extends GetxController {
  static ColorSchemeController get to => Get.find();

  ColorSchemeController(this._storage);

  final FlutterSecureStorage _storage;
  bool isCustomColorScheme = false;
  late ColorScheme colorScheme;

  @override
  void onInit() {
    initialize();
    super.onInit();
  }

  void initialize() {
    _storage.read(key: 'colorScheme').then((value) {
      isCustomColorScheme = value != null;
      colorScheme = jsonDecode(value!) as ColorScheme;
    });
  }


}