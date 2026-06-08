import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'navigation_wrapper.dart';

void main() {
  runApp(const ProviderScope(child: HelioApp()));
}

class HelioApp extends ConsumerWidget {
  const HelioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref
        .read(themeControllerProvider.notifier)
        .isDarkModeForHour();

    return MaterialApp(
      title: 'Helio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dayTheme,
      darkTheme: AppTheme.nightTheme,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: const NavigationWrapper(),
    );
  }
}
