// To parse this JSON data, do
//
//     final approvedPromoModel = approvedPromoModelFromJson(jsonString);

import 'dart:convert';

ApprovedPromoModel approvedPromoModelFromJson(String str) =>
    ApprovedPromoModel.fromJson(json.decode(str));

String approvedPromoModelToJson(ApprovedPromoModel data) =>
    json.encode(data.toJson());

class ApprovedPromoModel {
  ApprovedPromoModel({
    required this.status,
    required this.apPromoList,
  });

  final String status;
  final List<ApPromoList> apPromoList;

  factory ApprovedPromoModel.fromJson(Map<String, dynamic> json) =>
      ApprovedPromoModel(
        status: json["status"],
        apPromoList: List<ApPromoList>.from(
            json["apPromoList"].map((x) => ApPromoList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "apPromoList": List<dynamic>.from(apPromoList.map((x) => x.toJson())),
      };
}

class ApPromoList {
  ApPromoList({
    required this.productId,
    required this.bonusType,
    required this.fromDate,
    required this.fixedPercentRate,
    required this.toDate,
    required this.productName,
  });

  final String productId;
  final String bonusType;
  final String fromDate;
  final double fixedPercentRate;
  final String toDate;
  final String productName;

  factory ApPromoList.fromJson(Map<String, dynamic> json) => ApPromoList(
        productId: json["product_id"],
        bonusType: json["bonus_type"],
        fromDate: json["from_date"],
        fixedPercentRate: json["fixed_percent_rate"]?.toDouble(),
        toDate: json["to_date"],
        productName: json["product_name"],
      );

  Map<String, dynamic> toJson() => {
        "product_id": productId,
        "bonus_type": bonusType,
        "from_date": fromDate,
        "fixed_percent_rate": fixedPercentRate,
        "to_date": toDate,
        "product_name": productName,
      };
}
