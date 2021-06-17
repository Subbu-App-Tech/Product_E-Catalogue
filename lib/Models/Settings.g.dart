// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppSettingAdapter extends TypeAdapter<AppSetting> {
  @override
  final int typeId = 10;

  @override
  AppSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppSetting(
      apiKey: fields[0] as String?,
      viewMode: fields[1] as bool?,
      password: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppSetting obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.apiKey)
      ..writeByte(1)
      ..write(obj.viewMode)
      ..writeByte(2)
      ..write(obj.password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppSettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
