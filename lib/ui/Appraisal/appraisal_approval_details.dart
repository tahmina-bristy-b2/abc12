import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_FF_details_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AppraisalApprovalDetails extends StatefulWidget {
  const AppraisalApprovalDetails(
      {super.key,
      required this.cid,
      required this.userPass,
      this.callBackFuntion,
      required this.restParams});
  final String cid;
  final String userPass;
  final Function? callBackFuntion;
  final String restParams;

  @override
  State<AppraisalApprovalDetails> createState() =>
      _AppraisalApprovalDetailsState();
}

class _AppraisalApprovalDetailsState extends State<AppraisalApprovalDetails> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  TextEditingController honestintegrityController = TextEditingController();
  TextEditingController disciplineController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController qualityofSellsController = TextEditingController();
  TextEditingController incrementController = TextEditingController();
  TextEditingController feedbackController = TextEditingController();

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  AppraisalApprovalFfDetailsDataModel? appraisalApprovalFfDetailsData;
  bool _isLoading = true;
  bool _isPressed = false;
  bool isUpgrade = false;
  bool isDesignationChange = false;
  Map<String, dynamic> supScoreMapData = {};
  List<Map<String, dynamic>> supDataForSubmit = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getAppraisalApprovalFFDetailsdata(
        widget.restParams); // FF means Field force
  }

  String toCaculateMasterAchievedPoint(String vaseValue, String fullPoint) {
    if (vaseValue == '' || fullPoint == '') {
      return '0';
    } else {
      double result = double.parse(fullPoint) * (double.parse(vaseValue) / 100);
      return result.toStringAsFixed(2);
    }
  }

  String totalWeitages(RetStr appraisalMaster) {
    double weitagesTotal = 0.0;
    for (var element in appraisalMaster.kpiTable!) {
      weitagesTotal += double.parse(element.weightage ?? '0.0');
    }

    return weitagesTotal.toStringAsFixed(0);
  }

  String overalResult(var weitage, var selfScore) {
    double result = 0.0;
    result = double.parse(selfScore ?? '0.0') * (double.parse(weitage) / 100);
    return result.toStringAsFixed(2);
  }

  double totalOveralResult(RetStr appraisalMaster, String sup) {
    double result = 0.0;
    if (sup == 'RSM') {
      for (var element in appraisalMaster.kpiTable!) {
        result += double.parse(supScoreMapData[element.sl] ?? '0') *
            (double.parse(element.weightage ?? '0') / 100);
      }
    } else {
      for (var element in appraisalMaster.kpiTable!) {
        result += double.parse(element.selfScore ?? '0') *
            (double.parse(element.weightage ?? '0') / 100);
      }
    }

    return result;
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

  void removeFFAopraisal(int index) {
    listKey.currentState!.removeItem(
      index,
      (context, animation) {
        return appraisalListItemView(animation,
            appraisalApprovalFfDetailsData!.resData!.retStr!, index, context);
      },
      duration: const Duration(seconds: 1),
    );

    Future.delayed(const Duration(seconds: 1), () {
      appraisalApprovalFfDetailsData!.resData!.retStr!.removeAt(index);
    });

    // if (index == dsrDetails!.resData.dataList.length - 1) {
    //   return;
    // } else {
    //   dsrDetails!.resData.dataList.removeAt(index);
    // }
  }

  @override
  void dispose() {
    super.dispose();
    honestintegrityController.dispose();
    disciplineController.dispose();
    skillController.dispose();
    qualityofSellsController.dispose();
    incrementController.dispose();
    feedbackController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.callBackFuntion!('value');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("FF Appraisal Details"),
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
      ),
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
                staticKey: 'Employee Id',
                value: appraisalDetails[index].employeeId ?? ''),
            FfInformationWidget(
                staticKey: 'Designation',
                value: appraisalDetails[index].designation ?? ''),
            // const FfInformationWidget(
            //   staticKey: "Total Weitage%",
            //   value: '',
            //   // value: totalAchfullPoints(appraisalDetails[index]),
            // ),
            // const FfInformationWidget(
            //   staticKey: "Achieved Point",
            //   value: '',
            //   // value: totalAchPoints(appraisalDetails[index]),
            // ),
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
                value: appraisalDetails[index].lastAction ?? ''),

            const SizedBox(
              height: 20,
            ),
            appraisalAchievement(appraisalDetails[index]),
            const SizedBox(
              height: 8,
            ),
            appraisalMaster(appraisalDetails[index]),
            const SizedBox(
              height: 8,
            ),
            // reasonActionWidget(appraisalDetails[index]),
            // const SizedBox(
            //   height: 8,
            // ),
            increametGradeUpgrationWidget(appraisalDetails[index]),
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
                        controller: feedbackController,
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
            !_isPressed
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isPressed = true;
                          });
                          String upgradeGrade = isUpgrade ? '1' : '0';
                          String designationChange =
                              isDesignationChange ? '1' : '0';
                          String approvalRestParams =
                              'head_row_id=${appraisalDetails[index].headRowId}&increment_amount=${incrementController.text}&upgrade_grade=$upgradeGrade&designation_change=$designationChange&feedback=${feedbackController.text}&status=Rejected';
                          appraisalApproval(
                              approvalRestParams, index, supDataForSubmit);
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.red,
                          ),
                          // color: Colors.blue),
                          child: const Center(
                              child: Text(
                            "Reject",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isPressed = true;
                          });
                          String upgradeGrade = isUpgrade ? '1' : '0';
                          String designationChange =
                              isDesignationChange ? '1' : '0';
                          String approvalRestParams =
                              'head_row_id=${appraisalDetails[index].headRowId}&increment_amount=${incrementController.text}&upgrade_grade=$upgradeGrade&designation_change=$designationChange&feedback=${feedbackController.text}&status=Approved';
                          appraisalApproval(
                              approvalRestParams, index, supDataForSubmit);
                        },
                        child: Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: const Color(0xff38C172),
                          ),
                          // color: Colors.blue),
                          child: const Center(
                              child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          )),
                        ),
                      ),
                    ],
                  )
                : Container(),
            // Container(height: 100,color: Colors.,)

            const Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
              child: Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            )
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
            // DataColumn2(
            //     fixedWidth: 110,
            //     label: Center(
            //         child: Text(
            //       achievementData.previousAchievement ?? 'Previous Year',
            //       style: const TextStyle(fontWeight: FontWeight.bold),
            //     ))),
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
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.targetValue1 ?? ''))),
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
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.soldValue1 ?? ''))),
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
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.achievement1 ?? ''))),
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
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.avgSales1 ?? ''))),
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
                    child: Text("Avg. Rx Share (4P) "))),
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.avgSales4P1 ?? ''))),
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
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.avgSalesEmr1 ?? ''))),
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
                // const DataCell(
                //     Align(alignment: Alignment.centerRight, child: Text(''))),
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
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.noMonthAchiev1 ?? ''))),
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
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.chemistCov1 ?? ''))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.chemistCov2 ?? '')))
              ],
            ),
          ]),
    );
  }

  SizedBox appraisalMaster(RetStr appraisalMaster) {
    return SizedBox(
        height: (appraisalMaster.kpiTable!.length + 3) * 43,
        child: DataTable2(
            // border: TableBorder.all(),
            columnSpacing: 0,
            horizontalMargin: 0,
            dataRowHeight: (appraisalMaster.kpiTable!.length + 3) * 39,
            minWidth: 870,
            // fixedLeftColumns: 1,
            // headingRowColor: MaterialStateColor.resolveWith(
            //   (states) {
            //     return const Color.fromARGB(255, 159, 193, 165);
            //   },
            // ),
            headingRowHeight: 40,
            columns: [
              const DataColumn2(
                  fixedWidth: 300,
                  label: Center(
                      child: Text(
                    "",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
              DataColumn2(
                  fixedWidth: 180,
                  label: Container(
                    color: const Color.fromARGB(255, 159, 193, 165),
                    child: const Center(
                        child: Text(
                      "FM Review",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  )),
              const DataColumn2(
                  fixedWidth: 12,
                  label: Text(
                    "",
                  )),
              DataColumn2(
                  fixedWidth: 180,
                  label: Container(
                    color: const Color.fromARGB(255, 159, 193, 165),
                    child: const Center(
                        child: Text(
                      "RSM Review",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  )),
            ],
            rows: [
              DataRow2(cells: [
                DataCell(
                  DataTable2(
                      border: TableBorder.all(),
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      dataRowHeight: 38,
                      minWidth: 300,
                      headingRowHeight: 40,
                      columns: const [
                        DataColumn2(
                            fixedWidth: 40,
                            label: Center(
                                child: Text(
                              "SL N.",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                        DataColumn2(
                            fixedWidth: 170,
                            label: Center(
                                child: Text(
                              "Kpi Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                        DataColumn2(
                            fixedWidth: 70,
                            label: Center(
                                child: Text(
                              "Weitage %",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                      ],
                      rows: [
                        ...appraisalMaster.kpiTable!.map((element) {
                          return DataRow2(
                            cells: [
                              DataCell(Center(child: Text(element.sl ?? '0'))),
                              DataCell(
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(element.name ?? ''),
                                  ),
                                ),
                                onTap: () => _showDialouge(
                                    element.name ?? 'Title',
                                    element.definition ?? 'Defination'),
                              ),
                              DataCell(Align(
                                  alignment: Alignment.center,
                                  child: Text('${element.weightage}%'))),
                            ],
                          );
                        }).toList(),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return Colors.grey.shade300;
                            },
                          ),
                          cells: [
                            const DataCell(Center(child: Text(''))),
                            const DataCell(Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                      'Total (Sum of weitages and overal)'),
                                ))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(
                                    '${totalWeitages(appraisalMaster)}%'))),
                          ],
                        ),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return Colors.grey.shade300;
                            },
                          ),
                          cells: const [
                            DataCell(Center(child: Text(''))),
                            DataCell(Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text('Rounded Total (sum of Ovaral)'),
                                ))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(
                                    ''))), //${totalWeitages(appraisalMaster)}%
                          ],
                        )
                      ]),
                ),
                DataCell(
                  DataTable2(
                      border: TableBorder.all(),
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      dataRowHeight: 38,
                      minWidth: 180,
                      headingRowHeight: 40,
                      columns: [
                        const DataColumn2(
                            fixedWidth: 100,
                            label: Center(
                                child: Text(
                              "Score",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                        DataColumn2(
                            fixedWidth: 79,
                            label: Container(
                              color: Colors.grey[300],
                              child: const Center(
                                  child: Text(
                                "Ov. Review",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            )),
                      ],
                      rows: [
                        ...appraisalMaster.kpiTable!.map((element) {
                          return DataRow2(
                            cells: [
                              DataCell(Align(
                                  alignment: Alignment.center,
                                  child: Text(element.selfScore ?? ''))),
                              DataCell(Container(
                                color: Colors.grey.shade300,
                                child: Center(
                                    child: Text(overalResult(
                                        element.weightage, element.selfScore))),
                              )),
                            ],
                          );
                        }).toList(),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return Colors.grey.shade300;
                            },
                          ),
                          cells: [
                            const DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: Text(''))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(
                                    totalOveralResult(appraisalMaster, 'FM')
                                        .toStringAsFixed(2)))),
                          ],
                        ),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return Colors.grey.shade300;
                            },
                          ),
                          cells: [
                            //${totalWeitages(appraisalMaster)}%
                            const DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: Text(''))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(
                                    totalOveralResult(appraisalMaster, 'FM')
                                        .toStringAsFixed(0)))),
                          ],
                        )
                      ]),
                ),
                DataCell(
                  DataTable2(
                      // border: TableBorder.all(),
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      dataRowHeight: 38,
                      minWidth: 10,
                      headingRowHeight: 43,
                      columns: const [
                        DataColumn2(
                            fixedWidth: 10,
                            label: Center(
                                child: Text(
                              "",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                      ],
                      rows: []),
                ),
                DataCell(
                  DataTable2(
                      border: TableBorder.all(),
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      dataRowHeight: 38,
                      minWidth: 170,
                      headingRowHeight: 43,
                      columns: [
                        const DataColumn2(
                            fixedWidth: 100,
                            label: Center(
                                child: Text(
                              "Score",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                        DataColumn2(
                            fixedWidth: 79,
                            label: Container(
                              color: Colors.grey[300],
                              child: const Center(
                                  child: Text(
                                "Ov. Review",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            )),
                      ],
                      rows: [
                        ...appraisalMaster.kpiTable!.map((element) {
                          return DataRow2(
                            cells: [
                              element.kpiEdit == 'NO'
                                  ? DataCell(Align(
                                      alignment: Alignment.center,
                                      child: Text(element.supScore ?? '')))
                                  : DataCell(ButtonTheme(
                                      alignedDropdown: true,
                                      child: DropdownButton(
                                          hint: const Text('Select'),
                                          value: supScoreMapData[element.sl!],
                                          items: ['1', '2', '3']
                                              .map((String item) =>
                                                  DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(item)))
                                              .toList(),
                                          onChanged: (value) {
                                            supScoreMapData[element.sl!] =
                                                value;

                                            supDataForSubmit.removeWhere(
                                                (ele) =>
                                                    ele["row_id"] ==
                                                    element.rowId);

                                            supDataForSubmit.add({
                                              "row_id": element.rowId,
                                              "sup_score": value,
                                              "sup_overall_score": overalResult(
                                                  element.weightage,
                                                  supScoreMapData[element.sl!])
                                            });

                                            setState(() {});
                                          }),
                                    )),
                              DataCell(Container(
                                color: Colors.grey.shade300,
                                child: Align(
                                    alignment: Alignment.center,
                                    child: Text(overalResult(element.weightage,
                                        supScoreMapData[element.sl!]))),
                              )),
                            ],
                          );
                        }).toList(),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return Colors.grey.shade300;
                            },
                          ),
                          cells: [
                            const DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: Text(''))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(
                                    totalOveralResult(appraisalMaster, 'RSM')
                                        .toStringAsFixed(2)))),
                          ],
                        ),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return Colors.grey.shade300;
                            },
                          ),
                          cells: [
                            const DataCell(Align(
                                alignment: Alignment.centerRight,
                                child: Text(''))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(
                                    totalOveralResult(appraisalMaster, 'RSM')
                                        .toStringAsFixed(0)))),
                          ],
                        )
                      ]),
                ),
              ]),
            ])

        // DataTable2(
        //     border: TableBorder.all(),
        //     columnSpacing: 0,
        //     horizontalMargin: 0,
        //     dataRowHeight: 38,
        //     minWidth: 870,
        //     fixedLeftColumns: 1,
        //     headingRowColor: MaterialStateColor.resolveWith(
        //       (states) {
        //         return const Color.fromARGB(255, 159, 193, 165);
        //       },
        //     ),
        //     headingRowHeight: 40,
        //     columns: const [
        //       DataColumn2(
        //           fixedWidth: 40,
        //           label: Center(
        //               child: Text(
        //             "SL. N",
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ))),
        //       DataColumn2(
        //           fixedWidth: 180,
        //           label: Center(
        //               child: Text(
        //             "KPI Name",
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ))),
        //       DataColumn2(
        //           fixedWidth: 90,
        //           label: Center(
        //               child: Text(
        //             "Weitage (%)",
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ))),
        //       DataColumn2(
        //           fixedWidth: 100,
        //           label: Center(
        //               child: Text(
        //             "Score (FM)",
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ))),
        //       DataColumn2(
        //           fixedWidth: 80,
        //           label: Center(
        //               child: Text(
        //             "Ov. R.(FM)",
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ))),
        //       DataColumn2(
        //           fixedWidth: 100,
        //           label: Center(
        //               child: Text(
        //             "Score (RSM)",
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ))),
        //       DataColumn2(
        //           fixedWidth: 80,
        //           label: Center(
        //               child: Text(
        //             "Ov. R.(RSM)",
        //             style: TextStyle(fontWeight: FontWeight.bold),
        //           ))),
        //     ],
        //     rows: [
        //       ...appraisalMaster.kpiTable!.map((element) {
        //         return DataRow2(
        //           cells: [
        //             DataCell(Center(child: Text(element.sl ?? '0'))),
        //             DataCell(
        //               Align(
        //                 alignment: Alignment.centerLeft,
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(4.0),
        //                   child: Text(element.name ?? ''),
        //                 ),
        //               ),
        //               onTap: () => _showDialouge(element.name ?? 'Title',
        //                   element.definition ?? 'Defination'),
        //             ),
        //             DataCell(Align(
        //                 alignment: Alignment.center,
        //                 child: Text('${element.weitage}%'))),
        //             DataCell(Align(
        //                 alignment: Alignment.center,
        //                 child: Text(element.selfScror ?? ''))),
        //             DataCell(Container(
        //               color: Colors.grey.shade300,
        //               child: Center(
        //                   child: Text(
        //                       overalResult(element.weitage, element.selfScror))),
        //             )),
        //             element.editable == 'NO'
        //                 ? DataCell(Align(
        //                     alignment: Alignment.center,
        //                     child: Text(element.supervisorScore ?? '')))
        //                 : DataCell(ButtonTheme(
        //                     alignedDropdown: true,
        //                     child: DropdownButton(
        //                         hint: const Text('Select'),
        //                         value: supScoreMapData[element.sl!],
        //                         items: ['0', '1', '2', '3']
        //                             .map((String item) =>
        //                                 DropdownMenuItem<String>(
        //                                     value: item, child: Text(item)))
        //                             .toList(),
        //                         onChanged: (value) {
        //                           supScoreMapData[element.sl!] = value;
        //                           setState(() {});
        //                         }),
        //                   )),
        //             DataCell(Container(
        //               color: Colors.grey.shade300,
        //               child: Align(
        //                   alignment: Alignment.center,
        //                   child: Text(overalResult(
        //                       element.weitage, supScoreMapData[element.sl!]))),
        //             )),
        //           ],
        //         );
        //       }).toList(),
        //       DataRow2(
        //         color: MaterialStateColor.resolveWith(
        //           (states) {
        //             return Colors.grey.shade300;
        //           },
        //         ),
        //         cells: [
        //           const DataCell(Center(child: Text(''))),
        //           const DataCell(Align(
        //               alignment: Alignment.centerLeft,
        //               child: Padding(
        //                 padding: EdgeInsets.all(4.0),
        //                 child: Text('Total (Sum of weitages and overal)'),
        //               ))),
        //           DataCell(Align(
        //               alignment: Alignment.center,
        //               child: Text('${totalWeitages(appraisalMaster)}%'))),
        //           const DataCell(
        //               Align(alignment: Alignment.centerRight, child: Text(''))),
        //           DataCell(Align(
        //               alignment: Alignment.center,
        //               child: Text(totalOveralResult(appraisalMaster, 'FM')
        //                   .toStringAsFixed(2)))),
        //           const DataCell(
        //               Align(alignment: Alignment.centerRight, child: Text(''))),
        //           DataCell(Align(
        //               alignment: Alignment.center,
        //               child: Text(totalOveralResult(
        //                       appraisalMaster, appraisalMaster.step ?? '')
        //                   .toStringAsFixed(2)))),
        //         ],
        //       ),
        //       DataRow2(
        //         color: MaterialStateColor.resolveWith(
        //           (states) {
        //             return Colors.grey.shade300;
        //           },
        //         ),
        //         cells: [
        //           const DataCell(Center(child: Text(''))),
        //           const DataCell(Align(
        //               alignment: Alignment.centerLeft,
        //               child: Padding(
        //                 padding: EdgeInsets.all(4.0),
        //                 child: Text('Rounded Total (sum of Ovaral)'),
        //               ))),
        //           const DataCell(Align(
        //               alignment: Alignment.center,
        //               child: Text(''))), //${totalWeitages(appraisalMaster)}%
        //           const DataCell(
        //               Align(alignment: Alignment.centerRight, child: Text(''))),
        //           DataCell(Align(
        //               alignment: Alignment.center,
        //               child: Text(totalOveralResult(appraisalMaster, 'FM')
        //                   .toStringAsFixed(0)))),
        //           const DataCell(
        //               Align(alignment: Alignment.centerRight, child: Text(''))),
        //           DataCell(Align(
        //               alignment: Alignment.center,
        //               child: Text(totalOveralResult(
        //                       appraisalMaster, appraisalMaster.step ?? '')
        //                   .toStringAsFixed(0)))),
        //         ],
        //       )
        //     ]

        //     // [
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("1"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Sales Achievement  "))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(
        //     //               appraisalMaster.salesAchievementFullPoints ?? ''))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(toCaculateMasterAchievedPoint(
        //     //               appraisalMaster.salesAchievementBasePoint ?? '',
        //     //               appraisalMaster.salesAchievementFullPoints ?? '')))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(
        //     //               '${appraisalMaster.salesAchievementBasePoint ?? ''}%'))),
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("2"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Av. Rx Share (4P)"))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.avRx4PFullPoints ?? ''))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(toCaculateMasterAchievedPoint(
        //     //               appraisalMaster.avRx4PBasePoint ?? '',
        //     //               appraisalMaster.avRx4PFullPoints ?? '')))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text('${appraisalMaster.avRx4PBasePoint ?? ''}%'))),
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("3"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Av. Rx Share (EMR) "))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.avRxEmrFullPoints ?? ''))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(toCaculateMasterAchievedPoint(
        //     //               appraisalMaster.avRxEmrBasePoint ?? '',
        //     //               appraisalMaster.avRxEmrFullPoints ?? '')))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text('${appraisalMaster.avRxEmrBasePoint ?? ''}%'))),
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("4"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Chemist Coverage"))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child:
        //     //               Text(appraisalMaster.achChemistCovFullPoints ?? ''))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(toCaculateMasterAchievedPoint(
        //     //               appraisalMaster.achChemistCovBasePoint ?? '',
        //     //               appraisalMaster.achChemistCovFullPoints ?? '')))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(
        //     //               '${appraisalMaster.achChemistCovBasePoint ?? ''}%')))
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("5"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Exam Performance"))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child:
        //     //               Text(appraisalMaster.examPerformanceFullPoints ?? ''))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(toCaculateMasterAchievedPoint(
        //     //               appraisalMaster.examPerformanceBasePoint ?? '',
        //     //               appraisalMaster.examPerformanceFullPoints ?? '')))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(
        //     //               '${appraisalMaster.examPerformanceBasePoint ?? '0'}%')))
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("6"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("No. of Achieved Months "))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.noAchMonthFullPoints ?? ''))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(toCaculateMasterAchievedPoint(
        //     //               appraisalMaster.noAchMonthBasePoint ?? '',
        //     //               appraisalMaster.noAchMonthFullPoints ?? '')))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.noAchMonthBasePoint ?? '0')))
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("7"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Honesty & Integrity"))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.honestyFullPoints ?? ''))),
        //     //       DataCell(
        //     //         Align(
        //     //             alignment: Alignment.centerRight,
        //     //             child: Container(
        //     //               height: 28,
        //     //               decoration: const BoxDecoration(
        //     //                 color: Color.fromARGB(255, 222, 211, 235),
        //     //                 shape: BoxShape.rectangle,
        //     //               ),
        //     //               child: TextField(
        //     //                 readOnly: true,
        //     //                 controller: TextEditingController(
        //     //                     text: appraisalMaster.honestyAndIntegrity ?? ''),
        //     //                 textAlign: TextAlign.center,
        //     //                 decoration: const InputDecoration(
        //     //                   border: InputBorder.none,
        //     //                 ),
        //     //               ),
        //     //             )),
        //     //       ),
        //     //       const DataCell(
        //     //           Align(alignment: Alignment.centerRight, child: Text("")))
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("8"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Discipline"))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.discipFullPoints ?? ''))),
        //     //       DataCell(
        //     //         Align(
        //     //             alignment: Alignment.centerRight,
        //     //             child: Container(
        //     //               height: 28,
        //     //               decoration: const BoxDecoration(
        //     //                 color: Color.fromARGB(255, 222, 211, 235),
        //     //                 shape: BoxShape.rectangle,
        //     //               ),
        //     //               child: TextField(
        //     //                 readOnly: true,
        //     //                 controller: TextEditingController(
        //     //                     text: appraisalMaster.discipline ?? ''),
        //     //                 textAlign: TextAlign.center,
        //     //                 decoration: const InputDecoration(
        //     //                   border: InputBorder.none,
        //     //                 ),
        //     //               ),
        //     //             )),
        //     //       ),
        //     //       const DataCell(
        //     //           Align(alignment: Alignment.centerRight, child: Text("")))
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("9"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft, child: Text("Skill"))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.skillFullPoints ?? ''))),
        //     //       DataCell(
        //     //         Align(
        //     //             alignment: Alignment.centerRight,
        //     //             child: Container(
        //     //               height: 28,
        //     //               decoration: const BoxDecoration(
        //     //                 color: Color.fromARGB(255, 222, 211, 235),
        //     //                 shape: BoxShape.rectangle,
        //     //               ),
        //     //               child: TextField(
        //     //                 readOnly: true,
        //     //                 textAlign: TextAlign.center,
        //     //                 controller: TextEditingController(
        //     //                     text: appraisalMaster.skill ?? ''),
        //     //                 decoration: const InputDecoration(
        //     //                   border: InputBorder.none,
        //     //                 ),
        //     //               ),
        //     //             )),
        //     //       ),
        //     //       const DataCell(
        //     //           Align(alignment: Alignment.centerRight, child: Text("")))
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text("10"))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text("Quality of Sales "))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(appraisalMaster.qualitySalesFullPoints ?? ''))),
        //     //       DataCell(
        //     //         Align(
        //     //             alignment: Alignment.centerRight,
        //     //             child: Container(
        //     //               height: 28,
        //     //               decoration: const BoxDecoration(
        //     //                 color: Color.fromARGB(255, 222, 211, 235),
        //     //                 shape: BoxShape.rectangle,
        //     //               ),
        //     //               child: TextField(
        //     //                 readOnly: true,
        //     //                 textAlign: TextAlign.center,
        //     //                 controller: TextEditingController(
        //     //                     text: appraisalMaster.qualityOfSales ?? ''),
        //     //                 decoration: const InputDecoration(
        //     //                   border: InputBorder.none,
        //     //                 ),
        //     //               ),
        //     //             )),
        //     //       ),
        //     //       const DataCell(
        //     //           Align(alignment: Alignment.centerRight, child: Text("")))
        //     //     ],
        //     //   ),
        //     //   DataRow2(
        //     //     cells: [
        //     //       const DataCell(Center(child: Text(""))),
        //     //       const DataCell(Align(
        //     //           alignment: Alignment.centerLeft,
        //     //           child: Text(
        //     //             "Total ",
        //     //             style: TextStyle(fontWeight: FontWeight.bold),
        //     //           ))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(
        //     //             totalAchfullPoints(appraisalMaster),
        //     //             style: const TextStyle(fontWeight: FontWeight.bold),
        //     //           ))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: Text(
        //     //             totalAchPoints(appraisalMaster),
        //     //             style: const TextStyle(fontWeight: FontWeight.bold),
        //     //           ))),
        //     //       DataCell(Align(
        //     //           alignment: Alignment.centerRight,
        //     //           child: totalAchBaseValue(appraisalMaster))),
        //     //     ],
        //     //   ),
        //     // ]
        //     ),

        );
  }

  // String totalAchPoints(RetStr appraisalMaster) {
  //   return (double.parse(toCaculateMasterAchievedPoint(
  //               appraisalMaster.salesAchievementBasePoint ?? '',
  //               appraisalMaster.salesAchievementFullPoints ?? '')) +
  //           double.parse(toCaculateMasterAchievedPoint(
  //               appraisalMaster.avRx4PBasePoint ?? '',
  //               appraisalMaster.avRx4PFullPoints ?? '')) +
  //           double.parse(toCaculateMasterAchievedPoint(
  //               appraisalMaster.avRxEmrBasePoint ?? '',
  //               appraisalMaster.avRxEmrFullPoints ?? '')) +
  //           double.parse(toCaculateMasterAchievedPoint(
  //               appraisalMaster.achChemistCovBasePoint ?? '',
  //               appraisalMaster.achChemistCovFullPoints ?? '')) +
  //           double.parse(toCaculateMasterAchievedPoint(
  //               appraisalMaster.examPerformanceBasePoint ?? '',
  //               appraisalMaster.examPerformanceFullPoints ?? '')) +
  //           double.parse(toCaculateMasterAchievedPoint(
  //               appraisalMaster.noAchMonthBasePoint ?? '',
  //               appraisalMaster.noAchMonthFullPoints ?? '')) +
  //           double.parse(appraisalMaster.honestyAndIntegrity ?? '0') +
  //           double.parse(appraisalMaster.discipline ?? '0') +
  //           double.parse(appraisalMaster.skill ?? '0') +
  //           double.parse(appraisalMaster.qualityOfSales ?? '0'))
  //       .toStringAsFixed(2);
  // }

  // Text totalAchBaseValue(RetStr appraisalMaster) {
  //   return Text(
  //     '${((double.parse(toCaculateMasterAchievedPoint(appraisalMaster.salesAchievementBasePoint ?? '', appraisalMaster.salesAchievementFullPoints ?? '')) + double.parse(toCaculateMasterAchievedPoint(appraisalMaster.avRx4PBasePoint ?? '', appraisalMaster.avRx4PFullPoints ?? '')) + double.parse(toCaculateMasterAchievedPoint(appraisalMaster.avRxEmrBasePoint ?? '', appraisalMaster.avRxEmrFullPoints ?? '')) + double.parse(toCaculateMasterAchievedPoint(appraisalMaster.achChemistCovBasePoint ?? '', appraisalMaster.achChemistCovFullPoints ?? '')) + double.parse(toCaculateMasterAchievedPoint(appraisalMaster.examPerformanceBasePoint ?? '', appraisalMaster.examPerformanceFullPoints ?? '')) + double.parse(toCaculateMasterAchievedPoint(appraisalMaster.noAchMonthBasePoint ?? '', appraisalMaster.noAchMonthFullPoints ?? '')) + double.parse(appraisalMaster.honestyAndIntegrity ?? '0') + double.parse(appraisalMaster.discipline ?? '0') + double.parse(appraisalMaster.skill ?? '0') + double.parse(appraisalMaster.qualityOfSales ?? '0')) / ((double.parse(appraisalMaster.salesAchievementFullPoints ?? '0') + double.parse(appraisalMaster.avRx4PFullPoints ?? '0') + double.parse(appraisalMaster.avRxEmrFullPoints ?? '0') + double.parse(appraisalMaster.achChemistCovFullPoints ?? '0') + double.parse(appraisalMaster.examPerformanceFullPoints ?? '0') + double.parse(appraisalMaster.noAchMonthFullPoints ?? '0') + double.parse(appraisalMaster.honestyFullPoints ?? '0') + double.parse(appraisalMaster.discipFullPoints ?? '0') + double.parse(appraisalMaster.skillFullPoints ?? '0') + double.parse(appraisalMaster.qualitySalesFullPoints ?? '0'))) * 100).toStringAsFixed(2)}%',
  //     style: const TextStyle(fontWeight: FontWeight.bold),
  //   );
  // }
