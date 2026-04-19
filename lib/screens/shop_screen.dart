import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/resource_type.dart';
import '../models/upgrade.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/resource_bar.dart';
import '../widgets/resource_icon.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final navHeight = 66 + 20 + bottomPad;

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.bgGradient),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ResourceBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('МАГАЗИН',
                      style: Theme.of(context).textTheme.displayLarge),
                  const Gap(2),
                  Text('Прокачай снаряжение',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(20, 4, 20, navHeight + 8),
                itemCount: shopUpgrades.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, i) {
                  return _UpgradeCard(upgrade: shopUpgrades[i])
                      .animate(delay: (i * 80).ms)
                      .fadeIn()
                      .slideX(
                        begin: 0.12,
                        end: 0,
                        curve: Curves.easeOutCubic,
                        duration: 350.ms,
                      );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

    final (IconData icon, Color color, String status) =
        switch (upgrade.type) {
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
          AppColors.gold,
          maxed ? 'МАКС' : '×${player.bonusMultiplier}',
        ),
    };

    return Container(
      decoration: canAfford
          ? AppDecorations.mineralCard(color, radius: 22)
          : AppDecorations.glassCard(radius: 22),
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
                        color.withOpacity(0.22),
                        color.withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.35)),
                  ),
                  child: Icon(icon, color: color, size: 26),
                ),
                const Gap(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(upgrade.name,
                          style: Theme.of(context).textTheme.titleLarge),
                      const Gap(2),
                      Text(
                        nextLevel?.description ?? 'Максимальный уровень',
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Gap(10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.25),
                        color.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: color.withOpacity(0.4)),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
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
                      AppColors.cellBorder.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              const Gap(14),
              Row(
                children: [
                  if (nextLevel.costDiamond > 0)
                    _CostChip(
                      ResourceType.diamond,
                      nextLevel.costDiamond,
                      player.diamonds,
                    ),
                  if (nextLevel.costIron > 0) ...[
                    const Gap(6),
                    _CostChip(
                      ResourceType.iron,
                      nextLevel.costIron,
                      player.iron,
                    ),
                  ],
                  if (nextLevel.costCoal > 0) ...[
                    const Gap(6),
                    _CostChip(
                      ResourceType.coal,
                      nextLevel.costCoal,
                      player.coal,
                    ),
                  ],
                  const Spacer(),
                  GradientButton(
                    onPressed: canAfford ? purchase : null,
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    shadowColor: color,
                    radius: 14,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Text(
                      upgrade.type == UpgradeType.shield
                          ? 'КУПИТЬ'
                          : 'УЛУЧШИТЬ',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
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

class _CostChip extends StatelessWidget {
  final ResourceType type;
  final int cost;
  final int have;
  const _CostChip(this.type, this.cost, this.have);

  @override
  Widget build(BuildContext context) {
    final enough = have >= cost;
    final color = enough ? AppColors.success : AppColors.mine;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.28)),
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
