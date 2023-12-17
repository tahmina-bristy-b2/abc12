// To parse this JSON data, do
//
//     final userLoginModel = userLoginModelFromJson(jsonString);

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
part 'login_user_model.g.dart';

UserLoginModel userLoginModelFromJson(String str) =>
    UserLoginModel.fromJson(json.decode(str));

String userLoginModelToJson(UserLoginModel data) => json.encode(data.toJson());

@HiveType(typeId: 6)
class UserLoginModel extends HiveObject {
  UserLoginModel(
      {required this.status,
      required this.userId,
      required this.userName,
      required this.mobileNo,
      required this.areaPage,
      required this.orderFlag,
      required this.osShowFlag,
      required this.osDetailsFlag,
      required this.ordHistoryFlag,
      required this.invHistroyFlag,
      required this.dcrFlag,
      required this.rxFlag,
      required this.othersFlag,
      required this.visitPlanFlag,
      required this.plaginFlag,
      required this.offerFlag,
      required this.noteFlag,
      required this.dcrVisitWith,
      required this.dcrVisitWithList,
      required this.rxDocMust,
      required this.rxTypeMust,
      required this.rxGalleryAllow,
      required this.rxTypeList,
      required this.userSalesAchFlag,
      required this.clientFlag,
      required this.clientEditFlag,
      required this.timerFlag,
      required this.dcrDiscussion,
      required this.promoFlag,
      required this.leaveFlag,
      required this.noticeFlag,
      required this.docFlag,
      required this.docEditFlag,
      this.userLevelDepth,
      this.edsrFlag,
      this.edsrApprovalFlag,
      this.appraisalFlag,
      this.appraisalApprovalFlag});
  @HiveField(0)
  final String status;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final String userName;
  @HiveField(4)
  final String mobileNo;
  @HiveField(5)
  final bool areaPage;
  @HiveField(6)
  final bool orderFlag;
  @HiveField(7)
  final bool osShowFlag;
  @HiveField(8)
  final bool osDetailsFlag;
  @HiveField(9)
  final bool ordHistoryFlag;
  @HiveField(10)
  final bool invHistroyFlag;
  @HiveField(11)
  final bool dcrFlag;
  @HiveField(12)
  final bool rxFlag;
  @HiveField(13)
  final bool othersFlag;
  @HiveField(14)
  final bool visitPlanFlag;
  @HiveField(15)
  final bool plaginFlag;
  @HiveField(16)
  final bool offerFlag;
  @HiveField(17)
  final bool noteFlag;
  @HiveField(18)
  final bool dcrVisitWith;
  @HiveField(19)
  final List<String> dcrVisitWithList;
  @HiveField(20)
  final bool rxDocMust;
  @HiveField(21)
  final bool rxTypeMust;
  @HiveField(22)
  final bool rxGalleryAllow;
  @HiveField(23)
  final List<String> rxTypeList;
  @HiveField(24)
  final bool userSalesAchFlag;
  @HiveField(25)
  final bool clientFlag;
  @HiveField(26)
  final bool clientEditFlag;
  @HiveField(27)
  final bool timerFlag;
  @HiveField(28)
  final bool dcrDiscussion;
  @HiveField(29)
  final bool promoFlag;
  @HiveField(30)
  final bool leaveFlag;
  @HiveField(31)
  final bool noticeFlag;
  @HiveField(32)
  final bool docFlag;
  @HiveField(33)
  final bool docEditFlag;
  @HiveField(34)
  final String? userLevelDepth;
  @HiveField(35)
  final bool? edsrFlag;
  @HiveField(36)
  final bool? edsrApprovalFlag;
  @HiveField(37)
  final bool? appraisalFlag;
  @HiveField(38)
  final bool? appraisalApprovalFlag;
  factory UserLoginModel.buildEmpty() => UserLoginModel(
      status: '',
      userId: '',
      userName: '',
      mobileNo: '',
      areaPage: false,
      orderFlag: false,
      osShowFlag: false,
      osDetailsFlag: false,
      ordHistoryFlag: false,
      invHistroyFlag: false,
      dcrFlag: false,
      rxFlag: false,
      othersFlag: false,
      visitPlanFlag: false,
      plaginFlag: false,
      offerFlag: false,
      noteFlag: false,
      dcrVisitWith: false,
      dcrVisitWithList: [],
      rxDocMust: false,
      rxTypeMust: false,
      rxGalleryAllow: false,
      rxTypeList: [],
      userSalesAchFlag: false,
      clientFlag: false,
      clientEditFlag: false,
      timerFlag: false,
      dcrDiscussion: false,
      promoFlag: false,
      leaveFlag: false,
      noticeFlag: false,
      docFlag: false,
      docEditFlag: false,
      userLevelDepth: '',
      edsrFlag: false,
      edsrApprovalFlag: false,
      appraisalFlag: false,
      appraisalApprovalFlag: false);
  factory UserLoginModel.fromJson(Map<String, dynamic> json) => UserLoginModel(
      status: json["status"],
      userId: json["user_id"],
      userName: json["user_name"],
      mobileNo: json["mobile_no"],
      areaPage: json["area_page"],
      orderFlag: json["order_flag"],
      osShowFlag: json["os_show_flag"],
      osDetailsFlag: json["os_details_flag"],
      ordHistoryFlag: json["ord_history_flag"],
      invHistroyFlag: json["inv_histroy_flag"],
      dcrFlag: json["dcr_flag"],
      rxFlag: json["rx_flag"],
      othersFlag: json["others_flag"],
      visitPlanFlag: json["visit_plan_flag"],
      plaginFlag: json["plagin_flag"],
      offerFlag: json["offer_flag"],
      noteFlag: json["note_flag"],
      dcrVisitWith: json["dcr_visit_with"],
      dcrVisitWithList:
          List<String>.from(json["dcr_visit_with_list"].map((x) => x)),
      rxDocMust: json["rx_doc_must"],
      rxTypeMust: json["rx_type_must"],
      rxGalleryAllow: json["rx_gallery_allow"],
      rxTypeList: List<String>.from(json["rx_type_list"].map((x) => x)),
      userSalesAchFlag: json["user_sales_ach_flag"],
      clientFlag: json["client_flag"],
      clientEditFlag: json["client_edit_flag"],
      timerFlag: json["timer_flag"],
      dcrDiscussion: json["dcr_discussion"],
      promoFlag: json["promo_flag"],
      leaveFlag: json["leave_flag"],
      noticeFlag: json["notice_flag"],
      docFlag: json["doc_flag"],
      docEditFlag: json["doc_edit_flag"],
      userLevelDepth: json["user_level_depth"] ?? '',
      edsrFlag: json["edsr_flag"] ?? false,
      edsrApprovalFlag: json["edsr_approve_flag"] ?? false,
      appraisalFlag: json["appraisal_flag"] ?? false,
      appraisalApprovalFlag: json["appraisal_approve_flag"] ?? false);

