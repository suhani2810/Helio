import 'package:flutter/material.dart';

class HelioColors {
  // Sunrise Palette
  static const Color dawnPurple = Color(0xFF2E3B55);
  static const Color sunriseOrange = Color(0xFFFF8C00);
  static const Color morningYellow = Color(0xFFFFD700);
  static const Color softPink = Color(0xFFFF69B4);
  static const Color deepGold = Color(0xFFB8860B);

  // Backgrounds
  static const Color backgroundDark = Color(0xFF0F0F1A);
  static const Color surfaceDark = Color(0xFF1C1C2E);
  static const Color cardDark = Color(0xFF2A2A40);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFAAAAAA);

  // Gradients
  static const Gradient sunriseGradient = LinearGradient(
    colors: [dawnPurple, softPink, sunriseOrange, morningYellow],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );
}
