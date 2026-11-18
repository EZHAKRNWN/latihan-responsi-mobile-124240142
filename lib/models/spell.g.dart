// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spell.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SpellAdapter extends TypeAdapter<Spell> {
  @override
  final int typeId = 0;

  @override
  Spell read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Spell(
      index: fields[0] as int,
      spell: fields[1] as String,
      use: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Spell obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.index)
      ..writeByte(1)
      ..write(obj.spell)
      ..writeByte(2)
      ..write(obj.use);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SpellAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
