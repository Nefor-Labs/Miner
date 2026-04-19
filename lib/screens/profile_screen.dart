import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/resource_type.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/resource_icon.dart';

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
    _nicknameCtrl =
        TextEditingController(text: ref.read(playerProvider).nickname);
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
              Text('ПРОФИЛЬ',
                      style: Theme.of(context).textTheme.displayLarge)
                  .animate()
                  .fadeIn()
                  .slideY(begin: -0.3),
              const Gap(24),
              _AvatarSection(
                player: player,
                editing: _editing,
                controller: _nicknameCtrl,
                onEdit: () => setState(() => _editing = true),
                onSave: _saveNickname,
              ).animate(delay: 100.ms).fadeIn().slideY(begin: 0.2),
              const Gap(24),
              _sectionLabel(context, 'РЕСУРСЫ'),
              const Gap(8),
              _ResourceGrid(player: player)
                  .animate(delay: 200.ms)
                  .fadeIn()
                  .slideY(begin: 0.2),
              const Gap(24),
              _sectionLabel(context, 'СТАТИСТИКА'),
              const Gap(8),
              _StatsGrid(player: player)
                  .animate(delay: 300.ms)
                  .fadeIn()
                  .slideY(begin: 0.2),
              const Gap(24),
              _sectionLabel(context, 'УЛУЧШЕНИЯ'),
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

  Widget _sectionLabel(BuildContext context, String text) => Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(letterSpacing: 2),
      );
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
              child: Icon(Icons.hardware_rounded,
                  color: AppColors.iron, size: 30),
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
                            hintText: 'Введите ник',
                            hintStyle:
                                TextStyle(color: AppColors.textSecondary),
                          ),
                          onSubmitted: (_) => onSave(),
                        ),
                      ),
                      IconButton(
                        onPressed: onSave,
                        icon: const Icon(Icons.check_circle,
                            color: AppColors.success),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.nickname.isEmpty
                            ? 'Безымянный шахтёр'
                            : player.nickname,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text('Шахтёр',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
          ),
          if (!editing)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_rounded,
                  color: AppColors.textSecondary, size: 20),
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
    return Row(
      children: [
        Expanded(
          child: _ResCard(
              ResourceType.diamond, 'Алмазы', '${player.diamonds}'),
        ),
        const Gap(10),
        Expanded(
          child: _ResCard(ResourceType.iron, 'Железо', '${player.iron}'),
        ),
        const Gap(10),
        Expanded(
          child: _ResCard(ResourceType.coal, 'Уголь', '${player.coal}'),
        ),
      ],
    );
  }
}

class _ResCard extends StatelessWidget {
  final ResourceType type;
  final String label;
  final String value;

  const _ResCard(this.type, this.label, this.value);

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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          ResourceIcon(type: type, size: 36),
          const Gap(6),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
          Text(
            value,
            style: TextStyle(
                color: _color, fontSize: 20, fontWeight: FontWeight.w800),
          ),
        ],
      ),
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
        _StatCard(Icons.videogame_asset_rounded, 'Игр сыграно',
            '${player.gamesPlayed}', AppColors.primary),
        _StatCard(Icons.emoji_events_rounded, 'Лучший счёт',
            '${player.bestRoundScore}', AppColors.success),
        _StatCard(Icons.bar_chart_rounded, 'Всего очков',
            '${player.totalScore}', AppColors.diamond),
        _StatCard(Icons.shield_rounded, 'Мин обезврежено',
            '${player.minesDefused}', AppColors.iron),
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
          child: _StatCard(Icons.hardware_rounded, 'Кирка',
              'Ур.${player.pickaxeLevel}', AppColors.iron),
        ),
        const Gap(10),
        Expanded(
          child: _StatCard(Icons.bolt_rounded, 'Множитель',
              'x${player.bonusMultiplier}', AppColors.primary),
        ),
        const Gap(10),
        Expanded(
          child: _StatCard(Icons.shield_rounded, 'Щиты',
              '${player.shieldCharges}', AppColors.success),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard(this.icon, this.label, this.value, this.color);

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
              Icon(icon, color: AppColors.textSecondary, size: 14),
              const Gap(4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      letterSpacing: 0.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Gap(4),
          Text(
            value,
            style: TextStyle(
                color: color, fontSize: 18, fontWeight: FontWeight.w800),
          ),
        ],
      ),
    );
  }
}
