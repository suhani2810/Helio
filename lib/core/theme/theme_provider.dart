import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_mode_enum.dart';

const _kPrefKey = 'helio_selected_theme_mode';

class ThemeController extends StateNotifier<AppThemeMode> {
  ThemeController() : super(AppThemeMode.auto) {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_kPrefKey);
    if (stored != null) {
      try {
        state = AppThemeMode.values.firstWhere((e) => e.toString() == stored);
      } catch (_) {
        state = AppThemeMode.auto;
      }
    }
  }

  Future<void> setMode(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefKey, mode.toString());
  }

  bool isDarkModeForHour([DateTime? now]) {
    now ??= DateTime.now();
    if (state == AppThemeMode.day) return false;
    if (state == AppThemeMode.night) return true;
    // Auto: 6 AM - 6 PM day, otherwise night
    final hour = now.hour;
    return !(hour >= 6 && hour < 18);
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, AppThemeMode>((ref) {
      return ThemeController();
    });
