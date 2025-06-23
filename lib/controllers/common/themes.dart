import 'package:flutter/material.dart';
import '../app_colors_controller.dart';

ThemeData buildTheme(ThemeMode mode) {
  final colors = AppColorsController.to.themeColors.value;
  final isDark = mode == ThemeMode.dark;

  return ThemeData(
    brightness: isDark ? Brightness.dark : Brightness.light,
    scaffoldBackgroundColor: isDark ? colors.backgroundDark : colors.backgroundWhite,
    primaryColor: isDark ? colors.primaryDark : colors.primaryLight,
    colorScheme: ColorScheme(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primary: isDark ? colors.primaryDark : colors.primaryLight,
      primaryContainer: isDark ? colors.primaryDark : colors.primaryLight,
      secondary: isDark ? colors.secondaryDark : colors.secondaryLight,
      secondaryContainer: isDark ? colors.secondaryDark : colors.secondaryLight,
      surface: isDark ? colors.containerDark : colors.containerLight,
      error: colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: isDark ? colors.textDark : colors.textLight,
      onError: Colors.white,
      tertiary: colors.orange,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
        color: isDark ? colors.timerTextDark : colors.timerTextLight,
      ),
      displayMedium: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        color: isDark ? colors.timerTextDark : colors.timerTextLight,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: isDark ? colors.textDark : colors.textLight,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: isDark ? colors.textDark : colors.textLight,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDark ? colors.textDark : colors.textLight,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: isDark ? colors.primaryDark : colors.primaryLight,
      elevation: 2,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? colors.buttonDark : colors.buttonLight,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
    ),
    cardTheme: CardTheme(
      color: isDark ? colors.containerDark : colors.containerLight,
      elevation: 2,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
