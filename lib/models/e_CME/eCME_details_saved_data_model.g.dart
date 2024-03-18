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
      eCMERegionList: (fields[3] as List).cast<ECMERegionList>(),
    );
  }

  @override
  void write(BinaryWriter writer, ECMESavedDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.eCMEBrandList)
      ..writeByte(2)
      ..write(obj.eCMETypeList)
      ..writeByte(3)
      ..write(obj.eCMERegionList);
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

class ECMERegionListAdapter extends TypeAdapter<ECMERegionList> {
  @override
  final int typeId = 97;

  @override
  ECMERegionList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ECMERegionList(
      regionId: fields[0] as String,
      regionName: fields[1] as String,
      eCMEAreaList: (fields[2] as List).cast<ECMEAreaList>(),
    );
  }

  @override
  void write(BinaryWriter writer, ECMERegionList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.regionId)
      ..writeByte(1)
      ..write(obj.regionName)
      ..writeByte(2)
      ..write(obj.eCMEAreaList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ECMERegionListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ECMEAreaListAdapter extends TypeAdapter<ECMEAreaList> {
  @override
  final int typeId = 98;

  @override
  ECMEAreaList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ECMEAreaList(
      areaId: fields[0] as String,
      areaName: fields[1] as String,
      eCMEterritoryList: (fields[2] as List).cast<ECMETerritoryList>(),
    );
  }

  @override
  void write(BinaryWriter writer, ECMEAreaList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.areaId)
      ..writeByte(1)
      ..write(obj.areaName)
      ..writeByte(2)
      ..write(obj.eCMEterritoryList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ECMEAreaListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ECMETerritoryListAdapter extends TypeAdapter<ECMETerritoryList> {
  @override
  final int typeId = 99;

  @override
  ECMETerritoryList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ECMETerritoryList(
      territoryId: fields[0] as String,
      territoryName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ECMETerritoryList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.territoryId)
      ..writeByte(1)
      ..write(obj.territoryName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ECMETerritoryListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
