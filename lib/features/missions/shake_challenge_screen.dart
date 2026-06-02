import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';

class ShakeChallengeScreen extends StatefulWidget {
  const ShakeChallengeScreen({super.key});

  @override
  State<ShakeChallengeScreen> createState() => _ShakeChallengeScreenState();
}

class _ShakeChallengeScreenState extends State<ShakeChallengeScreen> {
  double _progress = 0.0;

  void _onShake() {
    setState(() {
      _progress += 0.05;
      if (_progress >= 1.0) {
        _progress = 1.0;
        _finish();
      }
    });
  }

  void _finish() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Energy levels 100%! Ready to go!')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [HelioColors.backgroundDark, HelioColors.dawnPurple],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.vibration, size: 100, color: HelioColors.sunriseOrange),
            const SizedBox(height: 40),
            Text(
              'Shake to Wake!',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Simulate by clicking rapidly',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: _onShake,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 200,
                    width: 200,
                    child: CircularProgressIndicator(
                      value: _progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.white.withOpacity(0.1),
                      color: HelioColors.sunriseOrange,
                    ),
                  ),
                  Text(
                    '${(_progress * 100).toInt()}%',
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
