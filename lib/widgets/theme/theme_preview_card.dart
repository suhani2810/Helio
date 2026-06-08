import 'package:flutter/material.dart';
import 'animated_sun.dart';
import 'animated_moon.dart';

class ThemePreviewCard extends StatelessWidget {
  final String label;
  final bool isNight;
  final VoidCallback? onTap;

  const ThemePreviewCard({
    super.key,
    required this.label,
    this.isNight = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isNight
              ? const LinearGradient(
                  colors: [Color(0xFF0D1B2A), Color(0xFF1B1636)],
                )
              : const LinearGradient(
                  colors: [Color(0xFF87CEEB), Color(0xFFBFE9FF)],
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Center(
                child: isNight
                    ? const AnimatedMoon(size: 46)
                    : const AnimatedSun(size: 46),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isNight ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
