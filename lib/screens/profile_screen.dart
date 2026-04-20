import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/resource_type.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/resource_icon.dart';

// ─── Rank helpers ─────────────────────────────────────────────────────────────

String _rankTitle(int games) {
  if (games >= 500) return 'АБСОЛЮТ';
  if (games >= 200) return 'ЛЕГЕНДА';
  if (games >= 100) return 'МАСТЕР';
  if (games >= 60) return 'ЭКСПЕРТ';
  if (games >= 30) return 'ГОРНЯК';
  if (games >= 10) return 'ШАХТЁР';
  return 'НОВИЧОК';
}

Color _rankColor(int games) {
  if (games >= 500) return AppColors.diamond;
  if (games >= 200) return AppColors.gold;
  if (games >= 100) return AppColors.primary;
  if (games >= 60) return AppColors.success;
  if (games >= 30) return AppColors.iron;
  return AppColors.textSecondary;
}

int _nextRankThreshold(int games) {
  if (games < 10) return 10;
  if (games < 30) return 30;
  if (games < 60) return 60;
  if (games < 100) return 100;
  if (games < 200) return 200;
  if (games < 500) return 500;
  return 500;
}

int _prevRankThreshold(int games) {
  if (games < 10) return 0;
  if (games < 30) return 10;
  if (games < 60) return 30;
  if (games < 100) return 60;
  if (games < 200) return 100;
  if (games < 500) return 200;
  return 200;
}

String _formatNum(int n) {
  if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
  if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
  return '$n';
}

// ─── Screen ───────────────────────────────────────────────────────────────────

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

              _HeroCard(
                player: player,
                editing: _editing,
                controller: _ctrl,
                onEdit: () => setState(() => _editing = true),
                onSave: _save,
              ).animate(delay: 80.ms).fadeIn().slideY(begin: 0.1),

              const Gap(20),
              _SectionLabel('РЕСУРСЫ'),
              const Gap(8),

              Row(
                children: [
                  Expanded(
                    child: _ResCard(
                      ResourceType.diamond, 'Алмазы',
                      _formatNum(player.diamonds),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: _ResCard(
                      ResourceType.iron, 'Железо',
                      _formatNum(player.iron),
                    ),
                  ),
                  const Gap(8),
                  Expanded(
                    child: _ResCard(
                      ResourceType.coal, 'Уголь',
                      _formatNum(player.coal),
                    ),
                  ),
                ],
              ).animate(delay: 160.ms).fadeIn().slideY(begin: 0.12),

              const Gap(20),
              _SectionLabel('СТАТИСТИКА'),
              const Gap(8),

              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          Icons.videogame_asset_rounded,
                          'Игр сыграно',
                          _formatNum(player.gamesPlayed),
                          AppColors.primary,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: _StatCard(
                          Icons.emoji_events_rounded,
                          'Лучший раунд',
                          _formatNum(player.bestRoundScore),
                          AppColors.gold,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          Icons.bar_chart_rounded,
                          'Всего очков',
                          _formatNum(player.totalScore),
                          AppColors.diamond,
                        ),
                      ),
                      const Gap(10),
                      Expanded(
                        child: _StatCard(
                          Icons.shield_rounded,
                          'Мин обезврежено',
                          '${player.minesDefused}',
                          AppColors.success,
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate(delay: 230.ms).fadeIn().slideY(begin: 0.12),

              const Gap(20),
              _SectionLabel('СНАРЯЖЕНИЕ'),
              const Gap(8),

              _GearSection(player: player)
                  .animate(delay: 300.ms)
                  .fadeIn()
                  .slideY(begin: 0.12),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Section label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 3,
            height: 12,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Gap(8),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.7),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 2.5,
            ),
          ),
        ],
      );
}

// ─── Hero card ────────────────────────────────────────────────────────────────

class _HeroCard extends StatelessWidget {
  final dynamic player;
  final bool editing;
  final TextEditingController controller;
  final VoidCallback onEdit;
  final VoidCallback onSave;

