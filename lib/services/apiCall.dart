// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:MREPORTING/ui/order_sections/customerListPage.dart';
import 'package:MREPORTING/ui/target_achievemet.dart';
import 'package:shared_preferences/shared_preferences.dart';

String timer_track_url = "";
String sync_notice_url = "";
String expenseSubmit = "";
String expenseType = "";
String expenseReport = "";
String cid = "";
String user_id = "";
String user_pass = "";
String device_id = "";
sharedpref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  timer_track_url = prefs.getString("timer_track_url") ?? "";
  expenseSubmit = prefs.getString("exp_submit_url") ?? "";
  expenseType = prefs.getString("exp_type_url") ?? "";
  sync_notice_url = prefs.getString("sync_notice_url") ?? "";
  expenseReport = prefs.getString("report_exp_url") ?? "";
  cid = prefs.getString("CID") ?? '';
  user_id = prefs.getString("USER_ID") ?? '';
  user_pass = prefs.getString("PASSWORD") ?? '';
  device_id = prefs.getString("deviceId") ?? '';
}

///*************************************************** *************************************///
///******************************** Area page **********************************************///
///******************************** ********************************************************///

Future<List> getAreaPage(
    areaPageUrl, String cid, String userId, String userPassword) async {
  List arePageList = [];

  try {
    final http.Response res = await http.get(
        Uri.parse(
            '$areaPageUrl?cid=$cid&user_id=$userId&user_pass=$userPassword'),
        headers: <String, String>{
          'Content-Type': 'appliscation/json; charset=UTF-8'
        });

    var areaPageInfo = json.decode(res.body);
    String status = areaPageInfo['status'];
    if (status == 'Success') {
      // arePageList = areaPageDataModelFromJson(res.body);
      arePageList = areaPageInfo['area_list'];
      return arePageList;
    } else {
      return arePageList;
    }
  } catch (e) {
    print('Error message: $e');
  }
  return arePageList;
}

///*************************************************** *************************************///
///******************************** Area Base Client ***************************************///
///******************************** ********************************************************///

