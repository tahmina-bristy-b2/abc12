// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddItemModelAdapter extends TypeAdapter<AddItemModel> {
  @override
  final int typeId = 0;

  @override
  AddItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddItemModel(
      uiqueKey1: fields[0] as int,
      quantity: fields[1] as int,
      item_name: fields[2] as String,
      tp: fields[3] as double,
      item_id: fields[4] as String,
      category_id: fields[5] as String,
      vat: fields[6] as double,
      manufacturer: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddItemModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uiqueKey1)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.item_name)
      ..writeByte(3)
      ..write(obj.tp)
      ..writeByte(4)
      ..write(obj.item_id)
      ..writeByte(5)
      ..write(obj.category_id)
      ..writeByte(6)
      ..write(obj.vat)
      ..writeByte(7)
      ..write(obj.manufacturer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CustomerDataModelAdapter extends TypeAdapter<CustomerDataModel> {
  @override
  final int typeId = 1;

  @override
  CustomerDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerDataModel(
      uiqueKey: fields[0] as int,
      clientName: fields[1] as String,
      marketName: fields[2] as String,
      areaId: fields[3] as String,
      clientId: fields[4] as String,
      outstanding: fields[5] as String,
      thana: fields[6] as String,
      address: fields[7] as String,
      deliveryDate: fields[8] as String,
      deliveryTime: fields[9] as String,
      paymentMethod: fields[10] as String,
      offer: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerDataModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.clientName)
      ..writeByte(2)
      ..write(obj.marketName)
      ..writeByte(3)
      ..write(obj.areaId)
      ..writeByte(4)
      ..write(obj.clientId)
      ..writeByte(5)
      ..write(obj.outstanding)
      ..writeByte(6)
      ..write(obj.thana)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.deliveryDate)
      ..writeByte(9)
      ..write(obj.deliveryTime)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.offer);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DcrDataModelAdapter extends TypeAdapter<DcrDataModel> {
  @override
  final int typeId = 2;

  @override
  DcrDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DcrDataModel(
      uiqueKey: fields[0] as int,
      docName: fields[1] as String,
      docId: fields[2] as String,
      areaId: fields[3] as String,
      areaName: fields[4] as String,
      address: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DcrDataModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.docName)
      ..writeByte(2)
      ..write(obj.docId)
      ..writeByte(3)
      ..write(obj.areaId)
      ..writeByte(4)
      ..write(obj.areaName)
      ..writeByte(5)
      ..write(obj.address);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DcrDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RxDcrDataModelAdapter extends TypeAdapter<RxDcrDataModel> {
  @override
  final int typeId = 3;

  @override
  RxDcrDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RxDcrDataModel(
      uiqueKey: fields[0] as int,
      docName: fields[1] as String,
      docId: fields[2] as String,
      areaId: fields[3] as String,
      areaName: fields[4] as String,
      address: fields[5] as String,
      presImage: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RxDcrDataModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.docName)
      ..writeByte(2)
      ..write(obj.docId)
      ..writeByte(3)
      ..write(obj.areaId)
      ..writeByte(4)
      ..write(obj.areaName)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.presImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RxDcrDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DcrGSPDataModelAdapter extends TypeAdapter<DcrGSPDataModel> {
  @override
  final int typeId = 4;

  @override
  DcrGSPDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DcrGSPDataModel(
      uiqueKey: fields[0] as int,
      quantity: fields[1] as int,
      giftName: fields[2] as String,
      giftId: fields[3] as String,
      giftType: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DcrGSPDataModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.quantity)
      ..writeByte(2)
      ..write(obj.giftName)
      ..writeByte(3)
      ..write(obj.giftId)
      ..writeByte(4)
      ..write(obj.giftType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DcrGSPDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MedicineListModelAdapter extends TypeAdapter<MedicineListModel> {
  @override
  final int typeId = 5;

  @override
  MedicineListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MedicineListModel(
      uiqueKey: fields[0] as int,
      strength: fields[1] as String,
      brand: fields[3] as String,
      company: fields[4] as String,
      formation: fields[5] as String,
      name: fields[2] as String,
      generic: fields[6] as String,
      itemId: fields[7] as String,
      quantity: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MedicineListModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.uiqueKey)
      ..writeByte(1)
      ..write(obj.strength)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.brand)
      ..writeByte(4)
      ..write(obj.company)
      ..writeByte(5)
      ..write(obj.formation)
      ..writeByte(6)
      ..write(obj.generic)
      ..writeByte(7)
      ..write(obj.itemId)
      ..writeByte(8)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicineListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
