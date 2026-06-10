import 'package:flutter/material.dart';

class AnimatedMoon extends StatefulWidget {
  final double size;

  const AnimatedMoon({super.key, this.size = 90});

  @override
  State<AnimatedMoon> createState() => _AnimatedMoonState();
}

class _AnimatedMoonState extends State<AnimatedMoon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(
        begin: 0.85,
        end: 1.0,
      ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)),
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.95),
          boxShadow: [
            BoxShadow(color: Colors.white.withValues(alpha: 0.1), blurRadius: 20),
          ],
        ),
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(-0.3, -0.3),
              child: Container(
                width: widget.size * 0.6,
                height: widget.size * 0.6,
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            CustomPaint(
              size: Size(widget.size, widget.size),
              painter: _MoonFacePainter(),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoonFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Eyes
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(-radius * 0.25, -radius * 0.1),
        width: radius * 0.3,
        height: radius * 0.15,
      ),
      3.14,
      3.14,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(radius * 0.25, -radius * 0.1),
        width: radius * 0.3,
        height: radius * 0.15,
      ),
      3.14,
      3.14,
      false,
      paint,
    );

    // Smile
    canvas.drawArc(
      Rect.fromCenter(
        center: center.translate(0, radius * 0.2),
        width: radius * 0.5,
        height: radius * 0.3,
      ),
      0,
      3.14,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
