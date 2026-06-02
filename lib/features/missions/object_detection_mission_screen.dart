import 'package:flutter/material.dart';
import '../../core/design_system/colors.dart';
import '../mood/mood_tracking_screen.dart';

class ObjectDetectionMissionScreen extends StatefulWidget {
  const ObjectDetectionMissionScreen({super.key});

  @override
  State<ObjectDetectionMissionScreen> createState() => _ObjectDetectionMissionScreenState();
}

class _ObjectDetectionMissionScreenState extends State<ObjectDetectionMissionScreen> {
  bool _isScanning = false;
  double _progress = 0.0;

  void _startScan() async {
    setState(() => _isScanning = true);
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      setState(() => _progress = i / 10);
    }
    _completeMission();
  }

  void _completeMission() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Object "Mug" Detected! Mission Complete.')),
    );
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MoodTrackingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.camera_enhance_outlined, size: 100, color: Colors.white10),
                SizedBox(height: 16),
                Text('Scanner Ready', style: TextStyle(color: Colors.white24)),
              ],
            ),
          ),
          if (_isScanning)
            Center(
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: HelioColors.sunriseOrange, width: 2),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.only(top: 250 * _progress),
                        height: 2,
                        width: 250,
                        color: HelioColors.sunriseOrange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Positioned(
            top: 64,
            left: 24,
            right: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white10),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: HelioColors.morningYellow),
                  SizedBox(width: 12),
                  Text('Detecting: Coffee Mug', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 64,
            left: 64,
            right: 64,
            child: ElevatedButton(
              onPressed: _isScanning ? null : _startScan,
              style: ElevatedButton.styleFrom(
                backgroundColor: HelioColors.sunriseOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
              ),
              child: Text(_isScanning ? 'SCANNING...' : 'START DETECTION'),
            ),
          ),
        ],
      ),
    );
  }
}
