import 'package:flutter/material.dart';
import 'theme_extensions.dart';

class AppTheme {
  // Day colors
  static final _dayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: const [Color(0xFF87CEEB), Color(0xFFBFE9FF), Color(0xFFFFF3B0)],
  );

  static final lightScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFFFFD54F),
    brightness: Brightness.light,
  );

  static final darkScheme = ColorScheme.fromSeed(
    seedColor: const Color(0xFF1B1636),
    brightness: Brightness.dark,
  );

  static ThemeData dayTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightScheme,
    scaffoldBackgroundColor: Colors.transparent,
    cardColor: Colors.white,
    textTheme: Typography.material2021().black,
    extensions: <ThemeExtension<dynamic>>[
      SkyTheme(
        skyGradient: _dayGradient,
        sunColor: const Color(0xFFFFD54F),
        cloudColor: Colors.white.withOpacity(0.9),
        cardColor: Colors.white,
        starColor: const Color(0xFFFFF59D),
      ),
    ],
  );

  static ThemeData nightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkScheme,
    scaffoldBackgroundColor: Colors.black,
    cardColor: Colors.white.withOpacity(0.06),
    textTheme: Typography.material2021().white,
    extensions: <ThemeExtension<dynamic>>[
      const SkyTheme(
        skyGradient: LinearGradient(
          colors: [Color(0xFF0D1B2A), Color(0xFF1B1636)],
        ),
        moonColor: Color(0xFFF5F5F5),
        cloudColor: Color(0xFF2A3440),
        cardColor: Color(0xFF0F1720),
        starColor: Color(0xFFFFF59D),
      ),
    ],
  );
}
