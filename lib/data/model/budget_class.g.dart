// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BudgetdataAdapter extends TypeAdapter<Budgetdata> {
  @override
  final int typeId = 0;

  @override
  Budgetdata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Budgetdata(
      fields[0] as int,
      fields[1] as int,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Budgetdata obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.budget)
      ..writeByte(1)
      ..write(obj.month)
      ..writeByte(2)
      ..write(obj.year);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BudgetdataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
