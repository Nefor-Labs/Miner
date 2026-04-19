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
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final navHeight = 66 + 20 + bottomPad;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 0, 20, navHeight + 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(18),
              Text('ПРОФИЛЬ',
                  style: Theme.of(context).textTheme.displayLarge)
                  .animate()
                  .fadeIn()
                  .slideY(begin: -0.3),
              Text('Статистика и прогресс',
                  style: Theme.of(context).textTheme.bodyMedium)
                  .animate(delay: 50.ms)
                  .fadeIn(),
              const Gap(18),

              _AvatarCard(
                player: player,
                editing: _editing,
                controller: _ctrl,
                onEdit: () => setState(() => _editing = true),
                onSave: _save,
              ).animate(delay: 80.ms).fadeIn().slideY(begin: 0.15),

              const Gap(20),
              _SectionLabel('РЕСУРСЫ'),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: _ResourceCard(
                        ResourceType.diamond, 'Алмазы', '${player.diamonds}'),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _ResourceCard(
                        ResourceType.iron, 'Железо', '${player.iron}'),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _ResourceCard(
                        ResourceType.coal, 'Уголь', '${player.coal}'),
                  ),
                ],
              ).animate(delay: 140.ms).fadeIn().slideY(begin: 0.15),

              const Gap(20),
              _SectionLabel('СТАТИСТИКА'),
              const Gap(10),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2.2,
                children: [
                  _StatCard(
                    Icons.videogame_asset_rounded,
                    'Игр сыграно',
                    '${player.gamesPlayed}',
                    AppColors.primary,
                  ),
                  _StatCard(
                    Icons.emoji_events_rounded,
                    'Лучший счёт',
                    '${player.bestRoundScore}',
                    AppColors.gold,
                  ),
                  _StatCard(
                    Icons.bar_chart_rounded,
                    'Всего очков',
                    '${player.totalScore}',
                    AppColors.diamond,
                  ),
                  _StatCard(
                    Icons.shield_rounded,
                    'Мин обезврежено',
                    '${player.minesDefused}',
                    AppColors.success,
                  ),
                ],
              ).animate(delay: 210.ms).fadeIn().slideY(begin: 0.15),

              const Gap(20),
              _SectionLabel('УЛУЧШЕНИЯ'),
              const Gap(10),
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      Icons.hardware_rounded,
                      'Кирка',
                      'Ур.${player.pickaxeLevel}',
                      AppColors.iron,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _StatCard(
                      Icons.bolt_rounded,
                      'Множитель',
                      '×${player.bonusMultiplier}',
                      AppColors.gold,
                    ),
                  ),
                  const Gap(10),
                  Expanded(
                    child: _StatCard(
                      Icons.shield_rounded,
                      'Щиты',
                      '${player.shieldCharges}',
                      AppColors.success,
                    ),
                  ),
                ],
              ).animate(delay: 290.ms).fadeIn().slideY(begin: 0.15),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.5,
      ),
    );
  }
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
      decoration: AppDecorations.glowCard(AppColors.primary, radius: 24),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
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
              border: Border.all(
                  color: AppColors.primary.withOpacity(0.55), width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Center(
              child: Icon(Icons.hardware_rounded,
                  color: AppColors.iron, size: 34),
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
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            fillColor: Colors.transparent,
                            filled: false,
                            hintText: 'Введите ник',
                            hintStyle: TextStyle(
                                color: AppColors.textSecondary),
                          ),
                          onSubmitted: (_) => onSave(),
                        ),
                      ),
                      IconButton(
                        onPressed: onSave,
                        icon: const Icon(Icons.check_circle_rounded,
                            color: AppColors.success, size: 28),
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
                          fontSize: 21,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary.withOpacity(0.2),
                              AppColors.primary.withOpacity(0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.35)),
                        ),
                        child: const Text(
                          'Шахтёр',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          if (!editing)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.cellBorder),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: AppColors.textSecondary, size: 17),
              ),
            ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final ResourceType type;
  final String label;
  final String value;
  const _ResourceCard(this.type, this.label, this.value);

  Color get _color => switch (type) {
        ResourceType.diamond => AppColors.diamond,
        ResourceType.iron => AppColors.iron,
        ResourceType.coal => AppColors.coal,
        _ => AppColors.mine,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_color.withOpacity(0.12), _color.withOpacity(0.03)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: _color.withOpacity(0.1),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        children: [
          ResourceIcon(type: type, size: 30),
          const Gap(8),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600)),
          const Gap(3),
          Text(value,
              style: TextStyle(
                  color: _color,
                  fontSize: 20,
                  fontWeight: FontWeight.w900)),
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 19),
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
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis),
                Text(value,
                    style: TextStyle(
                        color: color,
                        fontSize: 17,
                        fontWeight: FontWeight.w900)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
