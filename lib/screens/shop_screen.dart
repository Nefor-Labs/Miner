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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                itemCount: shopUpgrades.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, i) {
                  return _UpgradeCard(upgrade: shopUpgrades[i])
                      .animate(delay: (i * 80).ms)
                      .fadeIn()
                      .slideX(begin: 0.15, end: 0, curve: Curves.easeOutCubic);
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
                    border: Border.all(color: effectiveColor.withOpacity(0.35)),
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
