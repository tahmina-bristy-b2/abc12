import 'package:meta/meta.dart';
import 'dart:convert';

AppraisalDetailsModel appraisalDetailsModelFromJson(String str) =>
    AppraisalDetailsModel.fromJson(json.decode(str));

String appraisalDetailsModelToJson(AppraisalDetailsModel data) =>
    json.encode(data.toJson());

class AppraisalDetailsModel {
  final ResData resData;

  AppraisalDetailsModel({
    required this.resData,
  });

  factory AppraisalDetailsModel.fromJson(Map<String, dynamic> json) =>
      AppraisalDetailsModel(
        resData: ResData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData.toJson(),
      };
}

class ResData {
  final String status;
  final String supLevelDepthNo;
  final List<Map<String, String>> ffDetailsList;

  ResData({
    required this.status,
    required this.supLevelDepthNo,
    required this.ffDetailsList,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        supLevelDepthNo: json["sup_level_depth_no"],
        ffDetailsList: List<Map<String, String>>.from(json["ff_details_list"]
            .map((x) =>
                Map.from(x).map((k, v) => MapEntry<String, String>(k, v)))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "sup_level_depth_no": supLevelDepthNo,
        "ff_details_list": List<dynamic>.from(ffDetailsList.map(
            (x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
      };
}
