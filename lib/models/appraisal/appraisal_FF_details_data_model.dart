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
  final String? headRowId;
  final String? lastAction;
  final String? lastActionBy;
  final String? chemistCoverage;
  final String? brandPerformance;
  final String? rxShare;
  final String? upgradeGrade;
  final String? designationChange;
  final String? incrementAmount;
  final String? feedback;
  final String? kpiKey;
  final String? doctorCoverage;
  final String? salesAchievement;
  final String? previousAchievement;
  final String? currentAchievement;
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
  final String? soldValue1;
  final String? achievement1;
  final String? avgSales1;
  final String? avgSales4P1;
  final String? avgSalesEmr1;
  final String? noMonthAchiev1;
  final String? chemistCov1;
  final String? targetValue2;
  final String? soldValue2;
  final String? achievement2;
  final String? avgSales2;
  final String? avgSales4P2;
  final String? avgSalesEmr2;
  final String? noMonthAchiev2;
  final String? chemistCov2;
  final String? avRx4PBasePoint;
  final String? avRxEmrBasePoint;
  final String? achChemistCovBasePoint;
  final String? examPerformanceBasePoint;
  final String? noAchMonthBasePoint;
  final String? noLetterIssued;
  final String? cause;
  final String? action;
  final String? noIncidence;
  final String? avgRxGrowth;
  final String? seenRx;
  final String? incrementAmountSup;
  final String? designationChangeSup;
  final String? upgradeGradeSup;
  final String? feedbackSup;
  final List<KpiTable>? kpiTable;

  RetStr(
      {this.headRowId,
      this.lastAction,
      this.lastActionBy,
      this.chemistCoverage,
      this.brandPerformance,
      this.rxShare,
      this.upgradeGrade,
      this.designationChange,
      this.incrementAmount,
      this.feedback,
      this.kpiKey,
      this.doctorCoverage,
      this.salesAchievement,
      this.previousAchievement,
      this.currentAchievement,
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
      this.soldValue1,
      this.achievement1,
      this.avgSales1,
      this.avgSales4P1,
      this.avgSalesEmr1,
      this.noMonthAchiev1,
      this.chemistCov1,
      this.targetValue2,
      this.soldValue2,
      this.achievement2,
      this.avgSales2,
      this.avgSales4P2,
      this.avgSalesEmr2,
      this.noMonthAchiev2,
      this.chemistCov2,
      this.avRx4PBasePoint,
      this.avRxEmrBasePoint,
      this.achChemistCovBasePoint,
      this.examPerformanceBasePoint,
      this.noAchMonthBasePoint,
      this.noLetterIssued,
      this.cause,
      this.action,
      this.noIncidence,
      this.avgRxGrowth,
      this.incrementAmountSup,
      this.designationChangeSup,
      this.upgradeGradeSup,
      this.feedbackSup,
      this.kpiTable,
      this.seenRx});

  factory RetStr.fromJson(Map<String, dynamic> json) => RetStr(
        headRowId: json["head_row_id"],
        lastAction: json["last_action"],
        lastActionBy: json["last_action_by"],
        chemistCoverage: json["chemist_Coverage"],
        brandPerformance: json["brand_Performance"],
        rxShare: json["rx_share"],
        upgradeGrade: json["upgrade_grade"],
        designationChange: json["designation_change"],
        incrementAmount:
            double.parse(json["increment_amount"] ?? '0.0').toStringAsFixed(0),
        feedback: json["feedback"],
        kpiKey: json["kpi_key"],
        doctorCoverage: json["doctor_coverage"],
        salesAchievement: json["sales_achievement"],
        previousAchievement: json["previous_achievement"],
        currentAchievement: json["current_achievement"],
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
        targetValue1:
            double.parse(json["target_value_1"] ?? '0.0').toStringAsFixed(2),
        soldValue1:
            double.parse(json["sold_value_1"] ?? '0.0').toStringAsFixed(2),
        achievement1:
            double.parse(json["achievement_1"] ?? '0.0').toStringAsFixed(2),
        avgSales1:
            double.parse(json["avg_sales_1"] ?? '0.0').toStringAsFixed(2),
        avgSales4P1:
            double.parse(json["avg_sales_4p_1"] ?? '0.0').toStringAsFixed(2),
        avgSalesEmr1:
            double.parse(json["avg_sales_emr_1"] ?? '0.0').toStringAsFixed(2),
        noMonthAchiev1:
            double.parse(json["no_month_achiev_1"] ?? '0.0').toStringAsFixed(2),
        chemistCov1:
            double.parse(json["chemist_cov_1"] ?? '0.0').toStringAsFixed(2),
        targetValue2:
            double.parse(json["target_value_2"] ?? '0.0').toStringAsFixed(2),
        soldValue2:
            double.parse(json["sold_value_2"] ?? '0.0').toStringAsFixed(2),
        achievement2:
            double.parse(json["achievement_2"] ?? '0.0').toStringAsFixed(2),
        avgSales2:
            double.parse(json["avg_sales_2"] ?? '0.0').toStringAsFixed(2),
        avgSales4P2:
            double.parse(json["avg_sales_4p_2"] ?? '0.0').toStringAsFixed(2),
        avgSalesEmr2:
            double.parse(json["avg_sales_emr_2"] ?? '0.0').toStringAsFixed(2),
        noMonthAchiev2:
            double.parse(json["no_month_achiev_2"] ?? '0.0').toStringAsFixed(2),
        chemistCov2:
            double.parse(json["chemist_cov_2"] ?? '0.0').toStringAsFixed(2),
        avRx4PBasePoint: json["av_rx_4p_base_point"],
        avRxEmrBasePoint: json["av_rx_emr_base_point"],
        achChemistCovBasePoint: json["ach_chemist_cov_base_point"],
        examPerformanceBasePoint: json["exam_performance_base_point"],
        noAchMonthBasePoint: json["no_ach_month_base_point"],
        noLetterIssued: json["no_letter_issued"],
        cause: json["cause"],
        action: json["action"],
        noIncidence: json["no_incidence"],
        avgRxGrowth:
            double.parse(json["avg_rx_growth"] ?? '0.0').toStringAsFixed(2),
        seenRx: double.parse(json["seen_rx"] ?? '0.0').toStringAsFixed(2),
        incrementAmountSup: double.parse(json["increment_amount_sup"] ?? '0.00')
            .toStringAsFixed(0),
        designationChangeSup: json["designation_change_sup"],
        upgradeGradeSup: json["upgrade_grade_sup"],
        feedbackSup: json["feedback_sup"],
        kpiTable: json["kpi_table"] == null
            ? []
            : List<KpiTable>.from(
                json["kpi_table"]!.map((x) => KpiTable.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "head_row_id": headRowId,
        "last_action": lastAction,
        "last_action_by": lastActionBy,
        "chemist_Coverage": chemistCoverage,
        "brand_Performance": brandPerformance,
        "rx_share": rxShare,
        "upgrade_grade": upgradeGrade,
        "designation_change": designationChange,
        "increment_amount": incrementAmount,
        "feedback": feedback,
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
        "seen_rx": seenRx,
        "increment_amount_sup": incrementAmountSup,
        "designation_change_sup": designationChangeSup,
        "upgrade_grade_sup": upgradeGradeSup,
        "feedback_sup": feedbackSup,
        "kpi_table": kpiTable == null
            ? []
            : List<dynamic>.from(kpiTable!.map((x) => x.toJson())),
      };
}

class KpiTable {
  final String? rowId;
  final String? sl;
  final String? kpiId;
  final String? name;
  final String? definition;
  final String? definitionHead;
  final String? weightage;
  final String? kpiEdit;
  final String? selfScore;
  final String? selfOverallScore;
  final String? supScore;
  final String? supOverallScore;

  KpiTable({
    this.rowId,
    this.sl,
    this.kpiId,
    this.name,
    this.definition,
    this.definitionHead,
    this.weightage,
    this.kpiEdit,
    this.selfScore,
    this.selfOverallScore,
    this.supScore,
    this.supOverallScore,
  });

  factory KpiTable.fromJson(Map<String, dynamic> json) => KpiTable(
        rowId: json["row_id"],
        sl: json["sl"],
        kpiId: json["kpi_id"],
        name: json["name"],
        definition: json["definition"],
        definitionHead: json["definition_head"],
        weightage: json["weightage"],
        kpiEdit: json["kpi_edit"],
        selfScore: json["self_score"],
        selfOverallScore:
            double.parse(json["self_overall_score"]).toStringAsFixed(2),
        supScore: json["sup_score"],
        supOverallScore:
            double.parse(json["sup_overall_score"]).toStringAsFixed(2),
      );

  Map<String, dynamic> toJson() => {
        "row_id": rowId,
        "sl": sl,
        "kpi_id": kpiId,
        "name": name,
        "definition": definition,
        "weightage": weightage,
        "kpi_edit": kpiEdit,
        "self_score": selfScore,
        "self_overall_score": selfOverallScore,
        "sup_score": supScore,
        "sup_overall_score": supOverallScore,
      };
}

var fFDetailsJson = {
  "res_data": {
    "status": "Success",
    "sup_level_depth_no": "1",
    "ret_str": [
      {
        "head_row_id": "6",
        "last_action": "SUBMITTED_MSO",
        "last_action_by": "5092",
        "chemist_Coverage": "76.12",
        "brand_Performance": "0.0",
        "rx_share": "34.62",
        "upgrade_grade": "0",
        "designation_change": "1",
        "increment_amount": "2000",
        "feedback": "Hafizur Rahman",
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
        "seen_rx": "67401",
        "kpi_table": [
          {
            "row_id": "5",
            "sl": "1",
            "kpi_id": "sales_achievement",
            "name": "Sales Achievement",
            "definition": "Jan-Dec 2023",
            "weightage": "40.0",
            "kpi_edit": "NO",
            "self_score": "3.0",
            "self_overall_score": "1.2",
            "sup_score": "3.0",
            "sup_overall_score": "1.2"
          },
          {
            "row_id": "6",
            "sl": "2",
            "kpi_id": "doctor_coverage",
            "name": "Doctor Coverage",
            "definition": "1st April 2023 Onwards",
            "weightage": "10.0",
            "kpi_edit": "NO",
            "self_score": "2.0",
            "self_overall_score": "0.2",
            "sup_score": "2.0",
            "sup_overall_score": "0.2"
          },
          {
            "row_id": "7",
            "sl": "3",
            "kpi_id": "rx_share",
            "name": "Rx Share (Seen Rx, 4P, EMR)",
            "definition": "Average of three parameters",
            "weightage": "10.0",
            "kpi_edit": "NO",
            "self_score": "1.0",
            "self_overall_score": "0.1",
            "sup_score": "1.0",
            "sup_overall_score": "0.1"
          },
          {
            "row_id": "8",
            "sl": "4",
            "kpi_id": "brand_Performance",
            "name": "Brand Performance (Sales)",
            "definition":
                "Double Power Brands\nLeading Power Brands\nChasing Power Brands\nNew Power Brands\n\n1st April 2023 Onwards ",
            "weightage": "5.0",
            "kpi_edit": "NO",
            "self_score": "1.0",
            "self_overall_score": "0.05",
            "sup_score": "1.0",
            "sup_overall_score": "0.05"
          },
          {
            "row_id": "9",
            "sl": "5",
            "kpi_id": "chemist_Coverage",
            "name": "Chemist Coverage",
            "definition": "Jan-Dec 2023",
            "weightage": "5.0",
            "kpi_edit": "NO",
            "self_score": "1.0",
            "self_overall_score": "0.05",
            "sup_score": "1.0",
            "sup_overall_score": "0.05"
          },
          {
            "row_id": "10",
            "sl": "6",
            "kpi_id": "product_knowledge_and_details_skills",
            "name": "Product Knowledge and Detailing Skills",
            "definition": "",
            "weightage": "5.0",
            "kpi_edit": "NO",
            "self_score": "1.0",
            "self_overall_score": "0.05",
            "sup_score": "1.0",
            "sup_overall_score": "0.05"
          },
          {
            "row_id": "11",
            "sl": "7",
            "kpi_id": "PSD_GSD_Relationship",
            "name": "PSD, GSD Relationship",
            "definition":
                "Need Drop Down Box for\n- Very Good (10%)\n- Good (7%)\n- Need Improvement (4%)\n\nDefinition:\n- Weekly coverage (2 Calls)\n- Rx from PSD GSD \n- Number of Doctor",
            "weightage": "10.0",
            "kpi_edit": "YES",
            "self_score": "2.0",
            "self_overall_score": "0.2",
            "sup_score": "2.0",
            "sup_overall_score": "0.2"
          },
          {
            "row_id": "12",
            "sl": "8",
            "kpi_id": "market_Involvement",
            "name": "Market Involvement and Degree of Drive ",
            "definition":
                "Definition:\n- Market Coverage including Doctor & Chemist\n- Regular Initiatives by MSO to full fill his monthly targets",
            "weightage": "5.0",
            "kpi_edit": "YES",
            "self_score": "3.0",
            "self_overall_score": "0.15",
            "sup_score": "3.0",
            "sup_overall_score": "0.15"
          },
          {
            "row_id": "13",
            "sl": "9",
            "kpi_id": "pair_Co_ordination_and_Discipline",
            "name": "Pair Co-ordination and Discipline",
            "definition":
                "Definition:\n- Coordination among teams (A, B, C)\n- Time management\n- Absenteeism\n- Honesty & Integrity\ni. m-Reporting\nii. Resource Utilization (DSR, Gift, Sample, Literature)\niii. Working Authenticity",
            "weightage": "5.0",
            "kpi_edit": "YES",
            "self_score": "1.0",
            "self_overall_score": "0.05",
            "sup_score": "1.0",
            "sup_overall_score": "0.05"
          },
          {
            "row_id": "14",
            "sl": "10",
            "kpi_id": "special_Activities",
            "name": "Special Activities for Doctors and Chemists",
            "definition": "",
            "weightage": "5.0",
            "kpi_edit": "YES",
            "self_score": "3.0",
            "self_overall_score": "0.15",
            "sup_score": "3.0",
            "sup_overall_score": "0.15"
          }
        ]
      }
    ]
  }
};

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
