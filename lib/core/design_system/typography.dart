import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class HelioTypography {
  static TextTheme get textTheme {
    // Display / Headline: Sora — geometric, friendly, premium
    // Body / UI: DM Sans — clean, readable, modern
    return TextTheme(
      displayLarge: GoogleFonts.sora(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: HelioColors.textPrimary,
        letterSpacing: -2.0,
        height: 1.0,
      ),
      displayMedium: GoogleFonts.sora(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: HelioColors.textPrimary,
        letterSpacing: -1.2,
      ),
      displaySmall: GoogleFonts.sora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: HelioColors.textPrimary,
        letterSpacing: -0.8,
      ),
      headlineLarge: GoogleFonts.sora(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: HelioColors.textPrimary,
        letterSpacing: -0.5,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: HelioColors.textPrimary,
        letterSpacing: -0.3,
      ),
      headlineSmall: GoogleFonts.sora(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: HelioColors.textPrimary,
      ),
      titleLarge: GoogleFonts.dmSans(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: HelioColors.textPrimary,
        letterSpacing: -0.2,
      ),
      titleMedium: GoogleFonts.dmSans(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: HelioColors.textPrimary,
      ),
      titleSmall: GoogleFonts.dmSans(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: HelioColors.textSecondary,
        letterSpacing: 0.2,
      ),
      bodyLarge: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: HelioColors.textPrimary,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: HelioColors.textSecondary,
        height: 1.5,
      ),
      bodySmall: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: HelioColors.textTertiary,
        letterSpacing: 0.1,
      ),
      labelLarge: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: HelioColors.textPrimary,
        letterSpacing: 0.5,
      ),
      labelMedium: GoogleFonts.dmSans(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: HelioColors.textSecondary,
        letterSpacing: 0.8,
      ),
      labelSmall: GoogleFonts.dmSans(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: HelioColors.textTertiary,
        letterSpacing: 1.2,
      ),
    );
  }
}
