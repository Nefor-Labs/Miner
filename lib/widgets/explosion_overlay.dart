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
    _particles = List.generate(50, (_) => _Particle(_rng));

    _flashCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _flash = Tween<double>(begin: 0.8, end: 0).animate(
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
      duration: const Duration(milliseconds: 1000),
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
      animation:
          Listenable.merge([_particleCtrl, _shakeCtrl, _flashCtrl]),
      builder: (context, _) {
        final shake = _shake.value;
        final dx = sin(_shakeCtrl.value * pi * 9) * 16 * shake;
        final dy = cos(_shakeCtrl.value * pi * 7) * 10 * shake;

        return Transform.translate(
          offset: Offset(dx, dy),
          child: Stack(
            children: [
              Opacity(
                opacity: _flash.value * 0.75,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment.center,
                      radius: 1.0,
                      colors: [
                        Color(0xFFFF6600),
                        Color(0xFFCC1111),
                        Colors.transparent,
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
              CustomPaint(
                painter: _ParticlePainter(
                  particles: _particles,
                  progress: _particleCtrl.value,
                ),
                size: MediaQuery.of(context).size,
              ),
              if (_particleCtrl.value < 0.55)
                Center(
                  child: Opacity(
                    opacity: (1 - _particleCtrl.value * 1.8).clamp(0, 1),
                    child: Transform.scale(
                      scale: 0.4 + _particleCtrl.value * 2.2,
                      child: const Text(
                        'БУМ!',
                        style: TextStyle(
                          fontSize: 76,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 6,
                          shadows: [
                            Shadow(
                              color: Color(0xFFFF4444),
                              blurRadius: 30,
                            ),
                            Shadow(
                              color: Color(0xFFFF8800),
                              blurRadius: 60,
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
  final bool isSpark;

  _Particle(Random rng)
      : angle = rng.nextDouble() * pi * 2,
        speed = 0.25 + rng.nextDouble() * 0.75,
        size = 3 + rng.nextDouble() * 10,
        startDelay = rng.nextDouble() * 0.25,
        isSpark = rng.nextBool(),
        color = [
          const Color(0xFFFF4444),
          const Color(0xFFFF7700),
          const Color(0xFFFFCC00),
          const Color(0xFFFFFFFF),
          const Color(0xFFFF2200),
          const Color(0xFFFF5500),
          const Color(0xFFFFDD44),
        ][rng.nextInt(7)];
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  const _ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final maxDist = size.width * 0.65;

    for (final p in particles) {
      final t =
          ((progress - p.startDelay) / (1 - p.startDelay)).clamp(0, 1).toDouble();
      if (t <= 0) continue;

      final eased = 1 - pow(1 - t, 3).toDouble();
      final dist = eased * maxDist * p.speed;
      final x = cx + cos(p.angle) * dist;
      final y = cy + sin(p.angle) * dist - dist * 0.2;
      final opacity = pow(1 - t, 1.5).toDouble().clamp(0.0, 1.0);
      final currentSize = p.size * (1 - t * 0.6);

      if (p.isSpark) {
        final trailX = cx + cos(p.angle) * dist * 0.7;
        final trailY = cy + sin(p.angle) * dist * 0.7 - dist * 0.7 * 0.2;
        canvas.drawLine(
          Offset(trailX, trailY),
          Offset(x, y),
          Paint()
            ..color = p.color.withOpacity(opacity * 0.5)
            ..strokeWidth = currentSize * 0.5
            ..strokeCap = StrokeCap.round,
        );
      }

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
