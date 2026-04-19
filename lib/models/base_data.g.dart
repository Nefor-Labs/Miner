// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BaseDataAdapter extends TypeAdapter<BaseData> {
  @override
  final int typeId = 1;

  @override
  BaseData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BaseData(
      level: fields[0] as int,
      lastCollectMs: fields[1] as int,
      pendingDiamonds: fields[2] as int,
      pendingIron: fields[3] as int,
      pendingCoal: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, BaseData obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.lastCollectMs)
      ..writeByte(2)
      ..write(obj.pendingDiamonds)
      ..writeByte(3)
      ..write(obj.pendingIron)
      ..writeByte(4)
      ..write(obj.pendingCoal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
