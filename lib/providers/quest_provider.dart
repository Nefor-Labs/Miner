import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/quest.dart';
import 'player_provider.dart';

const _prefsKey = 'daily_quests_v1';

// 10:00 Moscow (UTC+3) in UTC = 07:00
const _resetHourUtc = 7;

class QuestNotifier extends Notifier<QuestDailyState> {
  final _rng = Random();

  @override
  QuestDailyState build() {
    // Load synchronously from cache, then refresh async
    _loadAsync();
    return QuestDailyState(
      quests: Quest.generateDaily(_rng),
      lastResetMs: _todayResetMs(),
    );
  }

  Future<void> _loadAsync() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw == null) {
      await _reset(prefs);
      return;
    }
    try {
      final loaded = QuestDailyState.fromJson(raw);
      if (_needsReset(loaded.lastResetMs)) {
        await _reset(prefs);
      } else {
        state = loaded;
      }
    } catch (_) {
      await _reset(prefs);
    }
  }

  Future<void> _reset(SharedPreferences prefs) async {
    final fresh = QuestDailyState(
      quests: Quest.generateDaily(_rng),
      lastResetMs: _todayResetMs(),
    );
    state = fresh;
    await prefs.setString(_prefsKey, fresh.toJson());
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, state.toJson());
  }

  // Called after each game ends
  void trackEvent({
    int diamonds = 0,
    int iron = 0,
    int coal = 0,
    bool gameCompleted = false,
    bool survived = false,
    bool cashedOut = false,
  }) {
    var updated = false;
    final newQuests = state.quests.map((q) {
      if (q.rewardClaimed) return q;
      int add = 0;
      switch (q.type) {
        case QuestType.collectDiamonds:
          add = diamonds;
          break;
        case QuestType.collectIron:
          add = iron;
          break;
        case QuestType.collectCoal:
          add = coal;
          break;
        case QuestType.playGames:
          add = gameCompleted ? 1 : 0;
          break;
        case QuestType.surviveRounds:
          add = survived ? 1 : 0;
          break;
        case QuestType.cashOut:
          add = cashedOut ? 1 : 0;
          break;
      }
      if (add <= 0) return q;
      updated = true;
      final newProgress = (q.progress + add).clamp(0, q.target);
      return q.copyWith(progress: newProgress);
    }).toList();

    if (updated) {
      state = state.copyWith(quests: newQuests);
      _save();
    }
  }

  void claimReward(String questId) {
    final quest =
        state.quests.firstWhere((q) => q.id == questId, orElse: () => throw StateError(''));
    if (!quest.completed || quest.rewardClaimed) return;

    ref.read(playerProvider.notifier).addResources(
          diamonds: quest.rewardDiamond,
          iron: quest.rewardIron,
          coal: quest.rewardCoal,
        );

    final newQuests = state.quests
        .map((q) => q.id == questId ? q.copyWith(rewardClaimed: true) : q)
        .toList();
    state = state.copyWith(quests: newQuests);
    _save();
  }

  // Minutes until next reset (10:00 Moscow)
  int minutesUntilReset() {
    final nowUtc = DateTime.now().toUtc();
    var next = DateTime.utc(
        nowUtc.year, nowUtc.month, nowUtc.day, _resetHourUtc, 0, 0);
    if (!nowUtc.isBefore(next)) {
      next = next.add(const Duration(days: 1));
    }
    return next.difference(nowUtc).inMinutes;
  }

  static bool _needsReset(int lastResetMs) {
    final nowUtc = DateTime.now().toUtc();
    final todayReset = DateTime.utc(
        nowUtc.year, nowUtc.month, nowUtc.day, _resetHourUtc, 0, 0);
    final last =
        DateTime.fromMillisecondsSinceEpoch(lastResetMs, isUtc: true);
    return !nowUtc.isBefore(todayReset) && last.isBefore(todayReset);
  }

  static int _todayResetMs() {
    final nowUtc = DateTime.now().toUtc();
    return DateTime.utc(
            nowUtc.year, nowUtc.month, nowUtc.day, _resetHourUtc, 0, 0)
        .millisecondsSinceEpoch;
  }
}

final questProvider =
    NotifierProvider<QuestNotifier, QuestDailyState>(QuestNotifier.new);
