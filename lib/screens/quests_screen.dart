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
                        Text('ЗАДАНИЯ',
                            style: Theme.of(context).textTheme.displayLarge),
                        Text('Обновляются каждый день в 10:00',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        AppColors.diamond.withOpacity(0.2),
                        AppColors.diamond.withOpacity(0.05),
                      ]),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                          color: AppColors.diamond.withOpacity(0.35)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.timer_rounded,
                            color: AppColors.diamond, size: 14),
                        const Gap(5),
                        Text(
                          'Через $timeStr',
                          style: const TextStyle(
                            color: AppColors.diamond,
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                itemCount: state.quests.length,
                separatorBuilder: (_, __) => const Gap(14),
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
                  AppColors.surface.withOpacity(0.5),
                  AppColors.surface.withOpacity(0.3),
                ]
              : [
                  accentColor.withOpacity(0.1),
                  AppColors.card,
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: claimed
              ? AppColors.cellBorder.withOpacity(0.3)
              : accentColor.withOpacity(0.4),
          width: done && !claimed ? 1.5 : 1,
        ),
        boxShadow: done && !claimed
            ? [
                BoxShadow(
                  color: accentColor.withOpacity(0.2),
                  blurRadius: 16,
                )
              ]
            : null,
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Type icon container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    accentColor.withOpacity(0.2),
                    accentColor.withOpacity(0.05),
                  ]),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: Center(
                  child: Text(
                    quest.type.icon,
                    style: const TextStyle(fontSize: 20),
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
                          ),
                    ),
                    const Gap(2),
                    Text(
                      '${quest.progress} / ${quest.target}',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
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
                      horizontal: 14, vertical: 10),
                  child: const Text(
                    'ЗАБРАТЬ',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                )
              else if (claimed)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      color: AppColors.textSecondary, size: 20),
                ),
            ],
          ),
          const Gap(14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: quest.percent,
              minHeight: 6,
              backgroundColor: AppColors.cellBorder.withOpacity(0.4),
              valueColor: AlwaysStoppedAnimation<Color>(
                claimed ? AppColors.textSecondary : accentColor,
              ),
            ),
          ),
          const Gap(12),
          // Rewards row
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.bg.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.card_giftcard_rounded,
                    color: AppColors.textSecondary, size: 14),
                const Gap(6),
                Text(
                  'Награда:',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const Gap(10),
                _RewardChip('💎', quest.rewardDiamond, AppColors.diamond,
                    claimed),
                const Gap(6),
                _RewardChip(
                    '🪨', quest.rewardIron, AppColors.iron, claimed),
                const Gap(6),
                _RewardChip(
                    '⬛', quest.rewardCoal, AppColors.coal, claimed),
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
            color: dimmed ? AppColors.textSecondary : color,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
