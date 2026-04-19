import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cell_widget.dart';
import '../widgets/explosion_overlay.dart';
import '../widgets/resource_bar.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _showExplosion = false;

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider);
    final player = ref.watch(playerProvider);
    final notifier = ref.read(gameProvider.notifier);

    // Trigger explosion when game is lost
    ref.listen(gameProvider, (prev, next) {
      if (prev?.status != GameStatus.lost &&
          next.status == GameStatus.lost) {
        setState(() => _showExplosion = true);
      }
    });

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          child: SafeArea(
            child: Column(
              children: [
                const ResourceBar(),
                const Gap(12),
                if (game.message != null) ...[
                  _StatusBanner(game: game),
                  const Gap(10),
                ],
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoPill(
                        icon: Icons.hardware_rounded,
                        label: 'Кирка Ур.${player.pickaxeLevel}',
                        color: AppColors.iron,
                      ),
                      _InfoPill(
                        icon: Icons.trending_up_rounded,
                        label:
                            '+${game.roundDiamonds * 10 + game.roundIron * 3 + game.roundCoal} очков',
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF1A2540), Color(0xFF0F1825)],
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: AppColors.cellBorder.withOpacity(0.6),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 6,
                            mainAxisSpacing: 6,
                          ),
                          itemCount: 25,
                          itemBuilder: (context, i) => CellWidget(
                            cell: game.cells[i],
                            onTap: game.isActive
                                ? () => notifier.revealCell(i)
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap(16),
                _ActionButtons(game: game, notifier: notifier),
                const Gap(20),
              ],
            ),
          ),
        ),

        // Explosion overlay
        if (_showExplosion)
          Positioned.fill(
            child: ExplosionOverlay(
              onDone: () => setState(() => _showExplosion = false),
            ),
          ),
      ],
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const Gap(5),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  final GameState game;
  const _StatusBanner({required this.game});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;
    if (game.status == GameStatus.lost) {
      color = AppColors.mine;
      icon = Icons.local_fire_department_rounded;
    } else if (game.status == GameStatus.won) {
      color = AppColors.success;
      icon = Icons.emoji_events_rounded;
    } else {
      color = AppColors.diamond;
      icon = Icons.shield_rounded;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.45)),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.2), blurRadius: 12, spreadRadius: 0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 18),
          const Gap(8),
          Text(
            game.message!,
            style: TextStyle(
                color: color, fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: -0.4, end: 0, duration: 300.ms, curve: Curves.easeOut);
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: GradientButton(
            onPressed: notifier.startNewGame,
            gradient: AppColors.primaryGradient,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hardware_rounded, size: 18),
                Gap(8),
                Text('НАЧАТЬ ДОБЫЧУ'),
              ],
            ),
          ),
        ),
      );
    }

    if (game.status == GameStatus.playing) {
      final hasResources =
          game.roundDiamonds + game.roundIron + game.roundCoal > 0;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: GradientButton(
            onPressed: hasResources ? notifier.cashOut : null,
            gradient: AppColors.successGradient,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.savings_rounded, size: 18),
                Gap(8),
                Text('ЗАБРАТЬ РЕСУРСЫ'),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: GradientButton(
          onPressed: notifier.startNewGame,
          gradient: AppColors.primaryGradient,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.refresh_rounded, size: 18),
              Gap(8),
              Text('НОВЫЙ РАУНД'),
            ],
          ),
        ),
      ),
    );
  }
}
