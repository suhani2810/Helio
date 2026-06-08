import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart' as rive;
import '../../core/theme/theme_extensions.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import 'animated_clouds.dart';
import 'animated_sun.dart';
import 'animated_moon.dart';
import 'animated_stars.dart';

enum DaySegment { earlyMorning, day, evening, night }

DaySegment _segmentForHour(int hour) {
  if (hour >= 5 && hour < 8) return DaySegment.earlyMorning;
  if (hour >= 8 && hour < 17) return DaySegment.day;
  if (hour >= 17 && hour < 19) return DaySegment.evening;
  return DaySegment.night;
}

class SkyBackground extends ConsumerWidget {
  final Widget? child;
  const SkyBackground({super.key, this.child});

  String _greetingForSegment(DaySegment s) {
    switch (s) {
      case DaySegment.earlyMorning:
        return 'Good Morning';
      case DaySegment.day:
        return 'Good Day';
      case DaySegment.evening:
        return 'Good Evening';
      case DaySegment.night:
        return 'Sleep Well';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeControllerProvider);
    final now = DateTime.now();
    final segment = _segmentForHour(now.hour);
    final sky = Theme.of(context).extension<SkyTheme>();
    final isNight =
        mode == AppThemeMode.night ||
        (mode == AppThemeMode.auto && (segment == DaySegment.night));

    return Container(
      decoration: BoxDecoration(
        gradient:
            sky?.skyGradient ??
            (isNight
                ? const LinearGradient(
                    colors: [Color(0xFF0D1B2A), Color(0xFF1B1636)],
                  )
                : const LinearGradient(
                    colors: [Color(0xFF87CEEB), Color(0xFFBFE9FF)],
                  )),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox.expand(
          child: Stack(
            children: [
              if (!isNight && segment != DaySegment.day)
                Positioned(
                  top: 24,
                  left: 24,
                  child: AnimatedSun(
                    size: 110,
                    color: sky?.sunColor ?? const Color(0xFFFFD54F),
                  ),
                ),
              if (!isNight && segment != DaySegment.day)
                Positioned(
                  top: 140,
                  left: -20,
                  right: -20,
                  child: AnimatedClouds(
                    height: 80,
                    color: sky?.cloudColor ?? Colors.white,
                  ),
                ),
              if (!isNight && segment == DaySegment.day)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 24,
                        left: 20,
                        right: 20,
                      ),
                      child: SizedBox(
                        height: 280,
                        child: rive.RiveAnimation.asset(
                          'assets/181-339-weather-icon.riv',
                          fit: BoxFit.contain,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              if (isNight)
                Positioned(top: 40, right: 28, child: AnimatedMoon(size: 90)),
              if (isNight)
                Positioned.fill(
                  child: IgnorePointer(child: AnimatedStars(count: 40)),
                ),
              Positioned.fill(child: child ?? const SizedBox()),
              Positioned(
                left: 20,
                top: 20,
                child: Text(
                  _greetingForSegment(segment),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: isNight ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
