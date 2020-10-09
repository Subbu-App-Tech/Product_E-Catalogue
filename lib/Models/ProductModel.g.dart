// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      favpic: fields[5] as int,
      rank: fields[6] as int,
      imagepathlist: (fields[4] as List)?.cast<dynamic>(),
      brand: fields[8] as String,
      categorylist: (fields[7] as List)?.cast<dynamic>(),
      description: fields[3] as String,
      favourite: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.imagepathlist)
      ..writeByte(5)
      ..write(obj.favpic)
      ..writeByte(6)
      ..write(obj.rank)
      ..writeByte(7)
      ..write(obj.categorylist)
      ..writeByte(8)
      ..write(obj.brand)
      ..writeByte(9)
      ..write(obj.favourite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
