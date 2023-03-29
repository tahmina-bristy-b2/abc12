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
      quantity: fields[0] as int,
      item_name: fields[1] as String,
      tp: fields[2] as double,
      item_id: fields[3] as String,
      category_id: fields[4] as String,
      vat: fields[5] as double,
      manufacturer: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AddItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.item_name)
      ..writeByte(2)
      ..write(obj.tp)
      ..writeByte(3)
      ..write(obj.item_id)
      ..writeByte(4)
      ..write(obj.category_id)
      ..writeByte(5)
      ..write(obj.vat)
      ..writeByte(6)
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
      clientName: fields[0] as String,
      marketName: fields[1] as String,
      areaId: fields[2] as String,
      clientId: fields[3] as String,
      outstanding: fields[4] as String,
      thana: fields[5] as String,
      address: fields[6] as String,
      deliveryDate: fields[7] as String,
      deliveryTime: fields[8] as String,
      paymentMethod: fields[9] as String,
      offer: fields[10] as String?,
      itemList: (fields[11] as List).cast<AddItemModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, CustomerDataModel obj) {
    writer
      ..writeByte(12)
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
      ..write(obj.deliveryDate)
      ..writeByte(8)
      ..write(obj.deliveryTime)
      ..writeByte(9)
      ..write(obj.paymentMethod)
      ..writeByte(10)
      ..write(obj.offer)
      ..writeByte(11)
      ..write(obj.itemList);
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
      docName: fields[0] as String,
      docId: fields[1] as String,
      areaId: fields[2] as String,
      areaName: fields[3] as String,
      address: fields[4] as String,
      visitedWith: fields[5] as String,
      notes: fields[6] as String,
      dcrGspList: (fields[7] as List).cast<DcrGSPDataModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, DcrDataModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.docName)
      ..writeByte(1)
      ..write(obj.docId)
      ..writeByte(2)
      ..write(obj.areaId)
      ..writeByte(3)
      ..write(obj.areaName)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.visitedWith)
      ..writeByte(6)
      ..write(obj.notes)
      ..writeByte(7)
      ..write(obj.dcrGspList);
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
      quantity: fields[0] as int,
      giftName: fields[1] as String,
      giftId: fields[2] as String,
      giftType: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DcrGSPDataModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.quantity)
      ..writeByte(1)
      ..write(obj.giftName)
      ..writeByte(2)
      ..write(obj.giftId)
      ..writeByte(3)
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
