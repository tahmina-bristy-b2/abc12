// To parse this JSON data, do
//
//     final appraisalDetailsModel = appraisalDetailsModelFromJson(jsonString);

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

AppraisalDetailsModel appraisalDetailsModelFromJson(String str) =>
    AppraisalDetailsModel.fromJson(json.decode(str));

String appraisalDetailsModelToJson(AppraisalDetailsModel data) =>
    json.encode(data.toJson());

class AppraisalDetailsModel {
  ResData resData;

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
  String status;
  String supLevelDepthNo;
  List<RetStr> retStr;

  ResData({
    required this.status,
    required this.supLevelDepthNo,
    required this.retStr,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        supLevelDepthNo: json["sup_level_depth_no"],
        retStr:
            List<RetStr>.from(json["ret_str"].map((x) => RetStr.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "sup_level_depth_no": supLevelDepthNo,
        "ret_str": List<dynamic>.from(retStr.map((x) => x.toJson())),
      };
}

class RetStr {
  String kpiKey;
  String doctorCoverage;
  String salesAchievement;
  String previousAchievement;
  String currentAchievement;
  String cid;
  String employeeId;
  String empName;
  String designation;
  String presentGrade;
  String businessSegment;
  String dateOfJoining;
  String lastPromotion;
  String lengthOfService;
  String trCode;
  String baseTerritory;
  String lengthOfPresentTrService;
  String targetValue2;
  String soldValue2;
  String achievement2;
  String avgSales2;
  String avgSalesSeenRx;
  String avgSales4P2;
  String avgSalesEmr2;
  String noMonthAchiev2;
  String chemistCov2;
  String avRx4PBasePoint;
  String avRxEmrBasePoint;
  String achChemistCovBasePoint;
  String examPerformanceBasePoint;
  String noAchMonthBasePoint;
  String noLetterIssued;
  String cause;
  String action;
  String noIncidence;
  String avgRxGrowth;
  List<KpiTable> kpiTable;

  RetStr({
    required this.kpiKey,
    required this.doctorCoverage,
    required this.salesAchievement,
    required this.previousAchievement,
    required this.currentAchievement,
    required this.cid,
    required this.employeeId,
    required this.empName,
    required this.designation,
    required this.presentGrade,
    required this.businessSegment,
    required this.dateOfJoining,
    required this.lastPromotion,
    required this.lengthOfService,
    required this.trCode,
    required this.baseTerritory,
    required this.lengthOfPresentTrService,
    required this.targetValue2,
    required this.soldValue2,
    required this.achievement2,
    required this.avgSalesSeenRx,
    required this.avgSales2,
    required this.avgSales4P2,
    required this.avgSalesEmr2,
    required this.noMonthAchiev2,
    required this.chemistCov2,
    required this.avRx4PBasePoint,
    required this.avRxEmrBasePoint,
    required this.achChemistCovBasePoint,
    required this.examPerformanceBasePoint,
    required this.noAchMonthBasePoint,
    required this.noLetterIssued,
    required this.cause,
    required this.action,
    required this.noIncidence,
    required this.avgRxGrowth,
    required this.kpiTable,
  });

  factory RetStr.fromJson(Map<String, dynamic> json) => RetStr(
        kpiKey: json["kpi_key"] ?? "",
        doctorCoverage: json["doctor_coverage"] ?? "0.0",
        salesAchievement: json["sales_achievement"] ?? "0.0",
        previousAchievement: json["previous_achievement"] ?? "0.0",
        currentAchievement: json["current_achievement"] ?? "0.0",
        cid: json["cid"] ?? "",
        employeeId: json["employee_id"] ?? "",
        empName: json["emp_name"] ?? "",
        designation: json["designation"] ?? "",
        presentGrade: json["present_grade"] ?? "",
        businessSegment: json["business_segment"] ?? "",
        dateOfJoining: json["date_of_joining"] ?? "",
        lastPromotion: json["last_promotion"] ?? "",
        lengthOfService: json["length_of_service"] ?? "",
        trCode: json["tr_code"] ?? "",
        baseTerritory: json["base_territory"] ?? "",
        lengthOfPresentTrService: json["length_of_present_tr_service"] ?? "",
        targetValue2: json["target_value_2"] ?? "0.0",
        soldValue2: json["sold_value_2"] ?? "0.0",
        achievement2: json["achievement_2"] ?? "0.0",
        avgSales2: json["avg_sales_2"] ?? "0.0",
        avgSalesSeenRx: json["avg_sales_seen_rx"] ?? "0.0",
        avgSales4P2: json["avg_sales_4p_2"] ?? "0.0",
        avgSalesEmr2: json["avg_sales_emr_2"] ?? "0.0",
        noMonthAchiev2: json["no_month_achiev_2"] ?? "0.0",
        chemistCov2: json["chemist_cov_2"] ?? "0.0",
        avRx4PBasePoint: json["av_rx_4p_base_point"] ?? "0.0",
        avRxEmrBasePoint: json["av_rx_emr_base_point"] ?? "0.0",
        achChemistCovBasePoint: json["ach_chemist_cov_base_point"] ?? "0.0",
        examPerformanceBasePoint: json["exam_performance_base_point"] ?? "0.0",
        noAchMonthBasePoint: json["no_ach_month_base_point"] ?? "0",
        noLetterIssued: json["no_letter_issued"] ?? "",
        cause: json["cause"] ?? "",
        action: json["action"] ?? "",
        noIncidence: json["no_incidence"] ?? "",
        avgRxGrowth: json["avg_rx_growth"] ?? "0.0",
        kpiTable: List<KpiTable>.from(
            json["kpi_table"].map((x) => KpiTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "kpi_key": kpiKey,
        "doctor_coverage": doctorCoverage,
        "sales_achievement": salesAchievement,
        "previous_achievement": previousAchievement,
        "current_achievement": currentAchievement,
        "cid": cid,
        "employee_id": employeeId,
        "emp_name": empName,
        "designation": designation,
        "present_grade": presentGrade,
        "business_segment": businessSegment,
        "date_of_joining": dateOfJoining,
        "last_promotion": lastPromotion,
        "length_of_service": lengthOfService,
        "tr_code": trCode,
        "base_territory": baseTerritory,
        "length_of_present_tr_service": lengthOfPresentTrService,
        "target_value_2": targetValue2,
        "sold_value_2": soldValue2,
        "achievement_2": achievement2,
        "avg_sales_2": avgSales2,
        "avg_sales_seen_rx": avgSalesSeenRx,
        "avg_sales_4p_2": avgSales4P2,
        "avg_sales_emr_2": avgSalesEmr2,
        "no_month_achiev_2": noMonthAchiev2,
        "chemist_cov_2": chemistCov2,
        "av_rx_4p_base_point": avRx4PBasePoint,
        "av_rx_emr_base_point": avRxEmrBasePoint,
        "ach_chemist_cov_base_point": achChemistCovBasePoint,
        "exam_performance_base_point": examPerformanceBasePoint,
        "no_ach_month_base_point": noAchMonthBasePoint,
        "no_letter_issued": noLetterIssued,
        "cause": cause,
        "action": action,
        "no_incidence": noIncidence,
        "avg_rx_growth": avgRxGrowth,
        "kpi_table": List<dynamic>.from(kpiTable.map((x) => x.toJson())),
      };
}

class KpiTable {
  String sl;
  String kpiId;
  String name;
  String definition;
  String weitage;
  String kpiEdit;
  String selfScore;
  KpiTable({
    required this.sl,
    required this.kpiId,
    required this.name,
    required this.definition,
    required this.weitage,
    required this.kpiEdit,
    required this.selfScore,
  });

  factory KpiTable.fromJson(Map<String, dynamic> json) => KpiTable(
        sl: json["sl"] ?? "",
        kpiId: json["kpi_id"] ?? "",
        name: json["name"] ?? "",
        definition: json["definition"] ?? "",
        weitage: json["weitage"] ?? "0.0",
        kpiEdit: json["kpi_edit"],
        selfScore:
            json["self_score"].toString(), //due to int value its raise an error
      );

  Map<String, dynamic> toJson() => {
        "sl": sl,
        "kpi_id": kpiId,
        "name": name,
        "definition": definition,
        "weitage": weitage,
        "kpi_edit": kpiEdit,
        "self_score": selfScore
      };
}

// import 'package:meta/meta.dart';
// import 'dart:convert';

// AppraisalDetailsModel appraisalDetailsModelFromJson(String str) =>
//     AppraisalDetailsModel.fromJson(json.decode(str));

// String appraisalDetailsModelToJson(AppraisalDetailsModel data) =>
//     json.encode(data.toJson());

// class AppraisalDetailsModel {
//   ResData resData;

//   AppraisalDetailsModel({
//     required this.resData,
//   });

//   factory AppraisalDetailsModel.fromJson(Map<String, dynamic> json) =>
//       AppraisalDetailsModel(
//         resData: ResData.fromJson(json["res_data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "res_data": resData.toJson(),
//       };
// }

// class ResData {
//   String status;
//   String supLevelDepthNo;
//   List<RetStr> retStr;

//   ResData({
//     required this.status,
//     required this.supLevelDepthNo,
//     required this.retStr,
//   });

//   factory ResData.fromJson(Map<String, dynamic> json) => ResData(
//         status: json["status"],
//         supLevelDepthNo: json["sup_level_depth_no"],
//         retStr:
//             List<RetStr>.from(json["ret_str"].map((x) => RetStr.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "sup_level_depth_no": supLevelDepthNo,
//         "ret_str": List<dynamic>.from(retStr.map((x) => x.toJson())),
//       };
// }

// class RetStr {
//   String previousAchievement;
//   String currentAchievement;
//   String cid;
//   String employeeId;
//   String empName;
//   String designation;
//   String presentGrade;
//   String businessSegment;
//   String dateOfJoining;
//   String lastPromotion;
//   String lengthOfService;
//   String trCode;
//   String baseTerritory;
//   String lengthOfPresentTrService;
//   String targetValue1;
//   String targetValue2;
//   String soldValue1;
//   String soldValue2;
//   String achievement1;
//   String achievement2;
//   String avgSales1;
//   String avgSales2;
//   String avgSales4P1;
//   String avgSales4P2;
//   String avgSalesEmr1;
//   String avgSalesEmr2;
//   String noMonthAchiev1;
//   String noMonthAchiev2;
//   String chemistCov1;
//   String chemistCov2;
//   String salesAchievementBasePoint;
//   String avRx4PBasePoint;
//   String avRxEmrBasePoint;
//   String achChemistCovBasePoint;
//   String examPerformanceBasePoint;
//   String noAchMonthBasePoint;
//   String noLetterIssued;
//   String cause;
//   String action;
//   String noIncidence;
//   String salesAchievementFullPoints;
//   String avRx4PFullPoints;
//   String avRxEmrFullPoints;
//   String achChemistCovFullPoints;
//   String examPerformanceFullPoints;
//   String noAchMonthFullPoints;
//   String honestyFullPoints;
//   String discipFullPoints;
//   String skillFullPoints;
//   String qualitySalesFullPoints;
//   String avgRxGrowth;
//   List<KpiTable> kpiTable;

//   RetStr({
//     required this.previousAchievement,
//     required this.currentAchievement,
//     required this.cid,
//     required this.employeeId,
//     required this.empName,
//     required this.designation,
//     required this.presentGrade,
//     required this.businessSegment,
//     required this.dateOfJoining,
//     required this.lastPromotion,
//     required this.lengthOfService,
//     required this.trCode,
//     required this.baseTerritory,
//     required this.lengthOfPresentTrService,
//     required this.targetValue1,
//     required this.targetValue2,
//     required this.soldValue1,
//     required this.soldValue2,
//     required this.achievement1,
//     required this.achievement2,
//     required this.avgSales1,
//     required this.avgSales2,
//     required this.avgSales4P1,
//     required this.avgSales4P2,
//     required this.avgSalesEmr1,
//     required this.avgSalesEmr2,
//     required this.noMonthAchiev1,
//     required this.noMonthAchiev2,
//     required this.chemistCov1,
//     required this.chemistCov2,
//     required this.salesAchievementBasePoint,
//     required this.avRx4PBasePoint,
//     required this.avRxEmrBasePoint,
//     required this.achChemistCovBasePoint,
//     required this.examPerformanceBasePoint,
//     required this.noAchMonthBasePoint,
//     required this.noLetterIssued,
//     required this.cause,
//     required this.action,
//     required this.noIncidence,
//     required this.salesAchievementFullPoints,
//     required this.avRx4PFullPoints,
//     required this.avRxEmrFullPoints,
//     required this.achChemistCovFullPoints,
//     required this.examPerformanceFullPoints,
//     required this.noAchMonthFullPoints,
//     required this.honestyFullPoints,
//     required this.discipFullPoints,
//     required this.skillFullPoints,
//     required this.qualitySalesFullPoints,
//     required this.avgRxGrowth,
//     required this.kpiTable,
//   });

//   factory RetStr.fromJson(Map<String, dynamic> json) => RetStr(
//         previousAchievement: json["previous_achievement"],
//         currentAchievement: json["current_achievement"],
//         cid: json["cid"],
//         employeeId: json["employee_id"],
//         empName: json["emp_name"],
//         designation: json["designation"],
//         presentGrade: json["present_grade"],
//         businessSegment: json["business_segment"],
//         dateOfJoining: json["date_of_joining"],
//         lastPromotion: json["last_promotion"],
//         lengthOfService: json["length_of_service"],
//         trCode: json["tr_code"],
//         baseTerritory: json["base_territory"],
//         lengthOfPresentTrService: json["length_of_present_tr_service"],
//         targetValue1: json["target_value_1"],
//         targetValue2: json["target_value_2"],
//         soldValue1: json["sold_value_1"],
//         soldValue2: json["sold_value_2"],
//         achievement1: json["achievement_1"],
//         achievement2: json["achievement_2"],
//         avgSales1: json["avg_sales_1"],
//         avgSales2: json["avg_sales_2"],
//         avgSales4P1: json["avg_sales_4p_1"],
//         avgSales4P2: json["avg_sales_4p_2"],
//         avgSalesEmr1: json["avg_sales_emr_1"],
//         avgSalesEmr2: json["avg_sales_emr_2"],
//         noMonthAchiev1: json["no_month_achiev_1"],
//         noMonthAchiev2: json["no_month_achiev_2"],
//         chemistCov1: json["chemist_cov_1"],
//         chemistCov2: json["chemist_cov_2"],
//         salesAchievementBasePoint: json["sales_achievement_base_point"],
//         avRx4PBasePoint: json["av_rx_4p_base_point"],
//         avRxEmrBasePoint: json["av_rx_emr_base_point"],
//         achChemistCovBasePoint: json["ach_chemist_cov_base_point"],
//         examPerformanceBasePoint: json["exam_performance_base_point"],
//         noAchMonthBasePoint: json["no_ach_month_base_point"],
//         noLetterIssued: json["no_letter_issued"],
//         cause: json["cause"],
//         action: json["action"],
//         noIncidence: json["no_incidence"],
//         salesAchievementFullPoints: json["sales_achievement_full_points"],
//         avRx4PFullPoints: json["av_rx_4p_full_points"],
//         avRxEmrFullPoints: json["av_rx_emr_full_points"],
//         achChemistCovFullPoints: json["ach_chemist_cov_full_points"],
//         examPerformanceFullPoints: json["exam_performance_full_points"],
//         noAchMonthFullPoints: json["no_ach_month_full_points"],
//         honestyFullPoints: json["honesty_full_points"],
//         discipFullPoints: json["discip_full_points"],
//         skillFullPoints: json["skill_full_points"],
//         qualitySalesFullPoints: json["quality_sales_full_points"],
//         avgRxGrowth: json["avg_rx_growth"],
//         kpiTable: List<KpiTable>.from(
//             json["kpi_table"].map((x) => KpiTable.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "previous_achievement": previousAchievement,
//         "current_achievement": currentAchievement,
//         "cid": cid,
//         "employee_id": employeeId,
//         "emp_name": empName,
//         "designation": designation,
//         "present_grade": presentGrade,
//         "business_segment": businessSegment,
//         "date_of_joining": dateOfJoining,
//         "last_promotion": lastPromotion,
//         "length_of_service": lengthOfService,
//         "tr_code": trCode,
//         "base_territory": baseTerritory,
//         "length_of_present_tr_service": lengthOfPresentTrService,
//         "target_value_1": targetValue1,
//         "target_value_2": targetValue2,
//         "sold_value_1": soldValue1,
//         "sold_value_2": soldValue2,
//         "achievement_1": achievement1,
//         "achievement_2": achievement2,
//         "avg_sales_1": avgSales1,
//         "avg_sales_2": avgSales2,
//         "avg_sales_4p_1": avgSales4P1,
//         "avg_sales_4p_2": avgSales4P2,
//         "avg_sales_emr_1": avgSalesEmr1,
//         "avg_sales_emr_2": avgSalesEmr2,
//         "no_month_achiev_1": noMonthAchiev1,
//         "no_month_achiev_2": noMonthAchiev2,
//         "chemist_cov_1": chemistCov1,
//         "chemist_cov_2": chemistCov2,
//         "sales_achievement_base_point": salesAchievementBasePoint,
//         "av_rx_4p_base_point": avRx4PBasePoint,
//         "av_rx_emr_base_point": avRxEmrBasePoint,
//         "ach_chemist_cov_base_point": achChemistCovBasePoint,
//         "exam_performance_base_point": examPerformanceBasePoint,
//         "no_ach_month_base_point": noAchMonthBasePoint,
//         "no_letter_issued": noLetterIssued,
//         "cause": cause,
//         "action": action,
//         "no_incidence": noIncidence,
//         "sales_achievement_full_points": salesAchievementFullPoints,
//         "av_rx_4p_full_points": avRx4PFullPoints,
//         "av_rx_emr_full_points": avRxEmrFullPoints,
//         "ach_chemist_cov_full_points": achChemistCovFullPoints,
//         "exam_performance_full_points": examPerformanceFullPoints,
//         "no_ach_month_full_points": noAchMonthFullPoints,
//         "honesty_full_points": honestyFullPoints,
//         "discip_full_points": discipFullPoints,
//         "skill_full_points": skillFullPoints,
//         "quality_sales_full_points": qualitySalesFullPoints,
//         "avg_rx_growth": avgRxGrowth,
//         "kpi_table": List<dynamic>.from(kpiTable.map((x) => x.toJson())),
//       };
// }

// class KpiTable {
//   String sl;
//   String name;
//   String definition;
//   String weitage;
//   String kpiEdit; // Changed from an enum to a string
//   String selfScore; // Changed from an enum to a string

//   KpiTable({
//     required this.sl,
//     required this.name,
//     required this.definition,
//     required this.weitage,
//     required this.kpiEdit,
//     required this.selfScore,
//   });

//   factory KpiTable.fromJson(Map<String, dynamic> json) => KpiTable(
//         sl: json["sl"],
//         name: json["name"],
//         definition: json["definition"],
//         weitage: json["weitage"],
//         kpiEdit: json["kpi_edit"],
//         selfScore: json["self_score"],
//       );

//   Map<String, dynamic> toJson() => {
//         "sl": sl,
//         "name": name,
//         "definition": definition,
//         "weitage": weitage,
//         "kpi_edit": kpiEdit,
//         "self_score": selfScore
//       };
// }

class RowData {
  final String sl;
  final String name;
  final String definition;
  final String weitage;
  final String kpiEdit;

  RowData({
    required this.sl,
    required this.name,
    required this.definition,
    required this.weitage,
    required this.kpiEdit,
  });
}
// import 'package:meta/meta.dart';
// import 'dart:convert';

// AppraisalDetailsModel appraisalDetailsModelFromJson(String str) =>
//     AppraisalDetailsModel.fromJson(json.decode(str));

// class AppraisalDetailsModel {
//   final ResData resData;

//   AppraisalDetailsModel({
//     required this.resData,
//   });

//   factory AppraisalDetailsModel.fromJson(Map<String, dynamic> json) =>
//       AppraisalDetailsModel(
//         resData: ResData.fromJson(json["res_data"]),
//       );
// }

// class ResData {
//   final String status;
//   final String supLevelDepthNo;
//   final List<RestModel> retStr;

//   ResData({
//     required this.status,
//     required this.supLevelDepthNo,
//     required this.retStr,
//   });

//   factory ResData.fromJson(Map<String, dynamic> json) => ResData(
//         status: json["status"],
//         supLevelDepthNo: json["sup_level_depth_no"],
//         retStr: List<RestModel>.from(
//             json["ret_str"].map((x) => RestModel.fromJson(x))),
//       );
// }

// // class RestModel {
// //   final String cid;
// //   final String employeeId;
// //   final String empName;
// //   final String designation;
// //   final String presentGrade;
// //   final String businessSegment;
// //   final String dateOfJoining;
// //   final String lastPromotion;
// //   final String lengthOfService;
// //   final String trCode;
// //   final String baseTerritory;
// //   final String lengthOfPresentTrService;
// //   final String targetValue1;
// //   final String targetValue2;
// //   final String soldValue1;
// //   final String soldValue2;
// //   final String achievement1;
// //   final String achievement2;
// //   final String avgSales1;
// //   final String avgSales2;
// //   final String avgSales4p1;
// //   final String avgSales4p2;
// //   final String avgSalesEmr1;
// //   final String avgSalesEmr2;
// //   final String avgRxGrowth;
// //   final String noMonthAchiev1;
// //   final String noMonthAchiev2;
// //   final String chemistCov1;
// //   final String chemistCov2;
// //   final String salesAchievementBasePoint;
// //   final String avRx4pBasePoint;
// //   final String avRxEmrBasePoint;
// //   final String achChemistCovBasePoint;
// //   final String examPerformanceBasePoint;
// //   final String noAchMonthBasePoint;
// //   final String noLetterIssued;
// //   final String cause;
// //   final String action;
// //   final String noIncidence;
// //   final String salesAchievementFullPoints;
// //   final String avRx4pFullPoints;
// //   final String avRxEmrFullPoints;
// //   final String achChemistCovFullPoints;
// //   final String examPerformanceFullPoints;
// //   final String noAchMonthFullPoints;
// //   final String honestyFullPoints;
// //   final String discipFullPoints;
// //   final String skillFullPoints;
// //   final String qualitySalesFullPoints;
// //   final String previousAchievement;
// //   final String currentAchievement;

// //   RestModel({
// //     required this.cid,
// //     required this.employeeId,
// //     required this.empName,
// //     required this.designation,
// //     required this.presentGrade,
// //     required this.businessSegment,
// //     required this.dateOfJoining,
// //     required this.lastPromotion,
// //     required this.lengthOfService,
// //     required this.trCode,
// //     required this.baseTerritory,
// //     required this.lengthOfPresentTrService,
// //     required this.targetValue1,
// //     required this.targetValue2,
// //     required this.soldValue1,
// //     required this.soldValue2,
// //     required this.achievement1,
// //     required this.achievement2,
// //     required this.avgSales1,
// //     required this.avgSales2,
// //     required this.avgSales4p1,
// //     required this.avgSales4p2,
// //     required this.avgSalesEmr1,
// //     required this.avgSalesEmr2,
// //     required this.avgRxGrowth,
// //     required this.noMonthAchiev1,
// //     required this.noMonthAchiev2,
// //     required this.chemistCov1,
// //     required this.chemistCov2,
// //     required this.salesAchievementBasePoint,
// //     required this.avRx4pBasePoint,
// //     required this.avRxEmrBasePoint,
// //     required this.achChemistCovBasePoint,
// //     required this.examPerformanceBasePoint,
// //     required this.noAchMonthBasePoint,
// //     required this.noLetterIssued,
// //     required this.cause,
// //     required this.action,
// //     required this.noIncidence,
// //     required this.salesAchievementFullPoints,
// //     required this.avRx4pFullPoints,
// //     required this.avRxEmrFullPoints,
// //     required this.achChemistCovFullPoints,
// //     required this.examPerformanceFullPoints,
// //     required this.noAchMonthFullPoints,
// //     required this.honestyFullPoints,
// //     required this.discipFullPoints,
// //     required this.skillFullPoints,
// //     required this.qualitySalesFullPoints,
// //     required this.previousAchievement,
// //     required this.currentAchievement,
// //   });

// //   factory RestModel.fromJson(Map<String, dynamic> json) {
// //     return RestModel(
// //       cid: json['cid'] ?? '',
// //       employeeId: json['employee_id'] ?? '',
// //       empName: json['emp_name'] ?? '',
// //       designation: json['designation'] ?? '',
// //       presentGrade: json['present_grade'] ?? '',
// //       businessSegment: json['business_segment'] ?? '',
// //       dateOfJoining: json['date_of_joining'] ?? '',
// //       lastPromotion: json['last_promotion'] ?? '',
// //       lengthOfService: json['length_of_service'] ?? '',
// //       trCode: json['tr_code'] ?? '',
// //       baseTerritory: json['base_territory'] ?? '',
// //       lengthOfPresentTrService: json['length_of_present_tr_service'] ?? '',
// //       targetValue1: json['target_value_1'] ?? '',
// //       targetValue2: json['target_value_2'] ?? '',
// //       soldValue1: json['sold_value_1'] ?? '',
// //       soldValue2: json['sold_value_2'] ?? '',
// //       achievement1: json['achievement_1'] ?? '',
// //       achievement2: json['achievement_2'] ?? '',
// //       avgSales1: json['avg_sales_1'] ?? '',
// //       avgSales2: json['avg_sales_2'] ?? '',
// //       avgSales4p1: json['avg_sales_4p_1'] ?? '',
// //       avgSales4p2: json['avg_sales_4p_2'] ?? '',
// //       avgSalesEmr1: json['avg_sales_emr_1'] ?? '',
// //       avgSalesEmr2: json['avg_sales_emr_2'] ?? '',
// //       avgRxGrowth: json['avg_rx_growth'] ?? '',
// //       noMonthAchiev1: json['no_month_achiev_1'] ?? '',
// //       noMonthAchiev2: json['no_month_achiev_2'] ?? '',
// //       chemistCov1: json['chemist_cov_1'] ?? '',
// //       chemistCov2: json['chemist_cov_2'] ?? '',
// //       salesAchievementBasePoint: json['sales_achievement_base_point'] ?? '',
// //       avRx4pBasePoint: json['av_rx_4p_base_point'] ?? '',
// //       avRxEmrBasePoint: json['av_rx_emr_base_point'] ?? '',
// //       achChemistCovBasePoint: json['ach_chemist_cov_base_point'] ?? '',
// //       examPerformanceBasePoint: json['exam_performance_base_point'] ?? '',
// //       noAchMonthBasePoint: json['no_ach_month_base_point'] ?? '',
// //       noLetterIssued: json['no_letter_issued'] ?? '',
// //       cause: json['cause'] ?? '',
// //       action: json['action'] ?? '',
// //       noIncidence: json['no_incidence'] ?? '',
// //       salesAchievementFullPoints: json['sales_achievement_full_points'] ?? '',
// //       avRx4pFullPoints: json['av_rx_4p_full_points'] ?? '',
// //       avRxEmrFullPoints: json['av_rx_emr_full_points'] ?? '',
// //       achChemistCovFullPoints: json['ach_chemist_cov_full_points'] ?? '',
// //       examPerformanceFullPoints: json['exam_performance_full_points'] ?? '',
// //       noAchMonthFullPoints: json['no_ach_month_full_points'] ?? '',
// //       honestyFullPoints: json['honesty_full_points'] ?? '',
// //       discipFullPoints: json['discip_full_points'] ?? '',
// //       skillFullPoints: json['skill_full_points'] ?? '',
// //       qualitySalesFullPoints: json['quality_sales_full_points'] ?? '',
// //       previousAchievement: json['previous_achievement'] ?? '    ',
// //       currentAchievement: json['current_achievement'] ?? '    ',
// //     );
// //   }
// // }

var selfAssesmentJson = {
  "res_data": {
    "status": "Success",
    "sup_level_depth_no": "2",
    "ret_str": [
      {
        "kpi_key": "mso_app_kpi",
        "doctor_coverage": "92.42",
        "sales_achievement": "0.0",
        "previous_achievement": "2021 (Jan-Dec)",
        "current_achievement": "2023 (Jan-Dec)",
        "cid": "SKF",
        "employee_id": "5280",
        "emp_name": "MS. NASRIN SULTANA AMINA",
        "designation": "Sr. Medical Services Officer",
        "present_grade": "O-03",
        "business_segment": "Formulation",
        "date_of_joining": "27-Jul-06",
        "last_promotion": "7-Jan-10",
        "length_of_service": "17Y 2M",
        "tr_code": "DSL21",
        "base_territory":
            "DNMI, GYE INDOOR, GYE OUT DOOR, PED INDOOR, SURGERY FEMALE OUT DOOR, MORDERN, MEDINOVA",
        "length_of_present_tr_service": "2Y  3M ",
        "target_value_2": "0.0",
        "sold_value_2": "0.0",
        "achievement_2": "0.0",
        "avg_sales_2": "0.0",
        "avg_sales_4p_2": "0.0",
        "avg_sales_emr_2": "0.0",
        "no_month_achiev_2": "0.0",
        "chemist_cov_2": "0.0",
        "av_rx_4p_base_point": "7.45",
        "av_rx_emr_base_point": "9.12",
        "ach_chemist_cov_base_point": "0.0",
        "exam_performance_base_point": "",
        "no_ach_month_base_point": "0.0",
        "no_letter_issued": "",
        "cause": "",
        "action": "",
        "no_incidence": "",
        "avg_rx_growth": "0.0",
        "kpi_table": [
          {
            "sl": "1",
            "name": "Sales Achievement",
            "definition": "Jan-Dec 2023",
            "weitage": "40.0",
            "kpi_edit": "NO",
            "self_score": "0.0"
          },
          {
            "sl": "2",
            "name": "Doctor Coverage",
            "definition": "1st April 2023 Onwards",
            "weitage": "10.0",
            "kpi_edit": "NO",
            "self_score": "92.42"
          },
          {
            "sl": "3",
            "name": "Rx Share (Seen Rx, 4P, EMR)",
            "definition": "Average of three parameters",
            "weitage": "10.0",
            "kpi_edit": "NO",
            "self_score": "104.12"
          },
          {
            "sl": "4",
            "name": "Brand Performance (Sales)",
            "definition":
                "Double Power Brands\nLeading Power Brands\nChasing Power Brands\nNew Power Brands\n\n1st April 2023 Onwards ",
            "weitage": "5.0",
            "kpi_edit": "NO",
            "self_score": "0.0"
          },
          {
            "sl": "5",
            "name": "Chemist Coverage",
            "definition": "Jan-Dec 2023",
            "weitage": "5.0",
            "kpi_edit": "NO",
            "self_score": "0.0"
          },
          {
            "sl": "6",
            "name": "Product Knowledge and Detailing Skills",
            "definition": "",
            "weitage": "5.0",
            "kpi_edit": "NO",
            "self_score": "52.9"
          },
          {
            "sl": "7",
            "name": "PSD, GSD Relationship",
            "definition":
                "Need Drop Down Box for\n- Very Good (10%)\n- Good (7%)\n- Need Improvement (4%)\n\nDefinition:\n- Weekly coverage (2 Calls)\n- Rx from PSD GSD \n- Number of Doctor",
            "weitage": "10.0",
            "kpi_edit": "YES",
            "self_score": "0"
          },
          {
            "sl": "8",
            "name": "Market Involvement and Degree of Drive ",
            "definition":
                "Definition:\n- Market Coverage including Doctor & Chemist\n- Regular Initiatives by MSO to full fill his monthly targets",
            "weitage": "5.0",
            "kpi_edit": "YES",
            "self_score": "0"
          },
          {
            "sl": "9",
            "name": "Pair Co-ordination and Discipline",
            "definition":
                "Definition:\n- Coordination among teams (A, B, C)\n- Time management\n- Absenteeism\n- Honesty & Integrity\ni. m-Reporting\nii. Resource Utilization (DSR, Gift, Sample, Literature)\niii. Working Authenticity",
            "weitage": "5.0",
            "kpi_edit": "YES",
            "self_score": "0"
          },
          {
            "sl": "10",
            "name": "Special Activities for Doctors and Chemists",
            "definition": "",
            "weitage": "5.0",
            "kpi_edit": "YES",
            "self_score": "0"
          }
        ]
      }
    ]
  }
};