  Map<String, dynamic> toJson() => {
        "status": status,
        "user_id": userId,
        "user_name": userName,
        "mobile_no": mobileNo,
        "area_page": areaPage,
        "order_flag": orderFlag,
        "os_show_flag": osShowFlag,
        "os_details_flag": osDetailsFlag,
        "ord_history_flag": ordHistoryFlag,
        "inv_histroy_flag": invHistroyFlag,
        "dcr_flag": dcrFlag,
        "rx_flag": rxFlag,
        "others_flag": othersFlag,
        "visit_plan_flag": visitPlanFlag,
        "plagin_flag": plaginFlag,
        "offer_flag": offerFlag,
        "note_flag": noteFlag,
        "dcr_visit_with": dcrVisitWith,
        "dcr_visit_with_list":
            List<dynamic>.from(dcrVisitWithList.map((x) => x)),
        "rx_doc_must": rxDocMust,
        "rx_type_must": rxTypeMust,
        "rx_gallery_allow": rxGalleryAllow,
        "rx_type_list": List<dynamic>.from(rxTypeList.map((x) => x)),
        "user_sales_ach_flag": userSalesAchFlag,
        "client_flag": clientFlag,
        "client_edit_flag": clientEditFlag,
        "timer_flag": timerFlag,
        "dcr_discussion": dcrDiscussion,
        "promo_flag": promoFlag,
        "leave_flag": leaveFlag,
        "notice_flag": noticeFlag,
        "doc_flag": docFlag,
        "doc_edit_flag": docEditFlag,
      };
}
