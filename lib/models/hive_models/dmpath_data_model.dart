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
    required this.doctorEditUrl,
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
    required this.doctorAddUrl,
    required this.doctorEditSubmitUrl,
    required this.reportPromoApUrl,
    required this.reportPromoUrl,
    required this.reportStockUrl,
    required this.reportUserDepotUrl,
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
  final String doctorEditUrl;
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
  final String doctorAddUrl;
  @HiveField(34)
  final String doctorEditSubmitUrl;
  //added new field at 02-04-2023
  @HiveField(35)
  final String reportPromoApUrl;
  @HiveField(36)
  final String reportPromoUrl;
  @HiveField(37)
  final String reportStockUrl;
  @HiveField(38)
  final String reportUserDepotUrl;
  //end

  factory DmPathDataModel.fromJson(Map<String, dynamic> json) =>
      DmPathDataModel(
        leaveRequestUrl: json["leave_request_url"],
        reportAttenUrl: json["report_atten_url"],
        reportLastInvUrl: json["report_last_inv_url"],
        loginUrl: json["login_url"],
        reportSalesUrl: json["report_sales_url"],
        clientUrl: json["client_url"],
        userAreaUrl: json["user_area_url"],
        doctorEditUrl: json["doctor_edit_url"],
        tourPlanUrl: json["tour_plan_url"],
        reportDcrUrl: json["report_dcr_url"],
        clientEditUrl: json["client_edit_url"],
        syncNoticeUrl: json["sync_notice_url"],
        userSalesCollAchUrl: json["user_sales_coll_ach_url"],
        reportLastOrdUrl: json["report_last_ord_url"],
        reportExpUrl: json["report_exp_url"],
        clientOutstUrl: json["client_outst_url"],
        photoUrl: json["photo_url"],
        reportRxUrl: json["report_rx_url"],
        osDetailsUrl: json["os_details_url"],
        reportOutstUrl: json["report_outst_url"],
        doctorAddUrl: json["doctor_add_url"],
        timerTrackUrl: json["timer_track_url"],
        leaveReportUrl: json["leave_report_url"],
        expTypeUrl: json["exp_type_url"],
        activityLogUrl: json["activity_log_url"],
        syncUrl: json["sync_url"],
        submitUrl: json["submit_url"],
        ordHistoryUrl: json["ord_history_url"],
        expSubmitUrl: json["exp_submit_url"],
        pluginUrl: json["plugin_url"],
        invHistoryUrl: json["inv_history_url"],
        photoSubmitUrl: json["photo_submit_url"],
        expApprovalUrl: json["exp_approval_url"],
        tourComplianceUrl: json["tour_compliance_url"],
        doctorEditSubmitUrl: json["doctor_edit_submit_url"],
        reportPromoApUrl: json["report_promo_ap_url"],
        reportPromoUrl: json["report_promo_url"],
        reportStockUrl: json["report_stock_url"],
        reportUserDepotUrl: json["report_user_depot_url"],
      );

  Map<String, dynamic> toJson() => {
        "leave_request_url": leaveRequestUrl,
        "report_atten_url": reportAttenUrl,
        "report_last_inv_url": reportLastInvUrl,
        "login_url": loginUrl,
        "report_sales_url": reportSalesUrl,
        "client_url": clientUrl,
        "user_area_url": userAreaUrl,
        "doctor_edit_url": doctorEditUrl,
        "tour_plan_url": tourPlanUrl,
        "report_dcr_url": reportDcrUrl,
        "client_edit_url": clientEditUrl,
        "sync_notice_url": syncNoticeUrl,
        "user_sales_coll_ach_url": userSalesCollAchUrl,
        "report_last_ord_url": reportLastOrdUrl,
        "report_exp_url": reportExpUrl,
        "client_outst_url": clientOutstUrl,
        "photo_url": photoUrl,
        "report_rx_url": reportRxUrl,
        "os_details_url": osDetailsUrl,
        "report_outst_url": reportOutstUrl,
        "doctor_add_url": doctorAddUrl,
        "timer_track_url": timerTrackUrl,
        "leave_report_url": leaveReportUrl,
        "exp_type_url": expTypeUrl,
        "activity_log_url": activityLogUrl,
        "sync_url": syncUrl,
        "submit_url": submitUrl,
        "ord_history_url": ordHistoryUrl,
        "exp_submit_url": expSubmitUrl,
        "plugin_url": pluginUrl,
        "inv_history_url": invHistoryUrl,
        "photo_submit_url": photoSubmitUrl,
        "exp_approval_url": expApprovalUrl,
        "tour_compliance_url": tourComplianceUrl,
        "doctor_edit_submit_url": doctorEditSubmitUrl,
        "report_promo_ap_url": reportPromoApUrl,
        "report_promo_url": reportPromoUrl,
        "report_stock_url": reportStockUrl,
        "report_user_depot_url": reportUserDepotUrl,
      };
}
