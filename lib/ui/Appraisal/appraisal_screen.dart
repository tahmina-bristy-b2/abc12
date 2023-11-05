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
  bool isUpgrade = false;
  bool isDesignationChange = false;
  bool isSubmit = false;
  double totalAchievedPoint = 0.0;
  double totalController = 0.0;

  double salesAchieved = 0.0;
  double avgRx4pShared = 0.0;
  double avgRxEMrShared = 0.0;
  double chemistCov = 0.0;
  double examPerformance = 0.0;

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

    if (appraisalDetailsModel != null) {
      if (appraisalDetailsModel!.resData.retStr.isNotEmpty) {
        totalEachAchievedPointsDis();
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

  // //==========================================Each Achieved Points =============================================
  double salesMethod() {
    return ((double.parse(appraisalDetailsModel!
            .resData.retStr.first.salesAchievementFullPoints)) *
        (double.parse(appraisalDetailsModel!
                .resData.retStr.first.salesAchievementBasePoint) /
            100));
  }

  double avgRx4pMethod() {
    return ((double.parse(
            appraisalDetailsModel!.resData.retStr.first.avRx4pFullPoints)) *
        (double.parse(
                appraisalDetailsModel!.resData.retStr.first.avRx4pBasePoint) /
            100));
  }

  double avgRxEMrSharedMethod() {
    return ((double.parse(
            appraisalDetailsModel!.resData.retStr.first.avRxEmrFullPoints)) *
        (double.parse(
                appraisalDetailsModel!.resData.retStr.first.avRxEmrBasePoint) /
            100));
  }

  double chemistCovMethod() {
    return ((double.parse(appraisalDetailsModel!
            .resData.retStr.first.achChemistCovFullPoints)) *
        (double.parse(appraisalDetailsModel!
                .resData.retStr.first.achChemistCovBasePoint) /
            100));
  }

  double examPerformanceMethod() {
    return ((double.parse(appraisalDetailsModel!
            .resData.retStr.first.examPerformanceFullPoints)) *
        (double.parse(appraisalDetailsModel!
                        .resData.retStr.first.examPerformanceBasePoint ==
                    ""
                ? "0.0"
                : appraisalDetailsModel!
                    .resData.retStr.first.examPerformanceBasePoint) /
            100));
  }

  //================== each points data=========================
  double totalEachAchievedPointsDis() {
    return salesMethod() +
        avgRx4pMethod() +
        avgRxEMrSharedMethod() +
        chemistCovMethod() +
        examPerformanceMethod() +
        totaAchievedCountfinal();
  }

  //============================base value counte method=================================
  double totalBasevalue() {
    double percent =
        ((totaAchievedCountfinal() / totalEachAchievedPointsDis()) * 100);
    setState(() {});
    return percent;
  }

  //======================================total achieved count=====================
  double totaAchievedCountfinal() {
    totalController = double.parse(honestintegrityController.text == ''
            ? "0.0"
            : honestintegrityController.text) +
        double.parse(disciplineController.text == ''
            ? "0.0"
            : disciplineController.text) +
        double.parse(
            skillController.text == '' ? "0.0" : skillController.text) +
        double.parse(qualityofSellsController.text == ''
            ? "0.0"
            : qualityofSellsController.text);
    return totalController;
  }

  //==========================================total points calcuation=========================
  String totalcalculation() {
    return (double.parse(appraisalDetailsModel!
                .resData.retStr.first.salesAchievementFullPoints) +
            double.parse(
                appraisalDetailsModel!.resData.retStr.first.avRx4pFullPoints) +
            double.parse(
                appraisalDetailsModel!.resData.retStr.first.avRxEmrFullPoints) +
            double.parse(appraisalDetailsModel!
                .resData.retStr.first.achChemistCovFullPoints) +
            double.parse(appraisalDetailsModel!
                .resData.retStr.first.examPerformanceFullPoints) +
            double.parse(appraisalDetailsModel!
                .resData.retStr.first.noAchMonthFullPoints) +
            double.parse(
                appraisalDetailsModel!.resData.retStr.first.honestyFullPoints) +
            double.parse(
                appraisalDetailsModel!.resData.retStr.first.discipFullPoints) +
            double.parse(
                appraisalDetailsModel!.resData.retStr.first.skillFullPoints) +
            double.parse(appraisalDetailsModel!
                .resData.retStr.first.qualitySalesFullPoints))
        .toString();
  }

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
            honestintegrityController.text,
            disciplineController.text,
            skillController.text,
            qualityofSellsController.text,
            incrementController.text.toString() == ""
                ? "0"
                : incrementController.text.toString(),
            isUpgrade ? "1" : "0",
            isDesignationChange ? "1" : "0",
            feeddbackController.text);
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
                        title: "Emplpyee Id",
                        description: appraisalDetailsModel!
                            .resData.retStr[0].employeeId
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
                        title: "Total Full Point",
                        description: totalcalculation()),
                    const SizedBox(
                      height: 8,
                    ),
                    RowWidget(
                        title: "Achieved Point",
                        description:
                            totalEachAchievedPointsDis().toStringAsFixed(1)),
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
                        title: "TR-Code",
                        description: appraisalDetailsModel!
                            .resData.retStr[0].trCode
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
                    reasonActionWidget(),
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
                  "${DateTime.now().year - 1}(Jan-Dec)",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  "${DateTime.now().year}(Jan-${DateFormat('MMMM').format(DateTime.now()).substring(0, 3)})",
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
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.achievement1
                        .toString()))),
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
                        .resData.retStr.first.avgSales1
                        .toString()))),
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
                        .resData.retStr.first.avgSales4p1
                        .toString()))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.avgSales4p2
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
                        .resData.retStr.first.avgSalesEmr1
                        .toString()))),
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
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(""))),
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
                        .resData.retStr.first.noMonthAchiev1
                        .toString()))),
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
                        .resData.retStr.first.chemistCov1
                        .toString()))),
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
      height: 425,
      child: DataTable2(
          border: TableBorder.all(),
          columnSpacing: 12,
          horizontalMargin: 8,
          dataRowHeight: 35,
          minWidth: 800,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) {
              return const Color.fromARGB(255, 159, 193, 165);
            },
          ),
          headingRowHeight: 40,
          columns: const [
            DataColumn2(
                fixedWidth: 50,
                label: Center(
                    child: Text(
                  "SL No",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 190,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 80,
                label: Center(
                    child: Text(
                  "Full Points",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  "Achieved Points",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 130,
                label: Center(
                    child: Text(
                  "Base value(2021)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
          ],
          rows: [
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("1"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sales Achievement  "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.salesAchievementFullPoints))),
                DataCell(
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(salesMethod().toStringAsFixed(1)),
                  ),
                ),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.salesAchievementBasePoint}%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("2"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Av. Rx Share (4P)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.avRx4pFullPoints))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(avgRx4pMethod().toStringAsFixed(1)))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.avRx4pBasePoint}%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("3"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Av. Rx Share (EMR) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.avRxEmrFullPoints))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(avgRxEMrSharedMethod().toStringAsFixed(1)))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.avRxEmrBasePoint}%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("4"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chemist Coverage"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.achChemistCovFullPoints))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(chemistCovMethod().toStringAsFixed(1)))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.achChemistCovBasePoint}%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("5"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Exam Performance"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.examPerformanceFullPoints))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(examPerformanceMethod().toString()))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                        "${appraisalDetailsModel!.resData.retStr.first.examPerformanceBasePoint == "" ? "0.0" : appraisalDetailsModel!.resData.retStr.first.examPerformanceBasePoint}%")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("6"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("No. of Achieved Months "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.noAchMonthFullPoints))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.noAchMonthBasePoint))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.noAchMonthBasePoint)))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("7"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Honesty & Integrity"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.honestyFullPoints))),
                DataCell(
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 211, 235),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: honestintegrityController,
                          keyboardType: const TextInputType.numberWithOptions(
                            //signed: true,
                            decimal: true,
                          ),
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (String? value) {
                            setState(() {});
                          },
                        ),
                      )),
                ),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text("")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("8"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Discipline"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.discipFullPoints))),
                DataCell(
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 211, 235),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: disciplineController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      )),
                ),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text("")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("9"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft, child: Text("Skill"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.skillFullPoints))),
                DataCell(
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 211, 235),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: skillController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text("")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("10"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quality of Sales "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(appraisalDetailsModel!
                        .resData.retStr.first.qualitySalesFullPoints))),
                DataCell(
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 211, 235),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          textAlign: TextAlign.right,
                          controller: qualityofSellsController,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text("")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text(""))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Total ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      totalcalculation(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      totalEachAchievedPointsDis().toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "${totalBasevalue().toStringAsFixed(1)} %",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )))
              ],
            ),
          ]),
    );
  }

