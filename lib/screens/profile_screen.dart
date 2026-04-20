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
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
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
                  ],
                ),
              ),
              const Gap(16),

              _AvatarCard(
                player: player,
                editing: _editing,
                controller: _ctrl,
                onEdit: () => setState(() => _editing = true),
                onSave: _save,
              ).animate(delay: 80.ms).fadeIn().slideY(begin: 0.15),

              const Gap(16),
              _SectionLabel('РЕСУРСЫ'),
              const Gap(8),

              Row(
                children: [
                  Expanded(
                    child: _ResCard(ResourceType.diamond, 'Алмазы',
                        '${player.diamonds}'),
                  ),
                  const Gap(8),
                  Expanded(
                    child:
                        _ResCard(ResourceType.iron, 'Железо', '${player.iron}'),
                  ),
                  const Gap(8),
                  Expanded(
                    child:
                        _ResCard(ResourceType.coal, 'Уголь', '${player.coal}'),
                  ),
                ],
              ).animate(delay: 150.ms).fadeIn().slideY(begin: 0.15),

              const Gap(16),
              _SectionLabel('СТАТИСТИКА'),
              const Gap(8),

              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5,
                children: [
                  _StatCard(Icons.videogame_asset_rounded, 'Игр сыграно',
                      '${player.gamesPlayed}', AppColors.primary),
                  _StatCard(Icons.emoji_events_rounded, 'Лучший счёт',
                      '${player.bestRoundScore}', AppColors.gold),
                  _StatCard(Icons.bar_chart_rounded, 'Всего очков',
                      '${player.totalScore}', AppColors.diamond),
                  _StatCard(Icons.shield_rounded, 'Мин обезврежено',
                      '${player.minesDefused}', AppColors.success),
                ],
              ).animate(delay: 220.ms).fadeIn().slideY(begin: 0.15),

              const Gap(16),
              _SectionLabel('СНАРЯЖЕНИЕ'),
              const Gap(8),

              Row(
                children: [
                  Expanded(
                    child: _GearCard(
                      icon: Icons.hardware_rounded,
                      label: 'Кирка',
                      value: 'Ур.${player.pickaxeLevel}',
                      color: AppColors.iron,
                      maxValue: 5,
                      currentValue: player.pickaxeLevel,
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: _GearCard(
                      icon: Icons.bolt_rounded,
                      label: 'Множитель',
                      value: '×${player.bonusMultiplier}',
                      color: AppColors.primary,
                      maxValue: 3,
                      currentValue: player.bonusMultiplier,
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: _GearCard(
                      icon: Icons.shield_rounded,
                      label: 'Щиты',
                      value: '${player.shieldCharges}',
                      color: AppColors.success,
                      maxValue: null,
                      currentValue: null,
                    ),
                  ),
                ],
              ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.15),
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
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 4, bottom: 0),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.textSecondary.withOpacity(0.6),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.5,
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C1630), Color(0xFF111420)],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 24,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          Stack(
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
                      AppColors.primary.withOpacity(0.35),
                      AppColors.accent,
                    ],
                  ),
                  border: Border.all(
                      color: AppColors.primary.withOpacity(0.5), width: 2),
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
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    gradient: AppColors.goldGradient,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.bg, width: 2),
                  ),
                  child: Text(
                    'Ур.${(player.gamesPlayed ~/ 10 + 1)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
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
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Gap(4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: AppColors.primary.withOpacity(0.25)),
                            ),
                            child: const Text(
                              'Шахтёр',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const Gap(6),
                          Text(
                            '${player.gamesPlayed} игр',
                            style: TextStyle(
                              color: AppColors.textSecondary.withOpacity(0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
          if (!editing)
            GestureDetector(
              onTap: onEdit,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.cardLight,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.cellBorder),
                ),
                child: const Icon(Icons.edit_rounded,
                    color: AppColors.textSecondary, size: 16),
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
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _color.withOpacity(0.1),
            _color.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _color.withOpacity(0.28)),
        boxShadow: [
          BoxShadow(
              color: _color.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          ResourceIcon(type: type, size: 28),
          const Gap(8),
          Text(label,
              style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontSize: 9,
                  letterSpacing: 0.5,
                  fontWeight: FontWeight.w600)),
          const Gap(2),
          Text(value,
              style: TextStyle(
                  color: _color,
                  fontSize: 18,
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
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
                    style: TextStyle(
                        color: AppColors.textSecondary.withOpacity(0.7),
                        fontSize: 10,
                        letterSpacing: 0.3),
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

class _GearCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int? maxValue;
  final int? currentValue;

  const _GearCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.maxValue,
    this.currentValue,
  });

  @override
  Widget build(BuildContext context) {
    final isMaxed = maxValue != null && currentValue == maxValue;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color.withOpacity(0.1), color.withOpacity(0.02)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isMaxed
                ? AppColors.gold.withOpacity(0.4)
                : color.withOpacity(0.22)),
        boxShadow: isMaxed
            ? [
                BoxShadow(
                  color: AppColors.gold.withOpacity(0.12),
                  blurRadius: 12,
                )
              ]
            : null,
      ),
      child: Column(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: (isMaxed ? AppColors.gold : color).withOpacity(0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: isMaxed ? AppColors.gold : color, size: 18),
          ),
          const Gap(6),
          Text(label,
              style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.6),
                  fontSize: 9,
                  letterSpacing: 0.3),
              overflow: TextOverflow.ellipsis),
          Text(isMaxed ? 'МАКС' : value,
              style: TextStyle(
                  color: isMaxed ? AppColors.gold : color,
                  fontSize: 14,
                  fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
