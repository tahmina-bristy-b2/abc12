import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_FF_details_data_model.dart';

import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppraisalSelfAssesmentHistoryScreen extends StatefulWidget {
  final String cid;
  final String userId;
  final String userPass;
  const AppraisalSelfAssesmentHistoryScreen(
      {super.key,
      required this.cid,
      required this.userId,
      required this.userPass});

  @override
  State<AppraisalSelfAssesmentHistoryScreen> createState() =>
      _AppraisalSelfAssesmentHistoryScreenState();
}

class _AppraisalSelfAssesmentHistoryScreenState
    extends State<AppraisalSelfAssesmentHistoryScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  AppraisalApprovalFfDetailsDataModel? appraisalApprovalFfDetailsData;
  bool _isLoading = true;
  bool _isPressed = false;
  bool isUpgrade = false;
  bool isDesignationChange = false;
  double totaOverallCount = 0.0;
  double totalWeightage = 0.0;
  List<RowDataForSelf> rowsList = [];

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getAppraisalApprovalFFDetailsdata();
  }

  String overalResult(var weitage, var selfScore) {
    double result = 0.0;
    result = double.parse(selfScore == null ? "" : selfScore) *
        (double.parse(weitage) / 100);
    return result.toStringAsFixed(2);
  }

  void getAppraisalApprovalFFDetailsdata() async {
    appraisalApprovalFfDetailsData = await AppraisalRepository()
        .getSelfAssesment(
            dmpathData!.syncUrl, widget.cid, widget.userId, widget.userPass);

    if (appraisalApprovalFfDetailsData != null) {
      kpitable(appraisalApprovalFfDetailsData!);

      setState(() {
        _isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _showDialouge(String title, String description) async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text(
                  '$title :',
                ),
                content: Text(description),
              ),
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self Asessment"),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          // Expanded(child: dataLoadingView())
          : appraisalApprovalFfDetailsData == null ||
                  appraisalApprovalFfDetailsData!.resData!.retStr!.isEmpty
              ? Center(
                  child: Stack(children: [
                    Image.asset(
                      'assets/images/no_data_found.png',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      left: MediaQuery.of(context).size.width / 2.5,
                      bottom: MediaQuery.of(context).size.height * .005,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffF0F0F0),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Go back',
                            style: TextStyle(color: Colors.black54),
                          )),
                    )
                  ]),
                )
              : fieldForceAppraisalview(
                  context, appraisalApprovalFfDetailsData!.resData!.retStr!),
    );
  }

  AnimatedList fieldForceAppraisalview(
      BuildContext context, List<RetStr> appraisalDetails) {
    return AnimatedList(
        key: listKey,
        initialItemCount: appraisalDetails.length,
        itemBuilder: (itemBuilder, index, animation) {
          return appraisalListItemView(
              animation, appraisalDetails, index, context);
        });
  }

  SizeTransition appraisalListItemView(Animation<double> animation,
      List<RetStr> appraisalDetails, int index, BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                    child: Icon(Icons.person,
                        size: 35, color: Color.fromARGB(255, 153, 197, 161))),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    flex: 8,
                    child: Text(
                      appraisalDetails[index].empName ?? '',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    )),
              ],
            ),

            FfInformationWidget(
                staticKey: 'Employee ID',
                value: appraisalDetails[index].employeeId ?? ''),
            FfInformationWidget(
                staticKey: 'Designation',
                value: appraisalDetails[index].designation ?? ''),

            FfInformationWidget(
                staticKey: "Present Grade",
                value: appraisalDetails[index].presentGrade ?? ''),
            FfInformationWidget(
                staticKey: "TR-Code",
                value: appraisalDetails[index].trCode ?? ''),
            FfInformationWidget(
                staticKey: "Business Segment",
                value: appraisalDetails[index].businessSegment ?? ''),
            FfInformationWidget(
                staticKey: "Date of Joining",
                value: appraisalDetails[index].dateOfJoining ?? ''),
            FfInformationWidget(
                staticKey: "Last Promotion",
                value: appraisalDetails[index].lastPromotion ?? ''),
            FfInformationWidget(
                staticKey: "Length of Service",
                value: appraisalDetails[index].lengthOfService ?? ''),
            FfInformationWidget(
                staticKey: "Base Territory",
                value: appraisalDetails[index].baseTerritory ?? ''),
            FfInformationWidget(
                staticKey: "Length of Present TR Service",
                value: appraisalDetails[index].lengthOfPresentTrService ?? ''),
            FfInformationWidget(
                staticKey: "Appraisal Status",
                value: appraisalDetails[index].lastAction!),

            const SizedBox(
              height: 20,
            ),
            appraisalAchievemetWidget(appraisalDetails[index]),
            const SizedBox(
              height: 8,
            ),
            appraisalMasterWidget(appraisalDetails[index]),
            const SizedBox(
              height: 8,
            ),
            // increametGradeUpgrationWidget(appraisalDetails[index]),
            // const SizedBox(
            //   height: 8,
            // ),
            // Row(
            //   children: [
            //     const Expanded(
            //         flex: 3,
            //         child: Text(
            //           "Feedback(60 Character)",
            //           style: TextStyle(fontWeight: FontWeight.bold),
            //         )),
            //     const Expanded(
            //         child: Text(
            //       ":",
            //       style: TextStyle(fontWeight: FontWeight.bold),
            //     )),
            //     Expanded(
            //         flex: 7,
            //         child: Container(
            //           decoration: BoxDecoration(
            //             shape: BoxShape.rectangle,
            //             borderRadius: BorderRadius.circular(5),
            //             border: Border.all(
            //               color: Colors.grey,
            //               width: 1.0,
            //             ),
            //           ),
            //           child: TextField(
            //             readOnly: true,
            //             textAlign: TextAlign.center,
            //             controller: TextEditingController(
            //                 text: appraisalDetails[index].feedbackSup ?? ''),
            //             decoration: const InputDecoration(
            //               hintText: 'Feedback/value of work',
            //               border: InputBorder.none,
            //             ),
            //           ),
            //         )),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  SizedBox appraisalAchievement(RetStr achievementData) {
    return SizedBox(
      height: 360,
      child: DataTable2(
          border: TableBorder.all(),
          columnSpacing: 12,
          horizontalMargin: 8,
          dataRowHeight: 35,
          minWidth: 380,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) {
              return const Color.fromARGB(255, 159, 193, 165);
            },
          ),
          headingRowHeight: 40,
          columns: [
            const DataColumn2(
                fixedWidth: 50,
                label: Center(
                    child: Text(
                  "SL No",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            const DataColumn2(
                fixedWidth: 200,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 120,
                label: Center(
                    child: Text(
                  achievementData.currentAchievement ?? 'Current Year',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))),
          ],
          rows: [
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("1"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Target (Value in lac)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.targetValue2 ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("2"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sold (Value in Lac)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.soldValue2 ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("3"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Achievement (%)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.achievement2 ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("4"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Sales/Month "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgSales2 ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("5"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (Seen Rx) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.seenRx ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("5"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (4P) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgSales4P2 ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("6"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (EMR) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgSalesEmr2 ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("7"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Growth "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgRxGrowth ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("8"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("No. of Month Achieved"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.noMonthAchiev2 ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("9"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chemist Coverage"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.chemistCov2 ?? '')))
              ],
            ),
          ]),
    );
  }

  //======================================= Appraisal Achievemet Widget==============================================
  SizedBox appraisalAchievemetWidget(RetStr achievementData) {
    return SizedBox(
      height: 290,
      child: DataTable2(
          border: TableBorder.all(),
          columnSpacing: 12,
          horizontalMargin: 8,
          dataRowHeight: 35,
          minWidth: 600,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) {
              return const Color.fromARGB(255, 159, 193, 165);
            },
          ),
          headingRowHeight: 40,
          columns: [
            const DataColumn2(
                fixedWidth: 50,
                label: Center(
                    child: Text(
                  "SL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            const DataColumn2(
                fixedWidth: 190,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  achievementData.currentAchievement ?? 'Current Year',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))),
          ],
          rows: [
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("1"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Target (Value in lac)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.targetValue2.toString() + "%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("2"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sold (Value in Lac)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.soldValue2.toString() + "%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("3"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Achievement (%)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.achievement2.toString() + "%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("4"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (Seen Rx) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.seenRx.toString() + "%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("5"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (4P) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgSales4P2.toString() + "%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("6"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (EMR) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgSalesEmr2.toString() + "%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("7"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chemist Coverage"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.chemistCov2.toString() + "%")))
              ],
            ),
          ]),
    );
  }

  //======================================= Appraisal Master Widget==============================================
  SizedBox appraisalMasterWidget(RetStr appraisalMaster) {
    return SizedBox(
      height: (appraisalMaster.kpiTable!.length * 45 + 70 + 45 + 60),
      child: DataTable2(
          border: TableBorder.all(),
          columnSpacing: 12,
          horizontalMargin: 8,
          dataRowHeight: 45,
          minWidth: 800,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) {
              return const Color.fromARGB(255, 159, 193, 165);
            },
          ),
          headingRowHeight: 70,
          columns: [
            const DataColumn2(
                fixedWidth: 40,
                label: Center(
                    child: Text(
                  "SL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            const DataColumn2(
                fixedWidth: 220,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            const DataColumn2(
                fixedWidth: 100,
                label: Center(
                    child: Text(
                  "Weightage(%)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 120,
                label: Center(
                    child: Column(
                  children: const [
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "  Score ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "1 - Below Expectation\n2 - Meets Expectation\n3 - Exceeds Expectation",
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                  ],
                ))),
            const DataColumn2(
                fixedWidth: 100,
                label: Center(
                    child: Text(
                  "Overall Result",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
          ],
          rows: kpiDataRow(appraisalMaster.kpiTable!)),
    );
  }

  List<DataRow> kpiDataRow(List<KpiTable>? kpiData) {
    return [
      ...kpiData!
          .map(
            (e) => DataRow(
              cells: [
                DataCell(Center(child: Text(e.sl!))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        e.name!,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      onPressed: () {
                        definationShowDialog(context, e.definition!);
                      },
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text("${e.weightage}%"))),
                DataCell(
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(e.supScore!.toString()),
                  ),
                ),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(overallCount(e.weightage!, e.supScore!)
                        .toStringAsFixed(2))))
              ],
            ),
          )
          .toList(),
      DataRow(
        color: MaterialStateColor.resolveWith(
            (states) => const Color.fromARGB(255, 165, 193, 170)),
        cells: [
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(
              child: Text(
            "Total (Sum of Weightage)",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ))),
          DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${totalWeightage.toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ))),
          const DataCell(Center(
              child: Text(
            "Total",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ))),
          DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              totaOverallCount.toStringAsFixed(2),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ))),
        ],
      ),
      DataRow(
        color: MaterialStateColor.resolveWith(
            (states) => const Color.fromARGB(255, 165, 193, 170)),
        // const Color.fromARGB(255, 226, 226, 226)),

        cells: [
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(
              child: Text(
            "Rounded",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ))),
          DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              totaOverallCount.round().toString(),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ))),
        ],
      ),
    ];
  }

  Future<void> definationShowDialog(
      BuildContext context, String TextLine) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'KPI Defination',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          content: Text(
            TextLine,
            style: const TextStyle(fontSize: 13),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  kpitable(AppraisalApprovalFfDetailsDataModel selfDEtails) {
    // totaOverallCount = 0.0;
    List<KpiTable>? kpiTableData = selfDEtails.resData!.retStr!.first.kpiTable;
    for (var kpi in kpiTableData!) {
      totalWeightage = totalWeightage + double.parse(kpi.weightage!);
    }
  }

  // //==================================================new================================================
  double overallCount(String weightageKey, String scrore) {
    double overallCount =
        ((double.parse(weightageKey) / 100) * double.parse(scrore));
    totaOverallCount = totaOverallCount + overallCount;

    return overallCount;
  }
}