Future<bool> getAreaBaseClient(BuildContext context, String syncUrl, cid,
    userId, userPassword, areaId) async {
  List clientList = [];
  try {
    final http.Response res = await http.get(
        Uri.parse(
            '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userPassword&area_id=$areaId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    var clientJsonData = json.decode(res.body);
    String clientStatus = clientJsonData['status'];

    if (clientStatus == 'Success') {
      clientList = clientJsonData['clientList'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CustomerListScreen(
                    data: clientList,
                  )));
      return false;
    } else {
      return false;
    }
  } catch (e) {
    print('Error message: $e');
  }
  return false;
}

///*************************************************** *************************************///
///******************************** Target Achievement *************************************///
///******************************** ********************************************************///

Future getTarAch(BuildContext context, String userSalesCollAchUrl, cid, userId,
    userPassword, deviceId) async {
  print(
      '$userSalesCollAchUrl?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId');
  try {
    final http.Response response = await http.get(
        Uri.parse(
            '$userSalesCollAchUrl?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });

    var userInfo = json.decode(response.body);
    var status = userInfo['status'];
    print(status);
    if (status == 'Success') {
      List tarAchievementList = userInfo['userSalesCollAchList'];
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => TargetAchievement(
                    tarAchievementList: tarAchievementList,
                  )));
    } else {
      // _submitToastforOrder2();
    }
  } on Exception catch (_) {
    // throw Exception("Error on server");
    Fluttertoast.showToast(msg: "No Target Achievement ");
  }
}

///*************************************************** *************************************///
///******************************** Order History ******************************************///
///******************************** ********************************************************///

Future getOrderHistory() async {
  try {
    final http.Response response = await http.get(
        Uri.parse(
            'http://w305.yeapps.com/acme_api/api_ord_history/ord_history'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var orderHistoryInfo = json.decode(response.body);
    String status = orderHistoryInfo['status'];
    if (status == 'Success') {
      return null;
    }
  } catch (e) {
    print('Order History error message: $e');
  }
  return null;
}

///*************************************************** *************************************///
///******************************** Invoice History ******************************************///
///******************************** ********************************************************///

Future getInvoiceHistory() async {
  try {
    final http.Response response = await http.get(
        Uri.parse(
            'http://w305.yeapps.com/acme_api/api_inv_history/inv_history'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var invoiceHistoryInfo = json.decode(response.body);
    String status = invoiceHistoryInfo['status'];
    if (status == 'Success') {
      return null;
    }
  } catch (e) {
    print('Invoice history error message: $e');
  }
  return null;
}

///*************************************************** *************************************///
///******************************** OutStanding Details ***********************************///
///******************************** ********************************************************///

Future getOutStandingDetails() async {
  try {
    final http.Response response = await http.get(
        Uri.parse('http://w305.yeapps.com/acme_api/api_os_details/os_details'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var outDetailsInfo = json.decode(response.body);
    String status = outDetailsInfo['status'];
    if (status == 'Success') {
      return null;
    }
  } catch (e) {
    print('OutStanding Details error message: $e');
  }
  return null;
}

///*************************************************** *************************************///
///******************************** Edit URL *************************************///
///******************************** ********************************************************///
///
///
///

Future timeTracker(String location) async {
  await sharedpref();
  print("ok ok ${timer_track_url}");
  print(cid);
  print(user_id);
  print(user_pass);
  print(device_id);
  if (location != "") {
    final response = await http.post(
      Uri.parse(
          // 'w05.yeapps.com/acme_api/api_expense_submit/submit_data'
          "${timer_track_url}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "cid": cid,
        "user_id": user_id,
        "user_pass": user_pass,
        "device_id": device_id,
        "locations": location,
      }),
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return data;
    }
  }

  return "Null";
}

///*************************************************** *************************************///
///******************************** Expense Entry ******************************************///
///******************************** ********************************************************///

expenseEntry() async {
  await sharedpref();
  print("$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass");

  try {
    final http.Response response = await http.get(
        Uri.parse(
            '$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass'),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var orderHistoryInfo = json.decode(response.body);

    String status = orderHistoryInfo['status'];
    List expTypeList = orderHistoryInfo['expTypeList'];

    if (status == 'Success') {
      return expTypeList;
    }
  } catch (e) {
    print('Order History error message: $e');
  }
  return "error";
}

///*************************************************** *************************************///
///******************************** Expense Submit ******************************************///
///******************************** ********************************************************///

SubmitToExpense(expDAteforSubmit, itemString) async {
  await sharedpref();
  print(
      "$expenseSubmit?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date=$expDAteforSubmit&exp_data=$itemString");

  try {
    final http.Response response = await http.get(
        Uri.parse(
            "$expenseSubmit?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id&exp_date=$expDAteforSubmit&exp_data=$itemString"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var ExpenseSubmitInfo = json.decode(response.body);
    print(ExpenseSubmitInfo);
    // String status = orderHistoryInfo['status'];
    // List expTypeList = orderHistoryInfo['expTypeList'];
    return ExpenseSubmitInfo;

    // if (status == 'Success') {
    //   return "200";
    //   // return expTypeList;

    // }
  } catch (e) {
    print('Expense Submit error message: $e');
  }
  return "error";
}

///*************************************************** *************************************///
///******************************** Expense LOG/EXPENSE REPORT ******************************************///
///******************************** ********************************************************///

ExpenseReport() async {
  await sharedpref();
  print(
      "$expenseReport?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id");

  try {
    final http.Response response = await http.get(
        Uri.parse(
            "$expenseReport?cid=$cid&user_id=$user_id&user_pass=$user_pass&device_id=$device_id"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var ExpenseHistoryInfo = json.decode(response.body);

    // print(ExpenseHistoryInfo);

    return ExpenseHistoryInfo;
  } catch (e) {
    print('Expense History error message: $e');
  }
  return "error";
}

///*************************************************** *************************************///
///******************************** Notice [[Homepage]] ******************************************///
///******************************** ********************************************************///

noticeEvent() async {
  await sharedpref();
  print("$sync_notice_url?cid=$cid&user_id=$user_id&user_pass=$user_pass");

  try {
    final http.Response response = await http.get(
        Uri.parse(
            "$sync_notice_url?cid=$cid&user_id=$user_id&user_pass=$user_pass"),
        headers: <String, String>{
          'Content-Type': 'Application/json; charset=UTF-8'
        });

    var noticeDetails = json.decode(response.body);
    print(noticeDetails);
    String status = noticeDetails['status'];
    List noticeList = noticeDetails['noticeList'];
    if (status == "Success") {
      return noticeList;
    } else {
      return "error";
    }
  } catch (e) {
    print('notice error message: $e');
  }
  return "error";
}
