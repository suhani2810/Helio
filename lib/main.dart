import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarm/alarm.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/theme_mode_enum.dart';
import 'navigation_wrapper.dart';
import 'core/services/alarm_scheduler_service.dart';
import 'core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Task 1: Initialize Alarm Service
  await AlarmSchedulerService.init();
  
  // Task 9: Initialize Notifications
  final notificationService = NotificationService();
  await notificationService.init();

  // Force translucent status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const ProviderScope(child: HelioApp()));
}

class HelioApp extends ConsumerWidget {
  const HelioApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    
    // Determine the actual theme mode to use for MaterialApp
    ThemeMode materialThemeMode;
    switch (mode) {
      case AppThemeMode.day:
        materialThemeMode = ThemeMode.light;
        break;
      case AppThemeMode.night:
        materialThemeMode = ThemeMode.dark;
        break;
      case AppThemeMode.auto:
        materialThemeMode = ThemeMode.system;
        break;
    }

    return MaterialApp(
      title: 'Helio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dayTheme,
      darkTheme: AppTheme.nightTheme,
      themeMode: materialThemeMode,
      home: const NavigationWrapper(),
    );
  }
}
