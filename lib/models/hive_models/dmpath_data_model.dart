// To parse this JSON data, do
//
//     final dmPathDataModel = dmPathDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'dmpath_data_model.g.dart';

DmPathDataModel dmPathDataModelFromJson(String str) =>
    DmPathDataModel.fromJson(json.decode(str));

String dmPathDataModelToJson(DmPathDataModel data) =>
    json.encode(data.toJson());

@HiveType(typeId: 10)
class DmPathDataModel extends HiveObject {
  DmPathDataModel({
    required this.loginUrl,
    required this.syncUrl,
    required this.photoUrl,
    required this.submitUrl,
    required this.photoSubmitUrl,
    required this.reportSalesUrl,
    required this.reportDcrUrl,
    required this.reportRxUrl,
    required this.userAreaUrl,
    required this.clientUrl,
    required this.doctorUrl,
    required this.leaveRequestUrl,
    required this.leaveReportUrl,
    required this.pluginUrl,
    required this.tourPlanUrl,
    required this.tourComplianceUrl,
    required this.activityLogUrl,
    required this.clientOutstUrl,
    required this.userSalesCollAchUrl,
    required this.osDetailsUrl,
    required this.ordHistoryUrl,
    required this.invHistoryUrl,
    required this.clientEditUrl,
    required this.timerTrackUrl,
    required this.expTypeUrl,
    required this.expSubmitUrl,
    required this.reportExpUrl,
    required this.expApprovalUrl,
    required this.reportOutstUrl,
    required this.reportLastOrdUrl,
    required this.reportLastInvUrl,
    required this.syncNoticeUrl,
    required this.reportAttenUrl,
  });
  @HiveField(0)
  final String loginUrl;
  @HiveField(1)
  final String syncUrl;
  @HiveField(2)
  final String photoUrl;
  @HiveField(3)
  final String submitUrl;
  @HiveField(4)
  final String photoSubmitUrl;
  @HiveField(5)
  final String reportSalesUrl;
  @HiveField(6)
  final String reportDcrUrl;
  @HiveField(7)
  final String reportRxUrl;
  @HiveField(8)
  final String userAreaUrl;
  @HiveField(9)
  final String clientUrl;
  @HiveField(10)
  final String doctorUrl;
  @HiveField(11)
  final String leaveRequestUrl;
  @HiveField(12)
  final String leaveReportUrl;
  @HiveField(13)
  final String pluginUrl;
  @HiveField(14)
  final String tourPlanUrl;
  @HiveField(15)
  final String tourComplianceUrl;
  @HiveField(16)
  final String activityLogUrl;
  @HiveField(17)
  final String clientOutstUrl;
  @HiveField(18)
  final String userSalesCollAchUrl;
  @HiveField(19)
  final String osDetailsUrl;
  @HiveField(20)
  final String ordHistoryUrl;
  @HiveField(21)
  final String invHistoryUrl;
  @HiveField(22)
  final String clientEditUrl;
  @HiveField(23)
  final String timerTrackUrl;
  @HiveField(24)
  final String expTypeUrl;
  @HiveField(25)
  final String expSubmitUrl;
  @HiveField(26)
  final String reportExpUrl;
  @HiveField(27)
  final String expApprovalUrl;
  @HiveField(28)
  final String reportOutstUrl;
  @HiveField(29)
  final String reportLastOrdUrl;
  @HiveField(30)
  final String reportLastInvUrl;
  @HiveField(31)
  final String syncNoticeUrl;
  @HiveField(32)
  final String reportAttenUrl;
  @HiveField(33)
  factory DmPathDataModel.fromJson(Map<String, dynamic> json) =>
      DmPathDataModel(
        loginUrl: json["login_url"],
        syncUrl: json["sync_url"],
        photoUrl: json["photo_url"],
        submitUrl: json["submit_url"],
        photoSubmitUrl: json["photo_submit_url"],
        reportSalesUrl: json["report_sales_url"],
        reportDcrUrl: json["report_dcr_url"],
        reportRxUrl: json["report_rx_url"],
        userAreaUrl: json["user_area_url"],
        clientUrl: json["client_url"],
        doctorUrl: json["doctor_url"],
        leaveRequestUrl: json["leave_request_url"],
        leaveReportUrl: json["leave_report_url"],
        pluginUrl: json["plugin_url"],
        tourPlanUrl: json["tour_plan_url"],
        tourComplianceUrl: json["tour_compliance_url"],
        activityLogUrl: json["activity_log_url"],
        clientOutstUrl: json["client_outst_url"],
        userSalesCollAchUrl: json["user_sales_coll_ach_url"],
        osDetailsUrl: json["os_details_url"],
        ordHistoryUrl: json["ord_history_url"],
        invHistoryUrl: json["inv_history_url"],
        clientEditUrl: json["client_edit_url"],
        timerTrackUrl: json["timer_track_url"],
        expTypeUrl: json["exp_type_url"],
        expSubmitUrl: json["exp_submit_url"],
        reportExpUrl: json["report_exp_url"],
        expApprovalUrl: json["exp_approval_url"],
        reportOutstUrl: json["report_outst_url"],
        reportLastOrdUrl: json["report_last_ord_url"],
        reportLastInvUrl: json["report_last_inv_url"],
        syncNoticeUrl: json["sync_notice_url"],
        reportAttenUrl: json["report_atten_url"],
      );

  Map<String, dynamic> toJson() => {
        "login_url": loginUrl,
        "sync_url": syncUrl,
        "photo_url": photoUrl,
        "submit_url": submitUrl,
        "photo_submit_url": photoSubmitUrl,
        "report_sales_url": reportSalesUrl,
        "report_dcr_url": reportDcrUrl,
        "report_rx_url": reportRxUrl,
        "user_area_url": userAreaUrl,
        "client_url": clientUrl,
        "doctor_url": doctorUrl,
        "leave_request_url": leaveRequestUrl,
        "leave_report_url": leaveReportUrl,
        "plugin_url": pluginUrl,
        "tour_plan_url": tourPlanUrl,
        "tour_compliance_url": tourComplianceUrl,
        "activity_log_url": activityLogUrl,
        "client_outst_url": clientOutstUrl,
        "user_sales_coll_ach_url": userSalesCollAchUrl,
        "os_details_url": osDetailsUrl,
        "ord_history_url": ordHistoryUrl,
        "inv_history_url": invHistoryUrl,
        "client_edit_url": clientEditUrl,
        "timer_track_url": timerTrackUrl,
        "exp_type_url": expTypeUrl,
        "exp_submit_url": expSubmitUrl,
        "report_exp_url": reportExpUrl,
        "exp_approval_url": expApprovalUrl,
        "report_outst_url": reportOutstUrl,
        "report_last_ord_url": reportLastOrdUrl,
        "report_last_inv_url": reportLastInvUrl,
        "sync_notice_url": syncNoticeUrl,
        "report_atten_url": reportAttenUrl,
      };
}
