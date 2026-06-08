import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../core/theme/theme_provider.dart';
import '../../widgets/theme/theme_preview_card.dart';

class ThemePreviewScreen extends ConsumerWidget {
  const ThemePreviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    final notifier = ref.read(themeControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Row(
              children: [
                ChoiceChip(
                  label: const Text('Auto'),
                  selected: mode == AppThemeMode.auto,
                  onSelected: (_) => notifier.setMode(AppThemeMode.auto),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Day'),
                  selected: mode == AppThemeMode.day,
                  onSelected: (_) => notifier.setMode(AppThemeMode.day),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Night'),
                  selected: mode == AppThemeMode.night,
                  onSelected: (_) => notifier.setMode(AppThemeMode.night),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Live Previews',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 140,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ThemePreviewCard(
                    label: 'Auto',
                    isNight: false,
                    onTap: () => notifier.setMode(AppThemeMode.auto),
                  ),
                  const SizedBox(width: 12),
                  ThemePreviewCard(
                    label: 'Day',
                    isNight: false,
                    onTap: () => notifier.setMode(AppThemeMode.day),
                  ),
                  const SizedBox(width: 12),
                  ThemePreviewCard(
                    label: 'Night',
                    isNight: true,
                    onTap: () => notifier.setMode(AppThemeMode.night),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 12.0,
                    ),
                    child: Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
