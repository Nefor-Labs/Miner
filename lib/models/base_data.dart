import 'dart:math';
import 'package:hive/hive.dart';

part 'base_data.g.dart';

@HiveType(typeId: 1)
class BaseData extends HiveObject {
  @HiveField(0)
  int level; // 0 = not purchased

  @HiveField(1)
  int lastCollectMs;

  @HiveField(2)
  int pendingDiamonds;

  @HiveField(3)
  int pendingIron;

  @HiveField(4)
  int pendingCoal;

  BaseData({
    this.level = 0,
    this.lastCollectMs = 0,
    this.pendingDiamonds = 0,
    this.pendingIron = 0,
    this.pendingCoal = 0,
  });

  bool get purchased => level > 0;
  int get workers => level;

  // Max 12 hours accumulation
  static const int maxAccumHours = 12;

  // Cost to reach [nextLevel] from current
  static int diamondCost(int nextLevel) =>
      (500 * pow(2.4, nextLevel - 1)).round();

  static int ironCost(int nextLevel) =>
      nextLevel <= 1 ? 0 : (180 * pow(2.2, nextLevel - 2)).round();

  static int coalCost(int nextLevel) =>
      nextLevel <= 1 ? 0 : (350 * pow(2.2, nextLevel - 2)).round();

  // Production per worker per hour (random ranges)
  static const int diamondPerWorkerMin = 1;
  static const int diamondPerWorkerMax = 4;
  static const int ironPerWorkerMin = 3;
  static const int ironPerWorkerMax = 10;
  static const int coalPerWorkerMin = 6;
  static const int coalPerWorkerMax = 18;

  /// Calculate accumulated resources since [lastCollectMs]
  ({int diamonds, int iron, int coal}) calculatePending(Random rng) {
    if (level == 0) return (diamonds: 0, iron: 0, coal: 0);
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    final elapsedHours =
        ((nowMs - lastCollectMs) / 3600000).clamp(0, maxAccumHours.toDouble());
    if (elapsedHours < 0.01) return (diamonds: 0, iron: 0, coal: 0);

    int d = 0, ir = 0, co = 0;
    for (int w = 0; w < workers; w++) {
      d += (rng.nextInt(diamondPerWorkerMax - diamondPerWorkerMin + 1) +
              diamondPerWorkerMin) *
          elapsedHours ~/ 1;
      ir += (rng.nextInt(ironPerWorkerMax - ironPerWorkerMin + 1) +
              ironPerWorkerMin) *
          elapsedHours ~/ 1;
      co += (rng.nextInt(coalPerWorkerMax - coalPerWorkerMin + 1) +
              coalPerWorkerMin) *
          elapsedHours ~/ 1;
    }
    return (diamonds: d, iron: ir, coal: co);
  }

  String get levelTitle {
    if (level == 0) return 'Не куплена';
    const titles = [
      '', 'Землянка', 'Сарай', 'Мастерская', 'Цех',
      'Завод', 'Комбинат', 'Корпорация', 'Мегакомплекс',
      'Шахтёрская Империя', 'Галактический Рудник',
    ];
    if (level < titles.length) return titles[level];
    return 'База Ур.$level';
  }
}
