// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eCME_details_saved_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ECMESavedDataModelAdapter extends TypeAdapter<ECMESavedDataModel> {
  @override
  final int typeId = 95;

  @override
  ECMESavedDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ECMESavedDataModel(
      status: fields[0] as String,
      eCMEBrandList: (fields[1] as List).cast<ECMEBrandList>(),
      eCMETypeList: (fields[2] as List).cast<String>(),
      eCMEdocList: (fields[3] as List).cast<DocListECMEModel>(),
      docCategoryList: (fields[5] as List).cast<String>(),
      payModeList: (fields[4] as List).cast<String>(),
      supAreaId: fields[6] as String,
      departmentList: (fields[7] as List).cast<String>(),
      payToDataList: (fields[8] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ECMESavedDataModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.eCMEBrandList)
      ..writeByte(2)
      ..write(obj.eCMETypeList)
      ..writeByte(3)
      ..write(obj.eCMEdocList)
      ..writeByte(4)
      ..write(obj.payModeList)
      ..writeByte(5)
      ..write(obj.docCategoryList)
      ..writeByte(6)
      ..write(obj.supAreaId)
      ..writeByte(7)
      ..write(obj.departmentList)
      ..writeByte(8)
      ..write(obj.payToDataList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ECMESavedDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ECMEBrandListAdapter extends TypeAdapter<ECMEBrandList> {
  @override
  final int typeId = 96;

  @override
  ECMEBrandList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ECMEBrandList(
      brandId: fields[0] as String,
      brandName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ECMEBrandList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.brandId)
      ..writeByte(1)
      ..write(obj.brandName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ECMEBrandListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
