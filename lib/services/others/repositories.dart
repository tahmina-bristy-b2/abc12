import 'dart:convert';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/dcr/dcr_data_providers.dart';
import 'package:MREPORTING/services/others/data_providers.dart';
import 'package:MREPORTING/services/sharedPrefernce.dart';
import 'package:MREPORTING/ui/loginPage.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:http/http.dart' as http;
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

          String sync_url = resData['sync_url'] ?? '';
          String submit_url = resData['submit_url'];
          String report_sales_url = resData['report_sales_url'];
          String report_dcr_url = resData['report_dcr_url'];
          String report_rx_url = resData['report_rx_url'];
          String photo_submit_url = resData['photo_submit_url'];
          String photo_url = resData['photo_url'];
          String leave_request_url = resData['leave_request_url'];
          String leave_report_url = resData['leave_report_url'];
          String plugin_url = resData['plugin_url'];
          String tour_plan_url = resData['tour_plan_url'];
          String tour_compliance_url = resData['tour_compliance_url'];
          String client_url = resData['client_url'];

          String activity_log_url = resData['activity_log_url'];
          String user_sales_coll_ach_url = resData['user_sales_coll_ach_url'];
          String client_outst_url = resData['client_outst_url'];
          String user_area_url = resData['user_area_url'];
          String os_details_url = resData['os_details_url'];
          String ord_history_url = resData['ord_history_url'];
          String inv_history_url = resData['inv_history_url'];
          String client_edit_url = resData['client_edit_url'];
          String timer_track_url = resData['timer_track_url'];
          String exp_type_url = resData['exp_type_url'];
          String exp_submit_url = resData['exp_submit_url'];
          String report_exp_url = resData['report_exp_url'];
          String report_outst_url = resData['report_outst_url'];
          String report_last_ord_url = resData['report_last_ord_url'];
          String report_last_inv_url = resData['report_last_inv_url'];
          String exp_approval_url = resData['exp_approval_url'];
          String sync_notice_url = resData['sync_notice_url'];

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('sync_url', sync_url);
          await prefs.setString('submit_url', submit_url);
          await prefs.setString('report_sales_url', report_sales_url);
          await prefs.setString('report_dcr_url', report_dcr_url);
          await prefs.setString('report_rx_url', report_rx_url);
          await prefs.setString('photo_submit_url', photo_submit_url);
          await prefs.setString('activity_log_url', activity_log_url);
          await prefs.setString('client_outst_url', client_outst_url);
          await prefs.setString('user_area_url', user_area_url);
          await prefs.setString('photo_url', photo_url);
          await prefs.setString('leave_request_url', leave_request_url);
          await prefs.setString('leave_report_url', leave_report_url);
          await prefs.setString('plugin_url', plugin_url);
          await prefs.setString('tour_plan_url', tour_plan_url);
          await prefs.setString('tour_compliance_url', tour_compliance_url);
          await prefs.setString('client_url', client_url);
          // await prefs.setString('doctor_url', doctor_url);
          await prefs.setString(
              'user_sales_coll_ach_url', user_sales_coll_ach_url);
          await prefs.setString('os_details_url', os_details_url);
          await prefs.setString('ord_history_url', ord_history_url);
          await prefs.setString('inv_history_url', inv_history_url);
          await prefs.setString('client_edit_url', client_edit_url);
          await prefs.setString('timer_track_url', timer_track_url);
          await prefs.setString('exp_type_url', exp_type_url);
          await prefs.setString('exp_submit_url', exp_submit_url);
          await prefs.setString('report_exp_url', report_exp_url);
          await prefs.setString('report_exp_url', report_exp_url);
          await prefs.setString('report_outst_url', report_outst_url);
          await prefs.setString('report_last_ord_url', report_last_ord_url);
          await prefs.setString('report_last_inv_url', report_last_inv_url);
          await prefs.setString('exp_approval_url', exp_approval_url);
          await prefs.setString('sync_notice_url', sync_notice_url);

          // login(deviceId, deviceBrand, deviceModel, cid, userId, password,
          //     login_url, context);

          return loginUrl;
        } else {
          return loginUrl;
        }
        // var userInfo = json.decode(response.body);

        // var resData = userInfo['res_data'];
      }
    } on Exception catch (e) {
      // throw Exception(e);
      // ignore: avoid_print
      print(e);
    }
    return loginUrl;
  }

  // Future<String> getDmPath(String cid) async {
  //   final dmPathBox = Boxes.getDmpath(); //dmpath box instance
  //   String loginUrl = '';

  //   DmPathDataModel dmPathDataModelData;
  //   try {
  //     final http.Response response = await DataProviders().dmPathData(cid);

  //     if (response.statusCode == 200) {
  //       var userInfo = json.decode(response.body);

  //       var resData = userInfo['res_data'];
  //       if (resData['ret_res'] != "Welcome to mReporting.") {
  //         dmPathDataModelData = dmPathDataModelFromJson(jsonEncode(resData));
  //         dmPathBox.put(
  //             'dmPathData', dmPathDataModelData); //saved dmPath data to hive

  //         loginUrl = resData['login_url'] ?? '';

  //         // old task

  //         String sync_url = resData['sync_url'] ?? '';
  //         String submit_url = resData['submit_url'];
  //         String report_sales_url = resData['report_sales_url'];
  //         String report_dcr_url = resData['report_dcr_url'];
  //         String report_rx_url = resData['report_rx_url'];
  //         String photo_submit_url = resData['photo_submit_url'];
  //         String photo_url = resData['photo_url'];
  //         String leave_request_url = resData['leave_request_url'];
  //         String leave_report_url = resData['leave_report_url'];
  //         String plugin_url = resData['plugin_url'];
  //         String tour_plan_url = resData['tour_plan_url'];
  //         String tour_compliance_url = resData['tour_compliance_url'];
  //         String client_url = resData['client_url'];

  //         String activity_log_url = resData['activity_log_url'];
  //         String user_sales_coll_ach_url = resData['user_sales_coll_ach_url'];
  //         String client_outst_url = resData['client_outst_url'];
  //         String user_area_url = resData['user_area_url'];
  //         String os_details_url = resData['os_details_url'];
  //         String ord_history_url = resData['ord_history_url'];
  //         String inv_history_url = resData['inv_history_url'];
  //         String client_edit_url = resData['client_edit_url'];
  //         String timer_track_url = resData['timer_track_url'];
  //         String exp_type_url = resData['exp_type_url'];
  //         String exp_submit_url = resData['exp_submit_url'];
  //         String report_exp_url = resData['report_exp_url'];
  //         String report_outst_url = resData['report_outst_url'];
  //         String report_last_ord_url = resData['report_last_ord_url'];
  //         String report_last_inv_url = resData['report_last_inv_url'];
  //         String exp_approval_url = resData['exp_approval_url'];
  //         String sync_notice_url = resData['sync_notice_url'];

  //         final prefs = await SharedPreferences.getInstance();
  //         await prefs.setString('sync_url', sync_url);
  //         await prefs.setString('submit_url', submit_url);
  //         await prefs.setString('report_sales_url', report_sales_url);
  //         await prefs.setString('report_dcr_url', report_dcr_url);
  //         await prefs.setString('report_rx_url', report_rx_url);
  //         await prefs.setString('photo_submit_url', photo_submit_url);
  //         await prefs.setString('activity_log_url', activity_log_url);
  //         await prefs.setString('client_outst_url', client_outst_url);
  //         await prefs.setString('user_area_url', user_area_url);
  //         await prefs.setString('photo_url', photo_url);
  //         await prefs.setString('leave_request_url', leave_request_url);
  //         await prefs.setString('leave_report_url', leave_report_url);
  //         await prefs.setString('plugin_url', plugin_url);
  //         await prefs.setString('tour_plan_url', tour_plan_url);
  //         await prefs.setString('tour_compliance_url', tour_compliance_url);
  //         await prefs.setString('client_url', client_url);
  //         // await prefs.setString('doctor_url', doctor_url);
  //         await prefs.setString(
  //             'user_sales_coll_ach_url', user_sales_coll_ach_url);
  //         await prefs.setString('os_details_url', os_details_url);
  //         await prefs.setString('ord_history_url', ord_history_url);
  //         await prefs.setString('inv_history_url', inv_history_url);
  //         await prefs.setString('client_edit_url', client_edit_url);
  //         await prefs.setString('timer_track_url', timer_track_url);
  //         await prefs.setString('exp_type_url', exp_type_url);
  //         await prefs.setString('exp_submit_url', exp_submit_url);
  //         await prefs.setString('report_exp_url', report_exp_url);
  //         await prefs.setString('report_exp_url', report_exp_url);
  //         await prefs.setString('report_outst_url', report_outst_url);
  //         await prefs.setString('report_last_ord_url', report_last_ord_url);
  //         await prefs.setString('report_last_inv_url', report_last_inv_url);
  //         await prefs.setString('exp_approval_url', exp_approval_url);
  //         await prefs.setString('sync_notice_url', sync_notice_url);

  //         // login(deviceId, deviceBrand, deviceModel, cid, userId, password,
  //         //     login_url, context);

  //         return loginUrl;
  //       } else {
  //         return loginUrl;
  //       }
  //       // var userInfo = json.decode(response.body);

  //       // var resData = userInfo['res_data'];
  //     }
  //   } on Exception catch (e) {
  //     // throw Exception(e);
  //     // ignore: avoid_print
  //     print(e);
  //   }
  //   return loginUrl;
  // }

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
        String user_id = userInfo['user_id'];
        String mobile_no = userInfo['mobile_no'];
        offer_flag = userInfo['offer_flag'];
        note_flag = userInfo['note_flag'];
        client_edit_flag = userInfo['client_edit_flag'];
        os_show_flag = userInfo['os_show_flag'];
        os_details_flag = userInfo['os_details_flag'];
        ord_history_flag = userInfo['ord_history_flag'];
        inv_histroy_flag = userInfo['inv_histroy_flag'];
        timer_flag = userInfo['timer_flag'];
        rx_doc_must = userInfo['rx_doc_must'];
        rx_type_must = userInfo['rx_type_must'];
        rx_gallery_allow = userInfo['rx_gallery_allow'];
        List dcr_visit_with_list = userInfo['dcr_visit_with_list'];
        List rx_type_list = userInfo['rx_type_list'];
        bool order_flag = userInfo['order_flag'];
        bool dcr_flag = userInfo['dcr_flag'];
        bool rx_flag = userInfo['rx_flag'];
        bool others_flag = userInfo['others_flag'];
        bool client_flag = userInfo['client_flag'];
        bool visit_plan_flag = userInfo['visit_plan_flag'];
        bool plagin_flag = userInfo['plagin_flag'];
        bool dcr_discussion = userInfo['dcr_discussion'];
        bool promo_flag = userInfo['promo_flag'];
        bool leave_flag = userInfo['leave_flag'];
        bool notice_flag = userInfo['notice_flag'];
        dcr_visitedWithList.clear();
        for (int i = 0; i < dcr_visit_with_list.length; i++) {
          dcr_visitedWithList.add(dcr_visit_with_list[i]);
        }
        rxTypeList.clear();
        rx_type_list.forEach((element) {
          rxTypeList.add(element);
        });

        final prefs = await SharedPreferences.getInstance();
        // await prefs.clear();
        await prefs.setBool('areaPage', userInfo['area_page']);
        await prefs.setString('userName', userName);
        await prefs.setString('user_id', user_id);
        await prefs.setString('PASSWORD', password);
        await prefs.setString('mobile_no', mobile_no);
        await prefs.setBool('offer_flag', offer_flag);
        await prefs.setBool('note_flag', note_flag!);
        await prefs.setBool('client_edit_flag', client_edit_flag!);
        await prefs.setBool('os_show_flag', os_show_flag!);
        await prefs.setBool('os_details_flag', os_details_flag!);
        await prefs.setBool('ord_history_flag', ord_history_flag!);
        await prefs.setBool('inv_histroy_flag', inv_histroy_flag!);
        await prefs.setBool('client_flag', client_flag);
        await prefs.setBool('rx_doc_must', rx_doc_must!);
        await prefs.setBool('rx_type_must', rx_type_must!);
        await prefs.setBool('rx_gallery_allow', rx_gallery_allow!);
        await prefs.setBool('order_flag', order_flag);
        await prefs.setBool('dcr_flag', dcr_flag);
        await prefs.setBool('timer_flag', timer_flag!);
        await prefs.setBool('rx_flag', rx_flag);
        await prefs.setBool('others_flag', others_flag);
        await prefs.setBool('visit_plan_flag', visit_plan_flag);
        await prefs.setBool('plagin_flag', plagin_flag);
        await prefs.setBool('dcr_discussion', dcr_discussion);
        await prefs.setBool('promo_flag', promo_flag);
        await prefs.setBool('leave_flag', leave_flag);
        await prefs.setBool('notice_flag', notice_flag);

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
}
