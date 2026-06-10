import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/colors.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../widgets/theme/sky_background.dart';
import '../../widgets/premium_card.dart';
import '../../core/services/mission_service.dart';
import '../mood/mood_tracking_screen.dart';
import '../../core/utils/sentence_pool.dart';
import '../../models/alarm_entity.dart';

class TypingChallengeScreen extends ConsumerStatefulWidget {
  final bool isPreview;
  final DateTime? scheduledTime;
  final AlarmEntity? alarm;

  const TypingChallengeScreen({
    super.key,
    this.isPreview = false,
    this.scheduledTime,
    this.alarm,
  });

  @override
  ConsumerState<TypingChallengeScreen> createState() => _TypingChallengeScreenState();
}

class _TypingChallengeScreenState extends ConsumerState<TypingChallengeScreen> {
  late final String _target;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _target = SentencePool.getRandomSentence();
    _controller.addListener(() {
      setState(() {});
      if (_controller.text == _target) {
        _focusNode.unfocus();
      }
    });
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollToInput();
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNode.hasFocus) {
        _scrollToInput();
      }
    });
  }

  void _scrollToInput() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _finish() async {
    if (!widget.isPreview) {
      await ref.read(missionServiceProvider).completeMission(
        missionType: 'Typing',
        scheduledTime: widget.scheduledTime ?? DateTime.now(),
        alarm: widget.alarm,
      );
    }

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(widget.isPreview ? 'Preview Complete!' : 'Well typed! Wake up time!')),
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

    final String typed = _controller.text;
    final int minLen = min(typed.length, _target.length);
    int correctCount = 0;
    for (int i = 0; i < minLen; i++) {
      if (typed[i] == _target[i]) {
        correctCount++;
      }
    }

    final double progressPercent = _target.isEmpty ? 1.0 : (typed.length / _target.length).clamp(0.0, 1.0);
    final int progressValue = (progressPercent * 100).toInt();

    final double accuracyPercent = typed.isEmpty ? 1.0 : (correctCount / typed.length).clamp(0.0, 1.0);
    final int accuracyValue = (accuracyPercent * 100).toInt();

    final bool isCorrect = typed == _target;
    final Color accuracyColor = accuracyValue == 100 ? Colors.green : (accuracyValue >= 90 ? Colors.orange : HelioColors.error);

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: SkyBackground(
        showForeground: false,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_rounded, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Typing Mission',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Type the following exactly:',
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Highlighted Target Text Card
                      PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.all(24),
                        child: _buildHighlightedTargetText(typed, _target, textColor, primaryColor),
                      ),
                      const SizedBox(height: 24),

                      // Real-time Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progressPercent,
                          minHeight: 6,
                          backgroundColor: primaryColor.withOpacity(0.08),
                          color: accuracyValue < 90 ? HelioColors.error : primaryColor,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stats Dashboard Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatItem('Typed', '${typed.length}/${_target.length}', textColor),
                          _buildStatItem('Progress', '$progressValue%', textColor),
                          _buildStatItem('Accuracy', '$accuracyValue%', accuracyColor),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // User Input Field Card
                      PremiumCard(
                        isGlass: isNight,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: TextField(
                          controller: _controller,
                          focusNode: _focusNode,
                          autofocus: true,
                          maxLines: null,
                          autocorrect: false,
                          enableSuggestions: false,
                          smartQuotesType: SmartQuotesType.disabled,
                          smartDashesType: SmartDashesType.disabled,
                          style: TextStyle(fontSize: 18, color: textColor, fontWeight: FontWeight.w600),
                          decoration: InputDecoration(
                            hintText: 'Start typing...',
                            hintStyle: TextStyle(color: textColor.withOpacity(0.3)),
                            border: InputBorder.none,
                          ),
                          onTap: _scrollToInput,
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Complete Action Button
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: ElevatedButton(
                          onPressed: isCorrect ? _finish : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: primaryColor.withOpacity(0.12),
                            disabledForegroundColor: textColor.withOpacity(0.2),
                            minimumSize: const Size(double.infinity, 56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: isCorrect ? 8 : 0,
                            shadowColor: primaryColor.withOpacity(0.4),
                          ),
                          child: Text(
                            'COMPLETE MISSION',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                              letterSpacing: 1.0,
                              color: isCorrect ? Colors.white : textColor.withOpacity(0.3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlightedTargetText(String typed, String target, Color textColor, Color primaryColor) {
    List<TextSpan> spans = [];
    for (int i = 0; i < target.length; i++) {
      if (i < typed.length) {
        if (typed[i] == target[i]) {
          spans.add(TextSpan(
            text: target[i],
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w900,
            ),
          ));
        } else {
          spans.add(TextSpan(
            text: target[i],
            style: const TextStyle(
              color: HelioColors.error,
              fontWeight: FontWeight.w900,
              decoration: TextDecoration.underline,
              decorationColor: HelioColors.error,
            ),
          ));
        }
      } else {
        spans.add(TextSpan(
          text: target[i],
          style: TextStyle(
            color: textColor.withOpacity(0.3),
            fontWeight: FontWeight.w700,
          ),
        ));
      }
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 20,
          height: 1.5,
        ),
        children: spans,
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color valueColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: valueColor.withOpacity(0.5),
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: valueColor,
          ),
        ),
      ],
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }
}
