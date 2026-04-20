import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/resource_type.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import 'resource_icon.dart';

class ResourceBar extends ConsumerWidget {
  const ResourceBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.card.withOpacity(0.85),
            border: Border(
              bottom: BorderSide(
                color: AppColors.cellBorder.withOpacity(0.4),
              ),
            ),
          ),
          child: Row(
            children: [
              _Pill(type: ResourceType.diamond, count: player.diamonds),
              const Gap(8),
              _Pill(type: ResourceType.iron, count: player.iron),
              const Gap(8),
              _Pill(type: ResourceType.coal, count: player.coal),
              if (player.shieldCharges > 0) ...[
                const Gap(8),
                _ShieldPill(count: player.shieldCharges),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final ResourceType type;
  final int count;

  const _Pill({required this.type, required this.count});

  Color get _color {
    switch (type) {
      case ResourceType.diamond:
        return AppColors.diamond;
      case ResourceType.iron:
        return AppColors.iron;
      case ResourceType.coal:
        return AppColors.coal;
      default:
        return AppColors.mine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: 16),
          const Gap(5),
          Text(
            _format(count),
            style: TextStyle(
              color: _color,
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  String _format(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _ShieldPill extends StatelessWidget {
  final int count;
  const _ShieldPill({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_rounded, color: AppColors.success, size: 14),
          const Gap(4),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// reusable badge used in shop
class ResourceBadge extends StatelessWidget {
  final ResourceType type;
  final int count;
  final double iconSize;

  const ResourceBadge({
    super.key,
    required this.type,
    required this.count,
    this.iconSize = 20,
  });

  Color get _color {
    switch (type) {
      case ResourceType.diamond:
        return AppColors.diamond;
      case ResourceType.iron:
        return AppColors.iron;
      case ResourceType.coal:
        return AppColors.coal;
      default:
        return AppColors.mine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: iconSize),
          const Gap(5),
          Text(
            '$count',
            style: TextStyle(
              color: _color,
              fontSize: iconSize * 0.7,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
