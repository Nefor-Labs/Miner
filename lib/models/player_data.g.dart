// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerDataAdapter extends TypeAdapter<PlayerData> {
  @override
  final int typeId = 0;

  @override
  PlayerData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlayerData(
      nickname: fields[0] as String,
      diamonds: fields[1] as int,
      iron: fields[2] as int,
      coal: fields[3] as int,
      gamesPlayed: fields[4] as int,
      bestRoundScore: fields[5] as int,
      totalScore: fields[6] as int,
      pickaxeLevel: fields[7] as int,
      shieldCharges: fields[8] as int,
      bonusMultiplier: fields[9] as int,
      minesDefused: fields[10] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PlayerData obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.nickname)
      ..writeByte(1)
      ..write(obj.diamonds)
      ..writeByte(2)
      ..write(obj.iron)
      ..writeByte(3)
      ..write(obj.coal)
      ..writeByte(4)
      ..write(obj.gamesPlayed)
      ..writeByte(5)
      ..write(obj.bestRoundScore)
      ..writeByte(6)
      ..write(obj.totalScore)
      ..writeByte(7)
      ..write(obj.pickaxeLevel)
      ..writeByte(8)
      ..write(obj.shieldCharges)
      ..writeByte(9)
      ..write(obj.bonusMultiplier)
      ..writeByte(10)
      ..write(obj.minesDefused);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
