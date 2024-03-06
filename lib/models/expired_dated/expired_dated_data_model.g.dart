// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expired_dated_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpiredItemListDataModelAdapter
    extends TypeAdapter<ExpiredItemListDataModel> {
  @override
  final int typeId = 70;

  @override
  ExpiredItemListDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpiredItemListDataModel(
      status: fields[0] as String,
      expiredItemList: (fields[1] as List).cast<ExpiredItemList>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpiredItemListDataModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.status)
      ..writeByte(1)
      ..write(obj.expiredItemList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpiredItemListDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpiredItemListAdapter extends TypeAdapter<ExpiredItemList> {
  @override
  final int typeId = 71;

  @override
  ExpiredItemList read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpiredItemList(
      itemId: fields[0] as String,
      itemName: fields[1] as String,
      categoryId: fields[2] as String,
      manufacturer: fields[3] as String,
      tp: fields[4] as String,
      vat: fields[5] as String,
      promo: fields[6] as String,
      stock: fields[7] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, ExpiredItemList obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.categoryId)
      ..writeByte(3)
      ..write(obj.manufacturer)
      ..writeByte(4)
      ..write(obj.tp)
      ..writeByte(5)
      ..write(obj.vat)
      ..writeByte(6)
      ..write(obj.promo)
      ..writeByte(7)
      ..write(obj.stock);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpiredItemListAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
