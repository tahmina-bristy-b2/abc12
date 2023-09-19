// To parse this JSON data, do
//
//     final edsrFmlIstModel = edsrFmlIstModelFromJson(jsonString);

import 'dart:convert';

EdsrFmListModel edsrFmListModelFromJson(String str) =>
    EdsrFmListModel.fromJson(json.decode(str));

String edsrFmlIstModelToJson(EdsrFmListModel data) =>
    json.encode(data.toJson());

class EdsrFmListModel {
  final ResData resData;

  EdsrFmListModel({
    required this.resData,
  });

  factory EdsrFmListModel.fromJson(Map<String, dynamic> json) =>
      EdsrFmListModel(
        resData: ResData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

class ResData {
  final String status;
  final List<DataList>? dataList;
  final String budget;
  final String expense;
  final String levelDepth;

  ResData(
      {required this.status,
      required this.dataList,
      required this.budget,
      required this.expense,
      required this.levelDepth});

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        dataList: List<DataList>.from(
            json["data_list"].map((x) => DataList.fromJson(x))),
        budget: json["budget"],
        expense: json["expense"],
        levelDepth: json["level_depth_no"] ?? '1',
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data_list": dataList == null
            ? []
            : List<dynamic>.from(dataList!.map((x) => x.toJson())),
        "budget": budget,
        "expense": expense,
        "level_depth_no": levelDepth
      };
}

class DataList {
  final String submitBy;
  final String territoryId;
  final String dueCount;
  final String countDoctor;
  final String countDcc;
  final String amount;

  DataList({
    required this.submitBy,
    required this.territoryId,
    required this.dueCount,
    required this.countDoctor,
    required this.countDcc,
    required this.amount,
  });

  factory DataList.fromJson(Map<String, dynamic> json) => DataList(
        submitBy: json["submit_by"],
        territoryId: json["territory_id"],
        dueCount: json["due_count"],
        countDoctor: json["count_doctor"],
        countDcc: json["count_dcc"] ?? '',
        amount: double.parse(json["amount"]).toStringAsFixed(0),
      );

  Map<String, dynamic> toJson() => {
        "submit_by": submitBy,
        "territory_id": territoryId,
        "due_count": dueCount,
        "count_doctor": countDoctor,
        "count_dcc": countDcc,
        "amount": amount,
      };
}
