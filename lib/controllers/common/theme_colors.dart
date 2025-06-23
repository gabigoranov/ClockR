import 'package:flutter/material.dart';

class ThemeColors {
  // Background colors
  final Color backgroundWhite;
  final Color backgroundDark;

  // Container colors
  final Color containerLight;
  final Color containerDark;

  // Text colors
  final Color textLight;
  final Color textDark;

  // Primary colors
  final Color primaryLight;
  final Color primaryDark;

  // Secondary colors
  final Color secondaryLight;
  final Color secondaryDark;

  // Accent colors
  final Color red;
  final Color orange;

  // Timer text
  final Color timerTextLight;
  final Color timerTextDark;

  // Button colors
  final Color buttonLight;
  final Color buttonDark;

  const ThemeColors({
    this.backgroundWhite = Colors.white,
    this.backgroundDark = const Color(0xff121212),
    this.containerLight = Colors.white,
    this.containerDark = const Color(0xff1E1E1E),
    this.textLight = Colors.black,
    this.textDark = Colors.white,
    this.primaryLight = const Color(0xff5183e1),
    this.primaryDark = const Color(0xff2962FF),
    this.secondaryLight = Colors.blueAccent,
    this.secondaryDark = Colors.blueAccent,
    this.red = const Color(0xffF44336),
    this.orange = const Color(0xffFF9800),
    this.timerTextLight = Colors.black,
    this.timerTextDark = Colors.white,
    this.buttonLight = Colors.blueAccent,
    this.buttonDark = Colors.blueAccent,
  });

  ThemeColors copyWith({
    Color? backgroundWhite,
    Color? backgroundDark,
    Color? containerLight,
    Color? containerDark,
    Color? textLight,
    Color? textDark,
    Color? primaryLight,
    Color? primaryDark,
    Color? secondaryLight,
    Color? secondaryDark,
    Color? red,
    Color? orange,
    Color? timerTextLight,
    Color? timerTextDark,
    Color? buttonLight,
    Color? buttonDark,
  }) {
    return ThemeColors(
      backgroundWhite: backgroundWhite ?? this.backgroundWhite,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      containerLight: containerLight ?? this.containerLight,
      containerDark: containerDark ?? this.containerDark,
      textLight: textLight ?? this.textLight,
      textDark: textDark ?? this.textDark,
      primaryLight: primaryLight ?? this.primaryLight,
      primaryDark: primaryDark ?? this.primaryDark,
      secondaryLight: secondaryLight ?? this.secondaryLight,
      secondaryDark: secondaryDark ?? this.secondaryDark,
      red: red ?? this.red,
      orange: orange ?? this.orange,
      timerTextLight: timerTextLight ?? this.timerTextLight,
      timerTextDark: timerTextDark ?? this.timerTextDark,
      buttonLight: buttonLight ?? this.buttonLight,
      buttonDark: buttonDark ?? this.buttonDark,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'backgroundWhite': backgroundWhite.toARGB32(),
      'backgroundDark': backgroundDark.toARGB32(),
      'containerLight': containerLight.toARGB32(),
      'containerDark': containerDark.toARGB32(),
      'textLight': textLight.toARGB32(),
      'textDark': textDark.toARGB32(),
      'primaryLight': primaryLight.toARGB32(),
      'primaryDark': primaryDark.toARGB32(),
      'secondaryLight': secondaryLight.toARGB32(),
      'secondaryDark': secondaryDark.toARGB32(),
      'red': red.toARGB32(),
      'orange': orange.toARGB32(),
      'timerTextLight': timerTextLight.toARGB32(),
      'timerTextDark': timerTextDark.toARGB32(),
      'buttonLight': buttonLight.toARGB32(),
      'buttonDark': buttonDark.toARGB32(),
    };
  }

  factory ThemeColors.fromJson(Map<String, dynamic> json) {
    return ThemeColors(
      backgroundWhite: Color(json['backgroundWhite'] ?? Colors.white.toARGB32()),
      backgroundDark: Color(json['backgroundDark'] ?? const Color(0xff121212).toARGB32()),
      containerLight: Color(json['containerLight'] ?? Colors.white.toARGB32()),
      containerDark: Color(json['containerDark'] ?? const Color(0xff1E1E1E).toARGB32()),
      textLight: Color(json['textLight'] ?? Colors.black.toARGB32()),
      textDark: Color(json['textDark'] ?? Colors.white.toARGB32()),
      primaryLight: Color(json['primaryLight'] ?? Colors.blueAccent.toARGB32()),
      primaryDark: Color(json['primaryDark'] ?? Colors.blueAccent.toARGB32()),
      secondaryLight: Color(json['secondaryLight'] ?? const Color(0xff5183e1).toARGB32()),
      secondaryDark: Color(json['secondaryDark'] ?? const Color(0xff2962FF).toARGB32()),
      red: Color(json['red'] ?? const Color(0xffF44336).toARGB32()),
      orange: Color(json['orange'] ?? const Color(0xffFF9800).toARGB32()),
      timerTextLight: Color(json['timerTextLight'] ?? Colors.black.toARGB32()),
      timerTextDark: Color(json['timerTextDark'] ?? Colors.white.toARGB32()),
      buttonLight: Color(json['buttonLight'] ?? Colors.blueAccent.toARGB32()),
      buttonDark: Color(json['buttonDark'] ?? Colors.blueAccent.toARGB32()),
    );
  }
}
