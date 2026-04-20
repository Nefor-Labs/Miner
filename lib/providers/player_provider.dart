import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/player_data.dart';

const _boxName = 'playerBox';
const _key = 'player';

class PlayerNotifier extends Notifier<PlayerData> {
  late Box<PlayerData> _box;

  @override
  PlayerData build() {
    _box = Hive.box<PlayerData>(_boxName);
    return _box.get(_key) ?? PlayerData();
  }

  void _save() {
    _box.put(_key, state);
  }

  void setNickname(String name) {
    state = PlayerData(
      nickname: name,
      diamonds: state.diamonds,
      iron: state.iron,
      coal: state.coal,
      gamesPlayed: state.gamesPlayed,
      bestRoundScore: state.bestRoundScore,
      totalScore: state.totalScore,
      pickaxeLevel: state.pickaxeLevel,
      shieldCharges: state.shieldCharges,
      bonusMultiplier: state.bonusMultiplier,
      minesDefused: state.minesDefused,
    );
    _save();
  }

  void addResources({int diamonds = 0, int iron = 0, int coal = 0}) {
    final mult = state.bonusMultiplier;
    state = _copyWith(
      diamonds: state.diamonds + diamonds * mult,
      iron: state.iron + iron * mult,
      coal: state.coal + coal * mult,
    );
    _save();
  }

  void recordGame({required int roundScore}) {
    state = _copyWith(
      gamesPlayed: state.gamesPlayed + 1,
      bestRoundScore: roundScore > state.bestRoundScore
          ? roundScore
          : state.bestRoundScore,
      totalScore: state.totalScore + roundScore,
    );
    _save();
  }

  bool spendResources({int diamonds = 0, int iron = 0, int coal = 0}) {
    if (state.diamonds < diamonds ||
        state.iron < iron ||
        state.coal < coal) {
      return false;
    }
    state = _copyWith(
      diamonds: state.diamonds - diamonds,
      iron: state.iron - iron,
      coal: state.coal - coal,
    );
    _save();
    return true;
  }

  void upgradePickaxe(int newLevel) {
    state = _copyWith(pickaxeLevel: newLevel);
    _save();
  }

  void addShieldCharge() {
    state = _copyWith(shieldCharges: state.shieldCharges + 1);
    _save();
  }

  bool useShieldCharge() {
    if (state.shieldCharges <= 0) return false;
    state = _copyWith(
      shieldCharges: state.shieldCharges - 1,
      minesDefused: state.minesDefused + 1,
    );
    _save();
    return true;
  }

  void upgradeMultiplier(int newLevel) {
    state = _copyWith(bonusMultiplier: newLevel);
    _save();
  }

  void addResourcesDirect({int diamonds = 0, int iron = 0, int coal = 0}) {
    state = _copyWith(
      diamonds: state.diamonds + diamonds,
      iron: state.iron + iron,
      coal: state.coal + coal,
    );
    _save();
  }

  bool exchangeResources({
    int spendDiamond = 0,
    int spendIron = 0,
    int spendCoal = 0,
    int gainDiamond = 0,
    int gainIron = 0,
    int gainCoal = 0,
  }) {
    if (state.diamonds < spendDiamond ||
        state.iron < spendIron ||
        state.coal < spendCoal) {
      return false;
    }
    state = _copyWith(
      diamonds: state.diamonds - spendDiamond + gainDiamond,
      iron: state.iron - spendIron + gainIron,
      coal: state.coal - spendCoal + gainCoal,
    );
    _save();
    return true;
  }

  PlayerData _copyWith({
    String? nickname,
    int? diamonds,
    int? iron,
    int? coal,
    int? gamesPlayed,
    int? bestRoundScore,
    int? totalScore,
    int? pickaxeLevel,
    int? shieldCharges,
    int? bonusMultiplier,
    int? minesDefused,
  }) {
    return PlayerData(
      nickname: nickname ?? state.nickname,
      diamonds: diamonds ?? state.diamonds,
      iron: iron ?? state.iron,
      coal: coal ?? state.coal,
      gamesPlayed: gamesPlayed ?? state.gamesPlayed,
      bestRoundScore: bestRoundScore ?? state.bestRoundScore,
      totalScore: totalScore ?? state.totalScore,
      pickaxeLevel: pickaxeLevel ?? state.pickaxeLevel,
      shieldCharges: shieldCharges ?? state.shieldCharges,
      bonusMultiplier: bonusMultiplier ?? state.bonusMultiplier,
      minesDefused: minesDefused ?? state.minesDefused,
    );
  }
}

final playerProvider = NotifierProvider<PlayerNotifier, PlayerData>(
  PlayerNotifier.new,
);

String get playerBoxName => _boxName;
