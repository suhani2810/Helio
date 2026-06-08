import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedStars extends StatefulWidget {
  final int count;
  const AnimatedStars({super.key, this.count = 30});

  @override
  State<AnimatedStars> createState() => _AnimatedStarsState();
}

class _AnimatedStarsState extends State<AnimatedStars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final List<double> _delays;
  final _rnd = Random(42);

  @override
  void initState() {
    super.initState();
    _delays = List.generate(widget.count, (_) => _rnd.nextDouble() * 2);
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (context, child) {
            return Stack(
              children: List.generate(widget.count, (i) {
                final x = _rnd.nextDouble() * constraints.maxWidth;
                final y = _rnd.nextDouble() * constraints.maxHeight;
                final t = (_ctrl.value + _delays[i]) % 1.0;
                final opacity = 0.4 + (sin(t * pi * 2) + 1) / 4;
                final size = 1.0 + (_rnd.nextDouble() * 2.8);
                return Positioned(
                  left: x,
                  top: y,
                  child: Opacity(
                    opacity: opacity.clamp(0.0, 1.0),
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }
}
