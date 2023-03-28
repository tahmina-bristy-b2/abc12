// ignore_for_file: non_constant_identifier_names

import 'package:hive_flutter/hive_flutter.dart';
part 'hive_data_model.g.dart';

@HiveType(typeId: 0)
class AddItemModel extends HiveObject {
  @HiveField(0)
  int uiqueKey1;
  @HiveField(1)
  int quantity;
  @HiveField(2)
  String item_name;
  @HiveField(3)
  double tp;
  @HiveField(4)
  String item_id;
  @HiveField(5)
  String category_id;
  @HiveField(6)
  double vat;
  @HiveField(7)
  String manufacturer;
  @HiveField(8)
  AddItemModel({
    required this.uiqueKey1,
    required this.quantity,
    required this.item_name,
    required this.tp,
    required this.item_id,
    required this.category_id,
    required this.vat,
    required this.manufacturer,
  });
}

@HiveType(typeId: 1)
class CustomerDataModel extends HiveObject {
  @HiveField(0)
  int uiqueKey;
  @HiveField(1)
  String clientName;
  @HiveField(2)
  String marketName;
  @HiveField(3)
  String areaId;
  @HiveField(4)
  String clientId;
  @HiveField(5)
  String outstanding;
  @HiveField(6)
  String thana;
  @HiveField(7)
  String address;
  @HiveField(8)
  String deliveryDate;
  @HiveField(9)
  String deliveryTime;
  @HiveField(10)
  String paymentMethod;
  @HiveField(11)
  String? offer;

  CustomerDataModel(
      {required this.uiqueKey,
      required this.clientName,
      required this.marketName,
      required this.areaId,
      required this.clientId,
      required this.outstanding,
      required this.thana,
      required this.address,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.paymentMethod,
      this.offer});
}

@HiveType(typeId: 2)
class DcrDataModel extends HiveObject {
  @HiveField(0)
  String docName;
  @HiveField(1)
  String docId;
  @HiveField(2)
  String areaId;
  @HiveField(3)
  String areaName;
  @HiveField(4)
  String address;
  @HiveField(5)
  String visitedWith;
  @HiveField(6)
  String notes;
  @HiveField(7)
  List<DcrGSPDataModel> dcrGspList;

  DcrDataModel(
      {required this.docName,
      required this.docId,
      required this.areaId,
      required this.areaName,
      required this.address,
      required this.visitedWith,
      required this.notes,
      required this.dcrGspList});
}

@HiveType(typeId: 3)
class RxDcrDataModel extends HiveObject {
  @HiveField(0)
  String uid;
  // @HiveField(0)
  // int uiqueKey;
  @HiveField(1)
  String docName;
  @HiveField(2)
  String docId;
  @HiveField(3)
  String areaId;
  @HiveField(4)
  String areaName;
  @HiveField(5)
  String address;
  @HiveField(6)
  String presImage;
  @HiveField(7)
  String rxType;
  @HiveField(8)
  List<MedicineListModel> rxMedicineList;

  RxDcrDataModel({
    required this.uid,
    required this.docName,
    required this.docId,
    required this.areaId,
    required this.areaName,
    required this.address,
    required this.presImage,
    required this.rxType,
    required this.rxMedicineList,
  });
}

@HiveType(typeId: 4)
class DcrGSPDataModel extends HiveObject {
  // @HiveField(0)
  // int uiqueKey;
  @HiveField(0)
  int quantity;
  @HiveField(1)
  String giftName;
  @HiveField(2)
  String giftId;
  @HiveField(3)
  String giftType;

  DcrGSPDataModel({
    // required this.uiqueKey,
    required this.quantity,
    required this.giftName,
    required this.giftId,
    required this.giftType,
  });
}

@HiveType(typeId: 5)
class MedicineListModel extends HiveObject {
  // @HiveField(0)
  // int uiqueKey;
  @HiveField(0)
  String strength;
  @HiveField(1)
  String name;
  @HiveField(2)
  String brand;
  @HiveField(3)
  String company;
  @HiveField(4)
  String formation;
  @HiveField(5)
  String generic;
  @HiveField(6)
  String itemId;
  @HiveField(7)
  int quantity;

  MedicineListModel({
    // required this.uiqueKey,
    required this.strength,
    required this.brand,
    required this.company,
    required this.formation,
    required this.name,
    required this.generic,
    required this.itemId,
    required this.quantity,
  });
}
