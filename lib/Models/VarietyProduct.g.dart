// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'VarietyProduct.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VarietyProductMAdapter extends TypeAdapter<VarietyProductM> {
  @override
  final int typeId = 1;

  @override
  VarietyProductM read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VarietyProductM(
      productid: fields[0] as String,
      id: fields[1] as String,
      name: fields[2] as String,
      price: fields[3] as double,
      wsp: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, VarietyProductM obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.productid)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.wsp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VarietyProductMAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
