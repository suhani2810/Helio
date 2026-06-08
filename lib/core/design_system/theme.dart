import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'colors.dart';
import 'typography.dart';

class HelioTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HelioColors.backgroundDark,

      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: HelioColors.sunriseOrange,
        onPrimary: Colors.white,
        primaryContainer: HelioColors.glassOrange20,
        onPrimaryContainer: HelioColors.amberGlow,
        secondary: HelioColors.twilightPurple,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFF2A1E3F),
        onSecondaryContainer: HelioColors.twilightPurple,
        tertiary: HelioColors.morningYellow,
        onTertiary: HelioColors.backgroundDark,
        error: HelioColors.error,
        onError: Colors.white,
        surface: HelioColors.surfaceDark,
        onSurface: HelioColors.textPrimary,
        surfaceContainerHighest: HelioColors.cardElevated,
        outline: HelioColors.divider,
        outlineVariant: HelioColors.glassWhite6,
      ),

      textTheme: HelioTypography.textTheme,

      // ── AppBar ───────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: HelioTypography.textTheme.headlineSmall?.copyWith(
          color: HelioColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: HelioColors.textPrimary),
      ),

      // ── Cards ──────────────────────────────────────────────────
      cardTheme: CardThemeData(
        color: HelioColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        margin: EdgeInsets.zero,
      ),

      // ── Input Decoration ───────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: HelioColors.cardDark,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: HelioColors.divider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(
            color: HelioColors.sunriseOrange,
            width: 1.5,
          ),
        ),
        hintStyle: HelioTypography.textTheme.bodyMedium,
      ),

      // ── Buttons ──────────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: HelioColors.sunriseOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: HelioTypography.textTheme.labelLarge,
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: HelioColors.sunriseOrange,
          textStyle: HelioTypography.textTheme.labelMedium,
        ),
      ),

      // ── Switch ─────────────────────────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return HelioColors.textTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return HelioColors.sunriseOrange;
          }
          return HelioColors.cardElevated;
        }),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
      ),

      // ── Bottom Nav ───────────────────────────────────────────────
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: HelioColors.navBarBg,
        selectedItemColor: HelioColors.sunriseOrange,
        unselectedItemColor: HelioColors.textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),

      // ── FAB ──────────────────────────────────────────────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: HelioColors.sunriseOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),

      // ── Divider ──────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: HelioColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ── ProgressIndicator ────────────────────────────────────────
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: HelioColors.sunriseOrange,
      ),
    );
  }
}
