import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late TextEditingController _nicknameCtrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _nicknameCtrl = TextEditingController(
      text: ref.read(playerProvider).nickname,
    );
  }

  @override
  void dispose() {
    _nicknameCtrl.dispose();
    super.dispose();
  }

  void _saveNickname() {
    final name = _nicknameCtrl.text.trim();
    if (name.isNotEmpty) {
      ref.read(playerProvider.notifier).setNickname(name);
    }
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROFILE',
                style: Theme.of(context).textTheme.displayLarge,
              ).animate().fadeIn().slideY(begin: -0.3),
              const Gap(24),
              _AvatarSection(
                player: player,
                editing: _editing,
                controller: _nicknameCtrl,
                onEdit: () => setState(() => _editing = true),
                onSave: _saveNickname,
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2),
              const Gap(24),
              Text(
                'RESOURCES',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      letterSpacing: 2,
                    ),
              ),
              const Gap(8),
              _ResourceGrid(player: player)
                  .animate(delay: 200.ms)
                  .fadeIn()
                  .slideY(begin: 0.2),
              const Gap(24),
              Text(
                'STATISTICS',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      letterSpacing: 2,
                    ),
              ),
              const Gap(8),
              _StatsGrid(player: player)
                  .animate(delay: 300.ms)
                  .fadeIn()
                  .slideY(begin: 0.2),
              const Gap(24),
              Text(
                'UPGRADES',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      letterSpacing: 2,
                    ),
              ),
              const Gap(8),
              _UpgradesRow(player: player)
                  .animate(delay: 400.ms)
                  .fadeIn()
                  .slideY(begin: 0.2),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final dynamic player;
  final bool editing;
  final TextEditingController controller;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  const _AvatarSection({
    required this.player,
    required this.editing,
    required this.controller,
    required this.onEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cellBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: const Center(
              child: Text('⛏', style: TextStyle(fontSize: 28)),
            ),
          ),
          const Gap(16),
          Expanded(
            child: editing
                ? Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          maxLength: 20,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: const InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: 'Enter nickname',
                            hintStyle:
                                TextStyle(color: AppColors.textSecondary),
                          ),
                          onSubmitted: (_) => onSave(),
                        ),
                      ),
                      IconButton(
                        onPressed: onSave,
                        icon: const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.nickname.isEmpty
                            ? 'Anonymous Miner'
                            : player.nickname,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Miner since launch',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
          ),
          if (!editing)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
            ),
        ],
      ),
    );
  }
}

class _ResourceGrid extends StatelessWidget {
  final dynamic player;

  const _ResourceGrid({required this.player});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        _StatCard('💎', 'Diamonds', '${player.diamonds}', AppColors.diamond),
        _StatCard('🪨', 'Iron', '${player.iron}', AppColors.iron),
        _StatCard('⬛', 'Coal', '${player.coal}', AppColors.coal),
      ],
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final dynamic player;

  const _StatsGrid({required this.player});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 2,
      children: [
        _StatCard('🎮', 'Games', '${player.gamesPlayed}', AppColors.primary),
        _StatCard('🏆', 'Best Score', '${player.bestRoundScore}',
            AppColors.success),
        _StatCard('📊', 'Total Score', '${player.totalScore}',
            AppColors.diamond),
        _StatCard('🛡', 'Mines Defused', '${player.minesDefused}',
            AppColors.iron),
      ],
    );
  }
}

class _UpgradesRow extends StatelessWidget {
  final dynamic player;

  const _UpgradesRow({required this.player});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
              '⛏', 'Pickaxe', 'Lvl ${player.pickaxeLevel}', AppColors.iron),
        ),
        const Gap(10),
        Expanded(
          child: _StatCard(
              '⚡', 'Multiplier', 'x${player.bonusMultiplier}',
              AppColors.primary),
        ),
        const Gap(10),
        Expanded(
          child: _StatCard(
              '🛡', 'Shields', '${player.shieldCharges}', AppColors.success),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;

  const _StatCard(this.emoji, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 14)),
              const Gap(4),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