//======================================== Reason & Action widget======================================
  Container reasonActionWidget() {
    return Container(
      color: const Color(0xffF8CBAD),
      height: 110,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Row(
            children: [
              const Expanded(
                  flex: 9,
                  child: Text(
                    "No. of Letter Issued",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(
                  flex: 7,
                  child: Text(appraisalDetailsModel!
                      .resData.retStr.first.noLetterIssued
                      .toString()))
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
                    "Cause/Reason",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(
                  flex: 7,
                  child: Text(appraisalDetailsModel!.resData.retStr.first.cause
                      .toString()))
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
                    "Action Taken",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(
                  flex: 7,
                  child: Text(appraisalDetailsModel!.resData.retStr.first.action
                      .toString()))
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
                    "No. of Incidence",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(
                  flex: 7,
                  child: Text(appraisalDetailsModel!
                      .resData.retStr.first.noIncidence
                      .toString()))
            ],
          ),
        ]),
      ),
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
        honestintegrityController.text != ""
            ? disciplineController.text != ""
                ? skillController.text != ""
                    ? qualityofSellsController.text != ""
                        ? feeddbackController.text != ""
                            ? await internetCheckForSubmit()
                            : AllServices().toastMessage(
                                "Enter the value of feedback for this employee first",
                                Colors.red,
                                Colors.white,
                                16)
                        : AllServices().toastMessage(
                            "Enter the value of quality of sales for this employee first",
                            Colors.red,
                            Colors.white,
                            16)
                    : AllServices().toastMessage(
                        "Enter the value of skill for this employee first ",
                        Colors.red,
                        Colors.white,
                        16)
                : AllServices().toastMessage(
                    "Enter the value of Descipline for this employee first",
                    Colors.red,
                    Colors.white,
                    16)
            : AllServices().toastMessage(
                "Enter the value of Honesty & Integrity for this employee first",
                Colors.red,
                Colors.white,
                16);
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
