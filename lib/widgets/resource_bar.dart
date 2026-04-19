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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141E30), Color(0xFF0F1722)],
        ),
        border: Border(
          bottom: BorderSide(
            color: AppColors.cellBorder.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _Chip(type: ResourceType.diamond, count: player.diamonds),
          _divider(),
          _Chip(type: ResourceType.iron, count: player.iron),
          _divider(),
          _Chip(type: ResourceType.coal, count: player.coal),
          if (player.shieldCharges > 0) ...[
            _divider(),
            _ShieldChip(count: player.shieldCharges),
          ],
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 24,
        color: AppColors.cellBorder.withOpacity(0.4),
      );
}

class _Chip extends StatelessWidget {
  final ResourceType type;
  final int count;

  const _Chip({required this.type, required this.count});

  Color get _color {
    switch (type) {
      case ResourceType.diamond: return AppColors.diamond;
      case ResourceType.iron: return AppColors.iron;
      case ResourceType.coal: return AppColors.coal;
      default: return AppColors.mine;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResourceIcon(type: type, size: 20),
        const Gap(6),
        Text(
          '$count',
          style: TextStyle(
            color: _color,
            fontSize: 15,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _ShieldChip extends StatelessWidget {
  final int count;
  const _ShieldChip({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.15),
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Icon(Icons.shield_rounded,
              color: AppColors.success, size: 16),
        ),
        const Gap(5),
        Text(
          '$count',
          style: const TextStyle(
            color: AppColors.success,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
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
      case ResourceType.diamond: return AppColors.diamond;
      case ResourceType.iron: return AppColors.iron;
      case ResourceType.coal: return AppColors.coal;
      default: return AppColors.mine;
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
