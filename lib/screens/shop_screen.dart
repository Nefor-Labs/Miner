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
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ResourceBar(),
            const Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'МАГАЗИН',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const Gap(8),
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: shopUpgrades.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, i) {
                  return _UpgradeCard(upgrade: shopUpgrades[i])
                      .animate(delay: (i * 80).ms)
                      .fadeIn()
                      .slideX(begin: 0.2, end: 0);
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
      final current = player.pickaxeLevel;
      final candidates = upgrade.levels.where((l) => l.level > current);
      maxed = candidates.isEmpty;
      if (!maxed) nextLevel = candidates.first;
    } else if (upgrade.type == UpgradeType.multiplier) {
      final current = player.bonusMultiplier;
      final candidates = upgrade.levels.where((l) => l.level > current);
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

    final String statusLabel;
    if (upgrade.type == UpgradeType.pickaxe) {
      statusLabel = maxed ? 'МАКС' : 'Ур.${player.pickaxeLevel}';
    } else if (upgrade.type == UpgradeType.multiplier) {
      statusLabel = maxed ? 'МАКС' : 'x${player.bonusMultiplier}';
    } else {
      statusLabel = 'x${player.shieldCharges}';
    }

    final IconData upgradeIcon;
    if (upgrade.type == UpgradeType.pickaxe) {
      upgradeIcon = Icons.hardware_rounded;
    } else if (upgrade.type == UpgradeType.shield) {
      upgradeIcon = Icons.shield_rounded;
    } else {
      upgradeIcon = Icons.bolt_rounded;
    }

    final Color iconColor;
    if (upgrade.type == UpgradeType.pickaxe) {
      iconColor = AppColors.iron;
    } else if (upgrade.type == UpgradeType.shield) {
      iconColor = AppColors.success;
    } else {
      iconColor = AppColors.primary;
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canAfford
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.cellBorder,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(upgradeIcon, color: iconColor, size: 24),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(upgrade.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      nextLevel?.description ?? 'Максимальный уровень',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(
                    color: AppColors.diamond,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          if (!maxed && nextLevel != null) ...[
            const Gap(12),
            const Divider(color: AppColors.cellBorder, height: 1),
            const Gap(12),
            Row(
              children: [
                _CostChip(ResourceType.diamond, nextLevel.costDiamond,
                    player.diamonds),
                const Gap(8),
                _CostChip(
                    ResourceType.iron, nextLevel.costIron, player.iron),
                const Gap(8),
                _CostChip(
                    ResourceType.coal, nextLevel.costCoal, player.coal),
                const Spacer(),
                ElevatedButton(
                  onPressed: canAfford ? purchase : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    backgroundColor:
                        canAfford ? AppColors.primary : AppColors.accent,
                  ),
                  child: Text(
                    upgrade.type == UpgradeType.shield
                        ? 'КУПИТЬ'
                        : 'УЛУЧШИТЬ',
                    style: const TextStyle(fontSize: 13),
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

class _CostChip extends StatelessWidget {
  final ResourceType type;
  final int cost;
  final int have;

  const _CostChip(this.type, this.cost, this.have);

  @override
  Widget build(BuildContext context) {
    final enough = have >= cost;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ResourceIcon(type: type, size: 16),
        const Gap(2),
        Text(
          '$cost',
          style: TextStyle(
            color: enough ? AppColors.textPrimary : AppColors.mine,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
