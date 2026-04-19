import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cell_widget.dart';
import '../widgets/resource_bar.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final game = ref.watch(gameProvider);
    final player = ref.watch(playerProvider);
    final notifier = ref.read(gameProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ResourceBar(),
            const Gap(8),
            _StatusBanner(game: game),
            const Gap(8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '⛏ Lvl ${player.pickaxeLevel}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    'Round: +${game.roundDiamonds * 10 + game.roundIron * 3 + game.roundCoal}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
            ),
            const Gap(8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: 25,
                    itemBuilder: (context, i) {
                      return CellWidget(
                        cell: game.cells[i],
                        onTap: game.isActive
                            ? () => notifier.revealCell(i)
                            : null,
                      );
                    },
                  ),
                ),
              ),
            ),
            const Gap(12),
            _ActionButtons(game: game, notifier: notifier),
            const Gap(16),
          ],
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final GameState game;

  const _StatusBanner({required this.game});

  @override
  Widget build(BuildContext context) {
    if (game.message == null && game.status == GameStatus.idle) {
      return const SizedBox.shrink();
    }

    final msg = game.message ?? '';
    if (msg.isEmpty) return const SizedBox.shrink();

    Color bannerColor;
    if (game.status == GameStatus.lost) {
      bannerColor = AppColors.mine;
    } else if (game.status == GameStatus.won) {
      bannerColor = AppColors.success;
    } else {
      bannerColor = AppColors.diamond;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bannerColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bannerColor.withOpacity(0.4)),
      ),
      child: Center(
        child: Text(
          msg,
          style: TextStyle(
            color: bannerColor,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.3, end: 0, duration: 300.ms);
  }
}

class _ActionButtons extends StatelessWidget {
  final GameState game;
  final GameNotifier notifier;

  const _ActionButtons({required this.game, required this.notifier});

  @override
  Widget build(BuildContext context) {
    if (game.status == GameStatus.idle) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: notifier.startNewGame,
            icon: const Text('⛏', style: TextStyle(fontSize: 18)),
            label: const Text('START MINING'),
          ),
        ),
      );
    }

    if (game.status == GameStatus.playing) {
      final hasResources = game.roundDiamonds + game.roundIron + game.roundCoal > 0;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: hasResources ? notifier.cashOut : null,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: const BorderSide(color: AppColors.success),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  '💰 CASH OUT',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Won or Lost
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: notifier.startNewGame,
          icon: const Text('🔄', style: TextStyle(fontSize: 16)),
          label: const Text('NEW ROUND'),
        ),
      ),
    );
  }
}