class RowWidget extends StatelessWidget {
  String title;
  String description;
  RowWidget({super.key, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            )),
        const Expanded(
            child: Text(
          ":",
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        Expanded(
            flex: 7,
            child: Text(
              description.toString(),
            ))
      ],
    );
  }
}

//=============================Increament upgration===========================================
Container increametGradeUpgrationWidget(RetStr appraisalOthers2) {
  return Container(
    color: const Color.fromARGB(255, 170, 196, 220),
    //color: Color.fromARGB(255, 180, 206, 184),
    height: 160,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        Row(
          children: [
            const Expanded(
                flex: 9,
                child: Text(
                  "Increment Amount",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const Expanded(
                child: Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Expanded(
              flex: 7,
              child: Container(
                  height: 28,
                  padding: const EdgeInsets.only(left: 60, top: 5),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 250, 250, 250),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(appraisalOthers2.incrementAmountSup ?? "")),
            )
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Expanded(
                flex: 9,
                child: Text(
                  "Upgrade Grade",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const Expanded(
                child: Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Expanded(
              flex: 7,
              child: Transform.scale(
                scale: 1.45,
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: Checkbox(
                    value:
                        appraisalOthers2.upgradeGradeSup == '1' ? true : false,
                    onChanged: (bool? value) {
                      // setState(() {
                      //   isUpgrade = value!;
                      // });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Expanded(
                flex: 9,
                child: Text(
                  "Designation Change",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )),
            const Expanded(
                child: Text(
              ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
            Expanded(
              flex: 7,
              child: Transform.scale(
                scale: 1.45,
                child: Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: Checkbox(
                    value: appraisalOthers2.designationChangeSup == '1'
                        ? true
                        : false,
                    onChanged: (bool? value) {
                      // setState(() {
                      //   isDesignationChange = value!;
                      // });
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    ),
  );
}

class FfInformationWidget extends StatelessWidget {
  const FfInformationWidget(
      {super.key, required this.staticKey, required this.value});
  final String staticKey;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
              flex: 4,
              child: Text(
                staticKey,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          const Expanded(
              child: Text(
            ":",
            style: TextStyle(fontWeight: FontWeight.bold),
          )),
          Expanded(flex: 7, child: Text(value))
        ],
      ),
    );
  }
}
