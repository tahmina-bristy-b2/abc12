// // To parse this JSON data, do
// //
// //     final appraisalApprovalFfDetailsDataModel = appraisalApprovalFfDetailsDataModelFromJson(jsonString);

// import 'dart:convert';

// AppraisalApprovalFfDetailsDataModel appraisalApprovalFfDetailsDataModelFromJson(
//         String str) =>
//     AppraisalApprovalFfDetailsDataModel.fromJson(json.decode(str));

// String appraisalApprovalFfDetailsDataModelToJson(
//         AppraisalApprovalFfDetailsDataModel data) =>
//     json.encode(data.toJson());

// class AppraisalApprovalFfDetailsDataModel {
//   final ResData? resData;

//   AppraisalApprovalFfDetailsDataModel({
//     this.resData,
//   });

//   factory AppraisalApprovalFfDetailsDataModel.fromJson(
//           Map<String, dynamic> json) =>
//       AppraisalApprovalFfDetailsDataModel(
//         resData: json["res_data"] == null
//             ? null
//             : ResData.fromJson(json["res_data"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "res_data": resData?.toJson(),
//       };
// }

// class ResData {
//   final String? status;
//   final String? supLevelDepthNo;
//   final List<RetStr>? retStr;

//   ResData({
//     this.status,
//     this.supLevelDepthNo,
//     this.retStr,
//   });

//   factory ResData.fromJson(Map<String, dynamic> json) => ResData(
//         status: json["status"],
//         supLevelDepthNo: json["sup_level_depth_no"],
//         retStr: json["ret_str"] == null
//             ? []
//             : List<RetStr>.from(
//                 json["ret_str"]!.map((x) => RetStr.fromJson(x))),
//       );

//   Map<String, dynamic> toJson() => {
//         "status": status,
//         "sup_level_depth_no": supLevelDepthNo,
//         "ret_str": retStr == null
//             ? []
//             : List<dynamic>.from(retStr!.map((x) => x.toJson())),
//       };
// }

// class RetStr {
//   final String? cid;
//   final String? employeeId;
//   final String? empName;
//   final String? designation;
//   final String? presentGrade;
//   final String? businessSegment;
//   final String? dateOfJoining;
//   final String? lastPromotion;
//   final String? lengthOfService;
//   final String? trCode;
//   final String? baseTerritory;
//   final String? lengthOfPresentTrService;
//   final String? targetValue1;
//   final String? targetValue2;
//   final String? soldValue1;
//   final String? soldValue2;
//   final String? lastAction;
//   final String? step;
//   final String? rowId;
//   final String? achievement1;
//   final String? achievement2;
//   final String? avgSales1;
//   final String? avgSales2;
//   final String? avgSales4P1;
//   final String? avgSales4P2;
//   final String? avgSalesEmr1;
//   final String? avgSalesEmr2;
//   final String? noMonthAchiev1;
//   final String? noMonthAchiev2;
//   final String? chemistCov1;
//   final String? chemistCov2;
//   final String? salesAchievementBasePoint;
//   final String? avRx4PBasePoint;
//   final String? avRxEmrBasePoint;
//   final String? achChemistCovBasePoint;
//   final String? examPerformanceBasePoint;
//   final String? noAchMonthBasePoint;
//   final String? noLetterIssued;
//   final String? cause;
//   final String? action;
//   final String? noIncidence;
//   final String? salesAchievementFullPoints;
//   final String? avRx4PFullPoints;
//   final String? avRxEmrFullPoints;
//   final String? achChemistCovFullPoints;
//   final String? examPerformanceFullPoints;
//   final String? noAchMonthFullPoints;
//   final String? honestyFullPoints;
//   final String? discipFullPoints;
//   final String? skillFullPoints;
//   final String? qualitySalesFullPoints;
//   final String? honestyAndIntegrity;
//   final String? discipline;
//   final String? skill;
//   final String? qualityOfSales;
//   final String? incrementAmount;
//   final String? upgradeGrade;
//   final String? designationChange;
//   final String? feedback;
//   final String? previousAchievement;
//   final String? currentAchievement;
//   final String? avgRxGrowth;

