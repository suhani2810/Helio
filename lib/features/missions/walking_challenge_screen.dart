import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class WalkingChallengeScreen extends StatefulWidget {
  const WalkingChallengeScreen({super.key});

  @override
  State<WalkingChallengeScreen> createState() => _WalkingChallengeScreenState();
}

class _WalkingChallengeScreenState extends State<WalkingChallengeScreen> {
  int _steps = 0;
  final int _targetSteps = 30;

  void _onStep() {
    setState(() {
      _steps++;
      if (_steps >= _targetSteps) {
        _finish();
      }
    });
  }

  void _finish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Target reached! You are now fully awake.')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = _steps / _targetSteps;

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [HelioColors.backgroundDark, Color(0xFF1A2E1A)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text('Step Mission', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Physical movement increases heart rate and cortisol levels, helping you naturally transition to wakefulness.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: HelioColors.textSecondary, fontSize: 12),
                ),
              ),
              const Spacer(),
              _buildStepCounter(progress),
              const SizedBox(height: 24),
              Text(
                '${_targetSteps - _steps} steps remaining',
                style: const TextStyle(fontWeight: FontWeight.bold, color: HelioColors.morningYellow),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  _steps < 10 
                      ? 'Keep moving!' 
                      : _steps < 20 
                          ? 'Almost there!' 
                          : 'Just a few more steps...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: HelioColors.sunriseOrange,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              // DEBUG BUTTON
              TextButton(
                onPressed: _onStep,
                child: const Text('DEBUG: SIMULATE STEP'),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepCounter(double progress) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 250,
          width: 250,
          child: CircularProgressIndicator(
            value: progress,
            strokeWidth: 20,
            backgroundColor: Colors.white.withOpacity(0.1),
            color: HelioColors.sunriseOrange,
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.directions_walk, size: 60, color: HelioColors.morningYellow),
            Text(
              '$_steps',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 80),
            ),
            Text(
              '/ $_targetSteps steps',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: HelioColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
