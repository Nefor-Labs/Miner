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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ResourceBar(),
            const Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('МАГАЗИН',
                      style: Theme.of(context).textTheme.displayLarge),
                  const Gap(2),
                  Text('Прокачай своё снаряжение',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: shopUpgrades.length,
                separatorBuilder: (_, __) => const Gap(14),
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

    return Container(
      decoration: AppDecorations.glassCard(
        borderColor: canAfford
            ? color.withOpacity(0.45)
            : AppColors.cellBorder,
        borderWidth: canAfford ? 1.5 : 1,
        shadows: canAfford
            ? [
                BoxShadow(
                  color: color.withOpacity(0.12),
                  blurRadius: 16,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
              children: [
                // Icon container
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color.withOpacity(0.2),
                        color.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Icon(icon, color: color, size: 24),
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
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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
                      AppColors.cellBorder.withOpacity(0.6),
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
                        colors: [color, color.withOpacity(0.7)]),
                    radius: 12,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    child: Text(
                      upgrade.type == UpgradeType.shield
                          ? 'КУПИТЬ'
                          : 'УЛУЧШИТЬ',
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: (enough ? AppColors.success : AppColors.mine).withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: (enough ? AppColors.success : AppColors.mine).withOpacity(0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ResourceIcon(type: type, size: 14),
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
