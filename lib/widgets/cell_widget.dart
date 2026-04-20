import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/cell.dart';
import '../models/resource_type.dart';
import '../theme/app_theme.dart';
import 'resource_icon.dart';

class CellWidget extends StatefulWidget {
  final Cell cell;
  final VoidCallback? onTap;

  const CellWidget({super.key, required this.cell, this.onTap});

  @override
  State<CellWidget> createState() => _CellWidgetState();
}

class _CellWidgetState extends State<CellWidget> {
  bool _burst = false;
  Key _burstKey = UniqueKey();

  @override
  void didUpdateWidget(CellWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.cell.isRevealed &&
        widget.cell.isRevealed &&
        widget.cell.type != ResourceType.mine) {
      setState(() {
        _burst = true;
        _burstKey = UniqueKey();
      });
      Future.delayed(const Duration(milliseconds: 520), () {
        if (mounted) setState(() => _burst = false);
      });
    }
  }

  Color _glowColor() {
    switch (widget.cell.type) {
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
    final revealed = widget.cell.isRevealed;
    final glow = _glowColor();

    return GestureDetector(
      onTap: revealed ? null : widget.onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutBack,
            decoration: revealed
                ? BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        glow.withOpacity(0.2),
                        glow.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: glow.withOpacity(0.6),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: glow.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 0,
                      ),
                    ],
                  )
                : BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF1A2040),
                        Color(0xFF101525),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.cellBorder,
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40000000),
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
            child: Stack(
              children: [
                if (!revealed)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      width: 8,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
                Center(
                  child: revealed
                      ? ResourceIcon(type: widget.cell.type, size: 26)
                          .animate()
                          .scale(
                            begin: const Offset(0.1, 0.1),
                            end: const Offset(1.0, 1.0),
                            duration: 380.ms,
                            curve: Curves.elasticOut,
                          )
                          .fadeIn(duration: 180.ms)
                      : null,
                ),
              ],
            ),
          ),
          if (_burst)
            Positioned.fill(
              child: IgnorePointer(
                child: _ParticleBurst(key: _burstKey, color: glow),
              ),
            ),
        ],
      ),
    );
  }
}

class _ParticleBurst extends StatelessWidget {
  final Color color;
  const _ParticleBurst({super.key, required this.color});

  static const _directions = [
    Offset(-1.0, -1.0),
    Offset(0.0, -1.3),
    Offset(1.0, -1.0),
    Offset(-1.3, 0.0),
    Offset(1.3, 0.0),
    Offset(-1.0, 1.0),
    Offset(0.0, 1.3),
    Offset(1.0, 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < _directions.length; i++)
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: color.withOpacity(0.9), blurRadius: 5),
                ],
              ),
            )
                .animate(delay: (i * 15).ms)
                .moveX(
                  begin: 0,
                  end: _directions[i].dx * 20,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                )
                .moveY(
                  begin: 0,
                  end: _directions[i].dy * 20,
                  duration: 400.ms,
                  curve: Curves.easeOut,
                )
                .fadeOut(begin: 1.0, duration: 380.ms, delay: 60.ms),
          ),
      ],
    );
  }
}
