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
import 'package:intl/intl.dart';

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
  TextEditingController feeddbackController = TextEditingController();

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  AppraisalApprovalFfDetailsDataModel? appraisalApprovalFfDetailsData;
  bool _isLoading = true;
  bool _isPressed = false;
  bool isUpgrade = false;
  bool isDesignationChange = false;
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
    feeddbackController.dispose();
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
            const FfInformationWidget(
              staticKey: "Total Weitage%",
              value: '',
              // value: totalAchfullPoints(appraisalDetails[index]),
            ),
            const FfInformationWidget(
              staticKey: "Achieved Point",
              value: '',
              // value: totalAchPoints(appraisalDetails[index]),
            ),
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
                        readOnly: true,
                        textAlign: TextAlign.center,
                        controller: TextEditingController(
                            text: appraisalDetails[index].feedback ?? ''),
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
                          String approvalRestParams =
                              'row_id=${appraisalDetails[index].rowId}&status=Rejected';
                          appraisalApproval(approvalRestParams, index);
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
                          String approvalRestParams =
                              'row_id=${appraisalDetails[index].rowId}&status=Approved';
                          appraisalApproval(approvalRestParams, index);
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
                            "Approve",
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
      height: (appraisalMaster.kpiTable!.length + 3) * 36,
      child: DataTable2(
          border: TableBorder.all(),
          columnSpacing: 12,
          horizontalMargin: 8,
          dataRowHeight: 35,
          minWidth: 870,
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
                fixedWidth: 200,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 90,
                label: Center(
                    child: Text(
                  "Weitage (%)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 100,
                label: Center(
                    child: Text(
                  "Score (FM)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 150,
                label: Center(
                    child: Text(
                  "Overal Result (FM)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 100,
                label: Center(
                    child: Text(
                  "Score (RSM)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 150,
                label: Center(
                    child: Text(
                  "Overal Result (RSM)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
          ],
          rows: [
            ...appraisalMaster.kpiTable!.map((element) {
              return DataRow2(
                cells: [
                  DataCell(Center(child: Text(element.sl ?? '0'))),
                  DataCell(Align(
                      alignment: Alignment.centerLeft,
                      child: Text(element.name ?? ''))),
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: Text('${element.weitage}%'))),
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: Text(element.selfScror ?? ''))),
                  const DataCell(
                      Align(alignment: Alignment.centerRight, child: Text(''))),
                  DataCell(Align(
                      alignment: Alignment.centerRight,
                      child: Text(element.supervisorScore ?? ''))),
                  const DataCell(
                      Align(alignment: Alignment.centerRight, child: Text(''))),
                ],
              );
            }).toList(),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text(''))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft, child: Text('Total'))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text('${totalWeitages(appraisalMaster)}%'))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
              ],
            ),
            DataRow2(
              cells: [
                const DataCell(Center(child: Text(''))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Rounded Total'))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text('${totalWeitages(appraisalMaster)}%'))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
                const DataCell(
                    Align(alignment: Alignment.centerRight, child: Text(''))),
              ],
            )
          ]

          // [
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("1"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Sales Achievement  "))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(
          //               appraisalMaster.salesAchievementFullPoints ?? ''))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(toCaculateMasterAchievedPoint(
          //               appraisalMaster.salesAchievementBasePoint ?? '',
          //               appraisalMaster.salesAchievementFullPoints ?? '')))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(
          //               '${appraisalMaster.salesAchievementBasePoint ?? ''}%'))),
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("2"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Av. Rx Share (4P)"))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.avRx4PFullPoints ?? ''))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(toCaculateMasterAchievedPoint(
          //               appraisalMaster.avRx4PBasePoint ?? '',
          //               appraisalMaster.avRx4PFullPoints ?? '')))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text('${appraisalMaster.avRx4PBasePoint ?? ''}%'))),
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("3"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Av. Rx Share (EMR) "))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.avRxEmrFullPoints ?? ''))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(toCaculateMasterAchievedPoint(
          //               appraisalMaster.avRxEmrBasePoint ?? '',
          //               appraisalMaster.avRxEmrFullPoints ?? '')))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text('${appraisalMaster.avRxEmrBasePoint ?? ''}%'))),
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("4"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Chemist Coverage"))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child:
          //               Text(appraisalMaster.achChemistCovFullPoints ?? ''))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(toCaculateMasterAchievedPoint(
          //               appraisalMaster.achChemistCovBasePoint ?? '',
          //               appraisalMaster.achChemistCovFullPoints ?? '')))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(
          //               '${appraisalMaster.achChemistCovBasePoint ?? ''}%')))
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("5"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Exam Performance"))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child:
          //               Text(appraisalMaster.examPerformanceFullPoints ?? ''))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(toCaculateMasterAchievedPoint(
          //               appraisalMaster.examPerformanceBasePoint ?? '',
          //               appraisalMaster.examPerformanceFullPoints ?? '')))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(
          //               '${appraisalMaster.examPerformanceBasePoint ?? '0'}%')))
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("6"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("No. of Achieved Months "))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.noAchMonthFullPoints ?? ''))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(toCaculateMasterAchievedPoint(
          //               appraisalMaster.noAchMonthBasePoint ?? '',
          //               appraisalMaster.noAchMonthFullPoints ?? '')))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.noAchMonthBasePoint ?? '0')))
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("7"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Honesty & Integrity"))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.honestyFullPoints ?? ''))),
          //       DataCell(
          //         Align(
          //             alignment: Alignment.centerRight,
          //             child: Container(
          //               height: 28,
          //               decoration: const BoxDecoration(
          //                 color: Color.fromARGB(255, 222, 211, 235),
          //                 shape: BoxShape.rectangle,
          //               ),
          //               child: TextField(
          //                 readOnly: true,
          //                 controller: TextEditingController(
          //                     text: appraisalMaster.honestyAndIntegrity ?? ''),
          //                 textAlign: TextAlign.center,
          //                 decoration: const InputDecoration(
          //                   border: InputBorder.none,
          //                 ),
          //               ),
          //             )),
          //       ),
          //       const DataCell(
          //           Align(alignment: Alignment.centerRight, child: Text("")))
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("8"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Discipline"))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.discipFullPoints ?? ''))),
          //       DataCell(
          //         Align(
          //             alignment: Alignment.centerRight,
          //             child: Container(
          //               height: 28,
          //               decoration: const BoxDecoration(
          //                 color: Color.fromARGB(255, 222, 211, 235),
          //                 shape: BoxShape.rectangle,
          //               ),
          //               child: TextField(
          //                 readOnly: true,
          //                 controller: TextEditingController(
          //                     text: appraisalMaster.discipline ?? ''),
          //                 textAlign: TextAlign.center,
          //                 decoration: const InputDecoration(
          //                   border: InputBorder.none,
          //                 ),
          //               ),
          //             )),
          //       ),
          //       const DataCell(
          //           Align(alignment: Alignment.centerRight, child: Text("")))
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("9"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft, child: Text("Skill"))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.skillFullPoints ?? ''))),
          //       DataCell(
          //         Align(
          //             alignment: Alignment.centerRight,
          //             child: Container(
          //               height: 28,
          //               decoration: const BoxDecoration(
          //                 color: Color.fromARGB(255, 222, 211, 235),
          //                 shape: BoxShape.rectangle,
          //               ),
          //               child: TextField(
          //                 readOnly: true,
          //                 textAlign: TextAlign.center,
          //                 controller: TextEditingController(
          //                     text: appraisalMaster.skill ?? ''),
          //                 decoration: const InputDecoration(
          //                   border: InputBorder.none,
          //                 ),
          //               ),
          //             )),
          //       ),
          //       const DataCell(
          //           Align(alignment: Alignment.centerRight, child: Text("")))
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text("10"))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text("Quality of Sales "))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(appraisalMaster.qualitySalesFullPoints ?? ''))),
          //       DataCell(
          //         Align(
          //             alignment: Alignment.centerRight,
          //             child: Container(
          //               height: 28,
          //               decoration: const BoxDecoration(
          //                 color: Color.fromARGB(255, 222, 211, 235),
          //                 shape: BoxShape.rectangle,
          //               ),
          //               child: TextField(
          //                 readOnly: true,
          //                 textAlign: TextAlign.center,
          //                 controller: TextEditingController(
          //                     text: appraisalMaster.qualityOfSales ?? ''),
          //                 decoration: const InputDecoration(
          //                   border: InputBorder.none,
          //                 ),
          //               ),
          //             )),
          //       ),
          //       const DataCell(
          //           Align(alignment: Alignment.centerRight, child: Text("")))
          //     ],
          //   ),
          //   DataRow2(
          //     cells: [
          //       const DataCell(Center(child: Text(""))),
          //       const DataCell(Align(
          //           alignment: Alignment.centerLeft,
          //           child: Text(
          //             "Total ",
          //             style: TextStyle(fontWeight: FontWeight.bold),
          //           ))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(
          //             totalAchfullPoints(appraisalMaster),
          //             style: const TextStyle(fontWeight: FontWeight.bold),
          //           ))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: Text(
          //             totalAchPoints(appraisalMaster),
          //             style: const TextStyle(fontWeight: FontWeight.bold),
          //           ))),
          //       DataCell(Align(
          //           alignment: Alignment.centerRight,
          //           child: totalAchBaseValue(appraisalMaster))),
          //     ],
          //   ),
          // ]
          ),
    );
  }

  String totalWeitages(RetStr appraisalMaster) {
    double weitagesTotal = 0.0;
    appraisalMaster.kpiTable!.forEach((element) {
      weitagesTotal += double.parse(element.weitage ?? '0.0');
    });

    return weitagesTotal.toStringAsFixed(0);
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
                    child: Text(appraisalOthers2.incrementAmount ?? "")),
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
                          appraisalOthers2.upgradeGrade == '1' ? true : false,
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
                      value: appraisalOthers2.designationChange == '1'
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

  void getAppraisalApprovalFFDetailsdata(String restParams) async {
    appraisalApprovalFfDetailsData = await AppraisalRepository()
        .getAppraisalApprovalFFDetails(dmpathData!.syncUrl, widget.cid,
            userInfo!.userId, widget.userPass, restParams);

    if (appraisalApprovalFfDetailsData != null) {
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

  void appraisalApproval(String approvalRestParams, int index) async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      Map<String, dynamic> approvedResponse =
          await AppraisalRepository().appraisalFFApprovalSubmit(
        dmpathData!.syncUrl,
        widget.cid,
        userInfo!.userId,
        widget.userPass,
        approvalRestParams,
      );

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
