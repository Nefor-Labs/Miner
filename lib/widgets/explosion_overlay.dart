import 'dart:math';
import 'package:flutter/material.dart';

class ExplosionOverlay extends StatefulWidget {
  final VoidCallback onDone;

  const ExplosionOverlay({super.key, required this.onDone});

  @override
  State<ExplosionOverlay> createState() => _ExplosionOverlayState();
}

class _ExplosionOverlayState extends State<ExplosionOverlay>
    with TickerProviderStateMixin {
  late AnimationController _particleCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _flashCtrl;

  late Animation<double> _flash;
  late Animation<double> _shake;

  final _rng = Random();
  late List<_Particle> _particles;

  @override
  void initState() {
    super.initState();

    _particles = List.generate(35, (_) => _Particle(_rng));

    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _flash = Tween<double>(begin: 0.7, end: 0).animate(
      CurvedAnimation(parent: _flashCtrl, curve: Curves.easeOut),
    );

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shake = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticOut),
    );

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _flashCtrl.forward();
    _shakeCtrl.forward();
    _particleCtrl.forward().then((_) {
      if (mounted) widget.onDone();
    });
  }

  @override
  void dispose() {
    _particleCtrl.dispose();
    _shakeCtrl.dispose();
    _flashCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_particleCtrl, _shakeCtrl, _flashCtrl]),
      builder: (context, _) {
        final shake = _shake.value;
        final dx = sin(_shakeCtrl.value * pi * 8) * 14 * shake;
        final dy = cos(_shakeCtrl.value * pi * 6) * 10 * shake;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Stack(
            children: [
              // Red flash
              Opacity(
                opacity: _flash.value,
                child: Container(
                  color: const Color(0xFFCC1111),
                ),
              ),
              // Particles
              CustomPaint(
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleCtrl.value,
                ),
                size: MediaQuery.of(context).size,
              ),
              // Boom text
              if (_particleCtrl.value < 0.5)
                Center(
                  child: Opacity(
                    opacity: (1 - _particleCtrl.value * 2).clamp(0, 1),
                    child: Transform.scale(
                      scale: 0.5 + _particleCtrl.value * 2,
                      child: const Text(
                        'БУМ!',
                        style: TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 4,
                          shadows: [
                            Shadow(
                              color: Color(0xFFFF4444),
                              blurRadius: 20,
                            ),
                            Shadow(
                              color: Color(0xFFFF8800),
                              blurRadius: 40,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final double startDelay;

  _Particle(Random rng)
      : angle = rng.nextDouble() * pi * 2,
        speed = 0.3 + rng.nextDouble() * 0.7,
        size = 4 + rng.nextDouble() * 10,
        startDelay = rng.nextDouble() * 0.2,
        color = [
          const Color(0xFFFF4444),
          const Color(0xFFFF8800),
          const Color(0xFFFFCC00),
          const Color(0xFFFFFFFF),
          const Color(0xFFFF2200),
          const Color(0xFFFF6600),
        ][rng.nextInt(6)];
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxDist = size.width * 0.6;

    for (final p in particles) {
      final t = ((progress - p.startDelay) / (1 - p.startDelay)).clamp(0, 1).toDouble();
      if (t <= 0) continue;

      final dist = t * maxDist * p.speed;
      final x = cx + cos(p.angle) * dist;
      final y = cy + sin(p.angle) * dist;
      final opacity = (1 - t).clamp(0.0, 1.0);
      final currentSize = p.size * (1 - t * 0.5);

      canvas.drawCircle(
        Offset(x, y),
        currentSize,
        Paint()..color = p.color.withOpacity(opacity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter old) =>
      old.progress != progress;
}
