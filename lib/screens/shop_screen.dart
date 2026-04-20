import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/resource_type.dart';
import '../models/upgrade.dart';
import '../providers/daily_reward_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/resource_bar.dart';
import '../widgets/resource_icon.dart';

// ─── Exchange rate definitions ───────────────────────────────────────────────
class _Rate {
  final ResourceType from;
  final int fromAmt;
  final ResourceType to;
  final int toAmt;
  final String label;
  const _Rate(this.from, this.fromAmt, this.to, this.toAmt, this.label);
}

const _rates = [
  _Rate(ResourceType.iron, 8, ResourceType.diamond, 1, 'Железо → Алмаз'),
  _Rate(ResourceType.coal, 20, ResourceType.diamond, 1, 'Уголь → Алмаз'),
  _Rate(ResourceType.coal, 6, ResourceType.iron, 1, 'Уголь → Железо'),
  _Rate(ResourceType.diamond, 1, ResourceType.iron, 5, 'Алмаз → Железо'),
  _Rate(ResourceType.diamond, 1, ResourceType.coal, 12, 'Алмаз → Уголь'),
  _Rate(ResourceType.iron, 1, ResourceType.coal, 3, 'Железо → Уголь'),
];

// ─── Screen ──────────────────────────────────────────────────────────────────
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
    _tab.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ResourceBar(),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('МАГАЗИН',
                      style: Theme.of(context).textTheme.displayLarge),
                  Text('Прокачай своё снаряжение',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Gap(14),
            _TabBar(controller: _tab),
            const Gap(4),
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: const [
                  _UpgradesTab(),
                  _ExchangeTab(),
                  _DailyTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Custom tab bar ──────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final TabController controller;
  const _TabBar({required this.controller});

  static const _tabs = [
    (Icons.storefront_rounded, 'УЛУЧШЕНИЯ'),
    (Icons.swap_horiz_rounded, 'ОБМЕННИК'),
    (Icons.card_giftcard_rounded, 'ЕЖЕДНЕВНО'),
  ];

  static const _accents = [
    AppColors.diamond,
    AppColors.gold,
    AppColors.success,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cellBorder.withOpacity(0.4)),
        ),
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final selected = controller.index == i;
            final (icon, label) = _tabs[i];
            final accent = _accents[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.animateTo(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeOutCubic,
                  padding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 4),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              accent.withOpacity(0.22),
                              accent.withOpacity(0.08),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(12),
                    border: selected
                        ? Border.all(color: accent.withOpacity(0.4))
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        size: 16,
                        color: selected
                            ? accent
                            : AppColors.textSecondary.withOpacity(0.5),
                      ),
                      const Gap(3),
                      Text(
                        label,
                        style: TextStyle(
                          color: selected
                              ? accent
                              : AppColors.textSecondary.withOpacity(0.4),
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── Tab 1: Upgrades ─────────────────────────────────────────────────────────
class _UpgradesTab extends ConsumerWidget {
  const _UpgradesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: shopUpgrades.length,
      separatorBuilder: (_, __) => const Gap(12),
      itemBuilder: (context, i) {
        return _UpgradeCard(upgrade: shopUpgrades[i])
            .animate(delay: (i * 80).ms)
            .fadeIn()
            .slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

// ─── Tab 2: Exchange ─────────────────────────────────────────────────────────
class _ExchangeTab extends ConsumerWidget {
  const _ExchangeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: _rates.length + 1,
      separatorBuilder: (_, __) => const Gap(10),
      itemBuilder: (context, i) {
        if (i == 0) return _ExchangeHeader();
        return _ExchangeCard(rate: _rates[i - 1])
            .animate(delay: ((i - 1) * 70).ms)
            .fadeIn()
            .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
      },
    );
  }
}

class _ExchangeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gold.withOpacity(0.08),
            AppColors.gold.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppColors.gold.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.gold.withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.swap_horiz_rounded,
                color: AppColors.gold, size: 16),
          ),
          const Gap(10),
          Expanded(
            child: Text(
              'Обменяй ресурсы по фиксированному курсу. Курс немного невыгодный — за удобство.',
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.7),
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _resColor(ResourceType t) {
  switch (t) {
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

class _ExchangeCard extends ConsumerWidget {
  final _Rate rate;
  const _ExchangeCard({required this.rate});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final notifier = ref.read(playerProvider.notifier);

    final have = switch (rate.from) {
      ResourceType.diamond => player.diamonds,
      ResourceType.iron => player.iron,
      ResourceType.coal => player.coal,
      _ => 0,
    };
    final canAfford = have >= rate.fromAmt;
    final fromColor = _resColor(rate.from);
    final toColor = _resColor(rate.to);

    void exchange() {
      notifier.exchangeResources(
        spendDiamond:
            rate.from == ResourceType.diamond ? rate.fromAmt : 0,
        spendIron: rate.from == ResourceType.iron ? rate.fromAmt : 0,
        spendCoal: rate.from == ResourceType.coal ? rate.fromAmt : 0,
        gainDiamond:
            rate.to == ResourceType.diamond ? rate.toAmt : 0,
        gainIron: rate.to == ResourceType.iron ? rate.toAmt : 0,
        gainCoal: rate.to == ResourceType.coal ? rate.toAmt : 0,
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            fromColor.withOpacity(canAfford ? 0.08 : 0.03),
            AppColors.card,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: canAfford
              ? fromColor.withOpacity(0.35)
              : AppColors.cellBorder,
          width: canAfford ? 1.5 : 1,
        ),
        boxShadow: [
          if (canAfford)
            BoxShadow(
              color: fromColor.withOpacity(0.1),
              blurRadius: 16,
            ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // From
          _ResChip(
            type: rate.from,
            amount: rate.fromAmt,
            have: have,
            color: fromColor,
          ),
          const Gap(8),
          // Arrow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              size: 14,
              color: canAfford
                  ? AppColors.textPrimary.withOpacity(0.8)
                  : AppColors.textSecondary.withOpacity(0.4),
            ),
          ),
          const Gap(8),
          // To
          _ResChip(
            type: rate.to,
            amount: rate.toAmt,
            have: -1,
            color: toColor,
          ),
          const Spacer(),
          // Button
          GradientButton(
            onPressed: canAfford ? exchange : null,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [fromColor, fromColor.withOpacity(0.6)],
            ),
            radius: 12,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            child: const Text(
              'ОБМЕН',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResChip extends StatelessWidget {
  final ResourceType type;
  final int amount;
  final int have; // -1 = skip affordability coloring
  final Color color;
  const _ResChip(
      {required this.type,
      required this.amount,
      required this.have,
      required this.color});

  @override
  Widget build(BuildContext context) {
    final dimmed = have >= 0 && have < amount;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(dimmed ? 0.04 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: color.withOpacity(dimmed ? 0.15 : 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: 16),
          const Gap(5),
          Text(
            '$amount',
            style: TextStyle(
              color: dimmed
                  ? AppColors.mine
                  : color,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab 3: Daily Reward ──────────────────────────────────────────────────────
class _DailyTab extends ConsumerWidget {
  const _DailyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dailyRewardProvider);
    final notifier = ref.read(dailyRewardProvider.notifier);
    final minutes = notifier.minutesUntilReset();
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final timeStr = hours > 0 ? '${hours}ч ${mins}м' : '${mins}м';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      child: Column(
        children: [
          _DailyCard(state: state, timeStr: timeStr, onClaim: () => notifier.claimReward())
              .animate()
              .fadeIn()
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
          const Gap(16),
          _DailyInfoCard()
              .animate(delay: 100.ms)
              .fadeIn()
              .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
        ],
      ),
    );
  }
}

class _DailyCard extends StatelessWidget {
  final DailyRewardState state;
  final String timeStr;
  final VoidCallback onClaim;
  const _DailyCard(
      {required this.state, required this.timeStr, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    final claimed = state.claimed;
    final accent = claimed ? AppColors.textSecondary : AppColors.gold;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: claimed
              ? [
                  AppColors.surface.withOpacity(0.4),
                  AppColors.card,
                ]
              : [
                  AppColors.gold.withOpacity(0.12),
                  AppColors.card,
                ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: claimed
              ? AppColors.cellBorder.withOpacity(0.3)
              : AppColors.gold.withOpacity(0.45),
          width: claimed ? 1 : 1.5,
        ),
        boxShadow: [
          if (!claimed)
            BoxShadow(
              color: AppColors.gold.withOpacity(0.2),
              blurRadius: 28,
              spreadRadius: 2,
            ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        accent.withOpacity(0.25),
                        accent.withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: accent.withOpacity(0.4)),
                    boxShadow: claimed
                        ? null
                        : [
                            BoxShadow(
                              color: AppColors.gold.withOpacity(0.3),
                              blurRadius: 16,
                            )
                          ],
                  ),
                  child: Icon(
                    claimed
                        ? Icons.check_circle_rounded
                        : Icons.card_giftcard_rounded,
                    color: accent,
                    size: 28,
                  ),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ЕЖЕДНЕВНАЯ НАГРАДА',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: claimed
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                      ),
                      const Gap(4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.diamond.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.diamond.withOpacity(0.25)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_rounded,
                                color: AppColors.diamond, size: 10),
                            const Gap(3),
                            Text(
                              claimed
                                  ? 'Следующая через $timeStr'
                                  : 'Обновляется через $timeStr',
                              style: const TextStyle(
                                color: AppColors.diamond,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(16),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.transparent,
                  AppColors.cellBorder.withOpacity(0.5),
                  Colors.transparent,
                ]),
              ),
            ),
            const Gap(16),
            Row(
              children: [
                _DailyResPill(
                    ResourceType.diamond, state.rewardDiamond, claimed),
                const Gap(8),
                _DailyResPill(ResourceType.iron, state.rewardIron, claimed),
                const Gap(8),
                _DailyResPill(ResourceType.coal, state.rewardCoal, claimed),
                const Spacer(),
                if (!claimed)
                  GradientButton(
                    onPressed: onClaim,
                    gradient: AppColors.goldGradient,
                    radius: 14,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: const Text(
                      'ЗАБРАТЬ',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.5),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.success.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_rounded,
                            color: AppColors.success, size: 14),
                        const Gap(5),
                        const Text(
                          'ПОЛУЧЕНО',
                          style: TextStyle(
                            color: AppColors.success,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyResPill extends StatelessWidget {
  final ResourceType type;
  final int amount;
  final bool dimmed;
  const _DailyResPill(this.type, this.amount, this.dimmed);

  Color get _color => _resColor(type);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withOpacity(dimmed ? 0.04 : 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: _color.withOpacity(dimmed ? 0.15 : 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: 15),
          const Gap(4),
          Text(
            '+$amount',
            style: TextStyle(
              color: dimmed ? AppColors.textSecondary.withOpacity(0.4) : _color,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _DailyInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cellBorder.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppColors.textSecondary.withOpacity(0.5), size: 14),
              const Gap(6),
              Text(
                'Как это работает',
                style: TextStyle(
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const Gap(8),
          _InfoRow('Обновляется каждый день в 10:00 МСК'),
          _InfoRow('Награда случайная каждый день'),
          _InfoRow('Не забудь забирать каждый день!'),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String text;
  const _InfoRow(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
          ),
          const Gap(8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Upgrade card (unchanged logic) ──────────────────────────────────────────
class _UpgradeCard extends ConsumerWidget {
  final Upgrade upgrade;
  const _UpgradeCard({required this.upgrade});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final notifier = ref.read(playerProvider.notifier);

    UpgradeLevel? nextLevel;
    bool maxed = false;

    if (upgrade.type == UpgradeType.pickaxe) {
      final candidates =
          upgrade.levels.where((l) => l.level > player.pickaxeLevel);
      maxed = candidates.isEmpty;
      if (!maxed) nextLevel = candidates.first;
    } else if (upgrade.type == UpgradeType.multiplier) {
      final candidates =
          upgrade.levels.where((l) => l.level > player.bonusMultiplier);
      maxed = candidates.isEmpty;
      if (!maxed) nextLevel = candidates.first;
    } else {
      nextLevel = upgrade.levels.first;
    }

    final canAfford = nextLevel != null &&
        player.diamonds >= nextLevel.costDiamond &&
        player.iron >= nextLevel.costIron &&
        player.coal >= nextLevel.costCoal;

    void purchase() {
      if (nextLevel == null) return;
      final spent = notifier.spendResources(
        diamonds: nextLevel.costDiamond,
        iron: nextLevel.costIron,
        coal: nextLevel.costCoal,
      );
      if (!spent) return;
      if (upgrade.type == UpgradeType.pickaxe) {
        notifier.upgradePickaxe(nextLevel.level);
      } else if (upgrade.type == UpgradeType.multiplier) {
        notifier.upgradeMultiplier(nextLevel.level);
      } else {
        notifier.addShieldCharge();
      }
    }

    final (IconData icon, Color color, String status) = switch (upgrade.type) {
      UpgradeType.pickaxe => (
          Icons.hardware_rounded,
          AppColors.iron,
          maxed ? 'МАКС' : 'Ур.${player.pickaxeLevel}',
        ),
      UpgradeType.shield => (
          Icons.shield_rounded,
          AppColors.success,
          '×${player.shieldCharges}',
        ),
      UpgradeType.multiplier => (
          Icons.bolt_rounded,
          AppColors.primary,
          maxed ? 'МАКС' : '×${player.bonusMultiplier}',
        ),
    };

    final effectiveColor = maxed ? AppColors.gold : color;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            effectiveColor.withOpacity(canAfford ? 0.1 : 0.04),
            AppColors.card,
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: maxed
              ? AppColors.gold.withOpacity(0.4)
              : canAfford
                  ? color.withOpacity(0.5)
                  : AppColors.cellBorder,
          width: canAfford && !maxed ? 1.5 : 1,
        ),
        boxShadow: [
          if (canAfford && !maxed)
            BoxShadow(
              color: color.withOpacity(0.14),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          if (maxed)
            BoxShadow(
              color: AppColors.gold.withOpacity(0.14),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        effectiveColor.withOpacity(0.22),
                        effectiveColor.withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(15),
                    border:
                        Border.all(color: effectiveColor.withOpacity(0.35)),
                  ),
                  child: Icon(icon, color: effectiveColor, size: 26),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(upgrade.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const Gap(3),
                      Text(
                        maxed
                            ? 'Максимальный уровень'
                            : (nextLevel?.description ?? ''),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: maxed
                          ? [
                              AppColors.gold.withOpacity(0.3),
                              AppColors.gold.withOpacity(0.1),
                            ]
                          : [
                              color.withOpacity(0.22),
                              color.withOpacity(0.08),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: maxed
                            ? AppColors.gold.withOpacity(0.45)
                            : color.withOpacity(0.35)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: maxed ? AppColors.gold : color,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            if (!maxed && nextLevel != null) ...[
              const Gap(14),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.cellBorder.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const Gap(14),
              Row(
                children: [
                  _CostPill(ResourceType.diamond, nextLevel.costDiamond,
                      player.diamonds),
                  const Gap(6),
                  _CostPill(
                      ResourceType.iron, nextLevel.costIron, player.iron),
                  const Gap(6),
                  _CostPill(
                      ResourceType.coal, nextLevel.costCoal, player.coal),
                  const Spacer(),
                  GradientButton(
                    onPressed: canAfford ? purchase : null,
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [color, color.withOpacity(0.65)]),
                    radius: 12,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Text(
                      upgrade.type == UpgradeType.shield
                          ? 'КУПИТЬ'
                          : 'УЛУЧШИТЬ',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CostPill extends StatelessWidget {
  final ResourceType type;
  final int cost;
  final int have;
  const _CostPill(this.type, this.cost, this.have);

  @override
  Widget build(BuildContext context) {
    final enough = have >= cost;
    final c = enough ? AppColors.success : AppColors.mine;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: 13),
          const Gap(3),
          Text(
            '$cost',
            style: TextStyle(
              color: enough ? AppColors.textPrimary : AppColors.mine,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
