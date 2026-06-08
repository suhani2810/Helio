import 'package:flutter/material.dart';

class AnimatedSun extends StatefulWidget {
  final double size;
  final Color color;

  const AnimatedSun({
    super.key,
    this.size = 120,
    this.color = const Color(0xFFFFD54F),
  });

  @override
  State<AnimatedSun> createState() => _AnimatedSunState();
}

class _AnimatedSunState extends State<AnimatedSun>
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
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        final scale = 1.0 + (_ctrl.value * 0.08);
        return Transform.scale(
          scale: scale,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glow
              Container(
                width: widget.size * 1.4,
                height: widget.size * 1.4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.color.withOpacity(0.4),
                      widget.color.withOpacity(0.0),
                    ],
                  ),
                ),
              ),
              // Sun body
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CustomPaint(
                  painter: _SunFacePainter(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SunFacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);

    // Eyes
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx - size.width * 0.2, center.dy - size.height * 0.05),
        width: size.width * 0.15,
        height: size.height * 0.1,
      ),
      3.14,
      3.14,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx + size.width * 0.2, center.dy - size.height * 0.05),
        width: size.width * 0.15,
        height: size.height * 0.1,
      ),
      3.14,
      3.14,
      false,
      paint,
    );

    // Smile
    canvas.drawArc(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + size.height * 0.1),
        width: size.width * 0.35,
        height: size.height * 0.2,
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
