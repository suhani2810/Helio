import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';
import '../mood/mood_tracking_screen.dart';

class MathChallengeScreen extends StatefulWidget {
  const MathChallengeScreen({super.key});

  @override
  State<MathChallengeScreen> createState() => _MathChallengeScreenState();
}

class _MathChallengeScreenState extends State<MathChallengeScreen> {
  final String _problem = '24 + 17';
  final String _answer = '41';
  String _input = '';

  void _onKeyTap(String key) {
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

  void _finish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Success! Good morning!')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text('Quick Math', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            Text(
              _problem,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 80),
            ),
            const SizedBox(height: 20),
            Container(
              height: 80,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: HelioColors.sunriseOrange, width: 2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  _input,
                  style: Theme.of(context).textTheme.displayMedium,
                ),
              ),
            ),
            const Spacer(),
            _buildKeypad(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', 'C', '0', '✓'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 40),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () => _onKeyTap(keys[index]),
          style: ElevatedButton.styleFrom(
            backgroundColor: HelioColors.cardDark,
            foregroundColor: HelioColors.textPrimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(keys[index], style: const TextStyle(fontSize: 24)),
        );
      },
    );
  }
}
