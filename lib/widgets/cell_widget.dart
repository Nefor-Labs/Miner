import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/cell.dart';
import '../models/resource_type.dart';
import '../theme/app_theme.dart';
import 'resource_icon.dart';

class CellWidget extends StatelessWidget {
  final Cell cell;
  final VoidCallback? onTap;

  const CellWidget({super.key, required this.cell, this.onTap});

  Color _glowColor() {
    switch (cell.type) {
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
    final revealed = cell.isRevealed;
    final glow = _glowColor();

    return GestureDetector(
      onTap: revealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutBack,
        decoration: BoxDecoration(
          gradient: revealed
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    glow.withOpacity(0.18),
                    glow.withOpacity(0.06),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF1E2E50),
                    Color(0xFF141E35),
                  ],
                ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: revealed
                ? glow.withOpacity(0.55)
                : AppColors.cellBorder,
            width: revealed ? 1.5 : 1,
          ),
          boxShadow: revealed
              ? [
                  BoxShadow(
                    color: glow.withOpacity(0.25),
                    blurRadius: 10,
                    spreadRadius: 0,
                  ),
                ]
              : [
                  const BoxShadow(
                    color: Color(0x33000000),
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: revealed
              ? ResourceIcon(type: cell.type, size: 26)
                  .animate()
                  .scale(
                    begin: const Offset(0.2, 0.2),
                    end: const Offset(1.0, 1.0),
                    duration: 350.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 200.ms)
              : Icon(
                  Icons.question_mark_rounded,
                  color: AppColors.cellBorder.withOpacity(0.6),
                  size: 18,
                ),
        ),
      ),
    );
  }
}
