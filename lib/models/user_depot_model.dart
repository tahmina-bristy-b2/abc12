// To parse this JSON data, do
//
//     final userDepotModel = userDepotModelFromJson(jsonString);

import 'dart:convert';

UserDepotModel userDepotModelFromJson(String str) =>
    UserDepotModel.fromJson(json.decode(str));

String userDepotModelToJson(UserDepotModel data) => json.encode(data.toJson());

class UserDepotModel {
  UserDepotModel({
    required this.status,
    required this.depotList,
  });

  final String status;
  final List<DepotList> depotList;

  factory UserDepotModel.fromJson(Map<String, dynamic> json) => UserDepotModel(
        status: json["status"],
        depotList: List<DepotList>.from(
            json["depotList"].map((x) => DepotList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "depotList": List<dynamic>.from(depotList.map((x) => x.toJson())),
      };
}

class DepotList {
  DepotList({
    required this.depotName,
    required this.depotId,
  });

  final String depotName;
  final String depotId;

  factory DepotList.fromJson(Map<String, dynamic> json) => DepotList(
        depotName: json["depot_name"],
        depotId: json["depot_id"],
      );

  Map<String, dynamic> toJson() => {
        "depot_name": depotName,
        "depot_id": depotId,
      };
}
