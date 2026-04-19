import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/upgrade.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/resource_bar.dart';

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
                'SHOP',
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
            const Gap(8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
      if (candidates.isEmpty) {
        maxed = true;
      } else {
        nextLevel = candidates.first;
      }
    } else if (upgrade.type == UpgradeType.multiplier) {
      final current = player.bonusMultiplier;
      final candidates = upgrade.levels.where((l) => l.level > current);
      if (candidates.isEmpty) {
        maxed = true;
      } else {
        nextLevel = candidates.first;
      }
    } else if (upgrade.type == UpgradeType.shield) {
      nextLevel = upgrade.levels.first;
    }

    bool canAfford = nextLevel != null &&
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
      } else if (upgrade.type == UpgradeType.shield) {
        notifier.addShieldCharge();
      }
    }

    String statusLabel;
    if (upgrade.type == UpgradeType.pickaxe) {
      statusLabel = maxed ? 'MAX' : 'Lvl ${player.pickaxeLevel}';
    } else if (upgrade.type == UpgradeType.multiplier) {
      statusLabel = maxed ? 'MAX' : 'x${player.bonusMultiplier}';
    } else {
      statusLabel = '🛡 ${player.shieldCharges}';
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canAfford
              ? AppColors.primary.withOpacity(0.5)
              : AppColors.cellBorder,
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(upgrade.emoji, style: const TextStyle(fontSize: 28)),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      upgrade.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      nextLevel?.description ?? 'Fully upgraded',
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
                _CostChip('💎', nextLevel.costDiamond, player.diamonds),
                const Gap(8),
                _CostChip('🪨', nextLevel.costIron, player.iron),
                const Gap(8),
                _CostChip('⬛', nextLevel.costCoal, player.coal),
                const Spacer(),
                ElevatedButton(
                  onPressed: canAfford ? purchase : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    backgroundColor: canAfford
                        ? AppColors.primary
                        : AppColors.accent,
                  ),
                  child: Text(
                    upgrade.type == UpgradeType.shield ? 'BUY' : 'UPGRADE',
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
  final String emoji;
  final int cost;
  final int have;

  const _CostChip(this.emoji, this.cost, this.have);

  @override
  Widget build(BuildContext context) {
    final enough = have >= cost;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
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
