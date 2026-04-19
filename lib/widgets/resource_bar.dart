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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF111219), Color(0xFF0D0E16)],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.cellBorder.withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          _ResourceChip(type: ResourceType.diamond, count: player.diamonds),
          const Gap(4),
          _divider(),
          const Gap(4),
          _ResourceChip(type: ResourceType.iron, count: player.iron),
          const Gap(4),
          _divider(),
          const Gap(4),
          _ResourceChip(type: ResourceType.coal, count: player.coal),
          const Spacer(),
          if (player.shieldCharges > 0) _ShieldBadge(count: player.shieldCharges),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 18,
        color: AppColors.cellBorder.withOpacity(0.5),
      );
}

class _ResourceChip extends StatelessWidget {
  final ResourceType type;
  final int count;
  const _ResourceChip({required this.type, required this.count});

  Color get _color => switch (type) {
        ResourceType.diamond => AppColors.diamond,
        ResourceType.iron => AppColors.iron,
        ResourceType.coal => AppColors.coal,
        _ => AppColors.mine,
      };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: 18),
          const Gap(5),
          Text(
            _formatCount(count),
            style: TextStyle(
              color: _color,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 10000) return '${(n / 1000).toStringAsFixed(0)}K';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _ShieldBadge extends StatelessWidget {
  final int count;
  const _ShieldBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.15),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_rounded, color: AppColors.success, size: 15),
          const Gap(4),
          Text(
            '$count',
            style: const TextStyle(
              color: AppColors.success,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

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

  Color get _color => switch (type) {
        ResourceType.diamond => AppColors.diamond,
        ResourceType.iron => AppColors.iron,
        ResourceType.coal => AppColors.coal,
        _ => AppColors.mine,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.28)),
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
