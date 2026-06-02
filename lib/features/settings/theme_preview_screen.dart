import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class ThemePreviewScreen extends StatefulWidget {
  const ThemePreviewScreen({super.key});

  @override
  State<ThemePreviewScreen> createState() => _ThemePreviewScreenState();
}

class _ThemePreviewScreenState extends State<ThemePreviewScreen> {
  String _selectedTheme = 'Sunrise';

  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'Sunrise',
      'colors': [HelioColors.sunriseOrange, HelioColors.softPink, HelioColors.dawnPurple],
      'desc': 'Warm, high-energy awakening'
    },
    {
      'name': 'Midnight',
      'colors': [const Color(0xFF1A237E), const Color(0xFF311B92), Colors.black],
      'desc': 'Calm, deep blue stillness'
    },
    {
      'name': 'Forest',
      'colors': [const Color(0xFF1B5E20), const Color(0xFF4CAF50), const Color(0xFFDCEDC8)],
      'desc': 'Nature inspired organic growth'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customization'),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          _buildActivePreview(),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              'Select Your Atmosphere',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _themes.length,
              itemBuilder: (context, index) {
                final theme = _themes[index];
                final isSelected = _selectedTheme == theme['name'];
                return _buildThemeCard(theme, isSelected);
              },
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: HelioColors.sunriseOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Apply Atmosphere', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivePreview() {
    final activeTheme = _themes.firstWhere((t) => t['name'] == _selectedTheme);
    final List<Color> colors = activeTheme['colors'] as List<Color>;

    return Container(
      height: 200,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '07:00',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 72, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildThemeCard(Map<String, dynamic> theme, bool isSelected) {
    final List<Color> colors = theme['colors'] as List<Color>;

    return GestureDetector(
      onTap: () => setState(() => _selectedTheme = theme['name'] as String),
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HelioColors.cardDark,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? HelioColors.sunriseOrange : Colors.white.withOpacity(0.05),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 60,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 16),
            Text(theme['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              theme['desc'] as String,
              style: const TextStyle(fontSize: 10, color: HelioColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}
