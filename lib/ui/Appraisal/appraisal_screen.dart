import 'dart:convert';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_details_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'dart:math';

class ApprisalScreen extends StatefulWidget {
  String cid;
  String userId;
  String userPass;
  String levelDepth;
  String employeeId;
  ApprisalScreen({
    super.key,
    required this.cid,
    required this.userId,
    required this.userPass,
    required this.levelDepth,
    required this.employeeId,
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
  Map<String, dynamic> dropdwonValueForSelfScore = {};
  List kpiValuesList = [];
  bool isUpgrade = false;
  bool isDesignationChange = false;
  bool isSubmit = false;
  //double totalOverallResult = 0.0;

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
    // appraisalDetailsModel = await AppraisalRepository().getEmployeeDetails(
    //     dmpathData!.syncUrl,
    //     widget.cid,
    //     widget.userId,
    //     widget.userPass,
    //     widget.levelDepth,
    //     widget.employeeId);
    appraisalDetailsModel =
        appraisalDetailsModelFromJson(json.encode(selfAssesmentJson));

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
        Navigator.pop(context);
      }
    } else {
      setState(() {
        hasAppraisaldata = false;
      });
      if (!mounted) return;
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
          overallCount(
              kpi.weitage, kpi.kpiEdit == "NO" ? kpi.selfScore : "0.0");
      // finalOveralResultCount = totaOverallCount;

      dropdwonValueForSelfScore.forEach((key, value) {
        key = kpi.sl;
      });
    }
  }

  // //==================================================new================================================
  double overallCount(String weightageKey, String scrore) {
    double overallCount =
        ((double.parse(weightageKey) / 100) * double.parse(scrore));

    return overallCount;
  }

  // //==========================================Each Achieved Points =============================================
  // double salesMethod() {
  //   return ((double.parse(appraisalDetailsModel!
  //           .resData.retStr.first.salesAchievementFullPoints)) *
  //       (double.parse(appraisalDetailsModel!
  //               .resData.retStr.first.salesAchievementBasePoint) /
  //           100));
  // }

  // double avgRx4pMethod() {
  //   return ((double.parse(
  //           appraisalDetailsModel!.resData.retStr.first.avRx4pFullPoints)) *
  //       (double.parse(
  //               appraisalDetailsModel!.resData.retStr.first.avRx4pBasePoint) /
  //           100));
  // }

  // double avgRxEMrSharedMethod() {
  //   return ((double.parse(
  //           appraisalDetailsModel!.resData.retStr.first.avRxEmrFullPoints)) *
  //       (double.parse(
  //               appraisalDetailsModel!.resData.retStr.first.avRxEmrBasePoint) /
  //           100));
  // }

  // double chemistCovMethod() {
  //   return ((double.parse(appraisalDetailsModel!
  //           .resData.retStr.first.achChemistCovFullPoints)) *
  //       (double.parse(appraisalDetailsModel!
  //               .resData.retStr.first.achChemistCovBasePoint) /
  //           100));
  // }

  // double examPerformanceMethod() {
  //   return ((double.parse(appraisalDetailsModel!
  //           .resData.retStr.first.examPerformanceFullPoints)) *
  //       (double.parse(appraisalDetailsModel!
  //                       .resData.retStr.first.examPerformanceBasePoint ==
  //                   ""
  //               ? "0.0"
  //               : appraisalDetailsModel!
  //                   .resData.retStr.first.examPerformanceBasePoint) /
  //           100));
  // }

  // //================== each points data=========================
  // double totalEachAchievedPointsDis() {
  //   return salesMethod() +
  //       avgRx4pMethod() +
  //       avgRxEMrSharedMethod() +
  //       chemistCovMethod() +
  //       examPerformanceMethod() +
  //       totaAchievedCountfinal();
  // }

  // //============================base value counte method=================================
  // double totalBasevalue() {
  //   double percent =
  //       ((totalEachAchievedPointsDis() / double.parse(totalcalculation())) *
  //           100);

  //   setState(() {});
  //   return percent;
  // }

  // //======================================total achieved count=====================
  // double totaAchievedCountfinal() {
  //   totalController = double.parse(honestintegrityController.text == ''
  //           ? "0.0"
  //           : honestintegrityController.text) +
  //       double.parse(disciplineController.text == ''
  //           ? "0.0"
  //           : disciplineController.text) +
  //       double.parse(
  //           skillController.text == '' ? "0.0" : skillController.text) +
  //       double.parse(qualityofSellsController.text == ''
  //           ? "0.0"
  //           : qualityofSellsController.text);
  //   return totalController;
  // }

  //==========================================total points calcuation=========================
  // String totalcalculation() {
  //   return (double.parse(appraisalDetailsModel!
  //               .resData.retStr.first.salesAchievementFullPoints) +
  //           double.parse(
  //               appraisalDetailsModel!.resData.retStr.first.avRx4pFullPoints) +
  //           double.parse(
  //               appraisalDetailsModel!.resData.retStr.first.avRxEmrFullPoints) +
  //           double.parse(appraisalDetailsModel!
  //               .resData.retStr.first.achChemistCovFullPoints) +
  //           double.parse(appraisalDetailsModel!
  //               .resData.retStr.first.examPerformanceFullPoints) +
  //           double.parse(appraisalDetailsModel!
  //               .resData.retStr.first.noAchMonthFullPoints) +
  //           double.parse(
  //               appraisalDetailsModel!.resData.retStr.first.honestyFullPoints) +
  //           double.parse(
  //               appraisalDetailsModel!.resData.retStr.first.discipFullPoints) +
  //           double.parse(
  //               appraisalDetailsModel!.resData.retStr.first.skillFullPoints) +
  //           double.parse(appraisalDetailsModel!
  //               .resData.retStr.first.qualitySalesFullPoints))
  //       .toString();
  // }

