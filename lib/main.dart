import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/design_system/theme.dart';
import 'navigation_wrapper.dart';

void main() {
  runApp(
    const ProviderScope(
      child: HelioApp(),
    ),
  );
}

class HelioApp extends StatelessWidget {
  const HelioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helio',
      debugShowCheckedModeBanner: false,
      theme: HelioTheme.darkTheme, // We'll use dark theme as primary for premium feel
      home: const NavigationWrapper(),
    );
  }
}
