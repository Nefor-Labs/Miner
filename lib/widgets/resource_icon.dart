import 'dart:math';
import 'package:flutter/material.dart';
import '../models/resource_type.dart';
import '../theme/app_theme.dart';

class ResourceIcon extends StatelessWidget {
  final ResourceType type;
  final double size;

  const ResourceIcon({super.key, required this.type, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _ResourcePainter(type)),
    );
  }
}

class _ResourcePainter extends CustomPainter {
  final ResourceType type;
  const _ResourcePainter(this.type);

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case ResourceType.diamond:
        _drawDiamond(canvas, size);
      case ResourceType.iron:
        _drawIron(canvas, size);
      case ResourceType.coal:
        _drawCoal(canvas, size);
      case ResourceType.mine:
        _drawMine(canvas, size);
    }
  }

  void _drawDiamond(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;

    final gradient = RadialGradient(
      colors: [
        AppColors.diamondBright,
        AppColors.diamond,
        AppColors.diamondDark,
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    final path = Path()
      ..moveTo(cx, s.height * 0.05)
      ..lineTo(s.width * 0.85, s.height * 0.38)
      ..lineTo(cx, s.height * 0.97)
      ..lineTo(s.width * 0.15, s.height * 0.38)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader =
            gradient.createShader(Rect.fromLTWH(0, 0, s.width, s.height))
        ..style = PaintingStyle.fill,
    );

    final topFacet = Path()
      ..moveTo(cx, s.height * 0.05)
      ..lineTo(s.width * 0.85, s.height * 0.38)
      ..lineTo(cx, s.height * 0.42)
      ..lineTo(s.width * 0.15, s.height * 0.38)
      ..close();
    canvas.drawPath(
      topFacet,
      Paint()
        ..color = Colors.white.withOpacity(0.4)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(cx - s.width * 0.1, cy - s.height * 0.14),
      s.width * 0.065,
      Paint()..color = Colors.white.withOpacity(0.75),
    );
  }

  void _drawIron(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;

    final gradient = RadialGradient(
      colors: [
        const Color(0xFFE2E8F0),
        AppColors.iron,
        const Color(0xFF334155),
      ],
      stops: const [0.0, 0.5, 1.0],
      center: const Alignment(-0.3, -0.3),
    );

    final path = Path()
      ..moveTo(cx, s.height * 0.05)
      ..quadraticBezierTo(
          s.width * 0.92, s.height * 0.1, s.width * 0.9, s.height * 0.4)
      ..quadraticBezierTo(
          s.width * 0.95, s.height * 0.7, s.width * 0.75, s.height * 0.92)
      ..quadraticBezierTo(
          s.width * 0.45, s.height * 1.0, s.width * 0.2, s.height * 0.88)
      ..quadraticBezierTo(
          s.width * 0.02, s.height * 0.7, s.width * 0.05, s.height * 0.42)
      ..quadraticBezierTo(
          s.width * 0.08, s.height * 0.15, cx, s.height * 0.05)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader =
            gradient.createShader(Rect.fromLTWH(0, 0, s.width, s.height))
        ..style = PaintingStyle.fill,
    );

    final crackPaint = Paint()
      ..color = const Color(0xFF334155).withOpacity(0.55)
      ..strokeWidth = s.width * 0.04
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - s.width * 0.1, cy - s.height * 0.1),
      Offset(cx + s.width * 0.15, cy + s.height * 0.05),
      crackPaint,
    );

    canvas.drawCircle(
      Offset(cx - s.width * 0.12, cy - s.height * 0.18),
      s.width * 0.08,
      Paint()..color = Colors.white.withOpacity(0.45),
    );
  }

  void _drawCoal(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;

    final gradient = RadialGradient(
      colors: const [
        Color(0xFF64748B),
        Color(0xFF1E293B),
        Color(0xFF020617),
      ],
      stops: const [0.0, 0.5, 1.0],
      center: const Alignment(-0.2, -0.2),
    );

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          s.width * 0.08, s.height * 0.08, s.width * 0.84, s.height * 0.84),
      Radius.circular(s.width * 0.15),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..shader =
            gradient.createShader(Rect.fromLTWH(0, 0, s.width, s.height))
        ..style = PaintingStyle.fill,
    );

    canvas.drawLine(
      Offset(cx - s.width * 0.2, cy - s.height * 0.1),
      Offset(cx + s.width * 0.1, cy + s.height * 0.2),
      Paint()
        ..color = Colors.white.withOpacity(0.18)
        ..strokeWidth = s.width * 0.04
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(cx - s.width * 0.15, cy - s.height * 0.15),
      s.width * 0.07,
      Paint()..color = Colors.white.withOpacity(0.28),
    );
  }

  void _drawMine(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.32;

    final spikePaint = Paint()
      ..color = AppColors.mineDark
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4) - pi / 8;
      final outer =
          Offset(cx + cos(angle) * r * 1.65, cy + sin(angle) * r * 1.65);
      final leftA = angle - pi / 12;
      final rightA = angle + pi / 12;
      final leftP =
          Offset(cx + cos(leftA) * r * 0.9, cy + sin(leftA) * r * 0.9);
      final rightP =
          Offset(cx + cos(rightA) * r * 0.9, cy + sin(rightA) * r * 0.9);
      canvas.drawPath(
        Path()
          ..moveTo(leftP.dx, leftP.dy)
          ..lineTo(outer.dx, outer.dy)
          ..lineTo(rightP.dx, rightP.dy)
          ..close(),
        spikePaint,
      );
    }

    final bodyGrad = RadialGradient(
      colors: const [Color(0xFF475569), Color(0xFF0F172A)],
      center: const Alignment(-0.3, -0.3),
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = bodyGrad.createShader(
            Rect.fromCircle(center: Offset(cx, cy), radius: r))
        ..style = PaintingStyle.fill,
    );

    canvas.drawLine(
      Offset(cx, cy - r),
      Offset(cx + s.width * 0.1, cy - r - s.height * 0.18),
      Paint()
        ..color = const Color(0xFF8D6E63)
        ..strokeWidth = s.width * 0.06
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawCircle(
      Offset(cx + s.width * 0.1, cy - r - s.height * 0.18),
      s.width * 0.055,
      Paint()..color = const Color(0xFFFDE68A),
    );

    canvas.drawCircle(
      Offset(cx - r * 0.4, cy - r * 0.4),
      r * 0.25,
      Paint()..color = Colors.white.withOpacity(0.2),
    );
  }

  @override
  bool shouldRepaint(covariant _ResourcePainter oldDelegate) =>
      oldDelegate.type != type;
}
