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
  final String? targetValue1;
  final String? targetValue2;
  final String? soldValue1;
  final String? soldValue2;
  final String? lastAction;
  final String? step;
  final String? rowId;
  final String? achievement1;
  final String? achievement2;
  final String? avgSales1;
  final String? avgSales2;
  final String? avgSales4P1;
  final String? avgSales4P2;
  final String? avgSalesEmr1;
  final String? avgSalesEmr2;
  final String? noMonthAchiev1;
  final String? noMonthAchiev2;
  final String? chemistCov1;
  final String? chemistCov2;
  final String? salesAchievementBasePoint;
  final String? avRx4PBasePoint;
  final String? avRxEmrBasePoint;
  final String? achChemistCovBasePoint;
  final String? examPerformanceBasePoint;
  final String? noAchMonthBasePoint;
  final String? noLetterIssued;
  final String? cause;
  final String? action;
  final String? noIncidence;
  final String? salesAchievementFullPoints;
  final String? avRx4PFullPoints;
  final String? avRxEmrFullPoints;
  final String? achChemistCovFullPoints;
  final String? examPerformanceFullPoints;
  final String? noAchMonthFullPoints;
  final String? honestyFullPoints;
  final String? discipFullPoints;
  final String? skillFullPoints;
  final String? qualitySalesFullPoints;
  final String? honestyAndIntegrity;
  final String? discipline;
  final String? skill;
  final String? qualityOfSales;
  final String? incrementAmount;
  final String? upgradeGrade;
  final String? designationChange;
  final String? feedback;
  final String? previousAchievement;
  final String? currentAchievement;
  final String? avgRxGrowth;

  RetStr({
    this.cid,
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
    this.targetValue1,
    this.targetValue2,
    this.soldValue1,
    this.soldValue2,
    this.lastAction,
    this.step,
    this.rowId,
    this.achievement1,
    this.achievement2,
    this.avgSales1,
    this.avgSales2,
    this.avgSales4P1,
    this.avgSales4P2,
    this.avgSalesEmr1,
    this.avgSalesEmr2,
    this.noMonthAchiev1,
    this.noMonthAchiev2,
    this.chemistCov1,
    this.chemistCov2,
    this.salesAchievementBasePoint,
    this.avRx4PBasePoint,
    this.avRxEmrBasePoint,
    this.achChemistCovBasePoint,
    this.examPerformanceBasePoint,
    this.noAchMonthBasePoint,
    this.noLetterIssued,
    this.cause,
    this.action,
    this.noIncidence,
    this.salesAchievementFullPoints,
    this.avRx4PFullPoints,
    this.avRxEmrFullPoints,
    this.achChemistCovFullPoints,
    this.examPerformanceFullPoints,
    this.noAchMonthFullPoints,
    this.honestyFullPoints,
    this.discipFullPoints,
    this.skillFullPoints,
    this.qualitySalesFullPoints,
    this.honestyAndIntegrity,
    this.discipline,
    this.skill,
    this.qualityOfSales,
    this.incrementAmount,
    this.upgradeGrade,
    this.designationChange,
    this.feedback,
    this.previousAchievement,
    this.currentAchievement,
    this.avgRxGrowth,
  });

  factory RetStr.fromJson(Map<String, dynamic> json) => RetStr(
        cid: json["cid"],
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
        targetValue1: json["target_value_1"],
        targetValue2: json["target_value_2"],
        soldValue1: json["sold_value_1"],
        soldValue2: json["sold_value_2"],
        lastAction: json["last_action"],
        step: json["step"],
        rowId: json["row_id"],
        achievement1: json["achievement_1"],
        achievement2: json["achievement_2"],
        avgSales1: json["avg_sales_1"],
        avgSales2: json["avg_sales_2"],
        avgSales4P1: json["avg_sales_4p_1"],
        avgSales4P2: json["avg_sales_4p_2"],
        avgSalesEmr1: json["avg_sales_emr_1"],
        avgSalesEmr2: json["avg_sales_emr_2"],
        noMonthAchiev1: json["no_month_achiev_1"],
        noMonthAchiev2: json["no_month_achiev_2"],
        chemistCov1: json["chemist_cov_1"],
        chemistCov2: json["chemist_cov_2"],
        salesAchievementBasePoint: json["sales_achievement_base_point"],
        avRx4PBasePoint: json["av_rx_4p_base_point"],
        avRxEmrBasePoint: json["av_rx_emr_base_point"],
        achChemistCovBasePoint: json["ach_chemist_cov_base_point"],
        examPerformanceBasePoint: json["exam_performance_base_point"],
        noAchMonthBasePoint: json["no_ach_month_base_point"],
        noLetterIssued: json["no_letter_issued"],
        cause: json["cause"],
        action: json["action"],
        noIncidence: json["no_incidence"],
        salesAchievementFullPoints: json["sales_achievement_full_points"],
        avRx4PFullPoints: json["av_rx_4p_full_points"],
        avRxEmrFullPoints: json["av_rx_emr_full_points"],
        achChemistCovFullPoints: json["ach_chemist_cov_full_points"],
        examPerformanceFullPoints: json["exam_performance_full_points"],
        noAchMonthFullPoints: json["no_ach_month_full_points"],
        honestyFullPoints: json["honesty_full_points"],
        discipFullPoints: json["discip_full_points"],
        skillFullPoints: json["skill_full_points"],
        qualitySalesFullPoints: json["quality_sales_full_points"],
        honestyAndIntegrity: json["honesty_and_integrity"],
        discipline: json["discipline"],
        skill: json["skill"],
        qualityOfSales: json["quality_of_sales"],
        incrementAmount: json["increment_amount"],
        upgradeGrade: json["upgrade_grade"],
        designationChange: json["designation_change"],
        feedback: json["feedback"],
        previousAchievement: json["previous_achievement"],
        currentAchievement: json["current_achievement"],
        avgRxGrowth: json["avg_rx_growth"],
      );

  Map<String, dynamic> toJson() => {
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
        "target_value_1": targetValue1,
        "target_value_2": targetValue2,
        "sold_value_1": soldValue1,
        "sold_value_2": soldValue2,
        "last_action": lastAction,
        "step": step,
        "row_id": rowId,
        "achievement_1": achievement1,
        "achievement_2": achievement2,
        "avg_sales_1": avgSales1,
        "avg_sales_2": avgSales2,
        "avg_sales_4p_1": avgSales4P1,
        "avg_sales_4p_2": avgSales4P2,
        "avg_sales_emr_1": avgSalesEmr1,
        "avg_sales_emr_2": avgSalesEmr2,
        "no_month_achiev_1": noMonthAchiev1,
        "no_month_achiev_2": noMonthAchiev2,
        "chemist_cov_1": chemistCov1,
        "chemist_cov_2": chemistCov2,
        "sales_achievement_base_point": salesAchievementBasePoint,
        "av_rx_4p_base_point": avRx4PBasePoint,
        "av_rx_emr_base_point": avRxEmrBasePoint,
        "ach_chemist_cov_base_point": achChemistCovBasePoint,
        "exam_performance_base_point": examPerformanceBasePoint,
        "no_ach_month_base_point": noAchMonthBasePoint,
        "no_letter_issued": noLetterIssued,
        "cause": cause,
        "action": action,
        "no_incidence": noIncidence,
        "sales_achievement_full_points": salesAchievementFullPoints,
        "av_rx_4p_full_points": avRx4PFullPoints,
        "av_rx_emr_full_points": avRxEmrFullPoints,
        "ach_chemist_cov_full_points": achChemistCovFullPoints,
        "exam_performance_full_points": examPerformanceFullPoints,
        "no_ach_month_full_points": noAchMonthFullPoints,
        "honesty_full_points": honestyFullPoints,
        "discip_full_points": discipFullPoints,
        "skill_full_points": skillFullPoints,
        "quality_sales_full_points": qualitySalesFullPoints,
        "honesty_and_integrity": honestyAndIntegrity,
        "discipline": discipline,
        "skill": skill,
        "quality_of_sales": qualityOfSales,
        "increment_amount": incrementAmount,
        "upgrade_grade": upgradeGrade,
        "designation_change": designationChange,
        "feedback": feedback,
        "previous_achievement": previousAchievement,
        "current_achievement": currentAchievement,
        "avg_rx_growth": avgRxGrowth,
      };
}

