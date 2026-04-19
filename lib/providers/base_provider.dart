import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/base_data.dart';
import 'player_provider.dart';

const _baseBoxName = 'baseBox';
const _baseKey = 'base';

class BaseNotifier extends Notifier<BaseData> {
  late Box<BaseData> _box;
  final _rng = Random();

  @override
  BaseData build() {
    _box = Hive.box<BaseData>(_baseBoxName);
    return _box.get(_baseKey) ?? BaseData();
  }

  void _save() => _box.put(_baseKey, state);

  BaseData _copy({
    int? level,
    int? lastCollectMs,
    int? pendingDiamonds,
    int? pendingIron,
    int? pendingCoal,
  }) =>
      BaseData(
        level: level ?? state.level,
        lastCollectMs: lastCollectMs ?? state.lastCollectMs,
        pendingDiamonds: pendingDiamonds ?? state.pendingDiamonds,
        pendingIron: pendingIron ?? state.pendingIron,
        pendingCoal: pendingCoal ?? state.pendingCoal,
      );

  bool purchase() {
    if (state.level > 0) return false;
    final spent = ref.read(playerProvider.notifier).spendResources(
          diamonds: BaseData.diamondCost(1),
        );
    if (!spent) return false;
    state = _copy(
      level: 1,
      lastCollectMs: DateTime.now().millisecondsSinceEpoch,
    );
    _save();
    return true;
  }

  bool upgrade() {
    if (state.level == 0) return false;
    final next = state.level + 1;
    final spent = ref.read(playerProvider.notifier).spendResources(
          diamonds: BaseData.diamondCost(next),
          iron: BaseData.ironCost(next),
          coal: BaseData.coalCost(next),
        );
    if (!spent) return false;

    // Collect pending before upgrading
    _collectInternal();

    state = _copy(level: next);
    _save();
    return true;
  }

  /// Recalculate pending without collecting
  void refreshPending() {
    if (state.level == 0) return;
    final r = state.calculatePending(_rng);
    state = _copy(
      pendingDiamonds: r.diamonds,
      pendingIron: r.iron,
      pendingCoal: r.coal,
    );
  }

  void _collectInternal() {
    if (state.level == 0) return;
    final r = state.calculatePending(_rng);
    if (r.diamonds + r.iron + r.coal == 0) return;
    ref.read(playerProvider.notifier).addResources(
          diamonds: r.diamonds,
          iron: r.iron,
          coal: r.coal,
        );
    state = _copy(
      lastCollectMs: DateTime.now().millisecondsSinceEpoch,
      pendingDiamonds: 0,
      pendingIron: 0,
      pendingCoal: 0,
    );
    _save();
  }

  void collect() => _collectInternal();

  /// Hours until storage is full
  double hoursUntilFull() {
    if (state.level == 0) return 0;
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final elapsed = (nowMs - state.lastCollectMs) / 3600000;
    return (BaseData.maxAccumHours - elapsed).clamp(0, BaseData.maxAccumHours.toDouble());
  }
}

final baseProvider =
    NotifierProvider<BaseNotifier, BaseData>(BaseNotifier.new);

String get baseBoxName => _baseBoxName;
