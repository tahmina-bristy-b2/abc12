import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_details_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
  TextEditingController honestintegrityController = TextEditingController();
  TextEditingController disciplineController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController qualityofSellsController = TextEditingController();
  TextEditingController incrementController = TextEditingController();
  TextEditingController feeddbackController = TextEditingController();
  bool isUpgrade = false;
  bool isDesignationChange = false;
  bool isSubmit = false;

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
      setState(() {
        hasAppraisaldata = true;
      });
    } else {
      setState(() {
        hasAppraisaldata = false;
      });
    }
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Information"),
        centerTitle: true,
      ),
      body: hasAppraisaldata == false
          ? const SizedBox()
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
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Emplpyee Id",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        const Expanded(
                            child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            flex: 7,
                            child: Text(
                              appraisalDetailsModel!
                                  .resData.retStr[0].employeeId
                                  .toString(),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Designation",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        const Expanded(
                            child: Text(
                          ":",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        Expanded(
                            flex: 7,
                            child: Text(
                              appraisalDetailsModel!
                                  .resData.retStr[0].designation
                                  .toString(),
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Total Full Point",
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
                                .resData.retStr[0].presentGrade
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Achieved Point",
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
                                .resData.retStr[0].presentGrade
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Present Grade",
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
                                .resData.retStr[0].presentGrade
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "TR-Code",
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
                                .resData.retStr[0].trCode
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Business Segment",
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
                                .resData.retStr[0].businessSegment
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Date of Joining",
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
                                .resData.retStr[0].dateOfJoining
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Last Promotion",
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
                                .resData.retStr[0].lastPromotion
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Length of Service",
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
                                .resData.retStr[0].lengthOfService
                                .toString()))
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 4,
                            child: Text(
                              "Base Territory",
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
                                .resData.retStr[0].baseTerritory
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
                              "Length of Present TR Service",
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
                                .resData.retStr[0].lengthOfPresentTrService
                                .toString()))
                      ],
                    ),
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
  //******************************************************************************************************* */

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
          columns: const [
            DataColumn2(
                fixedWidth: 50,
                label: Center(
                    child: Text(
                  "SL No",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 210,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  "2020(jan-Dec)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  "2021(jan-Nov)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
          ],
          rows: const [
            DataRow2(
              cells: [
                DataCell(Center(child: Text("1"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Target (Value in lac)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("2"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sold (Value in Lac)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("3"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Achievement (%)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("4"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Sales/Month "))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("5"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (4P) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("6"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Share (EMR) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("7"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Avg. Rx Growth "))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("8"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("No. of Month Achieved"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                DataCell(Center(child: Text("9"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chemist Coverage"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
          ]),
    );
  }

  //======================================= Appraisal Master Widget==============================================
  SizedBox appraisalMasterWidget() {
    return SizedBox(
      height: 400,
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
                fixedWidth: 210,
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
            const DataRow2(
              cells: [
                DataCell(Center(child: Text("1"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Sales Achievement  "))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            const DataRow2(
              cells: [
                DataCell(Center(child: Text("2"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Av. Rx Share (4P)"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            const DataRow2(
              cells: [
                DataCell(Center(child: Text("3"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Av. Rx Share (EMR) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            const DataRow2(
              cells: [
                DataCell(Center(child: Text("4"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Chemist Coverage"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            const DataRow2(
              cells: [
                DataCell(Center(child: Text("5"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Exam Performance"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            const DataRow2(
              cells: [
                DataCell(Center(child: Text("6"))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("No. of Achieved Months "))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06"))),
                DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("7"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Honesty & Integrity"))),
                const DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
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
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                const DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("8"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Discipline"))),
                const DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 157, 191, 219),
                          color: Color.fromARGB(255, 222, 211, 235),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: disciplineController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
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
                const DataCell(Center(child: Text("9"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft, child: Text("Skill"))),
                const DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 222, 211, 235),
                          // color: Color.fromARGB(255, 157, 191, 219),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: skillController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                const DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("10"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Quality of Sales "))),
                const DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("60.65"))),
                DataCell(
                  Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        height: 28,
                        decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 157, 191, 219),
                          color: Color.fromARGB(255, 222, 211, 235),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: qualityofSellsController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      )),
                ),
                const DataCell(Align(
                    alignment: Alignment.centerRight, child: Text("67.06")))
              ],
            ),
            const DataRow2(
              cells: [
                DataCell(Center(child: Text(""))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Total ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "60.65",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "67.06",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "67.06",
                      style: TextStyle(fontWeight: FontWeight.bold),
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
            children: const [
              Expanded(
                  flex: 9,
                  child: Text(
                    "No. of Letter Issued",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(flex: 7, child: Text(""))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: const [
              Expanded(
                  flex: 9,
                  child: Text(
                    "Cause/Reason",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(flex: 7, child: Text(""))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: const [
              Expanded(
                  flex: 9,
                  child: Text(
                    "Action Taken",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(flex: 7, child: Text(""))
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: const [
              Expanded(
                  flex: 9,
                  child: Text(
                    "No. of Incidence",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(flex: 7, child: Text("0"))
            ],
          ),
        ]),
      ),
    );
  }

  //=============================Increament upgration Widget===========================================
  Container increametGradeUpgrationWidget() {
    return Container(
      //color: const Color.fromARGB(255, 170, 196, 220),
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
                      //ctiveColor: Color.fromARGB(255, 134, 71, 211),
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
}
