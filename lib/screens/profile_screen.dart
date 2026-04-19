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
  late TextEditingController _ctrl;
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: ref.read(playerProvider).nickname);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _save() {
    final name = _ctrl.text.trim();
    if (name.isNotEmpty) ref.read(playerProvider.notifier).setNickname(name);
    setState(() => _editing = false);
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(playerProvider);

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: SafeArea(
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
              Text('Статистика и прогресс',
                      style: Theme.of(context).textTheme.bodyMedium)
                  .animate(delay: 50.ms)
                  .fadeIn(),
              const Gap(20),

              // Avatar card
              _AvatarCard(
                player: player,
                editing: _editing,
                controller: _ctrl,
                onEdit: () => setState(() => _editing = true),
                onSave: _save,
              ).animate(delay: 80.ms).fadeIn().slideY(begin: 0.15),

              const Gap(20),
              _label(context, 'РЕСУРСЫ'),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: _ResCard(ResourceType.diamond, 'Алмазы',
                        '${player.diamonds}'),
                  ),
                  const Gap(10),
                  Expanded(
                    child:
                        _ResCard(ResourceType.iron, 'Железо', '${player.iron}'),
                  ),
                  const Gap(10),
                  Expanded(
                    child:
                        _ResCard(ResourceType.coal, 'Уголь', '${player.coal}'),
                  ),
                ],
              ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.15),

              const Gap(20),
              _label(context, 'СТАТИСТИКА'),
              const Gap(10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
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
              ).animate(delay: 220.ms).fadeIn().slideY(begin: 0.15),

              const Gap(20),
              _label(context, 'УЛУЧШЕНИЯ'),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(Icons.hardware_rounded, 'Кирка',
                        'Ур.${player.pickaxeLevel}', AppColors.iron),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _StatCard(Icons.bolt_rounded, 'Множитель',
                        '×${player.bonusMultiplier}', AppColors.primary),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _StatCard(Icons.shield_rounded, 'Щиты',
                        '${player.shieldCharges}', AppColors.success),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.15),

              const Gap(8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 2,
                color: AppColors.textSecondary.withOpacity(0.7),
              ),
        ),
      );
}

class _AvatarCard extends StatelessWidget {
  final dynamic player;
  final bool editing;
  final TextEditingController controller;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  const _AvatarCard({
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
      decoration: AppDecorations.glowCard(AppColors.primary, radius: 22),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary.withOpacity(0.3),
                  AppColors.accent,
                ],
              ),
              border: Border.all(color: AppColors.primary.withOpacity(0.5),
                  width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.25),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.hardware_rounded,
                  color: AppColors.iron, size: 32),
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
                        icon: const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 26),
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
                      const Gap(3),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Шахтёр',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          if (!editing)
            Container(
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_rounded,
                    color: AppColors.textSecondary, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResCard extends StatelessWidget {
  final ResourceType type;
  final String label;
  final String value;
  const _ResCard(this.type, this.label, this.value);

  Color get _color => switch (type) {
        ResourceType.diamond => AppColors.diamond,
        ResourceType.iron => AppColors.iron,
        ResourceType.coal => AppColors.coal,
        _ => AppColors.mine,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _color.withOpacity(0.12),
            _color.withOpacity(0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ResourceIcon(type: type, size: 32),
          const Gap(8),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 10,
                  letterSpacing: 0.5)),
          const Gap(2),
          Text(value,
              style: TextStyle(
                  color: _color,
                  fontSize: 20,
                  fontWeight: FontWeight.w800)),
        ],
      ),
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const Gap(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                        letterSpacing: 0.3),
                    overflow: TextOverflow.ellipsis),
                Text(value,
                    style: TextStyle(
                        color: color,
                        fontSize: 17,
                        fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
