// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_cme_category_List_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorCategoryRestDataAdapter
    extends TypeAdapter<DoctorCategoryRestData> {
  @override
  final int typeId = 99;

  @override
  DoctorCategoryRestData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DoctorCategoryRestData(
      status: fields[0] as String,
      docSpecialtyList: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DoctorCategoryRestData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.docSpecialtyList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorCategoryRestDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
