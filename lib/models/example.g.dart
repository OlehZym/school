// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExampleAdapter extends TypeAdapter<Example> {
  @override
  final int typeId = 1;

  @override
  Example read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Example(
      left: fields[0] as int,
      right: fields[1] as int,
      operation: fields[2] as String,
      answer: fields[3] as int,
      checked: fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Example obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.left)
      ..writeByte(1)
      ..write(obj.right)
      ..writeByte(2)
      ..write(obj.operation)
      ..writeByte(3)
      ..write(obj.answer)
      ..writeByte(4)
      ..write(obj.checked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExampleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
