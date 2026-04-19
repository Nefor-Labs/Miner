import 'dart:convert';
import 'dart:math';

enum QuestType {
  collectDiamonds,
  collectIron,
  collectCoal,
  playGames,
  surviveRounds,
  cashOut,
}

extension QuestTypeExt on QuestType {
  String title(int target) {
    switch (this) {
      case QuestType.collectDiamonds:
        return 'Собери $target алмазов';
      case QuestType.collectIron:
        return 'Собери $target железа';
      case QuestType.collectCoal:
        return 'Собери $target угля';
      case QuestType.playGames:
        return 'Сыграй $target игр';
      case QuestType.surviveRounds:
        return 'Заверши $target раундов без взрыва';
      case QuestType.cashOut:
        return 'Сделай кэшаут $target раз';
    }
  }

  String get icon {
    switch (this) {
      case QuestType.collectDiamonds:
        return '💎';
      case QuestType.collectIron:
        return '🪨';
      case QuestType.collectCoal:
        return '⬛';
      case QuestType.playGames:
        return '🎮';
      case QuestType.surviveRounds:
        return '🛡';
      case QuestType.cashOut:
        return '💰';
    }
  }
}

class Quest {
  final String id;
  final QuestType type;
  final int target;
  final int progress;
  final bool rewardClaimed;
  final int rewardDiamond;
  final int rewardIron;
  final int rewardCoal;

  const Quest({
    required this.id,
    required this.type,
    required this.target,
    this.progress = 0,
    this.rewardClaimed = false,
    required this.rewardDiamond,
    required this.rewardIron,
    required this.rewardCoal,
  });

  bool get completed => progress >= target;

  double get percent => (progress / target).clamp(0.0, 1.0);

  Quest copyWith({int? progress, bool? rewardClaimed}) => Quest(
        id: id,
        type: type,
        target: target,
        progress: progress ?? this.progress,
        rewardClaimed: rewardClaimed ?? this.rewardClaimed,
        rewardDiamond: rewardDiamond,
        rewardIron: rewardIron,
        rewardCoal: rewardCoal,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'target': target,
        'progress': progress,
        'rewardClaimed': rewardClaimed,
        'rewardDiamond': rewardDiamond,
        'rewardIron': rewardIron,
        'rewardCoal': rewardCoal,
      };

  factory Quest.fromJson(Map<String, dynamic> j) => Quest(
        id: j['id'] as String,
        type: QuestType.values[j['type'] as int],
        target: j['target'] as int,
        progress: j['progress'] as int,
        rewardClaimed: j['rewardClaimed'] as bool,
        rewardDiamond: j['rewardDiamond'] as int,
        rewardIron: j['rewardIron'] as int,
        rewardCoal: j['rewardCoal'] as int,
      );

  static List<Quest> generateDaily(Random rng) {
    final types = List<QuestType>.from(QuestType.values)..shuffle(rng);
    final selected = types.take(3).toList();
    return selected.map((type) => _buildQuest(type, rng)).toList();
  }

  static Quest _buildQuest(QuestType type, Random rng) {
    final (int target, int d, int ir, int co) = switch (type) {
      QuestType.collectDiamonds => (
          3 + rng.nextInt(6),
          5 + rng.nextInt(8),
          10 + rng.nextInt(10),
          20 + rng.nextInt(20),
        ),
      QuestType.collectIron => (
          10 + rng.nextInt(15),
          3 + rng.nextInt(5),
          15 + rng.nextInt(15),
          30 + rng.nextInt(20),
        ),
      QuestType.collectCoal => (
          20 + rng.nextInt(20),
          2 + rng.nextInt(4),
          10 + rng.nextInt(10),
          40 + rng.nextInt(30),
        ),
      QuestType.playGames => (
          3 + rng.nextInt(5),
          4 + rng.nextInt(6),
          8 + rng.nextInt(10),
          15 + rng.nextInt(15),
        ),
      QuestType.surviveRounds => (
          2 + rng.nextInt(4),
          6 + rng.nextInt(8),
          12 + rng.nextInt(10),
          20 + rng.nextInt(15),
        ),
      QuestType.cashOut => (
          2 + rng.nextInt(3),
          5 + rng.nextInt(7),
          10 + rng.nextInt(10),
          18 + rng.nextInt(12),
        ),
    };

    return Quest(
      id: '${type.index}_${rng.nextInt(99999)}',
      type: type,
      target: target,
      rewardDiamond: d,
      rewardIron: ir,
      rewardCoal: co,
    );
  }
}

class QuestDailyState {
  final List<Quest> quests;
  final int lastResetMs;

  const QuestDailyState({
    required this.quests,
    required this.lastResetMs,
  });

  String toJson() => jsonEncode({
        'lastResetMs': lastResetMs,
        'quests': quests.map((q) => q.toJson()).toList(),
      });

  factory QuestDailyState.fromJson(String raw) {
    final j = jsonDecode(raw) as Map<String, dynamic>;
    return QuestDailyState(
      lastResetMs: j['lastResetMs'] as int,
      quests: (j['quests'] as List)
          .map((q) => Quest.fromJson(q as Map<String, dynamic>))
          .toList(),
    );
  }

  QuestDailyState copyWith({List<Quest>? quests, int? lastResetMs}) =>
      QuestDailyState(
        quests: quests ?? this.quests,
        lastResetMs: lastResetMs ?? this.lastResetMs,
      );
}
