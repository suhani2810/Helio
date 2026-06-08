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
          color: Colors.white.withOpacity(0.95),
          boxShadow: [
            BoxShadow(color: Colors.white.withOpacity(0.06), blurRadius: 20),
          ],
        ),
        child: Align(
          alignment: Alignment(-0.3, -0.3),
          child: Container(
            width: widget.size * 0.6,
            height: widget.size * 0.6,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.02),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
