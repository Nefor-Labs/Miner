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
                        Text('ЗАДАНИЯ',
                            style: Theme.of(context).textTheme.displayLarge),
                        Text('Обновляются каждый день в 10:00',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                  ),
                  _TimerBadge(timeStr: timeStr),
                ],
              ),
            ),
            const Gap(16),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(20, 4, 20, navHeight + 8),
                itemCount: state.quests.length,
                separatorBuilder: (_, __) => const Gap(12),
                itemBuilder: (context, i) {
                  return _QuestCard(
                    quest: state.quests[i],
                    onClaim: () => notifier.claimReward(state.quests[i].id),
                  )
                      .animate(delay: (i * 100).ms)
                      .fadeIn()
                      .slideY(
                        begin: 0.2,
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

class _TimerBadge extends StatelessWidget {
  final String timeStr;
  const _TimerBadge({required this.timeStr});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.diamond.withOpacity(0.18),
            AppColors.diamond.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.diamond.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.diamond.withOpacity(0.12),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.timer_rounded, color: AppColors.diamond, size: 14),
          const Gap(5),
          Text(
            'Через $timeStr',
            style: const TextStyle(
              color: AppColors.diamond,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
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

    final Color accent = claimed
        ? AppColors.textSecondary
        : done
            ? AppColors.success
            : AppColors.primary;

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
                  accent.withOpacity(0.1),
                  AppColors.card,
                ],
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: claimed
              ? AppColors.cellBorder.withOpacity(0.4)
              : accent.withOpacity(done ? 0.55 : 0.3),
          width: done && !claimed ? 1.5 : 1,
        ),
        boxShadow: done && !claimed
            ? [
                BoxShadow(
                  color: accent.withOpacity(0.2),
                  blurRadius: 20,
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      accent.withOpacity(0.2),
                      accent.withOpacity(0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: accent.withOpacity(0.35)),
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
                    const Gap(3),
                    Text(
                      '${quest.progress} / ${quest.target}',
                      style: TextStyle(
                        color: accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              if (done && !claimed)
                GradientButton(
                  onPressed: onClaim,
                  gradient: AppColors.successGradient,
                  shadowColor: AppColors.success,
                  radius: 14,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: const Text(
                    'ЗАБРАТЬ',
                    style: TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1),
                  ),
                )
              else if (claimed)
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.textSecondary.withOpacity(0.15)),
                  ),
                  child: const Icon(Icons.check_rounded,
                      color: AppColors.textSecondary, size: 20),
                ),
            ],
          ),
          const Gap(14),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: quest.percent,
              minHeight: 7,
              backgroundColor: AppColors.cellBorder.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(
                claimed ? AppColors.textSecondary : accent,
              ),
            ),
          ),
          const Gap(12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: AppColors.bgDeep.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.cellBorder.withOpacity(0.4)),
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
                _RewardItem('💎', quest.rewardDiamond, AppColors.diamond, claimed),
                const Gap(8),
                _RewardItem('🪨', quest.rewardIron, AppColors.iron, claimed),
                const Gap(8),
                _RewardItem('⬛', quest.rewardCoal, AppColors.coal, claimed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String emoji;
  final int amount;
  final Color color;
  final bool dimmed;

  const _RewardItem(this.emoji, this.amount, this.color, this.dimmed);

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
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
