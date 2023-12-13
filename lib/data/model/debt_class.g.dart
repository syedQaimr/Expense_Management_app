// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtclassAdapter extends TypeAdapter<Debtclass> {
  @override
  final int typeId = 3;

  @override
  Debtclass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Debtclass(
      fields[0] as String,
      fields[1] as int,
      fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Debtclass obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.debtto)
      ..writeByte(1)
      ..write(obj.amount)
      ..writeByte(2)
      ..write(obj.dt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtclassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