//   RetStr({
//     this.cid,
//     this.employeeId,
//     this.empName,
//     this.designation,
//     this.presentGrade,
//     this.businessSegment,
//     this.dateOfJoining,
//     this.lastPromotion,
//     this.lengthOfService,
//     this.trCode,
//     this.baseTerritory,
//     this.lengthOfPresentTrService,
//     this.targetValue1,
//     this.targetValue2,
//     this.soldValue1,
//     this.soldValue2,
//     this.lastAction,
//     this.step,
//     this.rowId,
//     this.achievement1,
//     this.achievement2,
//     this.avgSales1,
//     this.avgSales2,
//     this.avgSales4P1,
//     this.avgSales4P2,
//     this.avgSalesEmr1,
//     this.avgSalesEmr2,
//     this.noMonthAchiev1,
//     this.noMonthAchiev2,
//     this.chemistCov1,
//     this.chemistCov2,
//     this.salesAchievementBasePoint,
//     this.avRx4PBasePoint,
//     this.avRxEmrBasePoint,
//     this.achChemistCovBasePoint,
//     this.examPerformanceBasePoint,
//     this.noAchMonthBasePoint,
//     this.noLetterIssued,
//     this.cause,
//     this.action,
//     this.noIncidence,
//     this.salesAchievementFullPoints,
//     this.avRx4PFullPoints,
//     this.avRxEmrFullPoints,
//     this.achChemistCovFullPoints,
//     this.examPerformanceFullPoints,
//     this.noAchMonthFullPoints,
//     this.honestyFullPoints,
//     this.discipFullPoints,
//     this.skillFullPoints,
//     this.qualitySalesFullPoints,
//     this.honestyAndIntegrity,
//     this.discipline,
//     this.skill,
//     this.qualityOfSales,
//     this.incrementAmount,
//     this.upgradeGrade,
//     this.designationChange,
//     this.feedback,
//     this.previousAchievement,
//     this.currentAchievement,
//     this.avgRxGrowth,
//   });

//   factory RetStr.fromJson(Map<String, dynamic> json) => RetStr(
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
//         lastAction: json["last_action"],
//         step: json["step"],
//         rowId: json["row_id"],
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
//         honestyAndIntegrity: json["honesty_and_integrity"],
//         discipline: json["discipline"],
//         skill: json["skill"],
//         qualityOfSales: json["quality_of_sales"],
//         incrementAmount: json["increment_amount"],
//         upgradeGrade: json["upgrade_grade"],
//         designationChange: json["designation_change"],
//         feedback: json["feedback"],
//         previousAchievement: json["previous_achievement"],
//         currentAchievement: json["current_achievement"],
//         avgRxGrowth: json["avg_rx_growth"],
//       );

//   Map<String, dynamic> toJson() => {
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
//         "last_action": lastAction,
//         "step": step,
//         "row_id": rowId,
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
//         "honesty_and_integrity": honestyAndIntegrity,
//         "discipline": discipline,
//         "skill": skill,
//         "quality_of_sales": qualityOfSales,
//         "increment_amount": incrementAmount,
//         "upgrade_grade": upgradeGrade,
//         "designation_change": designationChange,
//         "feedback": feedback,
//         "previous_achievement": previousAchievement,
//         "current_achievement": currentAchievement,
//         "avg_rx_growth": avgRxGrowth,
//       };
// }

