import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:MREPORTING/utils/constant.dart';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/others/data_providers.dart';
import 'package:MREPORTING/services/sharedPrefernce.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Repositories {
  Future<String> getDmPath(String cid) async {
    final dmPathBox = Boxes.getDmpath(); //dmpath box instance
    String loginUrl = '';

    DmPathDataModel dmPathDataModelData;
    try {
      final http.Response response = await DataProviders().dmPathData(cid);

      if (response.statusCode == 200) {
        var userInfo = json.decode(response.body);

        var resData = userInfo['res_data'];
        if (resData['ret_res'] != "Welcome to mReporting.") {
          dmPathDataModelData = dmPathDataModelFromJson(jsonEncode(resData));
          dmPathBox.put(
              'dmPathData', dmPathDataModelData); //saved dmPath data to hive

          loginUrl = resData['login_url'] ?? '';

          // old task

          String syncUrl = resData['sync_url'] ?? '';
          String submitUrl = resData['submit_url'];
          String reportSalesUrl = resData['report_sales_url'];
          String reportDcrUrl = resData['report_dcr_url'];
          String reportRxUrl = resData['report_rx_url'];
          String photoSubmitUrl = resData['photo_submit_url'];
          String photoUrl = resData['photo_url'];
          String leaveRequestUrl = resData['leave_request_url'];
          String leaveReportUrl = resData['leave_report_url'];
          String pluginUrl = resData['plugin_url'];
          String tourPlanUrl = resData['tour_plan_url'];
          String tourComplianceUrl = resData['tour_compliance_url'];
          String clientUrl = resData['client_url'];

          String activityLogUrl = resData['activity_log_url'];
          String userSalesCollAchUrl = resData['user_sales_coll_ach_url'];
          String clientOutstUrl = resData['client_outst_url'];
          String userAreaUrl = resData['user_area_url'];
          String osDetailsUrl = resData['os_details_url'];
          String ordHistoryUrl = resData['ord_history_url'];
          String invHistoryUrl = resData['inv_history_url'];
          String clientEditUrl = resData['client_edit_url'];
          String timerTrackUrl = resData['timer_track_url'];
          String expTypeUrl = resData['exp_type_url'];
          String expSubmitUrl = resData['exp_submit_url'];
          String reportExpUrl = resData['report_exp_url'];
          String reportOutstUrl = resData['report_outst_url'];
          String reportLastOrdUrl = resData['report_last_ord_url'];
          String reportLastInvUrl = resData['report_last_inv_url'];
          String expApprovalUrl = resData['exp_approval_url'];
          String syncNoticeUrl = resData['sync_notice_url'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('sync_url', syncUrl);
          await prefs.setString('submit_url', submitUrl);
          await prefs.setString('report_sales_url', reportSalesUrl);
          await prefs.setString('report_dcr_url', reportDcrUrl);
          await prefs.setString('report_rx_url', reportRxUrl);
          await prefs.setString('photo_submit_url', photoSubmitUrl);
          await prefs.setString('activity_log_url', activityLogUrl);
          await prefs.setString('client_outst_url', clientOutstUrl);
          await prefs.setString('user_area_url', userAreaUrl);
          await prefs.setString('photo_url', photoUrl);
          await prefs.setString('leave_request_url', leaveRequestUrl);
          await prefs.setString('leave_report_url', leaveReportUrl);
          await prefs.setString('plugin_url', pluginUrl);
          await prefs.setString('tour_plan_url', tourPlanUrl);
          await prefs.setString('tour_compliance_url', tourComplianceUrl);
          await prefs.setString('client_url', clientUrl);
          await prefs.setString('user_sales_coll_ach_url', userSalesCollAchUrl);
          await prefs.setString('os_details_url', osDetailsUrl);
          await prefs.setString('ord_history_url', ordHistoryUrl);
          await prefs.setString('inv_history_url', invHistoryUrl);
          await prefs.setString('client_edit_url', clientEditUrl);
          await prefs.setString('timer_track_url', timerTrackUrl);
          await prefs.setString('exp_type_url', expTypeUrl);
          await prefs.setString('exp_submit_url', expSubmitUrl);
          await prefs.setString('report_exp_url', reportExpUrl);

          await prefs.setString('report_outst_url', reportOutstUrl);
          await prefs.setString('report_last_ord_url', reportLastOrdUrl);
          await prefs.setString('report_last_inv_url', reportLastInvUrl);
          await prefs.setString('exp_approval_url', expApprovalUrl);
          await prefs.setString('sync_notice_url', syncNoticeUrl);

          return loginUrl;
        } else {
          return loginUrl;
        }
      }
    } on Exception catch (e) {
      // throw Exception(e);

      print(e);
    }
    return loginUrl;
  }

//============================================Login======================================================
  Future<UserLoginModel> login(
      String loginUrl,
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String cid,
      String userId,
      String password) async {
    final http.Response response;
    UserLoginModel userLoginModelData = UserLoginModel.buildEmpty();
    final userloginBox = Boxes.getLoginData();

    try {
      response = await DataProviders().userLogin(loginUrl, cid, userId,
          password, deviceId, deviceBrand, deviceModel, appVersion);

      var userInfo = json.decode(response.body);
      var status = userInfo['status'];

      if (status == 'Success') {
        userLoginModelData = userLoginModelFromJson(response.body);
        userloginBox.put('userInfo', userLoginModelData);

        // old task
        String userName = userInfo['user_name'];
        String userId = userInfo['user_id'];
        String mobileNo = userInfo['mobile_no'];
        bool offerFlag = userInfo['offer_flag'];
        bool noteFlag = userInfo['note_flag'];
        bool clientEditFlag = userInfo['client_edit_flag'];
        bool osShowFlag = userInfo['os_show_flag'];
        bool osDetailsFlag = userInfo['os_details_flag'];
        bool ordHistoryFlag = userInfo['ord_history_flag'];
        bool invHistroyFlag = userInfo['inv_histroy_flag'];
        bool timerFlag = userInfo['timer_flag'];
        bool rxDocMust = userInfo['rx_doc_must'];
        bool rxTypeMust = userInfo['rx_type_must'];
        bool rxGalleryAllow = userInfo['rx_gallery_allow'];
        List dcrVisitWithList = userInfo['dcr_visit_with_list'];
        List rx_type_list = userInfo['rx_type_list'];
        bool orderFlag = userInfo['order_flag'];
        bool dcrFlag = userInfo['dcr_flag'];
        bool rxFlag = userInfo['rx_flag'];
        bool othersFlag = userInfo['others_flag'];
        bool clientFlag = userInfo['client_flag'];
        bool visitPlanFlag = userInfo['visit_plan_flag'];
        bool pluginFlag = userInfo['plagin_flag'];
        bool dcrDiscussion = userInfo['dcr_discussion'];
        bool promoFlag = userInfo['promo_flag'];
        bool leaveFlag = userInfo['leave_flag'];
        bool noticeFlag = userInfo['notice_flag'];
        List<String> dcr_visitedWithList = [];
        for (int i = 0; i < dcrVisitWithList.length; i++) {
          dcr_visitedWithList.add(dcrVisitWithList[i]);
        }
        List<String> rxTypeList = [];
        rx_type_list.forEach((element) {
          rxTypeList.add(element);
        });

        final prefs = await SharedPreferences.getInstance();
        // await prefs.clear();
        await prefs.setBool('areaPage', userInfo['area_page']);
        await prefs.setString('userName', userName);
        await prefs.setString('user_id', userId);
        await prefs.setString('PASSWORD', password);
        await prefs.setString('mobile_no', mobileNo);
        await prefs.setBool('offer_flag', offerFlag);
        await prefs.setBool('note_flag', noteFlag);
        await prefs.setBool('client_edit_flag', clientEditFlag);
        await prefs.setBool('os_show_flag', osShowFlag);
        await prefs.setBool('os_details_flag', osDetailsFlag);
        await prefs.setBool('ord_history_flag', ordHistoryFlag);
        await prefs.setBool('inv_histroy_flag', invHistroyFlag);
        await prefs.setBool('client_flag', clientFlag);
        await prefs.setBool('rx_doc_must', rxDocMust);
        await prefs.setBool('rx_type_must', rxTypeMust);
        await prefs.setBool('rx_gallery_allow', rxGalleryAllow);
        await prefs.setBool('order_flag', orderFlag);
        await prefs.setBool('dcr_flag', dcrFlag);
        await prefs.setBool('timer_flag', timerFlag);
        await prefs.setBool('rx_flag', rxFlag);
        await prefs.setBool('others_flag', othersFlag);
        await prefs.setBool('visit_plan_flag', visitPlanFlag);
        await prefs.setBool('plagin_flag', pluginFlag);
        await prefs.setBool('dcr_discussion', dcrDiscussion);
        await prefs.setBool('promo_flag', promoFlag);
        await prefs.setBool('leave_flag', leaveFlag);
        await prefs.setBool('notice_flag', noticeFlag);

        await prefs.setStringList('dcr_visit_with_list', dcr_visitedWithList);

        await prefs.setStringList('rx_type_list', rxTypeList);

        SharedPreferncesMethod()
            .sharedPreferenceSetDataForLogin(cid, userId, password);

        return userLoginModelData;
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    return userLoginModelData;
  }

//=============Attendance Repositories====================================

  Future<Map<String, dynamic>> attendanceRepo(
      String attendanceUrl,
      String? cid,
      String userId,
      String? userPass,
      String deviceId,
      String lat,
      String long,
      String address,
      String submitType,
      String mtrReading) async {
    Map<String, dynamic> jsonData = {};

    try {
      http.Response response = await DataProviders().attendanceDP(
          attendanceUrl,
          cid,
          userId,
          userPass,
          deviceId,
          lat,
          long,
          address,
          submitType,
          mtrReading);
      jsonData = json.decode(response.body);

      String status = jsonData['status'];

      if (status == 'Success') {
        var startTime = jsonData["start_time"];
        var endTime = jsonData["end_time"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('startTime', startTime);
        await prefs.setString('endTime', endTime);

        return jsonData;
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    return jsonData;
  }

//=============Area Repository====================================

  Future<List> areaRepo(
    String areaUrl,
    String? cid,
    String userId,
    String? userPass,
  ) async {
    List areaPageList = [];
    Map<String, dynamic> jsonData = {};

    try {
      http.Response response =
          await DataProviders().areaDP(areaUrl, cid, userId, userPass);
      jsonData = json.decode(response.body);

      String status = jsonData['status'];

      if (status == 'Success') {
        areaPageList = jsonData['area_list'];

        return areaPageList;
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    return areaPageList;
  }

//=============Area Base Client Repository====================================

  Future<List> areaBaseClientRepo(String areaUrl, String cid, String userId,
      String userPass, String areaId) async {
    List clientList = [];
    Map<String, dynamic> clientJsonData = {};

    try {
      http.Response response = await DataProviders()
          .areaBaseClientDP(areaUrl, cid, userId, userPass, areaId);
      clientJsonData = json.decode(response.body);

      String clientStatus = clientJsonData['status'];

      if (clientStatus == 'Success') {
        clientList = clientJsonData['clientList'];

        return clientList;
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    return clientList;
  }

//=============Area Base Doctor Repository====================================

  Future<List> areaBaseDoctorRepo(String areaBaseDoctorUrl, String cid,
      String userId, String userPass, String areaId) async {
    List doctorList = [];
    Map<String, dynamic> doctorJsonData = {};

    try {
      http.Response response = await DataProviders()
          .areaBaseDoctorDP(areaBaseDoctorUrl, cid, userId, userPass, areaId);
      doctorJsonData = json.decode(response.body);

      String doctorStatus = doctorJsonData["res_data"]['status'];

      if (doctorStatus == 'Success') {
        doctorList = doctorJsonData["res_data"]['doctorList'];

        return doctorList;
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    return doctorList;
  }
}
