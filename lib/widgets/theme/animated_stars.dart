import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedStars extends StatefulWidget {
  final int count;
  const AnimatedStars({super.key, this.count = 100});

  @override
  State<AnimatedStars> createState() => _AnimatedStarsState();
}

class _AnimatedStarsState extends State<AnimatedStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  final List<_Star> _stars = [];
  final _rnd = Random();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
    
    for (int i = 0; i < widget.count; i++) {
      _stars.add(_Star(
        x: _rnd.nextDouble(),
        y: _rnd.nextDouble(),
        size: 0.5 + _rnd.nextDouble() * 2.0,
        delay: _rnd.nextDouble(),
        speed: 0.5 + _rnd.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarPainter(_stars, _ctrl.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class _Star {
  final double x, y, size, delay, speed;
  _Star({required this.x, required this.y, required this.size, required this.delay, required this.speed});
}

class _StarPainter extends CustomPainter {
  final List<_Star> stars;
  final double progress;

  _StarPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (var star in stars) {
      final t = (progress + star.delay) % 1.0;
      final opacity = 0.2 + (sin(t * pi * 2) + 1.0) / 2.0 * 0.8;
      paint.color = Colors.white.withOpacity(opacity.clamp(0.0, 1.0));
      canvas.drawCircle(
        Offset(star.x * size.width, star.y * size.height),
        star.size,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) => true;
}
