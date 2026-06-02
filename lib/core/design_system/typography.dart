import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class HelioTypography {
  static TextTheme get textTheme {
    return GoogleFonts.montserratTextTheme(
      const TextTheme(
        displayLarge: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: HelioColors.textPrimary,
          letterSpacing: -1.0,
        ),
        displayMedium: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: HelioColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: HelioColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: HelioColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: HelioColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: HelioColors.textSecondary,
        ),
      ),
    );
  }
}