  const _HeroCard({
    required this.player,
    required this.editing,
    required this.controller,
    required this.onEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final games = player.gamesPlayed as int;
    final level = games ~/ 10 + 1;
    final rank = _rankTitle(games);
    final rankColor = _rankColor(games);
    final prev = _prevRankThreshold(games);
    final next = _nextRankThreshold(games);
    final progress =
        games >= 500 ? 1.0 : (games - prev) / (next - prev).toDouble();

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: rankColor.withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: rankColor.withOpacity(0.06), width: 2),
              ),
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: rankColor.withOpacity(0.08), width: 1),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            left: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.04), width: 2),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 92,
                      height: 92,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: rankColor.withOpacity(0.3), width: 2),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accent,
                      ),
                      child: const Center(
                        child: Icon(Icons.hardware_rounded,
                            color: AppColors.iron, size: 40),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: AppColors.goldGradient,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.bg, width: 2),
                        ),
                        child: Text(
                          'Ур.$level',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const Gap(14),

                if (editing) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: TextField(
                          controller: controller,
                          autofocus: true,
                          maxLength: 20,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
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
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        player.nickname.isEmpty
                            ? 'Безымянный шахтёр'
                            : player.nickname,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Gap(8),
                      GestureDetector(
                        onTap: onEdit,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.cardLight,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.cellBorder),
                          ),
                          child: const Icon(Icons.edit_rounded,
                              color: AppColors.textSecondary, size: 14),
                        ),
                      ),
                    ],
                  ),
                ],

                const Gap(8),

                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: rankColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: rankColor.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.military_tech_rounded,
                          color: rankColor, size: 13),
                      const Gap(5),
                      Text(
                        rank,
                        style: TextStyle(
                          color: rankColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),

                const Gap(18),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ДО СЛЕДУЮЩЕГО РАНГА',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.55),
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.5,
                          ),
                        ),
                        if (games < 500)
                          Text(
                            '$games / $next',
                            style: TextStyle(
                              color: rankColor.withOpacity(0.85),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          )
                        else
                          Text(
                            'МАКСИМУМ',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                      ],
                    ),
                    const Gap(7),
                    Stack(
                      children: [
                        Container(
                          height: 7,
                          decoration: BoxDecoration(
                            color: AppColors.cellBorder.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: progress.clamp(0.0, 1.0),
                          child: Container(
                            height: 7,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [rankColor, rankColor.withOpacity(0.5)],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Gap(18),

                Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.transparent,
                      AppColors.cellBorder.withOpacity(0.6),
                      Colors.transparent,
                    ]),
                  ),
                ),

                const Gap(16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _MiniStat(
                      Icons.videogame_asset_rounded,
                      'ИГРЫ',
                      _formatNum(player.gamesPlayed),
                      AppColors.primary,
                    ),
                    Container(
                        width: 1,
                        height: 32,
                        color: AppColors.cellBorder.withOpacity(0.4)),
                    _MiniStat(
                      Icons.emoji_events_rounded,
                      'РЕКОРД',
                      _formatNum(player.bestRoundScore),
                      AppColors.gold,
                    ),
                    Container(
                        width: 1,
                        height: 32,
                        color: AppColors.cellBorder.withOpacity(0.4)),
                    _MiniStat(
                      Icons.bar_chart_rounded,
                      'ОЧКИ',
                      _formatNum(player.totalScore),
                      AppColors.diamond,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _MiniStat(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color.withOpacity(0.7), size: 11),
              const Gap(4),
              Text(
                label,
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.55),
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const Gap(3),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      );
}

// ─── Resource cards ───────────────────────────────────────────────────────────

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
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withOpacity(0.25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _color.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: _color.withOpacity(0.2)),
            ),
            child: Center(child: ResourceIcon(type: type, size: 24)),
          ),
          const Gap(10),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.65),
              fontSize: 9,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Gap(3),
          Text(
            value,
            style: TextStyle(
              color: _color,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Stat cards ───────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  const _StatCard(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const Gap(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.65),
                    fontSize: 10,
                    letterSpacing: 0.3,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const Gap(2),
                Text(
                  value,
                  style: TextStyle(
                    color: color,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Gear section ─────────────────────────────────────────────────────────────

class _GearSection extends StatelessWidget {
  final dynamic player;
  const _GearSection({required this.player});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PickaxeCard(
          level: player.pickaxeLevel as int,
          maxLevel: 15,
        ),
        const Gap(10),
        Row(
          children: [
            Expanded(
              child: _GearCard(
                icon: Icons.bolt_rounded,
                label: 'Множитель',
                value: '×${player.bonusMultiplier}',
                color: AppColors.primary,
                maxValue: 3,
                currentValue: player.bonusMultiplier as int,
              ),
            ),
            const Gap(10),
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
        ),
      ],
    );
  }
}

class _PickaxeCard extends StatelessWidget {
  final int level;
  final int maxLevel;
  const _PickaxeCard({required this.level, required this.maxLevel});

  @override
  Widget build(BuildContext context) {
    final isMaxed = level >= maxLevel;
    final color = isMaxed ? AppColors.gold : AppColors.iron;
    final progress = level / maxLevel;

    final names = [
      '',
      'Деревянная', 'Железная', 'Золотая', 'Алмазная',
      'Мифическая', 'Рунная', 'Дух', 'Небесная',
      'Гром', 'Легендарная', 'Вечность', 'Хаос',
      'Дракон', 'Богов', 'Абсолюта',
    ];
    final name = level < names.length ? names[level] : 'Ур.$level';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: isMaxed
                ? AppColors.gold.withOpacity(0.4)
                : color.withOpacity(0.22)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: color.withOpacity(0.25)),
            ),
            child: Icon(Icons.hardware_rounded, color: color, size: 26),
          ),
          const Gap(14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Кирка "$name"',
                      style: TextStyle(
                        color: color,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 9, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(isMaxed ? 0.2 : 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(
                        isMaxed ? 'МАКС' : 'Ур.$level / $maxLevel',
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const Gap(8),
                Stack(
                  children: [
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.cellBorder.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: progress,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.5)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
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
    final effectiveColor = isMaxed ? AppColors.gold : color;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isMaxed
                ? AppColors.gold.withOpacity(0.4)
                : color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: effectiveColor.withOpacity(0.25)),
            ),
            child: Icon(icon, color: effectiveColor, size: 20),
          ),
          const Gap(8),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.6),
              fontSize: 10,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Gap(3),
          Text(
            isMaxed ? 'МАКС' : value,
            style: TextStyle(
              color: effectiveColor,
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (maxValue != null && currentValue != null && !isMaxed) ...[
            const Gap(6),
            Stack(
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.cellBorder.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: currentValue! / maxValue!,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [color, color.withOpacity(0.5)]),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
