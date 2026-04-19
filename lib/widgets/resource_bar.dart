import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';

class ResourceBar extends ConsumerWidget {
  const ResourceBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.cellBorder, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ResourceChip(emoji: '💎', count: player.diamonds, color: AppColors.diamond),
          _ResourceChip(emoji: '🪨', count: player.iron, color: AppColors.iron),
          _ResourceChip(emoji: '⬛', count: player.coal, color: AppColors.coal),
          if (player.shieldCharges > 0)
            _ResourceChip(
              emoji: '🛡',
              count: player.shieldCharges,
              color: AppColors.success,
            ),
        ],
      ),
    );
  }
}

class _ResourceChip extends StatelessWidget {
  final String emoji;
  final int count;
  final Color color;

  const _ResourceChip({
    required this.emoji,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const Gap(4),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
