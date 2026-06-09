import 'dart:math';
import 'package:flutter/material.dart';

/// A self-contained widget that displays an animated crescent moon with a pulsing glow.
class CustomAnimatedMoon extends StatefulWidget {
  final double size;
  const CustomAnimatedMoon({super.key, this.size = 140});

  @override
  State<CustomAnimatedMoon> createState() => _CustomAnimatedMoonState();
}

class _CustomAnimatedMoonState extends State<CustomAnimatedMoon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    // Duration for one complete cycle of floating and pulsing
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // Subtle floating movement (y-axis)
    _floatAnimation = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Dynamic glow radius for the pulsing effect
    _glowAnimation = Tween<double>(begin: 30, end: 50).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: SizedBox(
            width: widget.size + 100, // Extra space for the glow
            height: widget.size + 100,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Local twinkling stars specifically around the moon
                Positioned.fill(child: const LocalTwinklingStars()),
                
                // The Moon itself
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: MoonPainter(glowRadius: _glowAnimation.value),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Painter class that draws a realistic crescent moon using vector paths.
class MoonPainter extends CustomPainter {
  final double glowRadius;
  MoonPainter({required this.glowRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // 1. Draw Outer Atmosheric Glow
    final glowPaint = Paint()
      ..color = const Color(0xFF7C9DFF).withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, glowRadius);
    canvas.drawCircle(center, radius * 1.1, glowPaint);

    // 2. Define the Crescent Shape
    // We create a crescent by taking one circle and subtracting another offset circle from it.
    final moonPath = Path.combine(
      PathOperation.difference,
      Path()..addOval(Rect.fromCircle(center: center, radius: radius)),
      Path()..addOval(Rect.fromCircle(
        center: center.translate(radius * 0.6, -radius * 0.2), // Offset for crescent curve
        radius: radius * 0.95,
      )),
    );

    // 3. Draw the Moon body with a soft gradient
    final moonPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white,
          Color(0xFFE0E7FF), // Soft blue-ish white
          Color(0xFFB0C4FF),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));

    canvas.drawPath(moonPath, moonPaint);

    // 4. DRAW SMILEY FACE
    final facePaint = Paint()
      ..color = const Color(0xFF071330).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Eyes
    canvas.drawCircle(center.translate(-radius * 0.2, -radius * 0.1), 3, Paint()..color = facePaint.color);
    canvas.drawCircle(center.translate(radius * 0.2, -radius * 0.1), 3, Paint()..color = facePaint.color);

    // Smile
    final smilePath = Path()
      ..addArc(
        Rect.fromCenter(center: center.translate(0, radius * 0.1), width: radius * 0.4, height: radius * 0.3),
        0.2,
        pi - 0.4,
      );
    canvas.drawPath(smilePath, facePaint);

    // 5. Subtle Inner Rim Highlight
    final rimPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawPath(moonPath, rimPaint);
  }

  @override
  bool shouldRepaint(covariant MoonPainter oldDelegate) =>
      oldDelegate.glowRadius != glowRadius;
}

/// A lightweight widget for stars that twinkle specifically in the moon's vicinity.
class LocalTwinklingStars extends StatefulWidget {
  const LocalTwinklingStars({super.key});

  @override
  State<LocalTwinklingStars> createState() => _LocalTwinklingStarsState();
}

class _LocalTwinklingStarsState extends State<LocalTwinklingStars>
    with SingleTickerProviderStateMixin {
  late AnimationController _starController;
  final List<Offset> _starPositions = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _starController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Generate random star positions within the moon's container
    for (int i = 0; i < 8; i++) {
      _starPositions.add(Offset(
        _random.nextDouble() * 200,
        _random.nextDouble() * 200,
      ));
    }
  }

  @override
  void dispose() {
    _starController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _starController,
      builder: (context, child) {
        return CustomPaint(
          painter: _StarPainter(_starPositions, _starController.value),
        );
      },
    );
  }
}

class _StarPainter extends CustomPainter {
  final List<Offset> positions;
  final double animationValue;
  _StarPainter(this.positions, this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < positions.length; i++) {
      // Create independent twinkling by offsetting with index
      final opacity = (0.2 + 0.8 * sin(animationValue * pi + i)).clamp(0.1, 1.0);
      paint.color = Colors.white.withOpacity(opacity);
      canvas.drawCircle(positions[i], i % 2 == 0 ? 1.0 : 1.5, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
