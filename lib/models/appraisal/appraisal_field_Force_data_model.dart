// To parse this JSON data, do
//
//     final appraisalFfDataModel = appraisalFfDataModelFromJson(jsonString);

import 'dart:convert';

AppraisalFfDataModel appraisalFfDataModelFromJson(String str) =>
    AppraisalFfDataModel.fromJson(json.decode(str));

String appraisalFfDataModelToJson(AppraisalFfDataModel data) =>
    json.encode(data.toJson());

class AppraisalFfDataModel {
  final ResData resData;

  AppraisalFfDataModel({
    required this.resData,
  });

  factory AppraisalFfDataModel.fromJson(Map<String, dynamic> json) =>
      AppraisalFfDataModel(
        resData: ResData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

class ResData {
  final String status;
  final String levelDepthNo;
  final List<DataList> dataList;

  ResData({
    required this.status,
    required this.levelDepthNo,
    required this.dataList,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        levelDepthNo: json["level_depth_no"],
        dataList: List<DataList>.from(
            json["data_list"].map((x) => DataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "level_depth_no": levelDepthNo,
        "data_list": List<dynamic>.from(dataList.map((x) => x.toJson())),
      };
}

class DataList {
  final String submitBy;
  final String territoryId;
  final String dueCount;
  final String employeeId;

  DataList(
      {required this.submitBy,
      required this.territoryId,
      required this.dueCount,
      required this.employeeId});

  factory DataList.fromJson(Map<String, dynamic> json) => DataList(
      submitBy: json["submit_by"],
      territoryId: json["territory_id"],
      dueCount: json["due_count"],
      employeeId: json["employee_id"]);

  Map<String, dynamic> toJson() => {
        "submit_by": submitBy,
        "territory_id": territoryId,
        "due_count": dueCount,
        "employee_id": employeeId
      };
}

var fFdata = {
  "res_data": {
    "status": "Success",
    "level_depth_no": "1",
    "data_list": [
      {"submit_by": "ITFM", "territory_id": "DEMO", "due_count": "1"},
      {"submit_by": "ITFM2", "territory_id": "DEMO", "due_count": "3"},
      {"submit_by": "EFM", "territory_id": "DEMO", "due_count": "3"},
      {"submit_by": "ITFM2", "territory_id": "DEMO", "due_count": "3"},
      {"submit_by": "Rahim", "territory_id": "DNS", "due_count": "3"},
      {"submit_by": "ITFM2", "territory_id": "DEMO", "due_count": "3"},
      {"submit_by": "ITFM2", "territory_id": "Mirpur", "due_count": "3"}
    ]
  }
};
