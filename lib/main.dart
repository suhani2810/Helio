import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/design_system/theme.dart';
import 'navigation_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Force dark status bar icons (light text on dark bg)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );
  // Lock to portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const ProviderScope(child: HelioApp()));
}

class HelioApp extends StatelessWidget {
  const HelioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helio',
      debugShowCheckedModeBanner: false,
      theme: HelioTheme.darkTheme,
      darkTheme: HelioTheme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const NavigationWrapper(),
    );
  }
}
