import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import '../models/quest.dart';
import '../providers/quest_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/resource_bar.dart';

class QuestsScreen extends ConsumerWidget {
  const QuestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(questProvider);
    final notifier = ref.read(questProvider.notifier);
    final minutes = notifier.minutesUntilReset();
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    final timeStr = hours > 0 ? '${hours}ч ${mins}м' : '${mins}м';

    final completedCount = state.quests.where((q) => q.completed).length;

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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ЗАДАНИЯ',
                            style: Theme.of(context).textTheme.displayLarge),
                        Text('Обновляются каждый день в 10:00',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.diamond.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: AppColors.diamond.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_rounded,
                                color: AppColors.diamond, size: 13),
                            const Gap(4),
                            Text(
                              'Через $timeStr',
                              style: const TextStyle(
                                color: AppColors.diamond,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(4),
                      Text(
                        '$completedCount / ${state.quests.length} выполнено',
                        style: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.6),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _ProgressStrip(
                  completed: completedCount, total: state.quests.length),
            ),
            const Gap(14),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                itemCount: state.quests.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, i) {
                  return _QuestCard(
                    quest: state.quests[i],
                    onClaim: () =>
                        notifier.claimReward(state.quests[i].id),
                  )
                      .animate(delay: (i * 100).ms)
                      .fadeIn()
                      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressStrip extends StatelessWidget {
  final int completed;
  final int total;
  const _ProgressStrip({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    final pct = total == 0 ? 0.0 : completed / total;
    return Container(
      height: 4,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.cellBorder.withOpacity(0.4),
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        widthFactor: pct,
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: pct >= 1 ? AppColors.goldGradient : AppColors.successGradient,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}

class _QuestCard extends StatelessWidget {
  final Quest quest;
  final VoidCallback onClaim;

  const _QuestCard({required this.quest, required this.onClaim});

  @override
  Widget build(BuildContext context) {
    final done = quest.completed;
    final claimed = quest.rewardClaimed;

    Color accentColor;
    if (claimed) {
      accentColor = AppColors.textSecondary;
    } else if (done) {
      accentColor = AppColors.success;
    } else {
      accentColor = AppColors.primary;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: claimed
              ? [
                  AppColors.surface.withOpacity(0.4),
                  AppColors.surface.withOpacity(0.2),
                ]
              : done
                  ? [
                      AppColors.success.withOpacity(0.1),
                      AppColors.card,
                    ]
                  : [
                      accentColor.withOpacity(0.07),
                      AppColors.card,
                    ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: claimed
              ? AppColors.cellBorder.withOpacity(0.25)
              : accentColor.withOpacity(done ? 0.45 : 0.3),
          width: done && !claimed ? 1.5 : 1,
        ),
        boxShadow: done && !claimed
            ? [
                BoxShadow(
                  color: accentColor.withOpacity(0.18),
                  blurRadius: 20,
                  spreadRadius: 0,
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    accentColor.withOpacity(0.2),
                    accentColor.withOpacity(0.05),
                  ]),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    quest.type.icon,
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quest.type.title(quest.target),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: claimed
                                ? AppColors.textSecondary
                                : AppColors.textPrimary,
                            fontSize: 15,
                          ),
                    ),
                    const Gap(2),
                    Row(
                      children: [
                        Text(
                          '${quest.progress}',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          ' / ${quest.target}',
                          style: TextStyle(
                            color: AppColors.textSecondary.withOpacity(0.5),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (done && !claimed)
                GradientButton(
                  onPressed: onClaim,
                  gradient: AppColors.successGradient,
                  radius: 12,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  child: const Text(
                    'ЗАБРАТЬ',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5),
                  ),
                )
              else if (claimed)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: AppColors.success.withOpacity(0.2)),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.success, size: 18),
                ),
            ],
          ),
          const Gap(12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: quest.percent,
              minHeight: 5,
              backgroundColor: AppColors.cellBorder.withOpacity(0.3),
              valueColor: AlwaysStoppedAnimation<Color>(
                claimed ? AppColors.textSecondary.withOpacity(0.3) : accentColor,
              ),
            ),
          ),
          const Gap(10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bg.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.cellBorder.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.card_giftcard_rounded,
                    color: AppColors.textSecondary.withOpacity(0.5), size: 13),
                const Gap(6),
                Text(
                  'Награда:',
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                const Gap(10),
                _RewardChip('💎', quest.rewardDiamond, AppColors.diamond,
                    claimed),
                const Gap(8),
                _RewardChip('🪨', quest.rewardIron, AppColors.iron, claimed),
                const Gap(8),
                _RewardChip('⬛', quest.rewardCoal, AppColors.coal, claimed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardChip extends StatelessWidget {
  final String emoji;
  final int amount;
  final Color color;
  final bool dimmed;

  const _RewardChip(this.emoji, this.amount, this.color, this.dimmed);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(emoji, style: const TextStyle(fontSize: 13)),
        const Gap(3),
        Text(
          '$amount',
          style: TextStyle(
            color: dimmed ? AppColors.textSecondary.withOpacity(0.4) : color,
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
