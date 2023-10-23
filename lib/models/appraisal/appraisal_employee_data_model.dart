// To parse this JSON data, do
//
//     final appraisalEmployee = appraisalEmployeeFromJson(jsonString);

import 'dart:convert';

AppraisalEmployee appraisalEmployeeFromJson(String str) =>
    AppraisalEmployee.fromJson(json.decode(str));

// String appraisalEmployeeToJson(AppraisalEmployee data) => json.encode(data.toJson());

class AppraisalEmployee {
  final ResData resData;

  AppraisalEmployee({
    required this.resData,
  });

  factory AppraisalEmployee.fromJson(Map<String, dynamic> json) =>
      AppraisalEmployee(
        resData: ResData.fromJson(json["res_data"]),
      );

  // Map<String, dynamic> toJson() => {
  //     "res_data": resData.toJson(),
  // };
}

class ResData {
  final String status;
  final String supLevelDepthNo;
  final List<FfList> ffList;

  ResData({
    required this.status,
    required this.supLevelDepthNo,
    required this.ffList,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        supLevelDepthNo: json["sup_level_depth_no"],
        ffList:
            List<FfList>.from(json["ff_list"].map((x) => FfList.fromJson(x))),
      );

  // Map<String, dynamic> toJson() => {
  //     "status": status,
  //     "sup_level_depth_no": supLevelDepthNo,
  //     "ff_list": List<dynamic>.from(ffList.map((x) => x.toJson())),
  // };
}

class FfList {
  final String cid;
  final String employeeId;
  final String empName;
  final String areaId;

  FfList({
    required this.cid,
    required this.employeeId,
    required this.empName,
    required this.areaId,
  });

  factory FfList.fromJson(Map<String, dynamic> json) => FfList(
        cid: json["cid"],
        employeeId: json["employee_id"],
        empName: json["emp_name"],
        areaId: json["area_id"],
      );

  // Map<String, dynamic> toJson() => {
  //     "cid": cidValues.reverse[cid],
  //     "employee_id": employeeId,
  //     "emp_name": empName,
  //     "area_id": areaIdValues.reverse[areaId],
  // };
}
