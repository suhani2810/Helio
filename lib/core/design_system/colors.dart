import 'package:flutter/material.dart';

class HelioColors {
  // ── Core Brand ──────────────────────────────────────────────────
  static const Color sunriseOrange = Color(0xFFFF6B35);
  static const Color amberGlow = Color(0xFFFFB347);
  static const Color morningYellow = Color(0xFFFFD166);
  static const Color dawnPink = Color(0xFFFF8FAB);
  static const Color softPink = Color(0xFFFF8FAB);
  static const Color twilightPurple = Color(0xFF9B72CF);
  static const Color dawnPurple = Color(0xFF9B72CF);
  static const Color deepGold = Color(0xFFE8A838);

  // ── Backgrounds ─────────────────────────────────────────────────
  static const Color backgroundDark = Color(0xFF0A0A12);
  static const Color surfaceDark = Color(0xFF13131F);
  static const Color cardDark = Color(0xFF1A1A28);
  static const Color cardElevated = Color(0xFF202032);
  static const Color divider = Color(0xFF2A2A3E);

  // ── Glass / Overlay ─────────────────────────────────────────────
  static const Color glassWhite6 = Color(0x0FFFFFFF);
  static const Color glassWhite10 = Color(0x1AFFFFFF);
  static const Color glassWhite15 = Color(0x26FFFFFF);
  static const Color glassOrange12 = Color(0x1FFF6B35);
  static const Color glassOrange20 = Color(0x33FF6B35);
  static const Color glassOrange30 = Color(0x4DFF6B35);

  // ── Text ────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF5F5F8);
  static const Color textSecondary = Color(0xFF8888AA);
  static const Color textTertiary = Color(0xFF555570);
  static const Color textOrange = Color(0xFFFF8050);

  // ── Semantic ───────────────────────────────────────────────────
  static const Color success = Color(0xFF4CAF8B);
  static const Color warning = Color(0xFFFFB347);
  static const Color error = Color(0xFFFF5E5E);
  static const Color info = Color(0xFF5B9CF6);

  // ── Gradients ──────────────────────────────────────────────────
  static const LinearGradient sunriseGradient = LinearGradient(
    colors: [Color(0xFF1A0A2E), Color(0xFF2E1A0E), Color(0xFFFF6B35)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E30), Color(0xFF16162A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient orangeGradient = LinearGradient(
    colors: [Color(0xFFFF6B35), Color(0xFFFFB347)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFF9B72CF), Color(0xFF5B9CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nightSkyGradient = LinearGradient(
    colors: [Color(0xFF070712), Color(0xFF0F0F1E), Color(0xFF1A0A2E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient morningGradient = LinearGradient(
    colors: [Color(0xFF0D1117), Color(0xFF1A1228), Color(0xFF2E1A0E)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ── Nav bar shadow ───────────────────────────────────────────────
  static const Color navBarBg = Color(0xFF0F0F1E);
}
