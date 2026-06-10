import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../mood/mood_tracking_screen.dart';
import '../../core/services/mission_service.dart';
import '../../models/alarm_entity.dart';
import '../../core/utils/math_generator.dart';

class MathChallengeScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;
  final AlarmEntity? alarm;

  const MathChallengeScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
    this.alarm,
  });

  @override
  ConsumerState<MathChallengeScreen> createState() => _MathChallengeScreenState();
}

class _MathChallengeScreenState extends ConsumerState<MathChallengeScreen>
    with SingleTickerProviderStateMixin {
  late int _difficulty;
  late String _problem;
  late String _answer;
  String _input = '';
  int _solvedCount = 0;
  late int _totalCount;

  late final AnimationController _shakeController;
  bool _isError = false;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _difficulty = widget.alarm?.mathDifficulty ?? 1;
    _initMathSession();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  void _initMathSession() {
    if (_difficulty == 0) {
      _totalCount = 3;
    } else if (_difficulty == 1) {
      _totalCount = 5;
    } else {
      _totalCount = 7;
    }
    _solvedCount = 0;
    _input = '';
    _generateProblem();
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _generateProblem() {
    final question = MathGenerator.generate(_difficulty);
    _problem = question.expression;
    _answer = question.answer;
  }

  void _onKeyTap(String key) {
    if (_isSuccess || _isError) return;

    if (key == 'C') {
      setState(() {
        _input = '';
      });
      return;
    }

    if (key == '✓') {
      if (_input.isEmpty) return;
      if (_input == _answer) {
        setState(() {
          _isSuccess = true;
        });
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _isSuccess = false;
              _solvedCount++;
              if (_solvedCount >= _totalCount) {
                _finish();
              } else {
                _generateProblem();
                _input = '';
              }
            });
          }
        });
      } else {
        setState(() {
          _isError = true;
        });
        _shakeController.forward(from: 0.0);
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) {
            setState(() {
              _isError = false;
              _input = '';
            });
          }
        });
      }
      return;
    }

    if (_input.length < 6) {
      setState(() {
        _input += key;
      });
    }
  }

  void _finish() async {
    if (!widget.isPreview) {
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Math',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
        alarm: widget.alarm,
        mathDifficulty: _difficulty,
        mathQuestionsSolved: _totalCount,
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
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
            (route) => route.isFirst,
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

    final diffLabels = ['Easy', 'Medium', 'Hard'];
    final diffColors = [HelioColors.success, primaryColor, HelioColors.warning];
    final diffColor = diffColors[_difficulty];
    final diffLabel = diffLabels[_difficulty];

    Color borderAndShadowColor = primaryColor;
    if (_isError) {
      borderAndShadowColor = HelioColors.error;
    } else if (_isSuccess) {
      borderAndShadowColor = HelioColors.success;
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SkyBackground(
        showForeground: false,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'Quick Math',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              if (widget.isPreview)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    final label = diffLabels[index];
                    final color = diffColors[index];
                    final isSelected = _difficulty == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : textColor.withValues(alpha: 0.6),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: color,
                        backgroundColor: (isNight ? Colors.white : Colors.black).withValues(alpha: 0.05),
                        checkmarkColor: Colors.white,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _difficulty = index;
                              _initMathSession();
                            });
                          }
                        },
                      ),
                    );
                  }),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: diffColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: diffColor.withOpacity(0.3), width: 1.5),
                  ),
                  child: Text(
                    diffLabel.toUpperCase(),
                    style: TextStyle(
                      color: diffColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Question ${_solvedCount + 1} of $_totalCount',
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _problem,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: _difficulty == 2 ? 64 : 80,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  final offset = sin(_shakeController.value * 4 * pi) * 15;
                  return Transform.translate(
                    offset: Offset(_isError ? offset : 0, 0),
                    child: child,
                  );
                },
                child: Container(
                  height: 80,
                  width: 220,
                  decoration: BoxDecoration(
                    color: borderAndShadowColor.withOpacity(0.1),
                    border: Border.all(color: borderAndShadowColor, width: 3),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: borderAndShadowColor.withOpacity(0.2),
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
              ),
              const Spacer(),
              _buildKeypad(isNight, textColor, primaryColor),
              const SizedBox(height: 40),
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
