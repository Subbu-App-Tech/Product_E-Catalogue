// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Product.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductAdapter extends TypeAdapter<Product> {
  @override
  final int typeId = 0;

  @override
  Product read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Product(
      id: fields[0] as String,
      name: fields[1] as String,
      favpic: fields[5] as int?,
      rank: fields[6] as int?,
      imagepathlist: (fields[4] as List).cast<String>(),
      brand: fields[8] as String?,
      categories: (fields[7] as List).cast<String>(),
      description: fields[3] as String?,
      favourite: fields[9] as bool,
    )..varieties = (fields[10] as List).cast<VarietyProductM>();
  }

  @override
  void write(BinaryWriter writer, Product obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.categories)
      ..writeByte(8)
      ..write(obj.brand)
      ..writeByte(9)
      ..write(obj.favourite)
      ..writeByte(10)
      ..write(obj.varieties);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
