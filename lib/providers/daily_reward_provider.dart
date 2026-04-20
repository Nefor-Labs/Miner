import 'dart:convert';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'player_provider.dart';

const _dailyRewardKey = 'daily_reward_v1';
const _drResetHourUtc = 7; // 10:00 MSK = 07:00 UTC

class DailyRewardState {
  final bool claimed;
  final int lastResetMs;
  final int rewardDiamond;
  final int rewardIron;
  final int rewardCoal;

  const DailyRewardState({
    required this.claimed,
    required this.lastResetMs,
    required this.rewardDiamond,
    required this.rewardIron,
    required this.rewardCoal,
  });

  Map<String, dynamic> toMap() => {
        'claimed': claimed,
        'lastResetMs': lastResetMs,
        'rewardDiamond': rewardDiamond,
        'rewardIron': rewardIron,
        'rewardCoal': rewardCoal,
      };

  factory DailyRewardState.fromMap(Map<String, dynamic> m) => DailyRewardState(
        claimed: m['claimed'] as bool,
        lastResetMs: m['lastResetMs'] as int,
        rewardDiamond: m['rewardDiamond'] as int,
        rewardIron: m['rewardIron'] as int,
        rewardCoal: m['rewardCoal'] as int,
      );

  String toJson() => jsonEncode(toMap());

  factory DailyRewardState.fromJson(String s) =>
      DailyRewardState.fromMap(jsonDecode(s) as Map<String, dynamic>);

  DailyRewardState copyWith({bool? claimed}) => DailyRewardState(
        claimed: claimed ?? this.claimed,
        lastResetMs: lastResetMs,
        rewardDiamond: rewardDiamond,
        rewardIron: rewardIron,
        rewardCoal: rewardCoal,
      );
}

class DailyRewardNotifier extends Notifier<DailyRewardState> {
  final _rng = Random();

  @override
  DailyRewardState build() {
    _loadAsync();
    return _fresh(claimed: false);
  }

  DailyRewardState _fresh({required bool claimed}) => DailyRewardState(
        claimed: claimed,
        lastResetMs: _todayResetMs(),
        rewardDiamond: 3 + _rng.nextInt(8),
        rewardIron: 5 + _rng.nextInt(16),
        rewardCoal: 10 + _rng.nextInt(31),
      );

  Future<void> _loadAsync() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_dailyRewardKey);
    if (raw == null) {
      final s = _fresh(claimed: false);
      state = s;
      await prefs.setString(_dailyRewardKey, s.toJson());
      return;
    }
    try {
      final loaded = DailyRewardState.fromJson(raw);
      if (_needsReset(loaded.lastResetMs)) {
        final s = _fresh(claimed: false);
        state = s;
        await prefs.setString(_dailyRewardKey, s.toJson());
      } else {
        state = loaded;
      }
    } catch (_) {
      final s = _fresh(claimed: false);
      state = s;
      await prefs.setString(_dailyRewardKey, s.toJson());
    }
  }

  Future<void> claimReward() async {
    if (state.claimed) return;
    ref.read(playerProvider.notifier).addResourcesDirect(
          diamonds: state.rewardDiamond,
          iron: state.rewardIron,
          coal: state.rewardCoal,
        );
    state = state.copyWith(claimed: true);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dailyRewardKey, state.toJson());
  }

  int minutesUntilReset() {
    final nowUtc = DateTime.now().toUtc();
    var next = DateTime.utc(
        nowUtc.year, nowUtc.month, nowUtc.day, _drResetHourUtc, 0, 0);
    if (!nowUtc.isBefore(next)) next = next.add(const Duration(days: 1));
    return next.difference(nowUtc).inMinutes;
  }

  static bool _needsReset(int lastResetMs) {
    final nowUtc = DateTime.now().toUtc();
    final todayReset = DateTime.utc(
        nowUtc.year, nowUtc.month, nowUtc.day, _drResetHourUtc, 0, 0);
    final last =
        DateTime.fromMillisecondsSinceEpoch(lastResetMs, isUtc: true);
    return !nowUtc.isBefore(todayReset) && last.isBefore(todayReset);
  }

  static int _todayResetMs() {
    final nowUtc = DateTime.now().toUtc();
    return DateTime.utc(
            nowUtc.year, nowUtc.month, nowUtc.day, _drResetHourUtc, 0, 0)
        .millisecondsSinceEpoch;
  }
}

final dailyRewardProvider =
    NotifierProvider<DailyRewardNotifier, DailyRewardState>(
        DailyRewardNotifier.new);
