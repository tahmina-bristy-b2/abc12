import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:MREPORTING_OFFLINE/ui/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:MREPORTING_OFFLINE/models/area_page_model.dart';

String timer_track_url = "";
String sync_notice_url = "";
String expenseSubmit = "";
String expenseReport = "";
String cid = "";
String user_id = "";
String user_pass = "";
String device_id = "";

sharedpref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  timer_track_url = prefs.getString("timer_track_url") ?? "";
  expenseSubmit = prefs.getString("exp_submit_url") ?? "";
  sync_notice_url = prefs.getString("sync_notice_url") ?? "";
  expenseReport = prefs.getString("report_exp_url") ?? "";
  cid = prefs.getString("CID") ?? '';
  user_id = prefs.getString("USER_ID") ?? '';
  user_pass = prefs.getString("PASSWORD") ?? '';
  device_id = prefs.getString("deviceId") ?? '';
}

///*************************************************** *************************************///
///******************************** Edit URL *************************************///
///******************************** ********************************************************///

Future timeTracker(String location) async {
  await sharedpref();

  if (location != "") {
    final response = await http.post(
      Uri.parse(timer_track_url),
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

// expenseEntry() async {
//   await sharedpref();
//   print("$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass");

//   try {
//     final http.Response response = await http.get(
//         Uri.parse(
//             '$expenseType?cid=$cid&user_id=$user_id&user_pass=$user_pass'),
//         headers: <String, String>{
//           'Content-Type': 'Application/json; charset=UTF-8'
//         });

//     var orderHistoryInfo = json.decode(response.body);

//     String status = orderHistoryInfo['status'];
//     List expTypeList = orderHistoryInfo['expTypeList'];

//     if (status == 'Success') {
//       return expTypeList;
//     }
//   } catch (e) {
//     print('Order History error message: $e');
//   }
//   return "error";
// }

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
