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

  Color _getBorderColor() {
    if (!cell.isRevealed) return AppColors.cellBorder;
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

  Color _getBackgroundColor() {
    if (!cell.isRevealed) return AppColors.cellUnrevealed;
    switch (cell.type) {
      case ResourceType.diamond:
        return AppColors.diamond.withOpacity(0.15);
      case ResourceType.iron:
        return AppColors.iron.withOpacity(0.1);
      case ResourceType.coal:
        return AppColors.coal.withOpacity(0.2);
      case ResourceType.mine:
        return AppColors.mine.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: cell.isRevealed ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutBack,
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _getBorderColor(),
            width: cell.isRevealed ? 1.5 : 1,
          ),
          boxShadow: cell.isRevealed && cell.type == ResourceType.diamond
              ? [
                  BoxShadow(
                    color: AppColors.diamond.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Center(
          child: cell.isRevealed
              ? ResourceIcon(type: cell.type, size: 28)
                  .animate()
                  .scale(
                    begin: const Offset(0.3, 0.3),
                    end: const Offset(1, 1),
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 200.ms)
              : const Icon(
                  Icons.question_mark_rounded,
                  color: AppColors.cellBorder,
                  size: 20,
                ),
        ),
      ),
    );
  }
}
