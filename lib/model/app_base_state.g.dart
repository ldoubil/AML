// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_base_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AppBaseStateAdapter extends TypeAdapter<AppBaseState> {
  @override
  final int typeId = 0;

  @override
  AppBaseState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppBaseState(
      appDataDirectory: fields[0] as String?,
      java8Directory: fields[1] as String?,
      java17Directory: fields[2] as String?,
      java21Directory: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AppBaseState obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.appDataDirectory)
      ..writeByte(1)
      ..write(obj.java8Directory)
      ..writeByte(2)
      ..write(obj.java17Directory)
      ..writeByte(3)
      ..write(obj.java21Directory);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppBaseStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
