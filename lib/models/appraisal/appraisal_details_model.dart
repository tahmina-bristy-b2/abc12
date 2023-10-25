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
  final DateTime dateOfJoining;
  final String lastPromotion;
  final String lengthOfService;
  final String trCode;
  final String baseTerritory;
  final String lengthOfPresentTrService;
  final String field11;
  final String salesAchievement;
  final String doctorCoverage;
  final String seenRx;
  final String fourP;
  final String emr;
  final String result1;
  final String result2;
  final String result3;
  final String result4;
  final String field22;
  final String esoralMups;
  final String losectil;
  final String ostocalG;
  final String biltin;
  final String nabument;
  final String facid;
  final String lulizol;
  final String etorix;
  final String flucloxin;
  final String norium;
  final String reelife;
  final String roxim;
  final String kefuclav;
  final String solbion;
  final String pg;
  final String productKnowledgeAndDetailsSkills;
  final String field44;
  final String numberOfAchievementMsos;
  final String creditManagement;
  final String field55;
  final String productivityGrowth;

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
    required this.field11,
    required this.salesAchievement,
    required this.doctorCoverage,
    required this.seenRx,
    required this.fourP,
    required this.emr,
    required this.result1,
    required this.result2,
    required this.result3,
    required this.result4,
    required this.field22,
    required this.esoralMups,
    required this.losectil,
    required this.ostocalG,
    required this.biltin,
    required this.nabument,
    required this.facid,
    required this.lulizol,
    required this.etorix,
    required this.flucloxin,
    required this.norium,
    required this.reelife,
    required this.roxim,
    required this.kefuclav,
    required this.solbion,
    required this.pg,
    required this.productKnowledgeAndDetailsSkills,
    required this.field44,
    required this.numberOfAchievementMsos,
    required this.creditManagement,
    required this.field55,
    required this.productivityGrowth,
  });

  factory RestModel.fromJson(Map<String, dynamic> json) => RestModel(
        cid: json["cid"],
        employeeId: json["employee_id"],
        empName: json["emp_name"],
        designation: json["designation"],
        presentGrade: json["present_grade"],
        businessSegment: json["business_segment"],
        dateOfJoining: DateTime.parse(json["date_of_joining"]),
        lastPromotion: json["last_promotion"],
        lengthOfService: json["length_of_service"],
        trCode: json["tr_code"],
        baseTerritory: json["base_territory"],
        lengthOfPresentTrService: json["length_of_present_tr_service"],
        field11: json["field_11"],
        salesAchievement: json["sales_achievement"],
        doctorCoverage: json["doctor_coverage"],
        seenRx: json["seen_rx"],
        fourP: json["four_p"],
        emr: json["emr"],
        result1: json["result_1"],
        result2: json["result_2"],
        result3: json["result_3"],
        result4: json["result_4"],
        field22: json["field_22"],
        esoralMups: json["esoral_mups"],
        losectil: json["losectil"],
        ostocalG: json["ostocal_g"],
        biltin: json["biltin"],
        nabument: json["nabument"],
        facid: json["facid"],
        lulizol: json["lulizol"],
        etorix: json["etorix"],
        flucloxin: json["flucloxin"],
        norium: json["norium"],
        reelife: json["reelife"],
        roxim: json["roxim"],
        kefuclav: json["kefuclav"],
        solbion: json["solbion"],
        pg: json["pg"],
        productKnowledgeAndDetailsSkills:
            json["product_knowledge_and_details_skills"],
        field44: json["field_44"],
        numberOfAchievementMsos: json["number_of_achievement_msos"],
        creditManagement: json["credit_management"],
        field55: json["field_55"],
        productivityGrowth: json["productivity_growth"],
      );

  Map<String, dynamic> toJson() => {
        "cid": cid,
        "employee_id": employeeId,
        "emp_name": empName,
        "designation": designation,
        "present_grade": presentGrade,
        "business_segment": businessSegment,
        "date_of_joining":
            "${dateOfJoining.year.toString().padLeft(4, '0')}-${dateOfJoining.month.toString().padLeft(2, '0')}-${dateOfJoining.day.toString().padLeft(2, '0')}",
        "last_promotion": lastPromotion,
        "length_of_service": lengthOfService,
        "tr_code": trCode,
        "base_territory": baseTerritory,
        "length_of_present_tr_service": lengthOfPresentTrService,
        "field_11": field11,
        "sales_achievement": salesAchievement,
        "doctor_coverage": doctorCoverage,
        "seen_rx": seenRx,
        "four_p": fourP,
        "emr": emr,
        "result_1": result1,
        "result_2": result2,
        "result_3": result3,
        "result_4": result4,
        "field_22": field22,
        "esoral_mups": esoralMups,
        "losectil": losectil,
        "ostocal_g": ostocalG,
        "biltin": biltin,
        "nabument": nabument,
        "facid": facid,
        "lulizol": lulizol,
        "etorix": etorix,
        "flucloxin": flucloxin,
        "norium": norium,
        "reelife": reelife,
        "roxim": roxim,
        "kefuclav": kefuclav,
        "solbion": solbion,
        "pg": pg,
        "product_knowledge_and_details_skills":
            productKnowledgeAndDetailsSkills,
        "field_44": field44,
        "number_of_achievement_msos": numberOfAchievementMsos,
        "credit_management": creditManagement,
        "field_55": field55,
        "productivity_growth": productivityGrowth,
      };
}
