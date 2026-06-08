import 'package:flutter/material.dart';

class AnimatedClouds extends StatefulWidget {
  final Color color;
  final double height;

  const AnimatedClouds({
    super.key,
    this.color = Colors.white,
    this.height = 80,
  });

  @override
  State<AnimatedClouds> createState() => _AnimatedCloudsState();
}

class _AnimatedCloudsState extends State<AnimatedClouds>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final screenW = MediaQuery.of(context).size.width;
          final containerWidth = screenW * 2.0;
          return AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              final t = _ctrl.value;
              return ClipRect(
                child: FractionalTranslation(
                  translation: Offset((t * 2) - 1, 0),
                  child: Opacity(
                    opacity: 0.9,
                    child: UnconstrainedBox(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: containerWidth,
                        child: Row(
                          children: [
                            _cloud(widget.color, 1.0),
                            const SizedBox(width: 40),
                            _cloud(widget.color, 0.8),
                            const SizedBox(width: 30),
                            _cloud(widget.color, 1.2),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _cloud(Color color, double scale) {
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 160,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8),
          ],
        ),
      ),
    );
  }
}
