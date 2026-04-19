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
        break;
      case ResourceType.iron:
        _drawIron(canvas, size);
        break;
      case ResourceType.coal:
        _drawCoal(canvas, size);
        break;
      case ResourceType.mine:
        _drawMine(canvas, size);
        break;
    }
  }

  void _drawDiamond(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;

    final gradient = RadialGradient(
      colors: [const Color(0xFFAAEEFF), AppColors.diamond, const Color(0xFF0088AA)],
      stops: const [0.0, 0.5, 1.0],
    );

    final path = Path();
    path.moveTo(cx, s.height * 0.05);
    path.lineTo(s.width * 0.85, s.height * 0.38);
    path.lineTo(cx, s.height * 0.97);
    path.lineTo(s.width * 0.15, s.height * 0.38);
    path.close();

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, s.width, s.height))
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    // top facet
    final topPath = Path();
    topPath.moveTo(cx, s.height * 0.05);
    topPath.lineTo(s.width * 0.85, s.height * 0.38);
    topPath.lineTo(cx, s.height * 0.42);
    topPath.lineTo(s.width * 0.15, s.height * 0.38);
    topPath.close();
    canvas.drawPath(
      topPath,
      Paint()
        ..color = Colors.white.withOpacity(0.35)
        ..style = PaintingStyle.fill,
    );

    // shine
    canvas.drawCircle(
      Offset(cx - s.width * 0.1, cy - s.height * 0.15),
      s.width * 0.06,
      Paint()..color = Colors.white.withOpacity(0.7),
    );
  }

  void _drawIron(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;

    final gradient = RadialGradient(
      colors: [const Color(0xFFE0E0E0), const Color(0xFF9E9E9E), const Color(0xFF424242)],
      stops: const [0.0, 0.5, 1.0],
      center: const Alignment(-0.3, -0.3),
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, s.width, s.height))
      ..style = PaintingStyle.fill;

    // rocky irregular shape
    final path = Path();
    path.moveTo(cx, s.height * 0.05);
    path.quadraticBezierTo(s.width * 0.92, s.height * 0.1, s.width * 0.9, s.height * 0.4);
    path.quadraticBezierTo(s.width * 0.95, s.height * 0.7, s.width * 0.75, s.height * 0.92);
    path.quadraticBezierTo(s.width * 0.45, s.height * 1.0, s.width * 0.2, s.height * 0.88);
    path.quadraticBezierTo(s.width * 0.02, s.height * 0.7, s.width * 0.05, s.height * 0.42);
    path.quadraticBezierTo(s.width * 0.08, s.height * 0.15, cx, s.height * 0.05);
    path.close();

    canvas.drawPath(path, paint);

    // surface cracks
    final crackPaint = Paint()
      ..color = const Color(0xFF616161).withOpacity(0.6)
      ..strokeWidth = s.width * 0.04
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - s.width * 0.1, cy - s.height * 0.1),
      Offset(cx + s.width * 0.15, cy + s.height * 0.05),
      crackPaint,
    );
    canvas.drawLine(
      Offset(cx + s.width * 0.05, cy - s.height * 0.18),
      Offset(cx - s.width * 0.05, cy + s.height * 0.18),
      crackPaint..strokeWidth = s.width * 0.025,
    );

    // highlight
    canvas.drawCircle(
      Offset(cx - s.width * 0.12, cy - s.height * 0.18),
      s.width * 0.08,
      Paint()..color = Colors.white.withOpacity(0.4),
    );
  }

  void _drawCoal(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;

    final gradient = RadialGradient(
      colors: [const Color(0xFF616161), const Color(0xFF212121), const Color(0xFF000000)],
      stops: const [0.0, 0.5, 1.0],
      center: const Alignment(-0.2, -0.2),
    );

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(s.width * 0.08, s.height * 0.08, s.width * 0.84, s.height * 0.84),
      Radius.circular(s.width * 0.15),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..shader = gradient.createShader(Rect.fromLTWH(0, 0, s.width, s.height))
        ..style = PaintingStyle.fill,
    );

    // glint lines
    final glintPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = s.width * 0.04
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx - s.width * 0.2, cy - s.height * 0.1),
      Offset(cx + s.width * 0.1, cy + s.height * 0.2),
      glintPaint,
    );

    canvas.drawCircle(
      Offset(cx - s.width * 0.15, cy - s.height * 0.15),
      s.width * 0.07,
      Paint()..color = Colors.white.withOpacity(0.25),
    );
  }

  void _drawMine(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    final r = s.width * 0.32;

    // spikes
    final spikePaint = Paint()
      ..color = const Color(0xFFB71C1C)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 8; i++) {
      final angle = (i * pi / 4) - pi / 8;
      final outer = Offset(cx + cos(angle) * r * 1.65, cy + sin(angle) * r * 1.65);
      final leftA = angle - pi / 12;
      final rightA = angle + pi / 12;
      final leftP = Offset(cx + cos(leftA) * r * 0.9, cy + sin(leftA) * r * 0.9);
      final rightP = Offset(cx + cos(rightA) * r * 0.9, cy + sin(rightA) * r * 0.9);
      final path = Path()
        ..moveTo(leftP.dx, leftP.dy)
        ..lineTo(outer.dx, outer.dy)
        ..lineTo(rightP.dx, rightP.dy)
        ..close();
      canvas.drawPath(path, spikePaint);
    }

    // body gradient
    final gradient = RadialGradient(
      colors: [const Color(0xFF616161), const Color(0xFF212121)],
      center: const Alignment(-0.3, -0.3),
    );
    canvas.drawCircle(
      Offset(cx, cy),
      r,
      Paint()
        ..shader = gradient.createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
        ..style = PaintingStyle.fill,
    );

    // fuse
    final fusePaint = Paint()
      ..color = const Color(0xFF8D6E63)
      ..strokeWidth = s.width * 0.06
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy - r),
      Offset(cx + s.width * 0.1, cy - r - s.height * 0.18),
      fusePaint,
    );
    // spark
    canvas.drawCircle(
      Offset(cx + s.width * 0.1, cy - r - s.height * 0.18),
      s.width * 0.05,
      Paint()..color = const Color(0xFFFFD54F),
    );

    // shine
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

// Small inline icon for resource bars / cost chips
class ResourceBadge extends StatelessWidget {
  final ResourceType type;
  final int count;
  final double iconSize;
  final Color? textColor;

  const ResourceBadge({
    super.key,
    required this.type,
    required this.count,
    this.iconSize = 22,
    this.textColor,
  });

  Color get _color {
    switch (type) {
      case ResourceType.diamond:
        return AppColors.diamond;
      case ResourceType.iron:
        return AppColors.iron;
      case ResourceType.coal:
        return AppColors.coal;
      case ResourceType.mine:
        return AppColors.mine;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = textColor ?? _color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: iconSize),
          const SizedBox(width: 5),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: iconSize * 0.65,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
