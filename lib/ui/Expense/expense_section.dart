import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/Expense/approval.dart';
import 'package:MREPORTING/ui/Expense/attendanceMtrHistory.dart';
import 'package:MREPORTING/ui/Expense/expense_draft.dart';
import 'package:MREPORTING/ui/Expense/expense_entry.dart';
import 'package:MREPORTING/ui/Expense/expense_log.dart';
import 'package:MREPORTING/ui/Expense/expense_summary.dart';
import 'package:MREPORTING/ui/attendance_page.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/ui/Widgets/custombutton.dart';
import 'package:MREPORTING/ui/Widgets/syncCustomButton.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/services/apiCall.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class ExpensePage extends StatefulWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  String userId = "";
  String userName = "";
  String user_pass = "";
  String expApproval = "";
  String startTime = "";
  var prefix;
  var prefix2;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userId = prefs.getString("CID") ?? "";
        userName = prefs.getString("USER_ID") ?? "";
        user_pass = prefs.getString("PASSWORD") ?? "";
        expApproval = prefs.getString("exp_approval_url") ?? "";
        startTime = prefs.getString("startTime") ?? '';
        // print("start time ashbe $startTime");
        var parts = startTime.split(' ');
        prefix = parts[0].trim();
        // print(prefix);
        String dt = DateTime.now().toString();
        var parts2 = dt.split(' ');
        prefix2 = parts2[0].trim();
        // print("dateTime ashbe$prefix2");
      });
    });

    super.initState();
  }

  List newList = [];
  // List<ExpenseModel> expenseDraft = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Expense"),
        leading: IconButton(
            onPressed: () {
              // Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          userPassword: user_pass,
                          userName: userName,
                          user_id: userId)),
                  (route) => false);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                prefix2 != prefix
                    ?
                    // startTime == ""
                    //     ?
                    Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "Please Give Meter Reading First",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    // : Text("ok")
                    : Text(""),

                //******************************************************************************************************/
                //*******************************************************************************************************/
                //**************************Attendance & Meter Reading***************************************************/
                //*******************************************************************************************************/
                Container(
                  height: MediaQuery.of(context).size.height / 6.7,
                  color: Color(0xFFDDEBF7),
                  child: Row(
                    children: [
                      Expanded(
                        child: customBuildButton(
                          onClick: () async {
                            newList = await expenseEntry();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AttendanceScreen(
                                    // expenseTypelist: newList,
                                    // callback: () {}, tempExpList: [],
                                    // expDraftDate: '',
                                    // tempExpenseList: [],
                                    ),
                              ),
                            );
                          },
                          title: "Attendance & \nMeter Reading",
                          sizeWidth: MediaQuery.of(context).size.width,
                          inputColor: Color(0xff56CCF2).withOpacity(.3),
                          icon: Icons.chrome_reader_mode_sharp,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                //******************************************************************************************************/
                //*******************************************************************************************************/
                //**************************NEW EXPENSE ENTRY***************************************************/
                //*******************************************************************************************************/
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  color: Color(0xFFE2EFDA),
                  child: Column(
                    children: [
                      Expanded(
                        child: customBuildButton(
                          onClick: () async {
                            newList = await expenseEntry();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ExpenseEntry(
                                  expenseTypelist: newList,
                                  callback: () {},
                                  tempExpList: [],
                                  expDraftDate: '',
                                ),
                              ),
                            );
                          },
                          // color: Colors.green,
                          title: "Expense Entry",
                          sizeWidth: 300, icon: Icons.draw_rounded,
                          inputColor: Color(0xff56CCF2).withOpacity(.3),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      // //******************************************************************************************************/
                      //*******************************************************************************************************/
                      //**************************DRAFT***************************************************/
                      //*******************************************************************************************************/
                      Row(
                        children: [
                          Expanded(
                            child: customBuildButton(
                              onClick: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ExpenseDraft(temp: {})));
                              },
                              title: "Draft",
                              sizeWidth: 300,
                              icon: Icons.pending_actions_sharp,
                              inputColor: Colors.white,
                            ),
                          ),
                          // //******************************************************************************************************/
                          // //*******************************************************************************************************/
                          // //**************************MY EXPENSE LOG***************************************************/
                          // //*******************************************************************************************************/
                          Expanded(
                            child: customBuildButton(
                              onClick: () async {
                                var expReport = await ExpenseReport();
                                List ExpenseLog = expReport["expList"];
                                // print(ExpenseLog);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExpenseLogScreen(
                                      expenseLog: ExpenseLog,
                                    ),
                                  ),
                                );
                              },
                              title: "Expense Log",
                              sizeWidth: 300,
                              inputColor: Colors.white,
                              icon: Icons.receipt_long_sharp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                // //******************************************************************************************************/
                // //*******************************************************************************************************/
                // //**************************APPROVAL***************************************************/
                // //*******************************************************************************************************/

                Container(
                  // height: MediaQuery.of(context).size.height / 4.5,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xFFDDEBF7),
                  child: Column(
                    children: [
                      // Expanded(
                      //   child: customBuildButton(
                      //     onClick: () async {
                      //       var expReport = await ExpenseReport();
                      //       List ExpenseLog = expReport["expList"];

                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (context) => ApprovalPage(
                      //             expenseLog: ExpenseLog,
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     title: "Report",
                      //     sizeWidth: 300,
                      //     icon: Icons.approval,
                      //     inputColor: Color(0xff70BA85).withOpacity(.3),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 2,
                      // ),
                      // Row(
                      //   children: [
                      //     Expanded(
                      //       child: customBuildButton(
                      //         icon: Icons.summarize,
                      //         inputColor: Color(0xff70BA85).withOpacity(.3),
                      //         onClick: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       ExpenseSummaryScreen()));
                      //         },
                      //         sizeWidth: 300,
                      //         title: 'Expense Summary',
                      //       ),
                      //     ),
                      //     Expanded(
                      //       child: customBuildButton(
                      //         icon: Icons.summarize,
                      //         inputColor: Color(0xff70BA85).withOpacity(.3),
                      //         onClick: () {
                      //           Navigator.push(
                      //               context,
                      //               MaterialPageRoute(
                      //                   builder: (context) =>
                      //                       AttendanceMeterHistory()));
                      //         },
                      //         sizeWidth: 300,
                      //         title: 'Attendance & Meter Reading History',
                      //       ),
                      //     ),

                      //     // ElevatedButton(
                      //     //   onPressed: () {},
                      //     //   child: Text("Approval"),
                      //     // ),
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 2,
                      // ),
                      // Expanded(
                      //   child:
                      customBuildButton(
                        onClick: () async {
                          var url =
                              '$expApproval?cid=$cid&user_id=$user_id&user_pass=$user_pass';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        title: "Approval & Report",
                        sizeWidth: 300,
                        icon: Icons.approval,
                        inputColor: Color(0xff70BA85).withOpacity(.3),
                      ),
                      // ),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
