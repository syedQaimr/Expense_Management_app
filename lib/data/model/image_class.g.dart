// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageclassAdapter extends TypeAdapter<Imageclass> {
  @override
  final int typeId = 2;

  @override
  Imageclass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Imageclass(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Imageclass obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageclassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
