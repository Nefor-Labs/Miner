import 'package:hive/hive.dart';

part 'player_data.g.dart';

@HiveType(typeId: 0)
class PlayerData extends HiveObject {
  @HiveField(0)
  String nickname;

  @HiveField(1)
  int diamonds;

  @HiveField(2)
  int iron;

  @HiveField(3)
  int coal;

  @HiveField(4)
  int gamesPlayed;

  @HiveField(5)
  int bestRoundScore;

  @HiveField(6)
  int totalScore;

  @HiveField(7)
  int pickaxeLevel; // 1-5

  @HiveField(8)
  int shieldCharges; // mine protection charges

  @HiveField(9)
  int bonusMultiplier; // reward multiplier level 1-3

  @HiveField(10)
  int minesDefused; // stat: mines survived via shield

  PlayerData({
    this.nickname = '',
    this.diamonds = 0,
    this.iron = 0,
    this.coal = 0,
    this.gamesPlayed = 0,
    this.bestRoundScore = 0,
    this.totalScore = 0,
    this.pickaxeLevel = 1,
    this.shieldCharges = 0,
    this.bonusMultiplier = 1,
    this.minesDefused = 0,
  });
}
