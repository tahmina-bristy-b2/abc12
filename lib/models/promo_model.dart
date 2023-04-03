// To parse this JSON data, do
//
//     final promoModel = promoModelFromJson(jsonString);

import 'dart:convert';

PromoModel promoModelFromJson(String str) =>
    PromoModel.fromJson(json.decode(str));

String promoModelToJson(PromoModel data) => json.encode(data.toJson());

class PromoModel {
  PromoModel({
    required this.status,
    required this.promoList,
  });

  final String status;
  final List<PromoList> promoList;

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        status: json["status"],
        promoList: List<PromoList>.from(
            json["promoList"].map((x) => PromoList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "promoList": List<dynamic>.from(promoList.map((x) => x.toJson())),
      };
}

class PromoList {
  PromoList({
    required this.promoDes,
    required this.minQty,
  });

  final String promoDes;
  final int minQty;

  factory PromoList.fromJson(Map<String, dynamic> json) => PromoList(
        promoDes: json["promo_des"] ?? '',
        minQty: json["min_qty"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "promo_des": promoDes,
        "min_qty": minQty,
      };
}
