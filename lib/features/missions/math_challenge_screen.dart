import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../mood/mood_tracking_screen.dart';
import '../../core/services/mission_service.dart';

class MathChallengeScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;

  const MathChallengeScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
  });

  @override
  ConsumerState<MathChallengeScreen> createState() => _MathChallengeScreenState();
}

class _MathChallengeScreenState extends ConsumerState<MathChallengeScreen> {
  final String _problem = '24 + 17';
  final String _answer = '41';
  String _input = '';

  void _onKeyTap(String key) {
    if (key == '✓') return;
    setState(() {
      if (key == 'C') {
        _input = '';
      } else if (_input.length < 3) {
        _input += key;
      }
    });

    if (_input == _answer) {
      _finish();
    }
  }

  void _finish() async {
    if (!widget.isPreview) {
      // Task 2: Real completion flow
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Math',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
      );
    }

    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.isPreview ? 'Preview Complete!' : 'Success! Good morning!')),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        if (widget.isPreview) {
          Navigator.of(context).pop();
        } else {
          // Task 2: Open Mood Screen after success
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeControllerProvider);
    final isNight = _isNightMode(themeMode, DateTime.now().hour);
    final textColor = isNight ? Colors.white : HelioColors.dayText;
    final primaryColor = isNight ? HelioColors.nightPrimary : HelioColors.dayPrimary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        showForeground: false,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Text(
                'Quick Math',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 48),
              Text(
                _problem,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 96,
                  fontWeight: FontWeight.w900,
                  color: textColor,
                  letterSpacing: -2,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                height: 90,
                width: 220,
                decoration: BoxDecoration(
                  color: (isNight ? Colors.white : primaryColor).withValues(alpha: 0.1),
                  border: Border.all(color: primaryColor, width: 3),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha: 0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _input,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              _buildKeypad(isNight, textColor, primaryColor),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }

  Widget _buildKeypad(bool isNight, Color textColor, Color primaryColor) {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', '✓'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 48),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.4,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        final key = keys[index];
        final isSpecial = key == 'C' || key == '✓';
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _onKeyTap(key),
            borderRadius: BorderRadius.circular(20),
            child: PremiumCard(
              isGlass: isNight,
              padding: EdgeInsets.zero,
              child: Center(
                child: Text(
                  key,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: isSpecial ? primaryColor : textColor,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
