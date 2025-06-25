import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' show TestWidgetsFlutterBinding;
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tempus/controllers/app_colors_controller.dart';
import 'package:tempus/controllers/theme_controller.dart';
import 'package:test/test.dart';

import 'common/mock_flutter_secure_storage.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ThemeController themeController;
  late AppColorsController appColorsController;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    Get.testMode = true;
    Get.reset(); // reset everything first


    mockStorage = MockFlutterSecureStorage();

    Get.replace(AppColorsController(mockStorage));

    themeController = ThemeController(mockStorage);
  });

  tearDown(() {
    reset(mockStorage);
  });

  group('initialize', () {
    test('Should initialize with dark theme when storage contains "dark"', () async {
      // Arrange
      when(() => mockStorage.read(key: 'theme')).thenAnswer((_) async => 'dark');

      // Act
      await themeController.initialize();

      debugPrint("Initialized with theme: ${themeController.themeMode.value}");

      // Assert
      expect(themeController.themeMode.value, ThemeMode.dark);
    });

    test('Should initialize with light theme when storage contains "light"', () async {
      // Arrange
      when(() => mockStorage.read(key: 'theme')).thenAnswer((_) async => 'light');

      // Act
      await themeController.initialize();

      // Assert
      expect(themeController.themeMode.value, ThemeMode.light);
    });

    test('Should initialize with light theme as default when storage is empty', () async {
      // Arrange
      when(() => mockStorage.read(key: 'theme')).thenAnswer((_) async => null);

      // Act
      await themeController.initialize();

      // Assert
      expect(themeController.themeMode.value, ThemeMode.light);
    });
  });

  group('toggleTheme', () {
    test('Should toggle from dark to light', () async {
      // Arrange
      themeController.themeMode.value = ThemeMode.dark;

      // Act
      await themeController.toggleTheme();

      // Assert
      expect(themeController.themeMode.value, ThemeMode.light);
      verify(() => mockStorage.write(key: 'theme', value: 'light')).called(1);
    });

    test('Should toggle from light to dark', () async {
      // Arrange
      themeController.themeMode.value = ThemeMode.light;

      // Act
      await themeController.toggleTheme();

      // Assert
      expect(themeController.themeMode.value, ThemeMode.dark);
      verify(() => mockStorage.write(key: 'theme', value: 'dark')).called(1);
    });
  });

  group('setTheme', () {
    test('Should set theme to dark', () async {
      // Act
      await themeController.setTheme('dark');

      // Assert
      expect(themeController.themeMode.value, ThemeMode.dark);
      verify(() => mockStorage.write(key: 'theme', value: 'dark')).called(1);
    });

    test('Should set theme to light', () async {
      // Act
      await themeController.setTheme('light');

      // Assert
      expect(themeController.themeMode.value, ThemeMode.light);
      verify(() => mockStorage.write(key: 'theme', value: 'light')).called(1);
    });

    test('Should not change theme when invalid value is provided', () async {
      // Arrange
      themeController.themeMode.value = ThemeMode.light;

      // Act
      try{
        await themeController.setTheme('invalid');
      }
      catch(e) {
        // Expected to throw an error
        debugPrint('Caught expected error: $e');
      }

      // Assert
      expect(themeController.themeMode.value, ThemeMode.light);
      verifyNever(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')));
    });
  });
}