var fFDetailsJson = {
  "res_data": {
    "status": "Success",
    "sup_level_depth_no": "2",
    "ret_str": [
      {
        "cid": "SKF",
        "employee_id": "19709",
        "emp_name": "MR. MD. NURUZZAMAN",
        "designation": "Medical Services Officer",
        "present_grade": "O-01",
        "business_segment": "Formulation",
        "date_of_joining": "15-Dec-20",
        "last_promotion": "N/A",
        "length_of_service": "2Y 9M",
        "tr_code": "DS23A",
        "base_territory":
            "DNMI (SKIN, SURGERY, DENTAL, CARDIOLIGY OUTDOOR,INDOOR,SURGERY MALE OUTDOOR ), ASGAR ALI HOSPITAL,ENGLISH ROAD, POPULAR DIAGNOSTIC CENTER, GANDARIA, NARINDA",
        "length_of_present_tr_service": "2Y  9M ",
        "target_value_1": "78.13",
        "target_value_2": "0.0",
        "sold_value_1": "53.48",
        "sold_value_2": "0.0",
        "achievement_1": "68.45",
        "achievement_2": "68.45",
        "avg_sales_1": "4.86",
        "avg_sales_2": "4.86",
        "avg_sales_4p_1": "2.84",
        "avg_sales_4p_2": "0.0",
        "avg_sales_emr_1": "9.2",
        "avg_sales_emr_2": "0.0",
        "no_month_achiev_1": "1.0",
        "no_month_achiev_2": "0.0",
        "chemist_cov_1": "74.31",
        "chemist_cov_2": "0.0",
        "sales_achievement_base_point": "66.78",
        "av_rx_4p_base_point": "3.55",
        "av_rx_emr_base_point": "8.92",
        "ach_chemist_cov_base_point": "77.14",
        "exam_performance_base_point": "0",
        "no_ach_month_base_point": "0.0",
        "no_letter_issued": "",
        "cause": "",
        "action": "",
        "no_incidence": "",
        "sales_achievement_full_points": "280",
        "av_rx_4p_full_points": "40",
        "av_rx_emr_full_points": "40",
        "ach_chemist_cov_full_points": "10",
        "exam_performance_full_points": "5",
        "no_ach_month_full_points": "5",
        "honesty_full_points": "5",
        "discip_full_points": "5",
        "skill_full_points": "5",
        "quality_sales_full_points": "5"
      },
      {
        "cid": "SKF",
        "employee_id": "19709",
        "emp_name": "MR. MD. NURUZZAMAN",
        "designation": "Medical Services Officer",
        "present_grade": "O-01",
        "business_segment": "Formulation",
        "date_of_joining": "15-Dec-20",
        "last_promotion": "N/A",
        "length_of_service": "2Y 9M",
        "tr_code": "DS23A",
        "base_territory":
            "DNMI (SKIN, SURGERY, DENTAL, CARDIOLIGY OUTDOOR,INDOOR,SURGERY MALE OUTDOOR ), ASGAR ALI HOSPITAL,ENGLISH ROAD, POPULAR DIAGNOSTIC CENTER, GANDARIA, NARINDA",
        "length_of_present_tr_service": "2Y  9M ",
        "target_value_1": "78.13",
        "target_value_2": "0.0",
        "sold_value_1": "53.48",
        "sold_value_2": "0.0",
        "achievement_1": "68.45",
        "achievement_2": "68.45",
        "avg_sales_1": "4.86",
        "avg_sales_2": "4.86",
        "avg_sales_4p_1": "2.84",
        "avg_sales_4p_2": "0.0",
        "avg_sales_emr_1": "9.2",
        "avg_sales_emr_2": "0.0",
        "no_month_achiev_1": "1.0",
        "no_month_achiev_2": "0.0",
        "chemist_cov_1": "74.31",
        "chemist_cov_2": "0.0",
        "sales_achievement_base_point": "66.78",
        "av_rx_4p_base_point": "3.55",
        "av_rx_emr_base_point": "8.92",
        "ach_chemist_cov_base_point": "77.14",
        "exam_performance_base_point": "",
        "no_ach_month_base_point": "0.0",
        "no_letter_issued": "",
        "cause": "",
        "action": "",
        "no_incidence": "",
        "sales_achievement_full_points": "280",
        "av_rx_4p_full_points": "40",
        "av_rx_emr_full_points": "40",
        "ach_chemist_cov_full_points": "10",
        "exam_performance_full_points": "5",
        "no_ach_month_full_points": "5",
        "honesty_full_points": "5",
        "discip_full_points": "5",
        "skill_full_points": "5",
        "quality_sales_full_points": "5"
      },
      {
        "cid": "SKF",
        "employee_id": "19709",
        "emp_name": "MR. MD. NURUZZAMAN",
        "designation": "Medical Services Officer",
        "present_grade": "O-01",
        "business_segment": "Formulation",
        "date_of_joining": "15-Dec-20",
        "last_promotion": "N/A",
        "length_of_service": "2Y 9M",
        "tr_code": "DS23A",
        "base_territory":
            "DNMI (SKIN, SURGERY, DENTAL, CARDIOLIGY OUTDOOR,INDOOR,SURGERY MALE OUTDOOR ), ASGAR ALI HOSPITAL,ENGLISH ROAD, POPULAR DIAGNOSTIC CENTER, GANDARIA, NARINDA",
        "length_of_present_tr_service": "2Y  9M ",
        "target_value_1": "78.13",
        "target_value_2": "0.0",
        "sold_value_1": "53.48",
        "sold_value_2": "0.0",
        "achievement_1": "68.45",
        "achievement_2": "68.45",
        "avg_sales_1": "4.86",
        "avg_sales_2": "4.86",
        "avg_sales_4p_1": "2.84",
        "avg_sales_4p_2": "0.0",
        "avg_sales_emr_1": "9.2",
        "avg_sales_emr_2": "0.0",
        "no_month_achiev_1": "1.0",
        "no_month_achiev_2": "0.0",
        "chemist_cov_1": "74.31",
        "chemist_cov_2": "0.0",
        "sales_achievement_base_point": "66.78",
        "av_rx_4p_base_point": "3.55",
        "av_rx_emr_base_point": "8.92",
        "ach_chemist_cov_base_point": "77.14",
        "exam_performance_base_point": "",
        "no_ach_month_base_point": "0.0",
        "no_letter_issued": "",
        "cause": "",
        "action": "",
        "no_incidence": "",
        "sales_achievement_full_points": "280",
        "av_rx_4p_full_points": "40",
        "av_rx_emr_full_points": "40",
        "ach_chemist_cov_full_points": "10",
        "exam_performance_full_points": "5",
        "no_ach_month_full_points": "5",
        "honesty_full_points": "5",
        "discip_full_points": "5",
        "skill_full_points": "5",
        "quality_sales_full_points": "5"
      },
      {
        "cid": "SKF",
        "employee_id": "19709",
        "emp_name": "MR. MD. NURUZZAMAN",
        "designation": "Medical Services Officer",
        "present_grade": "O-01",
        "business_segment": "Formulation",
        "date_of_joining": "15-Dec-20",
        "last_promotion": "N/A",
        "length_of_service": "2Y 9M",
        "tr_code": "DS23A",
        "base_territory":
            "DNMI (SKIN, SURGERY, DENTAL, CARDIOLIGY OUTDOOR,INDOOR,SURGERY MALE OUTDOOR ), ASGAR ALI HOSPITAL,ENGLISH ROAD, POPULAR DIAGNOSTIC CENTER, GANDARIA, NARINDA",
        "length_of_present_tr_service": "2Y  9M ",
        "target_value_1": "78.13",
        "target_value_2": "0.0",
        "sold_value_1": "53.48",
        "sold_value_2": "0.0",
        "achievement_1": "68.45",
        "achievement_2": "68.45",
        "avg_sales_1": "4.86",
        "avg_sales_2": "4.86",
        "avg_sales_4p_1": "2.84",
        "avg_sales_4p_2": "0.0",
        "avg_sales_emr_1": "9.2",
        "avg_sales_emr_2": "0.0",
        "no_month_achiev_1": "1.0",
        "no_month_achiev_2": "0.0",
        "chemist_cov_1": "74.31",
        "chemist_cov_2": "0.0",
        "sales_achievement_base_point": "66.78",
        "av_rx_4p_base_point": "3.55",
        "av_rx_emr_base_point": "8.92",
        "ach_chemist_cov_base_point": "77.14",
        "exam_performance_base_point": "",
        "no_ach_month_base_point": "0.0",
        "no_letter_issued": "",
        "cause": "",
        "action": "",
        "no_incidence": "",
        "sales_achievement_full_points": "280",
        "av_rx_4p_full_points": "40",
        "av_rx_emr_full_points": "40",
        "ach_chemist_cov_full_points": "10",
        "exam_performance_full_points": "5",
        "no_ach_month_full_points": "5",
        "honesty_full_points": "5",
        "discip_full_points": "5",
        "skill_full_points": "5",
        "quality_sales_full_points": "5"
      },
      {
        "cid": "SKF",
        "employee_id": "19709",
        "emp_name": "MR. MD. NURUZZAMAN",
        "designation": "Medical Services Officer",
        "present_grade": "O-01",
        "business_segment": "Formulation",
        "date_of_joining": "15-Dec-20",
        "last_promotion": "N/A",
        "length_of_service": "2Y 9M",
        "tr_code": "DS23A",
        "base_territory":
            "DNMI (SKIN, SURGERY, DENTAL, CARDIOLIGY OUTDOOR,INDOOR,SURGERY MALE OUTDOOR ), ASGAR ALI HOSPITAL,ENGLISH ROAD, POPULAR DIAGNOSTIC CENTER, GANDARIA, NARINDA",
        "length_of_present_tr_service": "2Y  9M ",
        "target_value_1": "78.13",
        "target_value_2": "0.0",
        "sold_value_1": "53.48",
        "sold_value_2": "0.0",
        "achievement_1": "68.45",
        "achievement_2": "68.45",
        "avg_sales_1": "4.86",
        "avg_sales_2": "4.86",
        "avg_sales_4p_1": "2.84",
        "avg_sales_4p_2": "0.0",
        "avg_sales_emr_1": "9.2",
        "avg_sales_emr_2": "0.0",
        "no_month_achiev_1": "1.0",
        "no_month_achiev_2": "0.0",
        "chemist_cov_1": "74.31",
        "chemist_cov_2": "0.0",
        "sales_achievement_base_point": "66.78",
        "av_rx_4p_base_point": "3.55",
        "av_rx_emr_base_point": "8.92",
        "ach_chemist_cov_base_point": "77.14",
        "exam_performance_base_point": "",
        "no_ach_month_base_point": "0.0",
        "no_letter_issued": "",
        "cause": "",
        "action": "",
        "no_incidence": "",
        "sales_achievement_full_points": "280",
        "av_rx_4p_full_points": "40",
        "av_rx_emr_full_points": "40",
        "ach_chemist_cov_full_points": "10",
        "exam_performance_full_points": "5",
        "no_ach_month_full_points": "5",
        "honesty_full_points": "5",
        "discip_full_points": "5",
        "skill_full_points": "5",
        "quality_sales_full_points": "5"
      }
    ]
  }
};
