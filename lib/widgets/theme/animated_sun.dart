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
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: Tween(
          begin: 0.98,
          end: 1.06,
        ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut)),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                widget.color.withOpacity(0.95),
                widget.color.withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.25),
                blurRadius: 24,
                spreadRadius: 6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
