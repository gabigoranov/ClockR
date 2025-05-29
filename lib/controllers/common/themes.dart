import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Light theme configuration for the chess clock app
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.backgroundWhite, // Main background color for Scaffold
  primaryColor: AppColors.primaryLight, // Primary color for widgets
  colorScheme: const ColorScheme.light(
    brightness: Brightness.light,
    primary: AppColors.primaryLight, // Used for prominent interactive elements
    secondary: AppColors.secondaryLight, // Used for less prominent interactive elements
    surface: AppColors.containerLight, // Used for surfaces of cards, sheets, menus
    error: AppColors.red, // Used for error messages and validation errors
    onPrimary: Colors.white, // Text/icon color when on primary-colored backgrounds
    onSecondary: Colors.white, // Text/icon color when on secondary-colored backgrounds
    onSurface: AppColors.textLight, // Default text color
    onError: Colors.white, // Text/icon color when on error-colored backgrounds
    tertiary: AppColors.orange, // Used for additional accents and highlights
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle( // Used for the main chess clock timer display
      fontSize: 72,
      fontWeight: FontWeight.bold,
      color: AppColors.timerTextLight,
    ),
    displayMedium: TextStyle( // Used for secondary timer displays or smaller clocks
      fontSize: 48,
      fontWeight: FontWeight.w600,
      color: AppColors.timerTextLight,
    ),
    bodyLarge: TextStyle( // For normal paragraph text (settings, descriptions)
      fontSize: 16,
      color: AppColors.textLight,
    ),
    bodyMedium: TextStyle( // For smaller text (captions, helper text)
      fontSize: 14,
      color: AppColors.textLight,
    ),
    titleLarge: TextStyle( // For section headings and important labels
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textLight,
    ),
  ),
  appBarTheme: const AppBarTheme( // Styling for all AppBars in the app
    backgroundColor: AppColors.secondaryLight,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Colors.white), // Color for back button and action icons
  ),
  elevatedButtonTheme: ElevatedButtonThemeData( // Styling for all ElevatedButtons
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonLight, // Button background color
      foregroundColor: Colors.white, // Text and icon color
      textStyle: const TextStyle(fontWeight: FontWeight.bold), // Button text style
      shape: RoundedRectangleBorder( // Button shape and corners
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Button padding
    ),
  ),
  cardTheme: CardTheme( // Styling for all Cards in the app
    color: AppColors.containerLight, // Card background color
    elevation: 2, // Shadow depth
    margin: const EdgeInsets.all(8), // Default margin around cards
    shape: RoundedRectangleBorder( // Card shape and corners
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);

/// Dark theme configuration for the chess clock app
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.backgroundDark, // Dark background for Scaffold
  primaryColor: AppColors.primaryDark, // Primary color for widgets in dark mode
  colorScheme: const ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColors.primaryDark, // Primary color in dark mode
    secondary: AppColors.secondaryDark, // Secondary color in dark mode
    surface: AppColors.containerDark, // Card/surface color in dark mode
    error: AppColors.red, // Error color remains the same
    onPrimary: Colors.white, // Text on primary-colored widgets
    onSecondary: Colors.white, // Text on secondary-colored widgets
    onSurface: AppColors.textDark, // Default text color in dark mode
    onError: Colors.white, // Text on error-colored widgets
    tertiary: AppColors.orange, // Accent color remains the same
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle( // Dark mode timer display
      fontSize: 72,
      fontWeight: FontWeight.bold,
      color: AppColors.timerTextDark,
    ),
    displayMedium: TextStyle( // Secondary timer displays in dark mode
      fontSize: 48,
      fontWeight: FontWeight.w600,
      color: AppColors.timerTextDark,
    ),
    bodyLarge: TextStyle( // Paragraph text in dark mode
      fontSize: 16,
      color: AppColors.textDark,
    ),
    bodyMedium: TextStyle( // Small text in dark mode
      fontSize: 14,
      color: AppColors.textDark,
    ),
    titleLarge: TextStyle( // Headings in dark mode
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textDark,
    ),
  ),
  appBarTheme: const AppBarTheme( // Dark mode AppBar styling
    backgroundColor: AppColors.secondaryDark,
    elevation: 2,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData( // Dark mode button styling
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.buttonDark,
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    ),
  ),
  cardTheme: CardTheme( // Dark mode card styling
    color: AppColors.containerDark,
    elevation: 2,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
);