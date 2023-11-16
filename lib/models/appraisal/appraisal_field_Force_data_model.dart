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
  final String submitId;
  final String submitName;
  final String employeeId;
  final String employeeName;
  final String territoryId;
  final String dueCount;
  final String appActionStatus;

  DataList(
      {required this.submitId,
      required this.submitName,
      required this.employeeId,
      required this.employeeName,
      required this.territoryId,
      required this.dueCount,
      required this.appActionStatus});

  factory DataList.fromJson(Map<String, dynamic> json) => DataList(
        submitId: json["submit_id"] ?? '',
        submitName: json["submit_name"] ?? '',
        employeeId: json["employee_id"] ?? '',
        employeeName: json["employee_name"] ?? '',
        territoryId: json["territory_id"] ?? '',
        dueCount: json["due_count"] ?? '',
        appActionStatus: json["app_acction_status"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "submit_id": submitId,
        "submit_name": submitName,
        "employee_id": employeeId,
        "employee_name": employeeName,
        "territory_id": territoryId,
        "due_count": dueCount,
        "app_acction_status": appActionStatus,
      };
}

var fFdata = {
  "res_data": {
    "status": "Success",
    "level_depth_no": "1",
    "data_list": [
      {
        "submit_id": "5092",
        "submit_name": "MR. SADHON KUMAR SAHA",
        "employee_id": "14448",
        "employee_name": "MR. MD. SHOHEL BIN TAFAZZAL",
        "territory_id": "DS11A",
        "due_count": "1"
      },
      {
        "submit_id": "5092",
        "submit_name": "MR. SADHON KUMAR SAHA",
        "employee_id": "16147",
        "employee_name": "MR. MD. HAFIZUR RAHAMAN",
        "territory_id": "DS12A",
        "due_count": "1"
      }
    ]
  }
};
