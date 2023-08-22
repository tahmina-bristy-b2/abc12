// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'eDSR_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EdsrDataModelAdapter extends TypeAdapter<EdsrDataModel> {
  @override
  final int typeId = 60;

  @override
  EdsrDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EdsrDataModel(
      status: fields[0] as String,
      categoryList: (fields[1] as List).cast<CategoryList>(),
      brandList: (fields[2] as List).cast<BrandList>(),
      payScheduleList: (fields[3] as List).cast<String>(),
      payModeList: (fields[4] as List).cast<String>(),
      purposeList: (fields[5] as List).cast<PurposeList>(),
      subPurposeList: (fields[6] as List).cast<SubPurposeList>(),
      dsrTypeList: (fields[7] as List).cast<String>(),
      regionList: (fields[8] as List).cast<RegionList>(),
      rxDurationMonthList: (fields[9] as List).cast<RxDurationMonthList>(),
      dsrDurationMonthList: (fields[10] as List).cast<DsrDurationMonthList>(),
    );
  }

  @override
  void write(BinaryWriter writer, EdsrDataModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.categoryList)
      ..writeByte(2)
      ..write(obj.brandList)
      ..writeByte(3)
      ..write(obj.payScheduleList)
      ..writeByte(4)
      ..write(obj.payModeList)
      ..writeByte(5)
      ..write(obj.purposeList)
      ..writeByte(6)
      ..write(obj.subPurposeList)
      ..writeByte(7)
      ..write(obj.dsrTypeList)
      ..writeByte(8)
      ..write(obj.regionList)
      ..writeByte(9)
      ..write(obj.rxDurationMonthList)
      ..writeByte(10)
      ..write(obj.dsrDurationMonthList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EdsrDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BrandListAdapter extends TypeAdapter<BrandList> {
  @override
  final int typeId = 61;

  @override
  BrandList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrandList(
      brandId: fields[0] as String,
      brandName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BrandList obj) {
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
      other is BrandListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryListAdapter extends TypeAdapter<CategoryList> {
  @override
  final int typeId = 62;

  @override
  CategoryList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CategoryList(
      catId: fields[0] as String,
      category: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CategoryList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.catId)
      ..writeByte(1)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RegionListAdapter extends TypeAdapter<RegionList> {
  @override
  final int typeId = 63;

  @override
  RegionList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegionList(
      regionId: fields[0] as String,
      regionName: fields[1] as String,
      areaList: (fields[2] as List).cast<AreaList>(),
    );
  }

  @override
  void write(BinaryWriter writer, RegionList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.regionId)
      ..writeByte(1)
      ..write(obj.regionName)
      ..writeByte(2)
      ..write(obj.areaList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AreaListAdapter extends TypeAdapter<AreaList> {
  @override
  final int typeId = 64;

  @override
  AreaList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AreaList(
      areaId: fields[0] as String,
      areaName: fields[1] as String,
      territoryList: (fields[2] as List).cast<TerritoryList>(),
    );
  }

  @override
  void write(BinaryWriter writer, AreaList obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.areaId)
      ..writeByte(1)
      ..write(obj.areaName)
      ..writeByte(2)
      ..write(obj.territoryList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AreaListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TerritoryListAdapter extends TypeAdapter<TerritoryList> {
  @override
  final int typeId = 65;

  @override
  TerritoryList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TerritoryList(
      territoryId: fields[0] as String,
      territoryName: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TerritoryList obj) {
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
      other is TerritoryListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PurposeListAdapter extends TypeAdapter<PurposeList> {
  @override
  final int typeId = 66;

  @override
  PurposeList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PurposeList(
      dsrType: fields[0] as String,
      dsrCategory: fields[1] as String,
      purposeId: fields[2] as String,
      purposeName: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PurposeList obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.dsrType)
      ..writeByte(1)
      ..write(obj.dsrCategory)
      ..writeByte(2)
      ..write(obj.purposeId)
      ..writeByte(3)
      ..write(obj.purposeName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PurposeListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SubPurposeListAdapter extends TypeAdapter<SubPurposeList> {
  @override
  final int typeId = 67;

  @override
  SubPurposeList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SubPurposeList(
      sDsrType: fields[0] as String,
      sDsrCategory: fields[1] as String,
      sPurposeId: fields[2] as String,
      sPurposeName: fields[3] as String,
      sPurposeSubId: fields[4] as String,
      sPurposeSubName: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SubPurposeList obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.sDsrType)
      ..writeByte(1)
      ..write(obj.sDsrCategory)
      ..writeByte(2)
      ..write(obj.sPurposeId)
      ..writeByte(3)
      ..write(obj.sPurposeName)
      ..writeByte(4)
      ..write(obj.sPurposeSubId)
      ..writeByte(5)
      ..write(obj.sPurposeSubName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubPurposeListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RxDurationMonthListAdapter extends TypeAdapter<RxDurationMonthList> {
  @override
  final int typeId = 68;

  @override
  RxDurationMonthList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RxDurationMonthList(
      nextDate: fields[0] as String,
      nextDateV: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RxDurationMonthList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nextDate)
      ..writeByte(1)
      ..write(obj.nextDateV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RxDurationMonthListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DsrDurationMonthListAdapter extends TypeAdapter<DsrDurationMonthList> {
  @override
  final int typeId = 69;

  @override
  DsrDurationMonthList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DsrDurationMonthList(
      nextDate: fields[0] as String,
      nextDateV: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DsrDurationMonthList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.nextDate)
      ..writeByte(1)
      ..write(obj.nextDateV);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DsrDurationMonthListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
