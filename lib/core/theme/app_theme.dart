import 'package:flutter/material.dart';
import '../design_system/colors.dart';
import 'theme_extensions.dart';

class AppTheme {
  static final _dayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [Color(0xFFDFF6FF), Color(0xFFBEE7FF), Color(0xFF8EC5FF)],
  );

  static final _nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [HelioColors.nightBackgroundStart, HelioColors.nightBackgroundEnd],
  );

  static ThemeData dayTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: HelioColors.dayPrimary,
      primary: HelioColors.dayPrimary,
      secondary: HelioColors.daySecondary,
      surface: HelioColors.dayCard,
      onSurface: HelioColors.dayText,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    cardTheme: CardThemeData(
      color: HelioColors.dayCard,
      elevation: 4,
      shadowColor: HelioColors.dayShadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),
    textTheme: Typography.material2021().black.apply(
      displayColor: HelioColors.dayText,
      bodyColor: HelioColors.dayText,
      fontFamily: 'Inter',
    ),
    extensions: <ThemeExtension<dynamic>>[
      SkyTheme(
        skyGradient: _dayGradient,
        sunColor: HelioColors.daySecondary,
        cloudColor: Colors.white.withOpacity(0.9),
        cardColor: HelioColors.dayCard,
        accentColor: HelioColors.dayPrimary,
      ),
    ],
  );

  static ThemeData nightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: HelioColors.nightPrimary,
      brightness: Brightness.dark,
      primary: HelioColors.nightPrimary,
      secondary: HelioColors.nightSecondary,
      surface: HelioColors.nightCard,
      onSurface: HelioColors.nightText,
    ),
    scaffoldBackgroundColor: Colors.transparent,
    cardTheme: CardThemeData(
      color: HelioColors.nightCard.withOpacity(0.8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
        side: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
      ),
    ),
    textTheme: Typography.material2021().white.apply(
      displayColor: Colors.white,
      bodyColor: Colors.white.withOpacity(0.9),
      fontFamily: 'Inter',
    ),
    extensions: <ThemeExtension<dynamic>>[
      SkyTheme(
        skyGradient: _nightGradient,
        moonColor: Colors.white,
        cloudColor: const Color(0xFF2A3440).withOpacity(0.5),
        cardColor: HelioColors.nightCard,
        accentColor: HelioColors.nightPrimary,
      ),
    ],
  );
}
