

import 'dart:convert';
import 'package:hive_flutter/adapters.dart';
part 'expired_dated_data_model.g.dart';

ExpiredItemListDataModel expiredItemListDataModelFromJson(String str) => ExpiredItemListDataModel.fromJson(json.decode(str));

String expiredItemListDataModelToJson(ExpiredItemListDataModel data) => json.encode(data.toJson());
@HiveType(typeId:91)
class ExpiredItemListDataModel {
   @HiveField(0)
    String status;
     @HiveField(1)
    List<ExpiredItemList> expiredItemList;

    ExpiredItemListDataModel({
        required this.status,
        required this.expiredItemList,
    });

    factory ExpiredItemListDataModel.fromJson(Map<String, dynamic> json) => ExpiredItemListDataModel(
        status: json["status"],
        expiredItemList: List<ExpiredItemList>.from(json["itemList"].map((x) => ExpiredItemList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "itemList": List<dynamic>.from(expiredItemList.map((x) => x.toJson())),
    };
}

@HiveType(typeId: 92)
class ExpiredItemList {
    @HiveField(0)
    String itemId;
    @HiveField(1)
    String itemName;
    @HiveField(2)
    String categoryId;
    @HiveField(3)
    String manufacturer;
    @HiveField(4)
    double tp;
    @HiveField(5)
    double vat;
    @HiveField(6)
    String promo;
    @HiveField(7)
    dynamic stock;

    ExpiredItemList({
        required this.itemId,
        required this.itemName,
        required this.categoryId,
        required this.manufacturer,
        required this.tp,
        required this.vat,
        required this.promo,
        required this.stock,
    });

    factory ExpiredItemList.fromJson(Map<String, dynamic> json) => ExpiredItemList(
        itemId: json["item_id"]??"",
        itemName: json["item_name"]??"",
        categoryId: json["category_id"]??"",
        manufacturer: json["manufacturer"]??"",
        tp: json["tp"]??0.0,
        vat: json["vat"]??0.0,
        promo: json["promo"]??"",
        stock: json["stock"]??"",
    );

    Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "item_name": itemName,
        "category_id": categoryId,
        "manufacturer": manufacturer,
        "tp": tp,
        "vat": vat,
        "promo": promo,
        "stock": stock,
    };
}
