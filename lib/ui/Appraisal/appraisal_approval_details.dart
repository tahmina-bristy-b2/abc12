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
  String _step = '';
  String _step_sup = '';

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
    result = double.parse(selfScore) * (double.parse(weitage) / 100);
    return result.toStringAsFixed(2);
  }

  double totalOveralResult(RetStr appraisalMaster, String sup) {
    double result = 0.0;
    if (sup == 'RSM') {
      for (var element in appraisalMaster.kpiTable!) {
        result +=
            double.parse(supScoreMapData[element.sl] ?? element.supScore) *
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

            // reasonActionWidget(appraisalDetails[index]),
            // const SizedBox(
            //   height: 8,
            // ),
            increametGradeUpgration(appraisalDetails[index]),
            const SizedBox(
              height: 8,
            ),

            increametGradeUpgrationForSup(appraisalDetails[index]),

            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: _isPressed
                      ? () {}
                      : () {
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
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _isPressed ? Colors.grey[300] : Colors.red,
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
                  onTap: _isPressed
                      ? () {}
                      : () {
                          setState(() {
                            _isPressed = true;
                          });
                          String upgradeGrade = isUpgrade ? '1' : '0';
                          String designationChange =
                              isDesignationChange ? '1' : '0';
                          String approvalRestParams =
                              'head_row_id=${appraisalDetails[index].headRowId}&increment_amount=${incrementController.text}&upgrade_grade=$upgradeGrade&designation_change=$designationChange&feedback=${feedbackController.text}&status=DRAFT_SUP';
                          appraisalApproval(
                              approvalRestParams, index, supDataForSubmit);
                        },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _isPressed
                          ? Colors.grey[300]
                          : const Color.fromARGB(255, 48, 153, 206),
                    ),
                    // color: Colors.blue),
                    child: const Center(
                        child: Text(
                      "Save as Draft",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
                  ),
                ),
                InkWell(
                  onTap: _isPressed
                      ? () {}
                      : () {
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
                    width: MediaQuery.of(context).size.width * 0.3,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: _isPressed
                          ? Colors.grey[300]
                          : const Color(0xff38C172),
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
            ),
            // Container(height: 100,color: Colors.,)
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: _isPressed
                  ? () {}
                  : () {
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
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: _isPressed
                      ? Colors.grey[300]
                      : const Color.fromARGB(255, 4, 174, 247),
                ),
                // color: Colors.blue),
                child: const Center(
                    child: Text(
                  "Release",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )),
              ),
            ),

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
      height: 400,
      child: DataTable2(
          border: TableBorder.all(),
          columnSpacing: 12,
          horizontalMargin: 8,
          dataRowHeight: 35,
          minWidth: 390,
          headingRowColor: MaterialStateColor.resolveWith(
            (states) {
              return const Color.fromARGB(255, 159, 193, 165);
            },
          ),
          headingRowHeight: 40,
          columns: [
            const DataColumn2(
                fixedWidth: 30,
                label: Center(
                    child: Text(
                  "SL",
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
                    child: Text("Avg. Rx Share (Seen RX) "))),
                // DataCell(Align(
                //     alignment: Alignment.centerRight,
                //     child: Text(achievementData.avgSales4P1 ?? ''))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.seenRx ?? '')))
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text("6"))),
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
                const DataCell(Center(child: Text("7"))),
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
                const DataCell(Center(child: Text("8"))),
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
                const DataCell(Center(child: Text("9"))),
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
                const DataCell(Center(child: Text("10"))),
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
              DataColumn2(
                  fixedWidth: 280,
                  label: Container(
                    color: const Color.fromARGB(255, 159, 193, 165),
                    child: const Center(
                        child: Text(
                      "Score Scale",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  )),
              const DataColumn2(
                  fixedWidth: 12,
                  label: Text(
                    "",
                  )),
              DataColumn2(
                  fixedWidth: 152,
                  label: Container(
                    color: const Color.fromARGB(255, 159, 193, 165),
                    child: Center(
                        child: Text(
                      "$_step Appraisal",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                  )),
              const DataColumn2(
                  fixedWidth: 12,
                  label: Text(
                    "",
                  )),
              DataColumn2(
                  fixedWidth: 162,
                  label: Container(
                    color: const Color.fromARGB(255, 159, 193, 165),
                    child: Center(
                        child: Text(
                      "$_step_sup Appraisal",
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                              "SL",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                        DataColumn2(
                            fixedWidth: 170,
                            label: Center(
                                child: Text(
                              "KPI Name",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                        DataColumn2(
                            fixedWidth: 70,
                            label: Center(
                                child: Text(
                              "Weightage \n\t\t\t\t\t\t(%)",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                      ],
                      rows: [
                        ...appraisalMaster.kpiTable!.map((element) {
                          return DataRow2(
                            color: MaterialStateColor.resolveWith(
                              (states) {
                                return element.kpiEdit == "NO"
                                    ? Colors.transparent
                                    : const Color.fromARGB(255, 235, 228, 244);
                                // : Color.fromARGB(255, 199, 219, 235);
                              },
                            ),
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
                              return const Color.fromARGB(255, 159, 193, 165);
                            },
                          ),
                          cells: [
                            const DataCell(Center(child: Text(''))),
                            const DataCell(Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    'Total (Sum of Weightage and overall)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ))),
                            DataCell(Align(
                                alignment: Alignment.center,
                                child: Text(
                                  '${totalWeitages(appraisalMaster)}%',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))),
                          ],
                        ),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return const Color.fromARGB(255, 159, 193, 165);
                            },
                          ),
                          cells: const [
                            DataCell(Center(child: Text(''))),
                            DataCell(Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: Text(
                                    'Rounded Total (sum of Overall)',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
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
                      rows: const []),
                ),
                DataCell(
                  DataTable2(
                      border: TableBorder.all(),
                      columnSpacing: 0,
                      horizontalMargin: 0,
                      dataRowHeight: 38,
                      minWidth: 150,
                      headingRowHeight: 40,
                      columns: [
                        const DataColumn2(
                            fixedWidth: 70,
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
                                "Ov. Result",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            )),
                      ],
                      rows: [
                        ...appraisalMaster.kpiTable!.map((element) {
                          return DataRow2(
                            color: MaterialStateColor.resolveWith(
                              (states) {
                                return element.kpiEdit == "NO"
                                    ? Colors.transparent
                                    : const Color.fromARGB(255, 235, 228, 244);
                                // : Color.fromARGB(255, 199, 219, 235);
                              },
                            ),
                            cells: [
                              DataCell(Align(
                                  alignment: Alignment.center,
                                  child: Text(element.selfScore ?? ''))),
                              DataCell(Container(
                                color: Colors.grey.shade300,
                                // color: Colors.grey.shade300,
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
                              return const Color.fromARGB(255, 159, 193, 165);
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
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))),
                          ],
                        ),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return const Color.fromARGB(255, 159, 193, 165);
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
                                      .toStringAsFixed(0),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))),
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
                      minWidth: 160,
                      headingRowHeight: 43,
                      columns: [
                        const DataColumn2(
                            fixedWidth: 88,
                            label: Center(
                                child: Text(
                              "Score",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))),
                        DataColumn2(
                            fixedWidth: 70,
                            label: Container(
                              color: Colors.grey[300],
                              child: const Center(
                                  child: Text(
                                "Ov. Result",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                            )),
                      ],
                      rows: [
                        ...appraisalMaster.kpiTable!.map((element) {
                          return DataRow2(
                            color: MaterialStateColor.resolveWith(
                              (states) {
                                return element.kpiEdit == "NO"
                                    ? Colors.transparent
                                    : const Color.fromARGB(255, 235, 228, 244);
                                // : Color.fromARGB(255, 199, 219, 235);
                              },
                            ),
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
                                    child: Text(overalResult(
                                        element.weightage,
                                        supScoreMapData[element.sl!] ??
                                            element.supScore))),
                              )),
                            ],
                          );
                        }).toList(),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return const Color.fromARGB(255, 159, 193, 165);
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
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ))),
                          ],
                        ),
                        DataRow2(
                          color: MaterialStateColor.resolveWith(
                            (states) {
                              return const Color.fromARGB(255, 159, 193, 165);
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
                                    .toStringAsFixed(0),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            )),
                          ],
                        )
                      ]),
                ),
              ]),
            ]));
  }

  //=============================Increament upgration=========================
  Container increametGradeUpgration(RetStr appraisalOthers2) {
    return Container(
      color: const Color.fromARGB(255, 222, 211, 235),
      //color: Color.fromARGB(255, 180, 206, 184),
      // height: 160,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            '$_step SCORE',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(
            height: 15,
          ),
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
                      height: 28,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 250, 250),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        readOnly: true,
                        controller: TextEditingController(
                            text: appraisalOthers2.incrementAmount),
                        // controller: incrementController,
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
                      value:
                          appraisalOthers2.upgradeGrade == "0" ? false : true,
                      activeColor: const Color(0xff38C172),
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
                      value: appraisalOthers2.designation == "0" ? false : true,
                      activeColor: const Color(0xff38C172),
                      // value: isDesignationChange,
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
          Row(
            children: [
              const Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Feedback",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )),
              const Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(
                  flex: 7,
                  child: TextField(
                    readOnly: true,
                    textAlign: TextAlign.center,
                    controller:
                        TextEditingController(text: appraisalOthers2.feedback),
                    // controller: feedbackController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Feedback(60 Character)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
            ],
          ),
        ]),
      ),
    );
  }

