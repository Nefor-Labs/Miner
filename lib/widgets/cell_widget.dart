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

class _CellWidgetState extends State<CellWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pressCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 70),
    reverseDuration: const Duration(milliseconds: 200),
  );

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  Color get _accentColor {
    return switch (widget.cell.type) {
      ResourceType.diamond => AppColors.diamond,
      ResourceType.iron => AppColors.iron,
      ResourceType.coal => AppColors.coal,
      ResourceType.mine => AppColors.mine,
    };
  }

  @override
  Widget build(BuildContext context) {
    final revealed = widget.cell.isRevealed;
    final active = widget.onTap != null && !revealed;
    final accent = _accentColor;

    return GestureDetector(
      onTapDown: active ? (_) => _pressCtrl.forward() : null,
      onTapUp: active
          ? (_) {
              _pressCtrl.reverse();
              widget.onTap!();
            }
          : null,
      onTapCancel: active ? () => _pressCtrl.reverse() : null,
      child: AnimatedBuilder(
        animation: _pressCtrl,
        builder: (context, child) => Transform.scale(
          scale: 1.0 - 0.06 * _pressCtrl.value,
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            gradient: revealed
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accent.withOpacity(0.2),
                      accent.withOpacity(0.06),
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF1C1D2C),
                      Color(0xFF141520),
                    ],
                  ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: revealed
                  ? accent.withOpacity(0.55)
                  : AppColors.cellBorder,
              width: revealed ? 1.5 : 1,
            ),
            boxShadow: revealed
                ? [
                    BoxShadow(
                      color: accent.withOpacity(0.3),
                      blurRadius: 12,
                      spreadRadius: 0,
                    ),
                  ]
                : [
                    const BoxShadow(
                      color: Color(0x44000000),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
          ),
          child: Center(
            child: revealed
                ? ResourceIcon(type: widget.cell.type, size: 28)
                    .animate()
                    .scale(
                      begin: const Offset(0.0, 0.0),
                      end: const Offset(1.0, 1.0),
                      duration: 380.ms,
                      curve: Curves.elasticOut,
                    )
                    .fadeIn(duration: 150.ms)
                : Icon(
                    Icons.add,
                    color: AppColors.cellBorder.withOpacity(0.5),
                    size: 16,
                  ),
          ),
        ),
      ),
    );
  }
}
