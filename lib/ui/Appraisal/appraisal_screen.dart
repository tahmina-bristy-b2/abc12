import 'dart:convert';

import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/appraisal/appraisal_details_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/appraisal/appraisal_repository.dart';
import 'package:MREPORTING_OFFLINE/utils/constant.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ApprisalScreen extends StatefulWidget {
  String cid;
  String userId;
  String userPass;
  String levelDepth;
  String employeeId;
  final Function callBackFuntion;
  ApprisalScreen({
    super.key,
    required this.cid,
    required this.userId,
    required this.userPass,
    required this.levelDepth,
    required this.employeeId,
    required this.callBackFuntion,
  });

  @override
  State<ApprisalScreen> createState() => _ApprisalScreenState();
}

class _ApprisalScreenState extends State<ApprisalScreen> {
  DmPathDataModel? dmpathData;
  AppraisalDetailsModel? appraisalDetailsModel;
  bool hasAppraisaldata = false;
  TextEditingController honestintegrityController =
      TextEditingController(text: "");
  TextEditingController disciplineController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController qualityofSellsController =
      TextEditingController(text: "");
  TextEditingController incrementController = TextEditingController();
  TextEditingController feeddbackController = TextEditingController();
  List<RowData> rowsList = [];
  List<String>? selfDropdownValue = <String>['1', '2', '3'];
  Map<String, bool> supScoreErrorHandling = {};
  //  List<String>? selfDropdownValue = <String>[
  //   '1-Needs Improvement',
  //   '2-Good',
  //   '3-Very good'
  // ];
  Map<String, TextEditingController> dropdwonValueForSelfScore = {};
  List kpiValuesList = [];
  bool isUpgrade = false;
  bool isDesignationChange = false;
  bool isSubmit = false;
  bool isDraft = false;
  bool submitConfirmation = false;
  double totalWeightage = 0.0;

  double totaOverallCount = 0.0;
  double finalOveralResultCount = 0.0;
  double totalYesCount = 0.0;
  Map overalYesValuesMap = {};

  @override
  void initState() {
    super.initState();
    dmpathData = Boxes.getDmpath().get('dmPathData');
    internetCheckForEmployeeDetails();
  }

  //====================================== Internet check for Employee Details Api ============================================
  internetCheckForEmployeeDetails() async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      getEmployeeDetails();
    } else {
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
  }

  //============================================ Employee Details Api Call==========================================
  getEmployeeDetails() async {
    appraisalDetailsModel = await AppraisalRepository().getEmployeeDetails(
        dmpathData!.syncUrl,
        widget.cid,
        widget.userId,
        widget.userPass,
        widget.levelDepth,
        widget.employeeId);
    // appraisalDetailsModel = appraisalDetailsModelFromJson(json.encode(data));

    if (appraisalDetailsModel != null) {
      if (appraisalDetailsModel!.resData.retStr.isNotEmpty) {
        kpitable(appraisalDetailsModel);
        // totalEachAchievedPointsDis();
        setState(() {
          hasAppraisaldata = true;
        });
      } else {
        AllServices().toastMessage(
            "Employee appraisal information data not found",
            Colors.red,
            Colors.white,
            16);
        setState(() {
          hasAppraisaldata = false;
        });
        if (!mounted) return;
        widget.callBackFuntion('value');
        Navigator.pop(context);
      }
    } else {
      setState(() {
        hasAppraisaldata = false;
      });
      if (!mounted) return;
      widget.callBackFuntion('value');
      Navigator.pop(context);
    }
  }

  kpitable(AppraisalDetailsModel? appraisalDetailsModel) {
    totaOverallCount = 0.0;
    List<KpiTable> kpiTableData =
        appraisalDetailsModel!.resData.retStr.first.kpiTable;
    for (var kpi in kpiTableData) {
      rowsList.add(
        RowData(
          sl: kpi.sl,
          name: kpi.name,
          definition: kpi.definition,
          weitage: kpi.weitage,
          kpiEdit: kpi.kpiEdit,
        ),
      );

      totaOverallCount = totaOverallCount +
          (kpi.kpiEdit == "NO" ? double.parse(kpi.selAche.toString()) : 0);

      totalWeightage = totalWeightage + double.parse(kpi.weitage);

      dropdwonValueForSelfScore[kpi.sl] = TextEditingController(text: "");
      supScoreErrorHandling[kpi.sl] = false;
    }
    print(dropdwonValueForSelfScore);
  }

  // //==================================================new================================================
  double overallCount(String weightageKey, String scrore) {
    double overallCount = ((double.parse(scrore == "" ? "0" : scrore) * 100) /
        double.parse(weightageKey));

    return overallCount;
  }

  double totalScoreResult(List<RetStr> retStr) {
    double result = 0.0;
    for (var element in retStr.first.kpiTable) {
      result += element.kpiEdit == "YES"
          ? double.parse(dropdwonValueForSelfScore[element.sl]!.text.isEmpty
              ? "0"
              : dropdwonValueForSelfScore[element.sl]!.text.toString())
          : double.parse(element.selfScore);
      // *
      //     (double.parse(element.weightage ?? '0') / 100);
    }

    return result;
  }

