// To parse this JSON data, do
//
//     final stockModel = stockModelFromJson(jsonString);

import 'dart:convert';

StockModel stockModelFromJson(String str) =>
    StockModel.fromJson(json.decode(str));

String stockModelToJson(StockModel data) => json.encode(data.toJson());

class StockModel {
  StockModel({
    required this.status,
    required this.depotName,
    required this.depotId,
    required this.stockList,
  });

  final String status;
  final String depotName;
  final String depotId;
  final List<StockList> stockList;

  factory StockModel.fromJson(Map<String, dynamic> json) => StockModel(
        status: json["status"] ?? false,
        depotName: json["depot_name"] ?? '',
        depotId: json["depot_id"] ?? '',
        stockList: List<StockList>.from(
            json["stockList"].map((x) => StockList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "depot_name": depotName,
        "depot_id": depotId,
        "stockList": List<dynamic>.from(stockList.map((x) => x.toJson())),
      };
}

class StockList {
  StockList({
    required this.itemId,
    required this.itemDes,
    required this.stockQty,
  });

  final String itemId;
  final String itemDes;
  final String stockQty;

  factory StockList.fromJson(Map<String, dynamic> json) => StockList(
        itemId: json["item_id"],
        itemDes: json["item_des"],
        stockQty: json["stock_qty"],
      );

  Map<String, dynamic> toJson() => {
        "item_id": itemId,
        "item_des": itemDes,
        "stock_qty": stockQty,
      };
}
