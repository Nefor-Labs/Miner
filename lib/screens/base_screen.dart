import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/base_data.dart';
import '../providers/base_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/resource_bar.dart';

class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key});

  @override
  ConsumerState<BaseScreen> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Refresh pending every 30 seconds while screen is open
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      ref.read(baseProvider.notifier).refreshPending();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(baseProvider.notifier).refreshPending();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = ref.watch(baseProvider);
    final player = ref.watch(playerProvider);

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('БАЗА',
                            style: Theme.of(context).textTheme.displayLarge),
                        Text(
                          base.purchased
                              ? base.levelTitle
                              : 'Купи базу и получай пассивный доход',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (base.purchased)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          AppColors.iron.withOpacity(0.2),
                          AppColors.iron.withOpacity(0.05),
                        ]),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                            color: AppColors.iron.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.people_rounded,
                              color: AppColors.iron, size: 14),
                          const Gap(5),
                          Text(
                            '${base.workers} рабочих',
                            style: const TextStyle(
                              color: AppColors.iron,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            const Gap(20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  children: [
                    if (!base.purchased)
                      _PurchaseCard(player: player)
                          .animate()
                          .fadeIn()
                          .slideY(begin: 0.2),
                    if (base.purchased) ...[
                      _BaseCard(base: base)
                          .animate()
                          .fadeIn()
                          .slideY(begin: 0.15),
                      const Gap(14),
                      _CollectCard(base: base)
                          .animate(delay: 80.ms)
                          .fadeIn()
                          .slideY(begin: 0.15),
                      const Gap(14),
                      _UpgradeCard(base: base, player: player)
                          .animate(delay: 160.ms)
                          .fadeIn()
                          .slideY(begin: 0.15),
                      const Gap(14),
                      _WorkersCard(base: base)
                          .animate(delay: 240.ms)
                          .fadeIn()
                          .slideY(begin: 0.15),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseCard extends ConsumerWidget {
  final dynamic player;
  const _PurchaseCard({required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canAfford = player.diamonds >= 500;

    return Container(
      decoration: AppDecorations.glowCard(
        canAfford ? AppColors.diamond : AppColors.cellBorder,
        radius: 22,
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.diamond.withOpacity(0.2),
                  AppColors.accent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: AppColors.diamond.withOpacity(0.3)),
            ),
            child: const Icon(Icons.factory_rounded,
                color: AppColors.diamond, size: 40),
          ),
          const Gap(16),
          Text(
            'Шахтёрская База',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                ),
          ),
          const Gap(6),
          Text(
            'Нанимай рабочих, которые автоматически\nдобывают ресурсы пока ты не играешь',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.diamond_rounded,
                  color: AppColors.diamond, size: 18),
              const Gap(6),
              Text(
                '500 алмазов',
                style: TextStyle(
                  color: canAfford
                      ? AppColors.diamond
                      : AppColors.mine,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Gap(16),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              onPressed: canAfford
                  ? () => ref.read(baseProvider.notifier).purchase()
                  : null,
              gradient: AppColors.diamondGradient,
              child: const Text('КУПИТЬ БАЗУ'),
            ),
          ),
          if (!canAfford) ...[
            const Gap(8),
            Text(
              'Не хватает ${500 - player.diamonds} алмазов',
              style: const TextStyle(
                  color: AppColors.mine, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _BaseCard extends StatelessWidget {
  final BaseData base;
  const _BaseCard({required this.base});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.glassCard(radius: 20),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.2),
                  AppColors.accent,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border:
                  Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: const Icon(Icons.factory_rounded,
                color: AppColors.primary, size: 32),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(base.levelTitle,
                    style: Theme.of(context).textTheme.titleLarge),
                const Gap(4),
                Text(
                  'Уровень ${base.level} • ${base.workers} рабочих',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(8),
                // Production per hour
                _ProductionRow(base: base),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductionRow extends StatelessWidget {
  final BaseData base;
  const _ProductionRow({required this.base});

  @override
  Widget build(BuildContext context) {
    final dMin = base.workers * BaseData.diamondPerWorkerMin;
    final dMax = base.workers * BaseData.diamondPerWorkerMax;
    final irMin = base.workers * BaseData.ironPerWorkerMin;
    final irMax = base.workers * BaseData.ironPerWorkerMax;
    final coMin = base.workers * BaseData.coalPerWorkerMin;
    final coMax = base.workers * BaseData.coalPerWorkerMax;

    return Wrap(
      spacing: 8,
      children: [
        _ProdChip('💎', '$dMin-$dMax', AppColors.diamond),
        _ProdChip('🪨', '$irMin-$irMax', AppColors.iron),
        _ProdChip('⬛', '$coMin-$coMax', AppColors.coal),
      ],
    );
  }
}

class _ProdChip extends StatelessWidget {
  final String emoji;
  final String range;
  final Color color;
  const _ProdChip(this.emoji, this.range, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 11)),
          const Gap(3),
          Text(range,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          Text('/ч',
              style: TextStyle(
                  color: color.withOpacity(0.6), fontSize: 9)),
        ],
      ),
    );
  }
}

class _CollectCard extends ConsumerWidget {
  final BaseData base;
  const _CollectCard({required this.base});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasPending =
        base.pendingDiamonds + base.pendingIron + base.pendingCoal > 0;
    final hoursLeft = ref.read(baseProvider.notifier).hoursUntilFull();
    final isFull = hoursLeft <= 0;

    return Container(
      decoration: AppDecorations.glowCard(
        hasPending ? AppColors.success : AppColors.cellBorder,
        radius: 20,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.inventory_2_rounded,
                    color: AppColors.success, size: 22),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Накопленные ресурсы',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      isFull
                          ? 'Склад полон! Срочно забери ресурсы'
                          : 'Заполнится через ${hoursLeft.toStringAsFixed(1)}ч',
                      style: TextStyle(
                        color: isFull
                            ? AppColors.mine
                            : AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(16),
          Row(
            children: [
              _PendingChip('💎', base.pendingDiamonds, AppColors.diamond),
              const Gap(8),
              _PendingChip('🪨', base.pendingIron, AppColors.iron),
              const Gap(8),
              _PendingChip('⬛', base.pendingCoal, AppColors.coal),
              const Spacer(),
              GradientButton(
                onPressed: hasPending
                    ? () => ref.read(baseProvider.notifier).collect()
                    : null,
                gradient: AppColors.successGradient,
                radius: 12,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: const Text('СОБРАТЬ',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PendingChip extends StatelessWidget {
  final String emoji;
  final int amount;
  final Color color;
  const _PendingChip(this.emoji, this.amount, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: amount > 0 ? color.withOpacity(0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: amount > 0
                ? color.withOpacity(0.35)
                : AppColors.cellBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 14)),
          const Gap(4),
          Text(
            '$amount',
            style: TextStyle(
              color: amount > 0 ? color : AppColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _UpgradeCard extends ConsumerWidget {
  final BaseData base;
  final dynamic player;
  const _UpgradeCard({required this.base, required this.player});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final next = base.level + 1;
    final dCost = BaseData.diamondCost(next);
    final irCost = BaseData.ironCost(next);
    final coCost = BaseData.coalCost(next);

    final canAfford = player.diamonds >= dCost &&
        player.iron >= irCost &&
        player.coal >= coCost;

    return Container(
      decoration: AppDecorations.glassCard(
        borderColor: canAfford
            ? AppColors.primary.withOpacity(0.4)
            : AppColors.cellBorder,
        radius: 20,
        shadows: canAfford
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.12),
                  blurRadius: 16,
                )
              ]
            : null,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.upgrade_rounded,
                    color: AppColors.primary, size: 22),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Улучшить до Ур.$next',
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(
                      '+1 рабочий • больше ресурсов/ч',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(14),
          Row(
            children: [
              _CostItem('💎', dCost, player.diamonds, AppColors.diamond),
              if (irCost > 0) ...[
                const Gap(8),
                _CostItem('🪨', irCost, player.iron, AppColors.iron),
              ],
              if (coCost > 0) ...[
                const Gap(8),
                _CostItem('⬛', coCost, player.coal, AppColors.coal),
              ],
              const Spacer(),
              GradientButton(
                onPressed: canAfford
                    ? () => ref.read(baseProvider.notifier).upgrade()
                    : null,
                gradient: AppColors.primaryGradient,
                radius: 12,
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 10),
                child: const Text('УЛУЧШИТЬ',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CostItem extends StatelessWidget {
  final String emoji;
  final int cost;
  final int have;
  final Color color;
  const _CostItem(this.emoji, this.cost, this.have, this.color);

  @override
  Widget build(BuildContext context) {
    final ok = have >= cost;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const Gap(3),
        Text(
          _format(cost),
          style: TextStyle(
            color: ok ? color : AppColors.mine,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _format(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }
}

class _WorkersCard extends StatelessWidget {
  final BaseData base;
  const _WorkersCard({required this.base});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.glassCard(radius: 20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Рабочие',
              style: Theme.of(context).textTheme.titleLarge),
          const Gap(12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              base.workers,
              (i) => _WorkerBubble(index: i + 1)
                  .animate(delay: (i * 60).ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 300.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerBubble extends StatelessWidget {
  final int index;
  const _WorkerBubble({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.iron.withOpacity(0.2),
            AppColors.accent,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.iron.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_rounded, color: AppColors.iron, size: 22),
          Text(
            '#$index',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 9,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