// Text totalAchBaseValue(RetStr appraisalMaster) {
//     return Text(
//       '${(double.parse((appraisalMaster.salesAchievementBasePoint ?? '0')) + double.parse((appraisalMaster.avRxEmrBasePoint ?? '0')) + double.parse((appraisalMaster.avRxEmrBasePoint ?? '0')) + double.parse((appraisalMaster.achChemistCovBasePoint ?? '0')) + double.parse((appraisalMaster.examPerformanceBasePoint == '' ? '0' : appraisalMaster.examPerformanceBasePoint ?? '0')) + double.parse((appraisalMaster.noAchMonthBasePoint ?? '0'))
//           // +
//           // double.parse((appraisalMaster.honestyFullPoints ?? '0')) +
//           // double.parse((appraisalMaster.discipFullPoints ?? '0')) +
//           // double.parse((appraisalMaster.skillFullPoints ?? '0')) +
//           // double.parse((appraisalMaster.qualitySalesFullPoints ?? '0'))
//           ).toStringAsFixed(2)}%',
//       style: const TextStyle(fontWeight: FontWeight.bold),
//     );
//   }

//========================================reason action widget======================================
  // Container reasonActionWidget(RetStr appraisalOthers) {
  //   return Container(
  //     color: const Color(0xffF8CBAD),
  //     height: 110,
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Column(children: [
  //         Row(
  //           children: [
  //             const Expanded(
  //                 flex: 9,
  //                 child: Text(
  //                   "No. of Letter Issued",
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 )),
  //             const Expanded(
  //                 child: Text(
  //               ":",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             )),
  //             Expanded(
  //                 flex: 7, child: Text(appraisalOthers.noLetterIssued ?? ''))
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Row(
  //           children: [
  //             const Expanded(
  //                 flex: 9,
  //                 child: Text(
  //                   "Cause/Reason",
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 )),
  //             const Expanded(
  //                 child: Text(
  //               ":",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             )),
  //             Expanded(flex: 7, child: Text(appraisalOthers.cause ?? ''))
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Row(
  //           children: [
  //             const Expanded(
  //                 flex: 9,
  //                 child: Text(
  //                   "Action Taken",
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 )),
  //             const Expanded(
  //                 child: Text(
  //               ":",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             )),
  //             Expanded(flex: 7, child: Text(appraisalOthers.action ?? ''))
  //           ],
  //         ),
  //         const SizedBox(
  //           height: 8,
  //         ),
  //         Row(
  //           children: [
  //             const Expanded(
  //                 flex: 9,
  //                 child: Text(
  //                   "No. of Incidence",
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 )),
  //             const Expanded(
  //                 child: Text(
  //               ":",
  //               style: TextStyle(fontWeight: FontWeight.bold),
  //             )),
  //             Expanded(flex: 7, child: Text(appraisalOthers.noIncidence ?? ''))
  //           ],
  //         ),
  //       ]),
  //     ),
  //   );
  // }

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
                  child: TextField(
                    controller: incrementController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                  // child: Text(appraisalOthers2.incrementAmount ?? ""),
                ),
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

  void getAppraisalApprovalFFDetailsdata(String restParams) async {
    appraisalApprovalFfDetailsData = await AppraisalRepository()
        .getAppraisalApprovalFFDetails(dmpathData!.syncUrl, widget.cid,
            userInfo!.userId, widget.userPass, restParams);

    if (appraisalApprovalFfDetailsData != null) {
      for (var element in appraisalApprovalFfDetailsData!.resData!.retStr!) {
        incrementController.text = element.incrementAmount ?? '0.0';
        feedbackController.text = element.feedback ?? '';
        isUpgrade = element.upgradeGrade == '0' ? false : true;
        isDesignationChange = element.designation == '0' ? false : true;
        for (var ele in element.kpiTable!) {
          if (element.employeeId != null &&
              ele.sl != null &&
              ele.kpiEdit == 'YES') {
            supScoreMapData[ele.sl!] = ele.supScore;
          }
        }
      }
      // print(supScoreMapData);
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

  void appraisalApproval(String approvalRestParams, int index,
      List<Map<String, dynamic>> supRevData) async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      Map<String, dynamic> approvedResponse = await AppraisalRepository()
          .appraisalFFApprovalSubmit(
              dmpathData!.submitUrl,
              widget.cid,
              userInfo!.userId,
              widget.userPass,
              approvalRestParams,
              supRevData);

      if (approvedResponse.isNotEmpty &&
          approvedResponse["status"] == "Success") {
        removeFFAopraisal(index);
        setState(() {
          _isPressed = false;
        });
      } else {
        setState(() {
          _isPressed = false;
        });
      }
    } else {
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.yellow, Colors.black, 16);
      setState(() {
        _isPressed = false;
      });
    }
  }
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
