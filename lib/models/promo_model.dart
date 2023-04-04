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
    required this.promoPbList,
    required this.promoDiList,
    required this.promoFlatList,
    required this.promoSpList,
  });

  final String status;
  final List<PromoPbList> promoPbList;
  final List<PromoDiList> promoDiList;
  final List<PromoFlatList> promoFlatList;
  final List<PromoSpList> promoSpList;

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        status: json["status"],
        promoPbList: List<PromoPbList>.from(
            json["promoPbList"].map((x) => PromoPbList.fromJson(x))),
        promoDiList: List<PromoDiList>.from(
            json["promoDiList"].map((x) => PromoDiList.fromJson(x))),
        promoFlatList: List<PromoFlatList>.from(
            json["promoFlatList"].map((x) => PromoFlatList.fromJson(x))),
        promoSpList: List<PromoSpList>.from(
            json["promoSpList"].map((x) => PromoSpList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "promoPbList": List<dynamic>.from(promoPbList.map((x) => x.toJson())),
        "promoDiList": List<dynamic>.from(promoDiList.map((x) => x.toJson())),
        "promoFlatList":
            List<dynamic>.from(promoFlatList.map((x) => x.toJson())),
        "promoSpList": List<dynamic>.from(promoSpList.map((x) => x.toJson())),
      };
}

class PromoDiList {
  PromoDiList({
    required this.promoDes,
    required this.approvedDate,
  });

  final String promoDes;
  final DateTime approvedDate;

  factory PromoDiList.fromJson(Map<String, dynamic> json) => PromoDiList(
        promoDes: json["promo_des"],
        approvedDate: DateTime.parse(json["approved_date"]),
      );

  Map<String, dynamic> toJson() => {
        "promo_des": promoDes,
        "approved_date":
            "${approvedDate.year.toString().padLeft(4, '0')}-${approvedDate.month.toString().padLeft(2, '0')}-${approvedDate.day.toString().padLeft(2, '0')}",
      };
}

class PromoFlatList {
  PromoFlatList({
    required this.promoDes,
    required this.minQty,
    required this.flatRate,
  });

  final String promoDes;
  final int minQty;
  final double flatRate;

  factory PromoFlatList.fromJson(Map<String, dynamic> json) => PromoFlatList(
        promoDes: json["promo_des"],
        minQty: json["min_qty"],
        flatRate: json["flat_rate"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "promo_des": promoDes,
        "min_qty": minQty,
        "flat_rate": flatRate,
      };
}

class PromoPbList {
  PromoPbList({
    required this.promoDes,
    required this.minQty,
  });

  final String promoDes;
  final int minQty;

  factory PromoPbList.fromJson(Map<String, dynamic> json) => PromoPbList(
        promoDes: json["promo_des"],
        minQty: json["min_qty"],
      );

  Map<String, dynamic> toJson() => {
        "promo_des": promoDes,
        "min_qty": minQty,
      };
}

class PromoSpList {
  PromoSpList({
    required this.promoDes,
    required this.minQty,
    required this.specialRateTp,
  });

  final String promoDes;
  final int minQty;
  final double specialRateTp;

  factory PromoSpList.fromJson(Map<String, dynamic> json) => PromoSpList(
        promoDes: json["promo_des"],
        minQty: json["min_qty"],
        specialRateTp: json["special_rate_tp"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "promo_des": promoDes,
        "min_qty": minQty,
        "special_rate_tp": specialRateTp,
      };
}
