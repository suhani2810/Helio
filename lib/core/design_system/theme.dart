import 'package:flutter/material.dart';
import 'colors.dart';
import 'typography.dart';

class HelioTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HelioColors.backgroundDark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: HelioColors.sunriseOrange,
        brightness: Brightness.dark,
        primary: HelioColors.sunriseOrange,
        secondary: HelioColors.softPink,
        surface: HelioColors.surfaceDark,
        onSurface: HelioColors.textPrimary,
      ),
      textTheme: HelioTypography.textTheme,
      cardTheme: CardThemeData(
        color: HelioColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: HelioColors.surfaceDark,
        selectedItemColor: HelioColors.sunriseOrange,
        unselectedItemColor: HelioColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HelioColors.sunriseOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}
