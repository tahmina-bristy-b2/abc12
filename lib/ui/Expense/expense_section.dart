import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/others/repositories.dart';
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
  String userPass = "";
  String expApproval = "";
  String startTime = "";

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  var prefix;
  var prefix2;
  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        userPass = prefs.getString("PASSWORD") ?? "";
        expApproval = prefs.getString("exp_approval_url") ?? "";
        startTime = prefs.getString("startTime") ?? '';

        var parts = startTime.split(' ');
        prefix = parts[0].trim();
        String dt = DateTime.now().toString();
        var parts2 = dt.split(' ');
        prefix2 = parts2[0].trim();
      });
    });

    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    super.initState();
  }

  List newList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Expense"),
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(
                          userPassword: userPass,
                          userName: userInfo!.userName,
                          userId: userInfo!.userId)),
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
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                          ),
                          child: const Center(
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
                    : const Text(""),

                //******************************************************************************************************/
                //*******************************************************************************************************/
                //**************************Attendance & Meter Reading***************************************************/
                //*******************************************************************************************************/
                Container(
                  height: MediaQuery.of(context).size.height / 6.7,
                  color: const Color(0xFFDDEBF7),
                  child: Row(
                    children: [
                      Expanded(
                        child: customBuildButton(
                          onClick: () async {
                            newList = await Repositories().expenseEntryRepo(
                                dmpathData!.expTypeUrl,
                                cid,
                                userInfo!.userId,
                                userPass);
                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AttendanceScreen(),
                              ),
                            );
                          },
                          title: "Attendance & \nMeter Reading",
                          sizeWidth: MediaQuery.of(context).size.width,
                          inputColor: const Color(0xff56CCF2).withOpacity(.3),
                          icon: Icons.chrome_reader_mode_sharp,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                //******************************************************************************************************/
                //*******************************************************************************************************/
                //**************************NEW EXPENSE ENTRY***************************************************/
                //*******************************************************************************************************/
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  color: const Color(0xFFE2EFDA),
                  child: Column(
                    children: [
                      Expanded(
                        child: customBuildButton(
                          onClick: () async {
                            newList = await Repositories().expenseEntryRepo(
                                dmpathData!.expTypeUrl,
                                cid,
                                userInfo!.userId,
                                userPass);
                            if (!mounted) return;

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
                          inputColor: const Color(0xff56CCF2).withOpacity(.3),
                        ),
                      ),
                      const SizedBox(
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
                                List expenseLog = expReport["expList"];

                                if (!mounted) return;

                                // print(ExpenseLog);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ExpenseLogScreen(
                                      expenseLog: expenseLog,
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
                const SizedBox(
                  height: 5,
                ),
                // //******************************************************************************************************/
                // //*******************************************************************************************************/
                // //**************************APPROVAL***************************************************/
                // //*******************************************************************************************************/

                Container(
                  // height: MediaQuery.of(context).size.height / 4.5,
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xFFDDEBF7),
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
                              '$expApproval?cid=$cid&user_id=$user_id&userPass=$userPass';
                          if (await canLaunchUrl(Uri.parse(url))) {
                            await launchUrl(Uri.parse(url));
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        title: "Approval & Report",
                        sizeWidth: 300,
                        icon: Icons.approval,
                        inputColor: const Color(0xff70BA85).withOpacity(.3),
                      ),
                      // ),
                      const SizedBox(
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
