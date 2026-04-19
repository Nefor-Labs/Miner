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
                              : 'Пассивный доход пока ты отдыхаешь',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  if (base.purchased)
                    _WorkerBadge(workers: base.workers),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, navHeight + 8),
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
                      const Gap(12),
                      _CollectCard(base: base)
                          .animate(delay: 80.ms)
                          .fadeIn()
                          .slideY(begin: 0.15),
                      const Gap(12),
                      _UpgradeCard(base: base, player: player)
                          .animate(delay: 160.ms)
                          .fadeIn()
                          .slideY(begin: 0.15),
                      const Gap(12),
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

class _WorkerBadge extends StatelessWidget {
  final int workers;
  const _WorkerBadge({required this.workers});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.iron.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.iron.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.people_rounded, color: AppColors.iron, size: 14),
          const Gap(5),
          Text(
            '$workers рабочих',
            style: const TextStyle(
              color: AppColors.iron,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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
        radius: 24,
      ),
      padding: const EdgeInsets.all(28),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.diamond.withOpacity(0.2),
                  AppColors.diamond.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.diamond.withOpacity(0.3)),
            ),
            child: const Icon(Icons.factory_rounded,
                color: AppColors.diamond, size: 42),
          ),
          const Gap(18),
          Text(
            'Шахтёрская База',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 21),
          ),
          const Gap(8),
          Text(
            'Нанимай рабочих — они добывают\nресурсы пока ты отдыхаешь',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const Gap(22),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: canAfford
                  ? AppColors.diamond.withOpacity(0.1)
                  : AppColors.mine.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: canAfford
                    ? AppColors.diamond.withOpacity(0.3)
                    : AppColors.mine.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.diamond_rounded,
                  color: canAfford ? AppColors.diamond : AppColors.mine,
                  size: 18,
                ),
                const Gap(6),
                Text(
                  '500 алмазов',
                  style: TextStyle(
                    color: canAfford ? AppColors.diamond : AppColors.mine,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Gap(18),
          SizedBox(
            width: double.infinity,
            child: GradientButton(
              onPressed: canAfford
                  ? () => ref.read(baseProvider.notifier).purchase()
                  : null,
              gradient: AppColors.diamondGradient,
              radius: 16,
              child: const Text('КУПИТЬ БАЗУ'),
            ),
          ),
          if (!canAfford) ...[
            const Gap(8),
            Text(
              'Не хватает ${500 - player.diamonds} алмазов',
              style: const TextStyle(color: AppColors.mine, fontSize: 12),
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
      decoration: AppDecorations.glassCard(radius: 22),
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
                  AppColors.primary.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child:
                const Icon(Icons.factory_rounded, color: AppColors.primary, size: 32),
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
                const Gap(10),
                _ProductionChips(base: base),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductionChips extends StatelessWidget {
  final BaseData base;
  const _ProductionChips({required this.base});

  @override
  Widget build(BuildContext context) {
    final dMin = base.workers * BaseData.diamondPerWorkerMin;
    final dMax = base.workers * BaseData.diamondPerWorkerMax;
    final irMin = base.workers * BaseData.ironPerWorkerMin;
    final irMax = base.workers * BaseData.ironPerWorkerMax;
    final coMin = base.workers * BaseData.coalPerWorkerMin;
    final coMax = base.workers * BaseData.coalPerWorkerMax;

    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        _ProdChip('💎', '$dMin–$dMax/ч', AppColors.diamond),
        _ProdChip('🪨', '$irMin–$irMax/ч', AppColors.iron),
        _ProdChip('⬛', '$coMin–$coMax/ч', AppColors.coal),
      ],
    );
  }
}

class _ProdChip extends StatelessWidget {
  final String emoji;
  final String label;
  final Color color;
  const _ProdChip(this.emoji, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 11)),
          const Gap(4),
          Text(label,
              style: TextStyle(
                  color: color, fontSize: 11, fontWeight: FontWeight.w700)),
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
        radius: 22,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.success.withOpacity(0.25)),
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
                          ? 'Склад полон — срочно забери!'
                          : 'До заполнения ${hoursLeft.toStringAsFixed(1)}ч',
                      style: TextStyle(
                        color: isFull ? AppColors.mine : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
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
                radius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: const Text('СОБРАТЬ',
                    style: TextStyle(fontSize: 13, letterSpacing: 1)),
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: amount > 0 ? color.withOpacity(0.12) : AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: amount > 0 ? color.withOpacity(0.35) : AppColors.cellBorder,
        ),
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
              fontWeight: FontWeight.w800,
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
        shadows: canAfford
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.15),
                  blurRadius: 20,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
        radius: 22,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primary.withOpacity(0.25)),
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
                    Text('+1 рабочий · больше ресурсов/ч',
                        style: Theme.of(context).textTheme.bodyMedium),
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
                radius: 14,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: const Text('УЛУЧШИТЬ',
                    style: TextStyle(fontSize: 13, letterSpacing: 1)),
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

  String _fmt(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  @override
  Widget build(BuildContext context) {
    final ok = have >= cost;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: ok ? color.withOpacity(0.08) : AppColors.mine.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: ok ? color.withOpacity(0.25) : AppColors.mine.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 12)),
          const Gap(3),
          Text(
            _fmt(cost),
            style: TextStyle(
              color: ok ? color : AppColors.mine,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkersCard extends StatelessWidget {
  final BaseData base;
  const _WorkersCard({required this.base});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppDecorations.glassCard(radius: 22),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Рабочие', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.iron.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.iron.withOpacity(0.2)),
                ),
                child: Text(
                  '${base.workers} / ${base.workers}',
                  style: const TextStyle(
                    color: AppColors.iron,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const Gap(14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(
              base.workers,
              (i) => _WorkerTile(index: i + 1)
                  .animate(delay: (i * 50).ms)
                  .scale(
                    begin: const Offset(0.5, 0.5),
                    duration: 350.ms,
                    curve: Curves.elasticOut,
                  )
                  .fadeIn(duration: 200.ms),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkerTile extends StatelessWidget {
  final int index;
  const _WorkerTile({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.iron.withOpacity(0.18),
            AppColors.iron.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.iron.withOpacity(0.25)),
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
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
