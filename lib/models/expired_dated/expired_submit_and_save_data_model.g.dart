// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expired_submit_and_save_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpiredSubmitDataModelAdapter
    extends TypeAdapter<ExpiredSubmitDataModel> {
  @override
  final int typeId = 81;

  @override
  ExpiredSubmitDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpiredSubmitDataModel(
      clientName: fields[0] as String,
      marketName: fields[1] as String,
      areaId: fields[2] as String,
      clientId: fields[3] as String,
      outstanding: fields[4] as String,
      thana: fields[5] as String,
      address: fields[6] as String,
      expiredItemSubmitModel:
          (fields[7] as List).cast<ExpiredItemSubmitModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpiredSubmitDataModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.clientName)
      ..writeByte(1)
      ..write(obj.marketName)
      ..writeByte(2)
      ..write(obj.areaId)
      ..writeByte(3)
      ..write(obj.clientId)
      ..writeByte(4)
      ..write(obj.outstanding)
      ..writeByte(5)
      ..write(obj.thana)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.expiredItemSubmitModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpiredSubmitDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ExpiredItemSubmitModelAdapter
    extends TypeAdapter<ExpiredItemSubmitModel> {
  @override
  final int typeId = 82;

  @override
  ExpiredItemSubmitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpiredItemSubmitModel(
      itemName: fields[0] as int,
      quantity: fields[1] as String,
      tp: fields[2] as double,
      itemId: fields[3] as String,
      categoryId: fields[4] as String,
      vat: fields[5] as double,
      manufacturer: fields[6] as String,
      itemString: fields[7] as String,
      batchWiseItem: (fields[8] as List).cast<BatchWiseItemListModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, ExpiredItemSubmitModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.tp)
      ..writeByte(3)
      ..write(obj.itemId)
      ..writeByte(4)
      ..write(obj.categoryId)
      ..writeByte(5)
      ..write(obj.vat)
      ..writeByte(6)
      ..write(obj.manufacturer)
      ..writeByte(7)
      ..write(obj.itemString)
      ..writeByte(8)
      ..write(obj.batchWiseItem);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpiredItemSubmitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class BatchWiseItemListModelAdapter
    extends TypeAdapter<BatchWiseItemListModel> {
  @override
  final int typeId = 83;

  @override
  BatchWiseItemListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BatchWiseItemListModel(
      batchId: fields[0] as String,
      unitQty: fields[1] as String,
      expiredDate: fields[2] as String,
      eachbatchWiseItemString: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BatchWiseItemListModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.batchId)
      ..writeByte(1)
      ..write(obj.unitQty)
      ..writeByte(2)
      ..write(obj.expiredDate)
      ..writeByte(3)
      ..write(obj.eachbatchWiseItemString);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BatchWiseItemListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
