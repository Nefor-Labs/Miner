import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/cell_widget.dart';
import '../widgets/explosion_overlay.dart';
import '../models/resource_type.dart';
import '../widgets/resource_bar.dart';
import '../widgets/resource_icon.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  bool _showExplosion = false;
  int _cooldown = 0;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    _cooldownTimer?.cancel();
    setState(() => _cooldown = 3);
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        _cooldown--;
        if (_cooldown <= 0) t.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = ref.watch(gameProvider);
    final player = ref.watch(playerProvider);
    final notifier = ref.read(gameProvider.notifier);

    ref.listen(gameProvider, (prev, next) {
      if (prev?.status != GameStatus.lost && next.status == GameStatus.lost) {
        setState(() => _showExplosion = true);
        _startCooldown();
      }
      if (prev?.status != GameStatus.won && next.status == GameStatus.won) {
        _startCooldown();
      }
    });

    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                const ResourceBar(),
                const Gap(10),
                if (game.message != null) ...[
                  _StatusBanner(game: game),
                  const Gap(8),
                ],
                _RoundStatsBar(game: game, pickaxeLevel: player.pickaxeLevel),
                const Gap(10),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF151A30),
                              Color(0xFF0D1020),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: AppColors.cellBorder.withOpacity(0.7),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: AppColors.diamond.withOpacity(0.04),
                              blurRadius: 40,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          clipBehavior: Clip.none,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 7,
                            mainAxisSpacing: 7,
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
                ),
                const Gap(14),
                _ActionButtons(
                  game: game,
                  notifier: notifier,
                  cooldown: _cooldown,
                ),
                const Gap(100),
              ],
            ),
          ),
        ),
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

class _RoundStatsBar extends StatelessWidget {
  final GameState game;
  final int pickaxeLevel;
  const _RoundStatsBar({required this.game, required this.pickaxeLevel});

  @override
  Widget build(BuildContext context) {
    final playing = game.status == GameStatus.playing;
    final score = game.roundDiamonds * 10 + game.roundIron * 3 + game.roundCoal;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF181C30), Color(0xFF0E1120)],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.cellBorder.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Pickaxe level
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.iron.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.iron.withOpacity(0.25)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.hardware_rounded,
                      color: AppColors.iron, size: 12),
                  const Gap(4),
                  Text(
                    'Ур.$pickaxeLevel',
                    style: const TextStyle(
                      color: AppColors.iron,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Container(
              width: 1,
              height: 20,
              color: AppColors.cellBorder.withOpacity(0.4),
            ),
            const Gap(10),
            // Round resources
            _MiniRes(ResourceType.diamond, game.roundDiamonds, AppColors.diamond),
            const Gap(8),
            _MiniRes(ResourceType.iron, game.roundIron, AppColors.iron),
            const Gap(8),
            _MiniRes(ResourceType.coal, game.roundCoal, AppColors.coal),
            const Spacer(),
            // Score
            if (playing || game.roundScore > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withOpacity(0.2),
                      AppColors.gold.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.gold.withOpacity(score > 0 ? 0.4 : 0.15)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star_rounded,
                      color: AppColors.gold
                          .withOpacity(score > 0 ? 1 : 0.4),
                      size: 12,
                    ),
                    const Gap(4),
                    Text(
                      '$score',
                      style: TextStyle(
                        color: AppColors.gold
                            .withOpacity(score > 0 ? 1 : 0.4),
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MiniRes extends StatelessWidget {
  final ResourceType type;
  final int count;
  final Color color;
  const _MiniRes(this.type, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResourceIcon(type: type, size: 14),
        const Gap(3),
        Text(
          '$count',
          style: TextStyle(
            color: count > 0 ? color : AppColors.textSecondary.withOpacity(0.35),
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.18), color.withOpacity(0.04)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.2), blurRadius: 16),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 16),
          const Gap(8),
          Text(game.message!,
              style: TextStyle(
                  color: color, fontSize: 14, fontWeight: FontWeight.w800)),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 250.ms)
        .slideY(begin: -0.5, end: 0, duration: 250.ms, curve: Curves.easeOut);
  }
}

class _ActionButtons extends StatelessWidget {
  final GameState game;
  final GameNotifier notifier;
  final int cooldown;

  const _ActionButtons({
    required this.game,
    required this.notifier,
    required this.cooldown,
  });

  @override
  Widget build(BuildContext context) {
    if (game.status == GameStatus.idle) {
      return _buildWide(
        GradientButton(
          onPressed: notifier.startNewGame,
          gradient: AppColors.primaryGradient,
          radius: 18,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.hardware_rounded, size: 18),
              Gap(8),
              Text('НАЧАТЬ ДОБЫЧУ',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5)),
            ],
          ),
        ),
      );
    }

    if (game.status == GameStatus.playing) {
      final hasResources =
          game.roundDiamonds + game.roundIron + game.roundCoal > 0;
      return _buildWide(
        GradientButton(
          onPressed: hasResources ? notifier.cashOut : null,
          gradient: AppColors.successGradient,
          radius: 18,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.savings_rounded, size: 18),
              Gap(8),
              Text('ЗАБРАТЬ РЕСУРСЫ',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5)),
            ],
          ),
        ),
      );
    }

    final ready = cooldown <= 0;
    return _buildWide(
      GradientButton(
        onPressed: ready ? notifier.startNewGame : null,
        gradient: AppColors.primaryGradient,
        radius: 18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!ready) ...[
              _CooldownRing(seconds: cooldown),
              const Gap(10),
              Text(
                'Подождите $cooldown сек...',
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1),
              ),
            ] else ...[
              const Icon(Icons.refresh_rounded, size: 18),
              const Gap(8),
              const Text('НОВЫЙ РАУНД',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWide(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
            width: double.infinity,
            height: 56,
            child: child),
      );
}

class _CooldownRing extends StatelessWidget {
  final int seconds;
  const _CooldownRing({required this.seconds});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: seconds / 3,
            strokeWidth: 2.5,
            backgroundColor: Colors.white24,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Center(
            child: Text(
              '$seconds',
              style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