//====================================== Internet check for Appraisal Submit============================================
  internetCheckForSubmit() async {
    setState(() {
      isSubmit = true;
    });
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      if (supScoreErrorHandling.values.any((element) => element == true)) {
        AllServices().toastMessage(
            'Score Not more than corresponding weightage!',
            Colors.yellow,
            Colors.black,
            12);
        setState(() {
          isSubmit = false;
        });
      } else {
        if (!mounted) return;
        alartDialogForSubmitOrDraft(context, "submit");
      }
    } else {
      setState(() {
        isSubmit = false;
      });
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
  }

  //====================================== Internet check for Appraisal Draft============================================
  internetCheckForDraft() async {
    setState(() {
      isDraft = true;
    });
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      if (supScoreErrorHandling.values.any((element) => element == true)) {
        AllServices().toastMessage(
            'Score Not more than corresponding weightage!',
            Colors.yellow,
            Colors.black,
            12);
        setState(() {
          isDraft = false;
        });
      } else {
        if (!mounted) return;
        alartDialogForSubmitOrDraft(context, "draft");
      }
      //draftEmployeeAppraisal();
    } else {
      setState(() {
        isDraft = false;
      });
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
  }

//====================================== Submit Api Call ============================================
  submitEmployeeAppraisal() async {
    String feedBack = feeddbackController.text.trimLeft();
    feedBack = feedBack.trimRight();
    // print('feedBack: $feedBack');
    Map<String, dynamic> submitInfo = await AppraisalRepository()
        .appraisalSubmit(
            dmpathData!.submitUrl,
            widget.cid,
            widget.userId,
            widget.userPass,
            widget.levelDepth,
            widget.employeeId,
            kpiValuesList,
            '',
            incrementController.text.toString() == ""
                ? "0.0"
                : incrementController.text.toString(),
            isUpgrade ? "1" : "0",
            isDesignationChange ? "1" : "0",
            feedBack,
            appraisalDetailsModel!.resData.retStr.first.kpiKey,
            "SUBMITTED");
    if (submitInfo != {}) {
      if (submitInfo["status"] == "Success") {
        setState(() {
          isSubmit = false;
        });
        if (!mounted) return;
        widget.callBackFuntion('value');
        Navigator.pop(context);

        AllServices().toastMessage(
            "${submitInfo["ret_str"]}", Colors.green, Colors.white, 16);
      } else if (submitInfo["status"] == "Failed") {
        setState(() {
          isSubmit = false;
        });
        AllServices().toastMessage(
            "${submitInfo["ret_str"]}", Colors.red, Colors.white, 16);
      } else {
        setState(() {
          isSubmit = false;
        });
      }
    } else {
      setState(() {
        isSubmit = false;
      });
    }
  }

  //====================================== Submit Api Call ============================================
  draftEmployeeAppraisal() async {
    String feedBack = feeddbackController.text.trim();

    // print('feedBack: $feedBack');
    Map<String, dynamic> submitInfo = await AppraisalRepository()
        .appraisalSubmit(
            dmpathData!.submitUrl,
            widget.cid,
            widget.userId,
            widget.userPass,
            widget.levelDepth,
            widget.employeeId,
            kpiValuesList,
            '',
            incrementController.text.toString() == ""
                ? "0"
                : incrementController.text.toString(),
            isUpgrade ? "1" : "0",
            isDesignationChange ? "1" : "0",
            feedBack,
            appraisalDetailsModel!.resData.retStr.first.kpiKey,
            "DRAFT_MSO");
    if (submitInfo != {}) {
      if (submitInfo["status"] == "Success") {
        setState(() {
          isDraft = false;
        });
        if (!mounted) return;
        widget.callBackFuntion('value');
        Navigator.pop(context);

        AllServices().toastMessage(
            "${submitInfo["ret_str"]}", Colors.green, Colors.white, 16);
      } else if (submitInfo["status"] == "Failed") {
        setState(() {
          isDraft = false;
        });
        AllServices().toastMessage(
            "${submitInfo["ret_str"]}", Colors.red, Colors.white, 16);
      } else {
        setState(() {
          isDraft = false;
        });
      }
    } else {
      setState(() {
        isDraft = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    honestintegrityController.dispose();
    disciplineController.dispose();
    skillController.dispose();
    qualityofSellsController.dispose();
    incrementController.dispose();
    feeddbackController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.callBackFuntion('value');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Employee Appraisal"),
          centerTitle: true,
        ),
        body: hasAppraisaldata == false
            ? loadingWidget()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(
                              child: Icon(Icons.person,
                                  size: 35,
                                  color: Color.fromARGB(255, 153, 197, 161))),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              flex: 8,
                              child: Text(
                                appraisalDetailsModel!.resData.retStr[0].empName
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Employee ID",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].employeeId
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Employee Name",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].empName
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Designation",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].designation
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Present Grade",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].presentGrade
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Business Segment",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].businessSegment
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Date of Joining",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].dateOfJoining
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Last Promotion",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].lastPromotion
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Length of Service",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].lengthOfService
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "TR-Code",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].trCode
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Base Territory",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].baseTerritory
                              .toString()),
                      const SizedBox(
                        height: 8,
                      ),
                      RowWidget(
                          title: "Length of Present TR Service",
                          description: appraisalDetailsModel!
                              .resData.retStr[0].lengthOfPresentTrService
                              .toString()),
                      const SizedBox(
                        height: 20,
                      ),
                      appraisalAchievemetWidget(),
                      const SizedBox(
                        height: 8,
                      ),
                      appraisalMasterWidget(),
                      const SizedBox(
                        height: 8,
                      ),
                      increametGradeUpgrationWidget(),
                      const SizedBox(
                        height: 8,
                      ),
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
                      //             textAlign: TextAlign.center,
                      //             controller: feeddbackController,
                      //             keyboardType: TextInputType.text,
                      //             decoration: const InputDecoration(
                      //               hintText: 'Feedback/value of work',
                      //               border: InputBorder.none,
                      //             ),
                      //           ),
                      //         )),
                      //   ],
                      // ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SaveAsDraftWidget(context),
                          submitButtonWidget(context),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  //******************************************************************************************************* */
  //************************************************* Widgets ****************************************************** */
  //******************************************************************************************************* *

//======================================= Appraisal Achievemet Widget==============================================
  SizedBox appraisalAchievemetWidget() {
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
                fixedWidth: 40,
                label: Center(
                    child: Text(
                  "SL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            const DataColumn2(
                fixedWidth: 170,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 120,
                label: Center(
                    child: Text(
                  appraisalDetailsModel!
                      .resData.retStr.first.previousAchievement
                      .toString(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 120,
                label: Center(
                    child: Text(
                  appraisalDetailsModel!.resData.retStr.first.currentAchievement
                      .toString(),
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.targetValue1
                        .toString()))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.targetValue2
                        .toString())))
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.soldValue1
                        .toString()))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.soldValue2
                        .toString())))
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
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.achievement1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.achievement2}%")))
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
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.seenRx1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.seenRx}%")))
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
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.avgSales4P1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.avgSales4P2}%")))
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
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.avgSalesEmr1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.avgSalesEmr2}%")))
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
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.chemistCov1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.chemistCov2}%")))
              ],
            ),
          ]),
    );
  }

  //======================================= Appraisal Master Widget==============================================
  Column appraisalMasterWidget() {
    return Column(
      children: [
        SizedBox(
          height: (appraisalDetailsModel!.resData.retStr.first.kpiTable.length *
                  45 +
              70 +
              45),
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
              headingRowHeight: 60,
              columns: const [
                DataColumn2(
                    fixedWidth: 40,
                    label: Center(
                        child: Text(
                      "SL",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataColumn2(
                    fixedWidth: 400,
                    label: Center(
                        child: Text(
                      "KPI Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataColumn2(
                    fixedWidth: 80,
                    label: Center(
                        child: Text(
                      "Weightage",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataColumn2(
                    fixedWidth: 80,
                    label: Center(
                        child: Text(
                      "Score",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
                    // label: Center(
                    //     child: Column(
                    //   children: const [
                    //     SizedBox(
                    //       height: 12,
                    //     ),
                    //     Text(
                    //       "",
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //     SizedBox(
                    //       height: 5,
                    //     ),
                    //     Text(
                    //       "1 - Below Expectation\n2 - Meets Expectation\n3 - Exceeds Expectation",
                    //       style: TextStyle(fontSize: 10, color: Colors.black),
                    //     ),
                    //   ],
                    // )),
                    ),
                DataColumn2(
                    fixedWidth: 100,
                    label: Center(
                        child: Text(
                      "Achievement\n\t\t\t\t\t\t\t\t\t(%)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
              ],
              rows: kpiDataRow(
                  appraisalDetailsModel!.resData.retStr.first.kpiTable)),
        ),
        supScoreErrorHandling.values.any((element) => element == true)
            ? const Text(
                'Score not more than corresponding weightage',
                style: TextStyle(color: Colors.red),
              )
            : const SizedBox()
      ],
    );
  }

  //=============================Increament upgration Widget===========================================

  Container increametGradeUpgrationWidget() {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 222, 211, 235),
          borderRadius: BorderRadius.circular(5)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          // Padding(
          //   padding: const EdgeInsets.only(right: 8.0),
          //   child: Row(
          //     children: [
          //       const Expanded(
          //           flex: 5,
          //           child: Text(
          //             "Increment Amount",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           )),
          //       const Expanded(
          //           child: Text(
          //         ":",
          //         style: TextStyle(fontWeight: FontWeight.bold),
          //       )),
          //       Expanded(
          //         flex: 7,
          //         child: Align(
          //           alignment: Alignment.centerRight,
          //           child: Container(
          //             height: 40,
          //             decoration: BoxDecoration(
          //                 color: const Color.fromARGB(255, 250, 250, 250),
          //                 shape: BoxShape.rectangle,
          //                 borderRadius: BorderRadius.circular(5)),
          //             child: TextField(
          //               controller: incrementController,
          //               keyboardType: TextInputType.number,
          //               textAlign: TextAlign.right,
          //               inputFormatters: [
          //                 FilteringTextInputFormatter.allow(
          //                   RegExp("[0-9]"),
          //                 ),
          //               ],
          //               decoration: const InputDecoration(
          //                 border: InputBorder.none,
          //                 contentPadding: EdgeInsets.only(right: 8),
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          // const SizedBox(
          //   height: 8,
          // ),
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
            ),
            child: Row(
              children: [
                const Expanded(
                    flex: 5,
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
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Transform.scale(
                      scale: 1.45,
                      child: Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          activeColor: const Color(0xff38C172),
                          value: isUpgrade,
                          onChanged: (bool? value) {
                            setState(() {
                              isUpgrade = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: const [
                Expanded(
                  flex: 5,
                  child: Text(
                    "Feedback",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: feeddbackController,
            textInputAction: TextInputAction.done,
            maxLines: 2,
            maxLength: 60,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp("[A-Za-z0-9,-.'?! ]"),
              ),
            ],
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              hintText: 'Max 60 characters',
              hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          )
        ]),
      ),
    );
  }

  //=================================== Submit Button with Validation widget ===========================================
  GestureDetector submitButtonWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        kpiValuesList = [];

        List<KpiTable> kpiTableData =
            appraisalDetailsModel!.resData.retStr.first.kpiTable;
        int counter = 0;

        for (var kpi in kpiTableData) {
          counter++;
          Map<String, dynamic> eachKpiValues = {
            "kpi_name": kpi.name,
            "kpi_id": kpi.kpiId,
            "weightage": kpi.weitage,
            "self_score": kpi.kpiEdit == "YES"
                ? dropdwonValueForSelfScore[kpi.sl]!.text.toString()
                : kpi.selfScore,
            "defination": kpi.definition,
            "overall_result": kpi.kpiEdit == "YES"
                ? overallCount(kpi.weitage,
                        dropdwonValueForSelfScore[kpi.sl]!.text.toString())
                    .toStringAsFixed(2)
                : kpi.selAche
            // "overall_result": kpi.selAche ?? "0.0",
          };
          kpiValuesList.add(eachKpiValues);

          if (kpi.kpiEdit == "YES") {
            if ((dropdwonValueForSelfScore[kpi.sl]!.text != "")) {
            } else {
              AllServices().toastMessage(
                  "Please Enter ${kpi.name}", Colors.red, Colors.white, 16);
              break;
            }
          }
        }
        // await internetCheckForSubmit();

        if (kpiValuesList.length == counter &&
            dropdwonValueForSelfScore.values
                .every((element) => element != "")) {
          await internetCheckForSubmit();
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color(0xff38C172),
        ),
        child: Center(
            child: isSubmit == true
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
      ),
    );
  }

  //=================================== Save as Draft Button widget ===========================================
  GestureDetector SaveAsDraftWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        kpiValuesList = [];
        List<KpiTable> kpiTableData =
            appraisalDetailsModel!.resData.retStr.first.kpiTable;

        for (var kpi in kpiTableData) {
          Map<String, dynamic> eachKpiValues = {
            "kpi_name": kpi.name,
            "kpi_id": kpi.kpiId,
            "weightage": kpi.weitage,
            "self_score": kpi.kpiEdit == "YES"
                ? dropdwonValueForSelfScore[kpi.sl]!.text.toString()
                : kpi.selfScore,
            "defination": kpi.definition,
            "overall_result": kpi.kpiEdit == "YES"
                ? overallCount(kpi.weitage,
                        dropdwonValueForSelfScore[kpi.sl]!.text.toString())
                    .toStringAsFixed(2)
                : kpi.selAche
            // "kpi_name": kpi.name,
            // "kpi_id": kpi.kpiId,
            // "weightage": kpi.weitage,
            // "self_score": dropdwonValueForSelfScore[kpi.sl] ?? "0",
            // "defination": kpi.definition,
            // "overall_result": "0.0",
            // "overall_result": overallCount(
            //         kpi.weitage, dropdwonValueForSelfScore[kpi.sl] ?? '0')
            //     .toStringAsFixed(2),
          };
          kpiValuesList.add(eachKpiValues);
        }

        await internetCheckForDraft();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 48, 153, 206),
        ),
        child: Center(
            child: isDraft == true
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Text(
                    "Save as Draft",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
      ),
    );
  }

  //===================================Loading Widget=====================================
  Padding loadingWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Icon(Icons.person, size: 35, color: Colors.grey[300])),
              const SizedBox(
                width: 8,
              ),
              Expanded(
                  flex: 8,
                  child: Container(
                    margin: const EdgeInsets.only(right: 150),
                    height: 15,
                    constraints: const BoxConstraints(
                      maxHeight: double.infinity,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: Colors.grey[300],
                    ),
                  )),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                            flex: 4,
                            child: Container(
                              margin: const EdgeInsets.only(right: 30),
                              height: 12,
                              constraints: const BoxConstraints(
                                maxHeight: double.infinity,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: Colors.grey[300],
                              ),
                            )),
                        Expanded(
                            child: Text(
                          ":",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[300]),
                        )),
                        Expanded(
                          flex: 7,
                          child: Container(
                            margin: const EdgeInsets.only(right: 10),
                            height: 12,
                            constraints: const BoxConstraints(
                              maxHeight: double.infinity,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.grey[300],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  List<DataRow> kpiDataRow(List<KpiTable> kpiData) {
    return [
      ...kpiData
          .map(
            (e) => DataRow(
              color: MaterialStateColor.resolveWith(
                (states) {
                  return e.kpiEdit == "NO" ? Colors.transparent : Colors.yellow;
                  // : Color.fromARGB(255, 199, 219, 235);
                },
              ),
              cells: [
                DataCell(Center(child: Text(e.sl))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        e.kpiEdit != "NO" ? '${e.name}*' : e.name,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      onPressed: () {
                        definationShowDialog(
                            context, e.definitionHead, e.definition);
                      },
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text(e.weitage))),
                e.kpiEdit == "NO"
                    ? DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(e.selfScore),
                        ),
                      )
                    : DataCell(Container(
                        width: 300.0,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 250, 250),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(0)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(right: 8),
                          ),

                          controller: dropdwonValueForSelfScore[e.sl],
                          textAlign: TextAlign.right,
                          style: TextStyle(
                              color: supScoreErrorHandling[e.sl] == null
                                  ? Colors.black
                                  : supScoreErrorHandling[e.sl]!
                                      ? Colors.red
                                      : Colors.black),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp("[0-9]"),
                            ),
                          ],

                          onChanged: (value) {
                            if (value.isEmpty) {
                              setState(() {});
                              return;
                            }

                            if (double.parse(value) > double.parse(e.weitage)) {
                              AllServices().toastMessage(
                                  "Input value must be less than or equal to ${e.weitage}",
                                  Colors.red,
                                  Colors.white,
                                  12);
                              supScoreErrorHandling[e.sl] = true;
                            } else if (double.parse(value) <=
                                double.parse(e.weitage)) {
                              supScoreErrorHandling[e.sl] = false;
                            }
                            setState(() {
                              print(
                                  "data==================${dropdwonValueForSelfScore[e.sl]!.text.toString()}");

                              overalYesValuesMap[e.sl] = {
                                'weightage': e.weitage,
                                'value': dropdwonValueForSelfScore[e.sl]!
                                    .text
                                    .toString()
                              };
                            });

                            // work for total yes count
                            totalYesCount = 0;

                            overalYesValuesMap.values
                                .toList()
                                .forEach((element) {
                              totalYesCount += overallCount(
                                  element['weightage'],
                                  element['value'].toString());
                            });

                            // setState(() {});
                          },

                          // child: DropdownButton(
                          //   value: dropdwonValueForSelfScore[e.sl],
                          //   hint: const Text("Select"),
                          //   items: selfDropdownValue!
                          //       .map(
                          //           (String item) => DropdownMenuItem<String>(
                          //                 value: item,
                          //                 child: Text(item),
                          //               ))
                          //       .toList(),
                          //   onChanged: (value) {
                          //     setState(() {
                          //       dropdwonValueForSelfScore[e.sl] = value!;
                          //       overalYesValuesMap[e.sl] = {
                          //         'weightage': e.weitage,
                          //         'value': value
                          //       };
                          //     });

                          //     // work for total yes count
                          //     totalYesCount = 0;

                          //     overalYesValuesMap.values
                          //         .toList()
                          //         .forEach((element) {
                          //       totalYesCount += overallCount(
                          //           element['weightage'],
                          //           element['value'].toString());
                          //     });
                          //   },
                          // ),
                        ),
                      )),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(e.kpiEdit == "YES"
                            ? "${overallCount(e.weitage, e.kpiEdit == "YES" ? dropdwonValueForSelfScore[e.sl]!.text.toString() : "0").toStringAsFixed(2)}%"
                            : "${e.selAche.toString()}%"
                        // child: Text(overallCount(
                        //         e.weitage,
                        //         e.kpiEdit == "NO"
                        //             ? e.selfScore
                        //             : dropdwonValueForSelfScore[e.sl] == null
                        //                 ? "0.0"
                        //                 : dropdwonValueForSelfScore[e.sl])
                        //     .toStringAsFixed(2)),
                        )))
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
            "Total",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ))),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child: Text(
                totalWeightage.toStringAsFixed(0),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ))),
          DataCell(Align(
              alignment: Alignment.centerRight,
              child: Text(
                totalScoreResult(appraisalDetailsModel!.resData.retStr)
                    .toStringAsFixed(2),
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ))),
          const DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              // (totaOverallCount + totalYesCount).toStringAsFixed(2),
              "",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ))),
        ],
      ),
      // DataRow(
      //   color: MaterialStateColor.resolveWith(
      //       (states) => const Color.fromARGB(255, 165, 193, 170)),
      //   // const Color.fromARGB(255, 226, 226, 226)),

      //   cells: [
      //     const DataCell(Center(child: Text(""))),
      //     const DataCell(Center(child: Text(""))),
      //     const DataCell(Center(child: Text(""))),
      //     const DataCell(Center(
      //         child: Text(
      //       "Rounded",
      //       style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
      //     ))),
      //     DataCell(Center(
      //         child: Align(
      //       alignment: Alignment.centerRight,
      //       child: Text(
      //         (totaOverallCount + totalYesCount).round().toString(),
      //         style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      //       ),
      //     ))),
      //   ],
      // ),
    ];
  }

  Future<void> definationShowDialog(
      BuildContext context, String definationHead, String TextLine) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            definationHead,
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

  Future<void> alartDialogForSubmitOrDraft(
      BuildContext context, String actionName) async {
    if (actionName == "submit") {
      setState(() {
        isSubmit = false;
      });
    } else {
      setState(() {
        isDraft = false;
      });
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 70,
                child: Image.asset('assets/images/alert.png'),
              ),
              Text(
                "Are you sure to $actionName appraisal for this employee ?",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  foregroundColor: Colors.red),
              child: const Text('No'),
              onPressed: () {
                if (actionName == "submit") {
                  setState(() {
                    isSubmit = false;
                  });
                } else {
                  setState(() {
                    isDraft = false;
                  });
                }

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                  foregroundColor: Colors.green),
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);

                if (actionName == "submit") {
                  setState(() {
                    isSubmit = true;
                  });
                  submitEmployeeAppraisal();
                } else {
                  setState(() {
                    isDraft = true;
                  });
                  draftEmployeeAppraisal();
                }
              },
            ),
          ],
        );
      },
    );
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
