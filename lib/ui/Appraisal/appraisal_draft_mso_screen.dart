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

class AppraisalDraftMsoScreen extends StatefulWidget {
  final String cid;
  final String userId;
  final String userPass;
  final String levelDepth;
  final String employeeId;
  const AppraisalDraftMsoScreen({
    super.key,
    required this.cid,
    required this.userId,
    required this.userPass,
    required this.levelDepth,
    required this.employeeId,
  });

  @override
  State<AppraisalDraftMsoScreen> createState() =>
      _AppraisalDraftMsoScreenState();
}

class _AppraisalDraftMsoScreenState extends State<AppraisalDraftMsoScreen> {
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
  TextEditingController honestintegrityController =
      TextEditingController(text: "");
  TextEditingController disciplineController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController qualityofSellsController =
      TextEditingController(text: "");
  TextEditingController incrementController = TextEditingController();
  TextEditingController feeddbackController = TextEditingController();

  List<String>? selfDropdownValue = <String>['1', '2', '3'];
  Map<String, dynamic> dropdwonValueForSelfScore = {};
  List<Map<String, dynamic>> supDataForSubmit = [];
  List kpiValuesList = [];

  bool isSubmit = false;
  bool isDraft = false;
  bool submitConfirmation = false;
  double totalYesCount = 0.0;

  Map overalYesValuesMap = {};

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
        .getDraftAppraisalFOrMSOData(
            dmpathData!.syncUrl,
            widget.cid,
            widget.userId,
            widget.userPass,
            widget.levelDepth,
            widget.employeeId);

