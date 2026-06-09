import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/theme_extensions.dart';
import '../../core/theme/theme_provider.dart';
import '../../core/theme/theme_mode_enum.dart';
import '../../core/design_system/colors.dart';
import '../../providers/time_provider.dart';
import 'animated_sun.dart';
import 'animated_stars.dart';
import 'custom_moon.dart';

class SkyBackground extends ConsumerStatefulWidget {
  final Widget? child;
  final bool showForeground;
  const SkyBackground({super.key, this.child, this.showForeground = true});

  @override
  ConsumerState<SkyBackground> createState() => _SkyBackgroundState();
}

class _SkyBackgroundState extends ConsumerState<SkyBackground>
    with TickerProviderStateMixin {
  late final AnimationController _cloudController;
  late final AnimationController _nebulaController;

  @override
  void initState() {
    super.initState();
    _cloudController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _nebulaController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _cloudController.dispose();
    _nebulaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeControllerProvider);
    final now = ref.watch(currentTimeProvider).value ?? DateTime.now();
    final isNight = _isNightMode(mode, now.hour);
    final sky = Theme.of(context).extension<SkyTheme>();

    return Container(
      decoration: BoxDecoration(
        gradient: isNight
            ? const LinearGradient(
                colors: [HelioColors.nightBackgroundStart, HelioColors.nightBackgroundEnd],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : const LinearGradient(
                colors: [Color(0xFFDFF6FF), Color(0xFFBEE7FF), Color(0xFF8EC5FF)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
      ),
      child: Stack(
        children: [
          if (isNight) ...[
            // 1. Background Nebula Glows
            _buildNebula(top: -100, right: -100, color: const Color(0xFF7C9DFF), size: 600),
            _buildNebula(bottom: 0, left: -100, color: const Color(0xFF9B72CF), size: 500),
            
            // 2. Stars
            const Positioned.fill(child: IgnorePointer(child: AnimatedStars(count: 140))),
            
            // 3. Floating Particles
            const Positioned.fill(child: IgnorePointer(child: _FloatingParticles())),
            
            // 4. The Custom Animated Moon (Centered)
            if (widget.showForeground)
              const Positioned(
                top: 80,
                left: 0,
                right: 0,
                child: Center(
                  child: CustomAnimatedMoon(size: 160),
                ),
              ),
          ] else ...[
            // Day Elements
            if (widget.showForeground) ...[
              _buildAnimatedCloud(top: 100, left: -50, scale: 1.2, speed: 1.0),
              _buildAnimatedCloud(top: 200, left: 150, scale: 0.8, speed: 1.5),
              _buildAnimatedCloud(top: 400, left: 20, scale: 1.0, speed: 0.8),
              Positioned(
                top: 60,
                right: 40,
                child: AnimatedSun(
                  size: 64,
                  color: sky?.sunColor ?? const Color(0xFFFFD54F),
                ),
              ),
            ],
          ],
          
          if (widget.child != null) widget.child!,
        ],
      ),
    );
  }

  bool _isNightMode(AppThemeMode mode, int hour) {
    if (mode == AppThemeMode.night) return true;
    if (mode == AppThemeMode.day) return false;
    return hour < 5 || hour >= 19;
  }

  Widget _buildNebula({double? top, double? right, double? bottom, double? left, required Color color, required double size}) {
    return AnimatedBuilder(
      animation: _nebulaController,
      builder: (context, child) => Positioned(
        top: top, right: right, bottom: bottom, left: left,
        child: Opacity(
          opacity: 0.05 + (_nebulaController.value * 0.05),
          child: Container(
            width: size, height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [color.withOpacity(0.4), Colors.transparent]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCloud({required double top, required double left, required double scale, required double speed}) {
    return AnimatedBuilder(
      animation: _cloudController,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final offset = (_cloudController.value * screenWidth * speed) % (screenWidth + 200) - 100;
        return Positioned(
          top: top, left: left + offset,
          child: Transform.scale(scale: scale, child: Opacity(opacity: 0.8, child: child)),
        );
      },
      child: const _CloudWidget(),
    );
  }
}

class _CloudWidget extends StatelessWidget {
  const _CloudWidget();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120, height: 60,
      child: Stack(children: [
        Positioned(left: 10, top: 10, child: _cloudPart(50, 50)),
        Positioned(left: 40, top: 0, child: _cloudPart(60, 60)),
        Positioned(left: 80, top: 15, child: _cloudPart(40, 40)),
      ]),
    );
  }
  Widget _cloudPart(double w, double h) => Container(width: w, height: h, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle));
}

class _FloatingParticles extends StatefulWidget {
  const _FloatingParticles();
  @override
  State<_FloatingParticles> createState() => _FloatingParticlesState();
}

class _FloatingParticlesState extends State<_FloatingParticles> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final _rnd = Random();
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 20))..repeat();
    for (int i = 0; i < 25; i++) {
      _particles.add(_Particle(x: _rnd.nextDouble(), y: _rnd.nextDouble(), size: 1.5 + _rnd.nextDouble() * 3.0, speedX: (_rnd.nextDouble() - 0.5) * 0.04, speedY: -0.04 - _rnd.nextDouble() * 0.08));
    }
  }
  @override
  void dispose() { _controller.dispose(); super.dispose(); }
  @override
  Widget build(BuildContext context) => AnimatedBuilder(animation: _controller, builder: (context, child) => CustomPaint(painter: _ParticlePainter(_particles, _controller.value), size: Size.infinite));
}

class _Particle { double x, y; final double size, speedX, speedY; _Particle({required this.x, required this.y, required this.size, required this.speedX, required this.speedY}); }

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  _ParticlePainter(this.particles, this.progress);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withOpacity(0.12);
    for (var p in particles) {
      double currentX = (p.x + p.speedX * progress * 10) % 1.0;
      double currentY = (p.y + p.speedY * progress * 10) % 1.0;
      canvas.drawCircle(Offset(currentX * size.width, currentY * size.height), p.size, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) => true;
}