//=============================Increament upgration=========================
  Container increametGradeUpgrationForSup(RetStr appraisalOthers2) {
    return Container(
      color: const Color.fromARGB(255, 170, 196, 220),

      //color: Color.fromARGB(255, 180, 206, 184),
      // height: 160,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Text(
            '$_step_sup SCORE',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 15),
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
                      height: 28,
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
                      value: isUpgrade,
                      activeColor: const Color(0xff38C172),
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
          Row(
            children: [
              const Expanded(
                  flex: 3,
                  child: Text(
                    "Feedback\n(60 Character)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
              const Expanded(
                  child: Text(
                ":",
                style: TextStyle(fontWeight: FontWeight.bold),
              )),
              Expanded(
                  flex: 7,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: feedbackController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Feedback(60 Character)',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  )),
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
      _step = appraisalApprovalFfDetailsData!.resData!.supLevelDepthNo == '1'
          ? "FM"
          : 'RSM';
      _step_sup =
          appraisalApprovalFfDetailsData!.resData!.supLevelDepthNo == '1'
              ? "RSM"
              : 'ZH';
      for (var element in appraisalApprovalFfDetailsData!.resData!.retStr!) {
        incrementController.text = element.incrementAmountSup ?? '';
        feedbackController.text = element.feedbackSup ?? '';
        isUpgrade = element.upgradeGradeSup == '0' ? false : true;
        isDesignationChange =
            element.designationChangeSup == '0' ? false : true;
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
