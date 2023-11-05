import 'package:meta/meta.dart';
import 'dart:convert';

AppraisalDetailsModel appraisalDetailsModelFromJson(String str) =>
    AppraisalDetailsModel.fromJson(json.decode(str));

class AppraisalDetailsModel {
  final ResData resData;

  AppraisalDetailsModel({
    required this.resData,
  });

  factory AppraisalDetailsModel.fromJson(Map<String, dynamic> json) =>
      AppraisalDetailsModel(
        resData: ResData.fromJson(json["res_data"]),
      );
}

class ResData {
  final String status;
  final String supLevelDepthNo;
  final List<RestModel> retStr;

  ResData({
    required this.status,
    required this.supLevelDepthNo,
    required this.retStr,
  });

  factory ResData.fromJson(Map<String, dynamic> json) => ResData(
        status: json["status"],
        supLevelDepthNo: json["sup_level_depth_no"],
        retStr: List<RestModel>.from(
            json["ret_str"].map((x) => RestModel.fromJson(x))),
      );
}

class RestModel {
  final String cid;
  final String employeeId;
  final String empName;
  final String designation;
  final String presentGrade;
  final String businessSegment;
  final String dateOfJoining;
  final String lastPromotion;
  final String lengthOfService;
  final String trCode;
  final String baseTerritory;
  final String lengthOfPresentTrService;
  final String targetValue1;
  final String targetValue2;
  final String soldValue1;
  final String soldValue2;
  final String achievement1;
  final String achievement2;
  final String avgSales1;
  final String avgSales2;
  final String avgSales4p1;
  final String avgSales4p2;
  final String avgSalesEmr1;
  final String avgSalesEmr2;
  final String avgRxGrowth;
  final String noMonthAchiev1;
  final String noMonthAchiev2;
  final String chemistCov1;
  final String chemistCov2;
  final String salesAchievementBasePoint;
  final String avRx4pBasePoint;
  final String avRxEmrBasePoint;
  final String achChemistCovBasePoint;
  final String examPerformanceBasePoint;
  final String noAchMonthBasePoint;
  final String noLetterIssued;
  final String cause;
  final String action;
  final String noIncidence;
  final String salesAchievementFullPoints;
  final String avRx4pFullPoints;
  final String avRxEmrFullPoints;
  final String achChemistCovFullPoints;
  final String examPerformanceFullPoints;
  final String noAchMonthFullPoints;
  final String honestyFullPoints;
  final String discipFullPoints;
  final String skillFullPoints;
  final String qualitySalesFullPoints;
  final String previousAchievement;
  final String currentAchievement;

  RestModel({
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
    required this.targetValue1,
    required this.targetValue2,
    required this.soldValue1,
    required this.soldValue2,
    required this.achievement1,
    required this.achievement2,
    required this.avgSales1,
    required this.avgSales2,
    required this.avgSales4p1,
    required this.avgSales4p2,
    required this.avgSalesEmr1,
    required this.avgSalesEmr2,
    required this.avgRxGrowth,
    required this.noMonthAchiev1,
    required this.noMonthAchiev2,
    required this.chemistCov1,
    required this.chemistCov2,
    required this.salesAchievementBasePoint,
    required this.avRx4pBasePoint,
    required this.avRxEmrBasePoint,
    required this.achChemistCovBasePoint,
    required this.examPerformanceBasePoint,
    required this.noAchMonthBasePoint,
    required this.noLetterIssued,
    required this.cause,
    required this.action,
    required this.noIncidence,
    required this.salesAchievementFullPoints,
    required this.avRx4pFullPoints,
    required this.avRxEmrFullPoints,
    required this.achChemistCovFullPoints,
    required this.examPerformanceFullPoints,
    required this.noAchMonthFullPoints,
    required this.honestyFullPoints,
    required this.discipFullPoints,
    required this.skillFullPoints,
    required this.qualitySalesFullPoints,
    required this.previousAchievement,
    required this.currentAchievement,
  });

  factory RestModel.fromJson(Map<String, dynamic> json) {
    return RestModel(
      cid: json['cid'] ?? '',
      employeeId: json['employee_id'] ?? '',
      empName: json['emp_name'] ?? '',
      designation: json['designation'] ?? '',
      presentGrade: json['present_grade'] ?? '',
      businessSegment: json['business_segment'] ?? '',
      dateOfJoining: json['date_of_joining'] ?? '',
      lastPromotion: json['last_promotion'] ?? '',
      lengthOfService: json['length_of_service'] ?? '',
      trCode: json['tr_code'] ?? '',
      baseTerritory: json['base_territory'] ?? '',
      lengthOfPresentTrService: json['length_of_present_tr_service'] ?? '',
      targetValue1: json['target_value_1'] ?? '',
      targetValue2: json['target_value_2'] ?? '',
      soldValue1: json['sold_value_1'] ?? '',
      soldValue2: json['sold_value_2'] ?? '',
      achievement1: json['achievement_1'] ?? '',
      achievement2: json['achievement_2'] ?? '',
      avgSales1: json['avg_sales_1'] ?? '',
      avgSales2: json['avg_sales_2'] ?? '',
      avgSales4p1: json['avg_sales_4p_1'] ?? '',
      avgSales4p2: json['avg_sales_4p_2'] ?? '',
      avgSalesEmr1: json['avg_sales_emr_1'] ?? '',
      avgSalesEmr2: json['avg_sales_emr_2'] ?? '',
      avgRxGrowth: json['avg_rx_growth'] ?? '',
      noMonthAchiev1: json['no_month_achiev_1'] ?? '',
      noMonthAchiev2: json['no_month_achiev_2'] ?? '',
      chemistCov1: json['chemist_cov_1'] ?? '',
      chemistCov2: json['chemist_cov_2'] ?? '',
      salesAchievementBasePoint: json['sales_achievement_base_point'] ?? '',
      avRx4pBasePoint: json['av_rx_4p_base_point'] ?? '',
      avRxEmrBasePoint: json['av_rx_emr_base_point'] ?? '',
      achChemistCovBasePoint: json['ach_chemist_cov_base_point'] ?? '',
      examPerformanceBasePoint: json['exam_performance_base_point'] ?? '',
      noAchMonthBasePoint: json['no_ach_month_base_point'] ?? '',
      noLetterIssued: json['no_letter_issued'] ?? '',
      cause: json['cause'] ?? '',
      action: json['action'] ?? '',
      noIncidence: json['no_incidence'] ?? '',
      salesAchievementFullPoints: json['sales_achievement_full_points'] ?? '',
      avRx4pFullPoints: json['av_rx_4p_full_points'] ?? '',
      avRxEmrFullPoints: json['av_rx_emr_full_points'] ?? '',
      achChemistCovFullPoints: json['ach_chemist_cov_full_points'] ?? '',
      examPerformanceFullPoints: json['exam_performance_full_points'] ?? '',
      noAchMonthFullPoints: json['no_ach_month_full_points'] ?? '',
      honestyFullPoints: json['honesty_full_points'] ?? '',
      discipFullPoints: json['discip_full_points'] ?? '',
      skillFullPoints: json['skill_full_points'] ?? '',
      qualitySalesFullPoints: json['quality_sales_full_points'] ?? '',
      previousAchievement: json['previous_achievement'] ?? '',
      currentAchievement: json['current_achievement'] ?? '',
    );
  }
}