// var fFDetailsJson = {
//   "res_data": {
//     "status": "Success",
//     "sup_level_depth_no": "2",
//     "ret_str": [
//       {
//         "cid": "SKF",
//         "employee_id": "19709",
//         "emp_name": "MR. MD. NURUZZAMAN",
//         "designation": "Medical Services Officer",
//         "present_grade": "O-01",
//         "business_segment": "Formulation",
//         "date_of_joining": "15-Dec-20",
//         "last_promotion": "N/A",
//         "length_of_service": "2Y 9M",
//         "tr_code": "DS23A",
//         "base_territory":
//             "DNMI (SKIN, SURGERY, DENTAL, CARDIOLIGY OUTDOOR,INDOOR,SURGERY MALE OUTDOOR ), ASGAR ALI HOSPITAL,ENGLISH ROAD, POPULAR DIAGNOSTIC CENTER, GANDARIA, NARINDA",
//         "length_of_present_tr_service": "2Y  9M ",
//         "target_value_1": "78.13",
//         "target_value_2": "0.0",
//         "sold_value_1": "53.48",
//         "sold_value_2": "0.0",
//         "achievement_1": "68.45",
//         "achievement_2": "68.45",
//         "avg_sales_1": "4.86",
//         "avg_sales_2": "4.86",
//         "avg_sales_4p_1": "2.84",
//         "avg_sales_4p_2": "0.0",
//         "avg_sales_emr_1": "9.2",
//         "avg_sales_emr_2": "0.0",
//         "no_month_achiev_1": "1.0",
//         "no_month_achiev_2": "0.0",
//         "chemist_cov_1": "74.31",
//         "chemist_cov_2": "0.0",
//         "sales_achievement_base_point": "66.78",
//         "av_rx_4p_base_point": "3.55",
//         "av_rx_emr_base_point": "8.92",
//         "ach_chemist_cov_base_point": "77.14",
//         "exam_performance_base_point": "0",
//         "no_ach_month_base_point": "0.0",
//         "no_letter_issued": "",
//         "cause": "",
//         "action": "",
//         "no_incidence": "",
//         "sales_achievement_full_points": "280",
//         "av_rx_4p_full_points": "40",
//         "av_rx_emr_full_points": "40",
//         "ach_chemist_cov_full_points": "10",
//         "exam_performance_full_points": "5",
//         "no_ach_month_full_points": "5",
//         "honesty_full_points": "5",
//         "discip_full_points": "5",
//         "skill_full_points": "5",
//         "quality_sales_full_points": "5"
//       },
//     ]
//   }
// };
// To parse this JSON data, do
//
//     final appraisalApprovalFfDetailsDataModel = appraisalApprovalFfDetailsDataModelFromJson(jsonString);

import 'dart:convert';

AppraisalApprovalFfDetailsDataModel appraisalApprovalFfDetailsDataModelFromJson(
        String str) =>
    AppraisalApprovalFfDetailsDataModel.fromJson(json.decode(str));

String appraisalApprovalFfDetailsDataModelToJson(
        AppraisalApprovalFfDetailsDataModel data) =>
    json.encode(data.toJson());

class AppraisalApprovalFfDetailsDataModel {
  final ResData? resData;

  AppraisalApprovalFfDetailsDataModel({
    this.resData,
  });

  factory AppraisalApprovalFfDetailsDataModel.fromJson(
          Map<String, dynamic> json) =>
      AppraisalApprovalFfDetailsDataModel(
        resData: json["res_data"] == null
            ? null
            : ResData.fromJson(json["res_data"]),
      );

  Map<String, dynamic> toJson() => {
        "res_data": resData?.toJson(),
      };
}

class ResData {
  final String? status;
  final String? supLevelDepthNo;
  final List<RetStr>? retStr;