//====================================== Internet check for Appraisal Submit============================================
  internetCheckForSubmit() async {
    setState(() {
      isSubmit = true;
    });
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      submitEmployeeAppraisal();
    } else {
      setState(() {
        isSubmit = false;
      });
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
  }

//====================================== Submit Api Call ============================================
  submitEmployeeAppraisal() async {
    Map<String, dynamic> submitInfo = await AppraisalRepository()
        .appraisalSubmit(
            dmpathData!.submitUrl,
            widget.cid,
            widget.userId,
            widget.userPass,
            widget.levelDepth,
            widget.employeeId,
            kpiValuesList,
            incrementController.text.toString() == ""
                ? "0"
                : incrementController.text.toString(),
            isUpgrade ? "1" : "0",
            isDesignationChange ? "1" : "0",
            feeddbackController.text,
            appraisalDetailsModel!.resData.retStr.first.kpiKey);
    if (submitInfo != {}) {
      if (submitInfo["status"] == "Success") {
        setState(() {
          isSubmit = false;
        });
        if (!mounted) return;
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
    return Scaffold(
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
                        title: "Emplpyee ID",
                        description: appraisalDetailsModel!
                            .resData.retStr[0].employeeId
                            .toString()),
                    const SizedBox(
                      height: 8,
                    ),
                    RowWidget(
                        title: "Emplpyee Name",
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
                    Row(
                      children: [
                        const Expanded(
                            flex: 3,
                            child: Text(
                              "Feedback(60 Character)",
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
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: feeddbackController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                  hintText: 'Feedback/value of work',
                                  border: InputBorder.none,
                                ),
                              ),
                            )),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    submitButtonWidget(context)
                  ],
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
      height: 360,
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
                  "SL No",
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.achievement2
                        .toString())))
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.avgSales2
                        .toString())))
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.avRx4PBasePoint
                        .toString())))
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.avgSalesEmr2
                        .toString())))
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.avgRxGrowth
                        .toString())))
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.noMonthAchiev2
                        .toString())))
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.chemistCov2
                        .toString())))
              ],
            ),
          ]),
    );
  }

  //======================================= Appraisal Master Widget==============================================
  SizedBox appraisalMasterWidget() {
    return SizedBox(
      height:
          (appraisalDetailsModel!.resData.retStr.first.kpiTable.length * 45 +
              70 +
              45),
      child: DataTable2(
          border: TableBorder.all(),
          columnSpacing: 12,
          horizontalMargin: 8,
          dataRowHeight: 45,
          minWidth: 800,
          fixedLeftColumns: 1,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) {
              return const Color.fromARGB(255, 159, 193, 165);
            },
          ),
          headingRowHeight: 70,
          columns: const [
            DataColumn2(
                fixedWidth: 50,
                label: Center(
                    child: Text(
                  "SL",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 220,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  "% WEIGHTAGE\n       of KEY",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  "   SCORE \n(min-max)\n    1 2 3",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 130,
                label: Center(
                    child: Text(
                  "OVERALL RESULT",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
          ],
          rows:
              kpiDataRow(appraisalDetailsModel!.resData.retStr.first.kpiTable)),
    );
  }

  //=============================Increament upgration Widget===========================================
  Container increametGradeUpgrationWidget() {
    return Container(
      color: const Color.fromARGB(255, 222, 211, 235),
      height: 170,
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
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 250, 250),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: incrementController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                        ),
                      ),
                    )),
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
                      value: isDesignationChange,
                      activeColor: const Color(0xff38C172),
                      onChanged: (bool? value) {
                        setState(() {
                          isDesignationChange = value!;
                        });
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

  //=================================== Submit Button with Validation widget ===========================================
  GestureDetector submitButtonWidget(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        kpiValuesList = [];

        List<KpiTable> kpiTableData =
            appraisalDetailsModel!.resData.retStr.first.kpiTable;
        int counter = 0;

        for (var kpi in kpiTableData) {
          if (kpi.kpiEdit == "YES") {
            counter++;
            if ((dropdwonValueForSelfScore[kpi.sl] != null)) {
              Map<String, dynamic> eachKpiValues = {
                "kpi_name": kpi.name,
                "kpi_id": kpi.kpiId,
                "weightage": kpi.weitage,
                "self_score": dropdwonValueForSelfScore[kpi.sl],
                "defination": kpi.definition,
                "overall_result":
                    overallCount(kpi.weitage, dropdwonValueForSelfScore[kpi.sl])
                        .toStringAsFixed(2),
              };
              kpiValuesList.add(eachKpiValues);
            } else {
              AllServices().toastMessage("Please select score of ${kpi.name}",
                  Colors.red, Colors.white, 16);
              break;
            }
          }
        }

        if (kpiValuesList.length == counter) {
          feeddbackController.text != ""
              ? await internetCheckForSubmit()
              : AllServices().toastMessage("Please provide feedback first ",
                  Colors.red, Colors.white, 16);
        }
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
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
              cells: [
                DataCell(Center(child: Text(e.sl))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        overalYesValuesMap.containsKey(e.sl)
                            ? '${e.name}*'
                            : e.name,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w400),
                      ),
                      onPressed: () {
                        definationShowDialog(context, e.definition);
                      },
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text("${e.weitage}%"))),
                e.kpiEdit == "NO"
                    ? DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(e.selfScore),
                        ),
                      )
                    : DataCell(Container(
                        width: 300.0,
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButton(
                              value: dropdwonValueForSelfScore[e.sl],
                              hint: const Text("Select"),
                              items: selfDropdownValue!
                                  .map(
                                      (String item) => DropdownMenuItem<String>(
                                            value: item,
                                            child: Text(item),
                                          ))
                                  .toList(),
                              onChanged: (value) {
                                // finalOverallCount(
                                //     overallCount(e.weitage, value.toString()));

                                setState(() {
                                  dropdwonValueForSelfScore[e.sl] = value!;
                                  overalYesValuesMap[e.sl] = {
                                    'weightage': e.weitage,
                                    'value': value
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
                              },
                            ),
                          ),
                        ),
                      )),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(overallCount(
                            e.weitage,
                            e.kpiEdit == "NO"
                                ? e.selfScore
                                : dropdwonValueForSelfScore[e.sl] == null
                                    ? "0.0"
                                    : dropdwonValueForSelfScore[e.sl])
                        .toStringAsFixed(2))))
              ],
            ),
          )
          .toList(),
      DataRow(
        color: MaterialStateColor.resolveWith(
            (states) => Color.fromARGB(255, 226, 226, 226)),
        cells: [
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(
              child: Text(
            "Total",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ))),
          DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              (totaOverallCount + totalYesCount).toStringAsFixed(2),
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