    if (appraisalApprovalFfDetailsData != null) {
      kpitable(appraisalApprovalFfDetailsData!);
      isDesignationChange = appraisalApprovalFfDetailsData!
                  .resData!.retStr!.first.designationChange ==
              "0"
          ? false
          : true;
      isUpgrade =
          appraisalApprovalFfDetailsData!.resData!.retStr!.first.upgradeGrade ==
                  "0"
              ? false
              : true;
      incrementController.text = appraisalApprovalFfDetailsData!
          .resData!.retStr!.first.incrementAmount!;
      feeddbackController.text =
          appraisalApprovalFfDetailsData!.resData!.retStr!.first.feedback!;

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
        title: const Text("Employee Draft"),
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
                staticKey: 'Employee Id',
                value: appraisalDetails[index].employeeId ?? ''),
            FfInformationWidget(
                staticKey: 'Employee Name',
                value: appraisalDetails[index].empName ?? ''),
            FfInformationWidget(
                staticKey: 'Designation',
                value: appraisalDetails[index].designation ?? ''),
            FfInformationWidget(
                staticKey: "Present Grade",
                value: appraisalDetails[index].presentGrade ?? ''),
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
                staticKey: "TR-Code",
                value: appraisalDetails[index].trCode ?? ''),

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
            increametGradeUpgrationWidget(
              appraisalDetails[index],
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SaveAsDraftWidget(
                    context, appraisalDetails[index], supDataForSubmit),
                submitButtonWidget(
                    context, appraisalDetails[index], supDataForSubmit)
              ],
            ),
            // !_isPressed
            //     ? Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         children: [
            //           InkWell(
            //             onTap: () {
            //               setState(() {
            //                 _isPressed = true;
            //               });
            //               String approvalRestParams =
            //                   'row_id=${appraisalDetails[index].rowId}&status=Rejected';
            //               appraisalApproval(approvalRestParams, index);
            //             },
            //             child: Container(
            //               height: 40,
            //               width: MediaQuery.of(context).size.width * 0.4,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(5),
            //                 color: Colors.red,
            //               ),
            //               // color: Colors.blue),
            //               child: const Center(
            //                   child: Text(
            //                 "Reject",
            //                 style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 18),
            //               )),
            //             ),
            //           ),
            //           InkWell(
            //             onTap: () {
            //               setState(() {
            //                 _isPressed = true;
            //               });
            //               String approvalRestParams =
            //                   'row_id=${appraisalDetails[index].rowId}&status=Approved';
            //               appraisalApproval(approvalRestParams, index);
            //             },
            //             child: Container(
            //               height: 40,
            //               width: MediaQuery.of(context).size.width * 0.4,
            //               decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(5),
            //                 color: const Color(0xff38C172),
            //               ),
            //               // color: Colors.blue),
            //               child: const Center(
            //                   child: Text(
            //                 "Approve",
            //                 style: TextStyle(
            //                     color: Colors.white,
            //                     fontWeight: FontWeight.bold,
            //                     fontSize: 18),
            //               )),
            //             ),
            //           ),
            //         ],
            //       )
            //     : Container(),
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

  //=================================== Submit Button with Validation widget ===========================================
  GestureDetector submitButtonWidget(BuildContext context, RetStr selfDEtails,
      List<Map<String, dynamic>> selpKpiData) {
    return GestureDetector(
      onTap: () async {
        kpiValuesList = [];

        List<KpiTable>? kpiTableData = selfDEtails.kpiTable;
        int counter = 0;

        for (var kpi in kpiTableData!) {
          counter++;
          // Map<String, dynamic> eachKpiValues = {
          //   "kpi_name": kpi.name,
          //   "kpi_id": kpi.kpiId,
          //   "weightage": kpi.weightage,
          //   "self_score": dropdwonValueForSelfScore[kpi.sl] ?? "0",
          //   "defination": kpi.definition,
          //   "overall_result": overallCount(
          //           kpi.weightage!, dropdwonValueForSelfScore[kpi.sl] ?? '0')
          //       .toStringAsFixed(2),
          // };
          // kpiValuesList.add(eachKpiValues);

          if (kpi.kpiEdit == "YES") {
            if ((dropdwonValueForSelfScore[kpi.sl] != null)) {
            } else {
              AllServices().toastMessage("Please select score of ${kpi.name}",
                  Colors.red, Colors.white, 16);
              break;
            }
          }
        }

        if (dropdwonValueForSelfScore.values
            .every((element) => element != null)) {
          feeddbackController.text != ""
              ? await internetCheckForSubmit(selfDEtails, selpKpiData)
              : AllServices().toastMessage("Please provide feedback first ",
                  Colors.red, Colors.white, 16);
        }

        // kpiValuesList = [];

        // List<KpiTable>? kpiTableData =
        //     selfDEtails.resData!.retStr!.first.kpiTable;
        // int counter = 0;

        // for (var kpi in kpiTableData!) {
        //   counter++;
        //   Map<String, dynamic> eachKpiValues = {
        //     "kpi_name": kpi.name,
        //     "kpi_id": kpi.kpiId,
        //     "weightage": kpi.weightage,
        //     "self_score": dropdwonValueForSelfScore[kpi.sl] ?? "0",
        //     "defination": kpi.definition,
        //     "overall_result": overallCount(
        //             kpi.weightage!, dropdwonValueForSelfScore[kpi.sl] ?? '0')
        //         .toStringAsFixed(2),
        //   };
        //   kpiValuesList.add(eachKpiValues);

        //   if (kpi.kpiEdit == "YES") {
        //     if ((dropdwonValueForSelfScore[kpi.sl] != null)) {
        //     } else {
        //       AllServices().toastMessage("Please select score of ${kpi.name}",
        //           Colors.red, Colors.white, 16);
        //       break;
        //     }
        //   }
        // }

        // if (kpiValuesList.length == counter &&
        //     dropdwonValueForSelfScore.values
        //         .every((element) => element != null)) {
        //   feeddbackController.text != ""
        //       ? await internetCheckForSubmit()
        //       : AllServices().toastMessage("Please provide feedback first ",
        //           Colors.red, Colors.white, 16);
        // }
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
  GestureDetector SaveAsDraftWidget(BuildContext context, RetStr selfDEtails,
      List<Map<String, dynamic>> supRevData) {
    return GestureDetector(
      onTap: () async {
        // kpiValuesList = [];

        // List<KpiTable>? kpiTableData = selfDEtails.kpiTable;
        // int counter = 0;

        // for (var kpi in kpiTableData!) {
        //   if (kpi.kpiEdit == "YES") {
        //     counter++;
        //     Map<String, dynamic> eachKpiValues = {
        //       "kpi_name": kpi.name,
        //       "kpi_id": kpi.kpiId,
        //       "weightage": kpi.weightage,
        //       "self_score": dropdwonValueForSelfScore[kpi.sl] ?? "0",
        //       "defination": kpi.definition,
        //       "overall_result": overallCount(
        //               kpi.weightage!, dropdwonValueForSelfScore[kpi.sl] ?? '0')
        //           .toStringAsFixed(2),
        //     };
        //     kpiValuesList.add(eachKpiValues);
        //   }
        // }

        await internetCheckForDraft(selfDEtails, supRevData);
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
      // child: Container(
      //   height: 50,
      //   width: MediaQuery.of(context).size.width * 0.4,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(5),
      //     color: const Color(0xff38C172),
      //   ),
      //   child: Center(
      //       child: isSubmit == true
      //           ? const CircularProgressIndicator(
      //               color: Colors.white,
      //             )
      //           : const Text(
      //               "Submit",
      //               style: TextStyle(
      //                   color: Colors.white,
      //                   fontWeight: FontWeight.bold,
      //                   fontSize: 18),
      //             )),
      // ),
    );
  }

  Future<void> alartDialogForSubmit(BuildContext context, RetStr retStr,
      List<Map<String, dynamic>> selpKpiData) async {
    setState(() {
      isSubmit = false;
    });

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
              const Text(
                "Are you sure to submit appraisal for this employee ?",
                style: TextStyle(fontSize: 14),
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
                setState(() {
                  isSubmit = false;
                });

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
                setState(() {
                  isSubmit = true;
                });
                submitEmployeeAppraisal(retStr, selpKpiData);
              },
            ),
          ],
        );
      },
    );
  }

  //====================================== Submit Api Call ============================================
  submitEmployeeAppraisal(
      RetStr retStr, List<Map<String, dynamic>> selpKpiData) async {
    Map<String, dynamic> submitInfo = await AppraisalRepository()
        .appraisalSubmit(
            dmpathData!.submitUrl,
            widget.cid,
            widget.userId,
            widget.userPass,
            widget.levelDepth,
            widget.employeeId,
            selpKpiData,
            retStr.headRowId ?? '',
            incrementController.text.toString() == ""
                ? "0"
                : incrementController.text.toString(),
            isUpgrade ? "1" : "0",
            isDesignationChange ? "1" : "0",
            feeddbackController.text,
            retStr.kpiKey!,
            "SUBMITTED");
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

  //====================================== Submit Api Call ============================================
  draftEmployeeAppraisal(
      RetStr retStr, List<Map<String, dynamic>> selpKpiData) async {
    Map<String, dynamic> submitInfo = await AppraisalRepository()
        .appraisalSubmit(
            dmpathData!.submitUrl,
            widget.cid,
            widget.userId,
            widget.userPass,
            widget.levelDepth,
            widget.employeeId,
            selpKpiData,
            retStr.headRowId ?? '',
            incrementController.text.toString() == ""
                ? "0"
                : incrementController.text.toString(),
            isUpgrade ? "1" : "0",
            isDesignationChange ? "1" : "0",
            feeddbackController.text,
            retStr.kpiKey!,
            "DRAFT_MSO");
    if (submitInfo != {}) {
      if (submitInfo["status"] == "Success") {
        setState(() {
          isDraft = false;
        });
        if (!mounted) return;
        Navigator.pop(context);
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

  //====================================== Internet check for Appraisal Submit============================================
  internetCheckForSubmit(
      RetStr retStr, List<Map<String, dynamic>> selpKpiData) async {
    setState(() {
      isSubmit = true;
    });
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      alartDialogForSubmit(context, retStr, selpKpiData);
    } else {
      setState(() {
        isSubmit = false;
      });
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
  }

  //====================================== Internet check for Appraisal Draft============================================
  internetCheckForDraft(
      RetStr retStr, List<Map<String, dynamic>> selpKpiData) async {
    setState(() {
      isDraft = true;
    });
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      draftEmployeeAppraisal(retStr, selpKpiData);
    } else {
      setState(() {
        isDraft = false;
      });
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
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
      height: 400,
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
                    child: Text("Avg. Rx Share (Seen Rx) "))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgSalesEmr2 ?? '')))
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

  //======================================= Appraisal Master Widget==============================================
  SizedBox appraisalMasterWidget(RetStr appraisalMaster) {
    return SizedBox(
      height: (appraisalMaster.kpiTable!.length * 45 + 70 + 45 + 50),
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
                fixedWidth: 95,
                label: Center(
                    child: Text(
                  "Weightage(%)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 100,
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
                    Text(
                      " Min - 1\nMax - 3",
                      style: TextStyle(fontSize: 10),
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
              color: MaterialStateColor.resolveWith(
                (states) {
                  return e.kpiEdit == "NO"
                      ? Colors.transparent
                      : Color.fromARGB(255, 235, 228, 244);
                  // : Color.fromARGB(255, 199, 219, 235);
                },
              ),
              cells: [
                DataCell(Center(child: Text(e.sl!))),
                DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      child: Text(
                        e.kpiEdit != "NO" ? '${e.name}*' : e.name!,
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
                e.kpiEdit == "NO"
                    ? DataCell(
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(e.selfScore!),
                        ),
                      )
                    : DataCell(SizedBox(
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
                                setState(() {
                                  dropdwonValueForSelfScore[e.sl!] = value!;
                                  overalYesValuesMap[e.sl] = {
                                    'weightage': e.weightage,
                                    'value': value
                                  };
                                  totalYesCount = 0;

                                  overalYesValuesMap.values
                                      .toList()
                                      .forEach((element) {
                                    totalYesCount += overallCount(
                                        element['weightage'],
                                        element['value'].toString());
                                  });

                                  supDataForSubmit.removeWhere(
                                      (ele) => ele["row_id"] == e.rowId);

                                  supDataForSubmit.add({
                                    "row_id": e.rowId,
                                    "self_score": value,
                                    "self_overall_score": overalResult(
                                        e.weightage,
                                        dropdwonValueForSelfScore[e.sl!])
                                  });
                                });
                              },
                            ),
                          ),
                        ),
                      )),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(overallCount(
                            e.weightage!,
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
            (states) => const Color.fromARGB(255, 165, 193, 170)),
        cells: [
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(
              child: Text(
            "Total (Sum of Weightage & Overall Result)",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ))),
          DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "${totalWeightage.toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ))),
          const DataCell(Center(
              child: Text(
            "",
          ))),
          DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              (totaOverallCount + totalYesCount).toStringAsFixed(2),
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
          const DataCell(Center(
              child: Text(
            "Total (Rounded)",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ))),
          const DataCell(Center(child: Text(""))),
          const DataCell(Center(
              child: Text(
            "",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ))),
          DataCell(Center(
              child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              (totaOverallCount + totalYesCount).round().toString(),
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

  double kpitable(AppraisalApprovalFfDetailsDataModel selfDEtails) {
    totaOverallCount = 0.0;
    int counter = 0;
    List<KpiTable>? kpiTableData = selfDEtails.resData!.retStr!.first.kpiTable;
    for (var kpi in kpiTableData!) {
      totalWeightage = totalWeightage + double.parse(kpi.weightage!);
      dropdwonValueForSelfScore[kpi.sl!] =
          kpi.selfScore == "0" ? null : kpi.selfScore;

      if (kpi.kpiEdit == 'YES' && kpi.selfScore != "0") {
        overalYesValuesMap[kpi.sl] = {
          'weightage': kpi.weightage,
          'value': kpi.selfScore
        };
        totalYesCount = 0;

        overalYesValuesMap.values.toList().forEach((element) {
          totalYesCount +=
              overallCount(element['weightage'], element['value'].toString());
        });
      }
      if (kpi.kpiEdit == "NO") {
        totaOverallCount = totaOverallCount +
            overallCount(
                kpi.weightage!, kpi.selfScore! == "0" ? "0.0" : kpi.selfScore!);
      }

      // feeddbackController.text = selfDEtails.resData!.retStr!.first.feedback!;
    }
    return totaOverallCount;
  }

  // //==================================================new================================================
  double overallCount(String weightageKey, String scrore) {
    double overallCount =
        ((double.parse(weightageKey) / 100) * double.parse(scrore));

    return overallCount;
  }

  //=============================Increament upgration===========================================
  Container increametGradeUpgrationWidget(
    RetStr appraisalOthers2,
  ) {
    return Container(
      color: const Color.fromARGB(255, 222, 211, 235),
      //color: Color.fromARGB(255, 180, 206, 184),
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
                  ),
                ),
                // child: Container(
                //   height: 28,
                //   padding: const EdgeInsets.only(left: 60, top: 5),
                //   decoration: BoxDecoration(
                //       color: const Color.fromARGB(255, 250, 250, 250),
                //       shape: BoxShape.rectangle,
                //       borderRadius: BorderRadius.circular(5)),
                //   child: Text(appraisalOthers2.incrementAmount ?? ""),
                // ),
              )
            ],
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