  ResData({
    this.status,
    this.supLevelDepthNo,
    this.retStr,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        supLevelDepthNo: json["sup_level_depth_no"],
        retStr: json["ret_str"] == null
            ? []
            : List<RetStr>.from(
                json["ret_str"]!.map((x) => RetStr.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "sup_level_depth_no": supLevelDepthNo,
        "ret_str": retStr == null
            ? []
            : List<dynamic>.from(retStr!.map((x) => x.toJson())),
      };
}

class RetStr {
  final String? cid;
  final String? releaseStatus;
  final String? employeeId;
  final String? empName;
  final String? designation;
  final String? presentGrade;
  final String? businessSegment;
  final String? dateOfJoining;
  final String? lastPromotion;
  final String? lengthOfService;
  final String? trCode;
  final String? baseTerritory;
  final String? lengthOfPresentTrService;
  final String? targetValue2;
  final String? soldValue2;
  final String? achievement2;
  final String? avgSales2;
  final String? avgSales4P2;
  final String? avgSalesEmr2;
  final String? noMonthAchiev2;
  final String? chemistCov2;
  final String? lastAction;
  final String? step;
  final String? rowId;
  final String? avgRxGrowth;
  final String? incrementAmount;
  final String? upgradeGrade;
  final String? designationChange;
  final String? feedback;
  final String? currentAchievement;
  final List<KpiTable>? kpiTable;

  RetStr({
    this.cid,
    this.releaseStatus,
    this.employeeId,
    this.empName,
    this.designation,
    this.presentGrade,
    this.businessSegment,
    this.dateOfJoining,
    this.lastPromotion,
    this.lengthOfService,
    this.trCode,
    this.baseTerritory,
    this.lengthOfPresentTrService,
    this.targetValue2,
    this.soldValue2,
    this.achievement2,
    this.avgSales2,
    this.avgSales4P2,
    this.avgSalesEmr2,
    this.noMonthAchiev2,
    this.chemistCov2,
    this.lastAction,
    this.step,
    this.rowId,
    this.avgRxGrowth,
    this.incrementAmount,
    this.upgradeGrade,
    this.designationChange,
    this.feedback,
    this.currentAchievement,
    this.kpiTable,
  });

  factory RetStr.fromJson(Map<String, dynamic> json) => RetStr(
        cid: json["cid"],
        releaseStatus: json["release_status"],
        employeeId: json["employee_id"],
        empName: json["emp_name"],
        designation: json["designation"],
        presentGrade: json["present_grade"],
        businessSegment: json["business_segment"],
        dateOfJoining: json["date_of_joining"],
        lastPromotion: json["last_promotion"],
        lengthOfService: json["length_of_service"],
        trCode: json["tr_code"],
        baseTerritory: json["base_territory"],
        lengthOfPresentTrService: json["length_of_present_tr_service"],
        targetValue2: json["target_value_2"],
        soldValue2: json["sold_value_2"],
        achievement2: json["achievement_2"],
        avgSales2: json["avg_sales_2"],
        avgSales4P2: json["avg_sales_4p_2"],
        avgSalesEmr2: json["avg_sales_emr_2"],
        noMonthAchiev2: json["no_month_achiev_2"],
        chemistCov2: json["chemist_cov_2"],
        lastAction: json["last_action"],
        step: json["step"],
        rowId: json["row_id"],
        avgRxGrowth: json["avg_rx_growth"],
        incrementAmount: json["increment_amount"],
        upgradeGrade: json["upgrade_grade"],
        designationChange: json["designation_change"],
        feedback: json["feedback"],
        currentAchievement: json["current_achievement"],
        kpiTable: json["kpi_table"] == null
            ? []
            : List<KpiTable>.from(
                json["kpi_table"]!.map((x) => KpiTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "release_status": releaseStatus,
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
        "avg_sales_4p_2": avgSales4P2,
        "avg_sales_emr_2": avgSalesEmr2,
        "no_month_achiev_2": noMonthAchiev2,
        "chemist_cov_2": chemistCov2,
        "last_action": lastAction,
        "step": step,
        "row_id": rowId,
        "avg_rx_growth": avgRxGrowth,
        "increment_amount": incrementAmount,
        "upgrade_grade": upgradeGrade,
        "designation_change": designationChange,
        "feedback": feedback,
        "current_achievement": currentAchievement,
        "kpi_table": kpiTable == null
            ? []
            : List<dynamic>.from(kpiTable!.map((x) => x.toJson())),
      };
}

// class KpiTable {
//   final String? sl;
//   final String? name;
//   final String? definition;
//   final String? weitage;
//   final String? selfScror;
//   final String? supervisorScore;
//   final String? editable;

//   KpiTable({
//     this.sl,
//     this.name,
//     this.definition,
//     this.weitage,
//     this.selfScror,
//     this.supervisorScore,
//     this.editable,
//   });

//   factory KpiTable.fromJson(Map<String, dynamic> json) => KpiTable(
//         sl: json["sl"],
//         name: json["name"],
//         definition: json["definition"],
//         weitage: json["weitage"],
//         selfScror: json["self_scror"],
//         supervisorScore: json["supervisor_score"],
//         editable: json["editable"],
//       );

//   // factory KpiTable.buildEpmty() => KpiTable(
//   //   sl: '0',
//   //   selfScror: '',
//   //   supervisorScore: ''
//   // );

//   Map<String, dynamic> toJson() => {
//         "sl": sl,
//         "name": name,
//         "definition": definition,
//         "weitage": weitage,
//         "self_scror": selfScror,
//         "supervisor_score": supervisorScore,
//         "editable": editable,
//       };
// }

class KpiTable {
  String? rowId;
  String? sl;
  String? kpiId;
  String? name;
  String? definition;
  String? weitage;
  String? kpiEdit;
  String? selfScror;
  String? selfOverallScore;
  String? supScore;
  String? supOverallScore;

  KpiTable({
    required this.rowId,
    required this.sl,
    required this.kpiId,
    required this.name,
    required this.definition,
    required this.weitage,
    required this.kpiEdit,
    required this.selfScror,
    required this.selfOverallScore,
    required this.supScore,
    required this.supOverallScore,
  });

  factory KpiTable.fromJson(Map<String, dynamic> json) => KpiTable(
        rowId: json["row_id"],
        sl: json["sl"],
        kpiId: json["kpi_id"],
        name: json["name"],
        definition: json["definition"],
        weitage: json["weightage"],
        kpiEdit: json["kpi_edit"],
        selfScror: json["self_score"],
        selfOverallScore: json["self_overall_score"],
        supScore: json["sup_score"],
        supOverallScore: json["sup_overall_score"],
      );

  Map<String, dynamic> toJson() => {
        "row_id": rowId,
        "sl": sl,
        "kpi_id": kpiId,
        "name": name,
        "definition": definition,
        "weightage": weitage,
        "kpi_edit": kpiEdit,
        "self_score": selfScror,
        "self_overall_score": selfOverallScore,
        "sup_score": supScore,
        "sup_overall_score": supOverallScore,
      };
}

class RowDataForSelf {
  final String sl;
  final String name;
  final String definition;
  final String weitage;
  final String kpiEdit;

  RowDataForSelf({
    required this.sl,
    required this.name,
    required this.definition,
    required this.weitage,
    required this.kpiEdit,
  });
}

var fFDetailsJson = {
  "res_data": {
    "status": "Success",
    "ret_str": [
      {
        "head_row_id": "6",
        "last_action": "Approved",
        "last_action_by": "2761",
        "chemist_Coverage": "76.12",
        "brand_Performance": "0.0",
        "rx_share": "34.62",
        "upgrade_grade": "0",
        "designation_change": "1",
        "increment_amount": "20000",
        "feedback": "test for approval",
        "kpi_key": "mso_app_kpi",
        "doctor_coverage": "87.31",
        "sales_achievement": "96.64",
        "previous_achievement": "2021 (Jan-Dec)",
        "current_achievement": "2023 (Jan-Dec)",
        "cid": "SKF",
        "employee_id": "16147",
        "emp_name": "MR. MD. HAFIZUR RAHAMAN",
        "designation": "Medical Services Officer",
        "present_grade": "O-01",
        "business_segment": "Formulation",
        "date_of_joining": "16-Jun-19",
        "last_promotion": "N/A",
        "length_of_service": "4Y 3M",
        "tr_code": "DS12A",
        "base_territory":
            "SSMCH (GASTRO OUTDOORINDOOR,ENDRO,HEPATO), WEST POSTOGOLA, JURAIN, SOUTH EAST DIGITAL HOSPITAL, SHOBHAN NURSING HOME",
        "length_of_present_tr_service": "4Y  3M ",
        "target_value_2": "0.0",
        "sold_value_2": "0.0",
        "achievement_2": "81.52",
        "avg_sales_2": "4.1",
        "avg_sales_4p_2": "0.0",
        "avg_sales_emr_2": "0.0",
        "no_month_achiev_2": "0.0",
        "chemist_cov_2": "0.0",
        "av_rx_4p_base_point": "5.57",
        "av_rx_emr_base_point": "10.12",
        "ach_chemist_cov_base_point": "76.12",
        "exam_performance_base_point": "",
        "no_ach_month_base_point": "0.0",
        "no_letter_issued": "",
        "cause": "",
        "action": "",
        "no_incidence": "",
        "avg_rx_growth": "0.0",
        "kpi_table": [
          {
            "row_id": "44",
            "sl": "1",
            "kpi_id": "sales_achievement",
            "name": "Sales Achievement",
            "definition": "Jan-Dec 2023",
            "weightage": "40.0",
            "kpi_edit": "NO",
            "self_score": "3",
            "self_overall_score": "1.2",
            "sup_score": "3",
            "sup_overall_score": "1.2"
          },
          {
            "row_id": "45",
            "sl": "2",
            "kpi_id": "doctor_coverage",
            "name": "Doctor Coverage",
            "definition": "1st April 2023 Onwards",
            "weightage": "10.0",
            "kpi_edit": "NO",
            "self_score": "2",
            "self_overall_score": "0.2",
            "sup_score": "2",
            "sup_overall_score": "0.2"
          },
          {
            "row_id": "46",
            "sl": "3",
            "kpi_id": "rx_share",
            "name": "Rx Share (Seen Rx, 4P, EMR)",
            "definition": "Average of three parameters",
            "weightage": "10.0",
            "kpi_edit": "NO",
            "self_score": "1",
            "self_overall_score": "0.1",
            "sup_score": "1",
            "sup_overall_score": "0.1"
          },
          {
            "row_id": "47",
            "sl": "4",
            "kpi_id": "brand_Performance",
            "name": "Brand Performance (Sales)",
            "definition":
                "Double Power Brands\nLeading Power Brands\nChasing Power Brands\nNew Power Brands\n\n1st April 2023 Onwards ",
            "weightage": "5.0",
            "kpi_edit": "NO",
            "self_score": "1",
            "self_overall_score": "0.05",
            "sup_score": "1",
            "sup_overall_score": "0.05"
          },
          {
            "row_id": "48",
            "sl": "5",
            "kpi_id": "chemist_Coverage",
            "name": "Chemist Coverage",
            "definition": "Jan-Dec 2023",
            "weightage": "5.0",
            "kpi_edit": "NO",
            "self_score": "1",
            "self_overall_score": "0.05",
            "sup_score": "1",
            "sup_overall_score": "0.05"
          },
          {
            "row_id": "49",
            "sl": "6",
            "kpi_id": "product_knowledge_and_details_skills",
            "name": "Product Knowledge and Detailing Skills",
            "definition": "",
            "weightage": "5.0",
            "kpi_edit": "NO",
            "self_score": "1",
            "self_overall_score": "0.05",
            "sup_score": "1",
            "sup_overall_score": "0.05"
          },
          {
            "row_id": "50",
            "sl": "7",
            "kpi_id": "PSD_GSD_Relationship",
            "name": "PSD, GSD Relationship",
            "definition":
                "Need Drop Down Box for\n- Very Good (10%)\n- Good (7%)\n- Need Improvement (4%)\n\nDefinition:\n- Weekly coverage (2 Calls)\n- Rx from PSD GSD \n- Number of Doctor",
            "weightage": "10.0",
            "kpi_edit": "YES",
            "self_score": "3",
            "self_overall_score": "0.3",
            "sup_score": "2",
            "sup_overall_score": "0.2"
          },
          {
            "row_id": "51",
            "sl": "8",
            "kpi_id": "market_Involvement",
            "name": "Market Involvement and Degree of Drive ",
            "definition":
                "Definition:\n- Market Coverage including Doctor & Chemist\n- Regular Initiatives by MSO to full fill his monthly targets",
            "weightage": "5.0",
            "kpi_edit": "YES",
            "self_score": "2",
            "self_overall_score": "0.1",
            "sup_score": "2",
            "sup_overall_score": "0.1"
          },
          {
            "row_id": "52",
            "sl": "9",
            "kpi_id": "pair_Co_ordination_and_Discipline",
            "name": "Pair Co-ordination and Discipline",
            "definition":
                "Definition:\n- Coordination among teams (A, B, C)\n- Time management\n- Absenteeism\n- Honesty & Integrity\ni. m-Reporting\nii. Resource Utilization (DSR, Gift, Sample, Literature)\niii. Working Authenticity",
            "weightage": "5.0",
            "kpi_edit": "YES",
            "self_score": "2",
            "self_overall_score": "0.1",
            "sup_score": "3",
            "sup_overall_score": "0.15"
          },
          {
            "row_id": "53",
            "sl": "10",
            "kpi_id": "special_Activities",
            "name": "Special Activities for Doctors and Chemists",
            "definition": "",
            "weightage": "5.0",
            "kpi_edit": "YES",
            "self_score": "2",
            "self_overall_score": "0.1",
            "sup_score": "2",
            "sup_overall_score": "0.1"
          }
        ]
      }
    ]
  }
};
