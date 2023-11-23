import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_FF_details_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class AppraisalDraftMsoScreen extends StatefulWidget {
  final String cid;
  final String userId;
  final String userPass;
  final String levelDepth;
  final String employeeId;
  final Function callBackFuntion;
  const AppraisalDraftMsoScreen({
    super.key,
    required this.cid,
    required this.userId,
    required this.userPass,
    required this.levelDepth,
    required this.employeeId,
    required this.callBackFuntion,
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
  Map<String, TextEditingController> dropdwonValueForSelfScore = {};
  List<Map<String, dynamic>> supDataForSubmit = [];
  Map<String, bool> supScoreErrorHandling = {};
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

  // String overalResult(var weitage, var selfScore) {
  //   double result = 0.0;
  //   result = double.parse(selfScore == null ? "" : selfScore) *
  //       (double.parse(weitage) / 100);
  //   return result.toStringAsFixed(2);
  // }

  double overallCount(String weightageKey, String scrore) {
    double overallCount = ((double.parse(scrore == "" ? "0" : scrore) * 100) /
        double.parse(weightageKey));

    return overallCount;
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
      widget.callBackFuntion('value');
      Navigator.pop(context);
      // setState(() {
      //   _isLoading = false;
      // });
    }
  }

  double totalScoreResult(RetStr appraisalMaster) {
    double result = 0.0;
    for (var element in appraisalMaster.kpiTable!) {
      result += element.kpiEdit == "YES"
          ? double.parse(dropdwonValueForSelfScore[element.sl]!.text.isEmpty
              ? "0"
              : dropdwonValueForSelfScore[element.sl]!.text.toString())
          : double.parse(element.selfScore!);
      // *
      //     (double.parse(element.weightage ?? '0') / 100);
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
                              widget.callBackFuntion('value');
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
                staticKey: 'Employee ID',
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
                value: appraisalDetails[index].lastAction! == 'DRAFT_MSO'
                    ? appraisalDetails[index].lastAction!.substring(0, 5)
                    : appraisalDetails[index].lastAction!),
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

          if (kpi.kpiEdit == "YES") {
            if ((dropdwonValueForSelfScore[kpi.sl]!.text != "")) {
            } else {
              AllServices().toastMessage(
                  "Please Enter of ${kpi.name}", Colors.red, Colors.white, 16);
              break;
            }
          }
        }

        if (dropdwonValueForSelfScore.values
            .every((element) => element.text != "")) {
          await internetCheckForSubmit(selfDEtails, selpKpiData);
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

  // Future<void> alartDialogForSubmitOrDraft(
  //   BuildContext context,
  //   RetStr retStr,
  //   List<Map<String, dynamic>> selpKpiData,
  // ) async {
  //   setState(() {
  //     isSubmit = false;
  //   });

  //   return showDialog<void>(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20.0),
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SizedBox(
  //               height: 70,
  //               child: Image.asset('assets/images/alert.png'),
  //             ),
  //             const Text(
  //               "Are you sure to submit appraisal for this employee ?",
  //               style: TextStyle(fontSize: 14),
  //             ),
  //           ],
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             style: TextButton.styleFrom(
  //                 textStyle: Theme.of(context).textTheme.labelLarge,
  //                 foregroundColor: Colors.red),
  //             child: const Text('No'),
  //             onPressed: () {
  //               setState(() {
  //                 isSubmit = false;
  //               });

  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             style: TextButton.styleFrom(
  //                 textStyle: Theme.of(context).textTheme.labelLarge,
  //                 foregroundColor: Colors.green),
  //             child: const Text('Yes'),
  //             onPressed: () {
  //               Navigator.pop(context);
  //               setState(() {
  //                 isSubmit = true;
  //               });
  //               submitEmployeeAppraisal(retStr, selpKpiData);
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> alartDialogForSubmitOrDraft(BuildContext context, RetStr retStr,
      List<Map<String, dynamic>> selpKpiData, String actionName) async {
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
                  submitEmployeeAppraisal(retStr, selpKpiData);
                } else {
                  setState(() {
                    isDraft = true;
                  });
                  draftEmployeeAppraisal(retStr, selpKpiData);
                }
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
    String feedBack = feeddbackController.text.trimLeft();
    feedBack = feedBack.trimRight();
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
            feedBack,
            retStr.kpiKey!,
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
  draftEmployeeAppraisal(
      RetStr retStr, List<Map<String, dynamic>> selpKpiData) async {
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
            selpKpiData,
            retStr.headRowId ?? '',
            incrementController.text.toString() == ""
                ? "0"
                : incrementController.text.toString(),
            isUpgrade ? "1" : "0",
            isDesignationChange ? "1" : "0",
            feedBack,
            retStr.kpiKey!,
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

  //====================================== Internet check for Appraisal Submit============================================
  internetCheckForSubmit(
      RetStr retStr, List<Map<String, dynamic>> selpKpiData) async {
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
        alartDialogForSubmitOrDraft(context, retStr, selpKpiData, "submit");
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
  internetCheckForDraft(
      RetStr retStr, List<Map<String, dynamic>> selpKpiData) async {
    setState(() {
      isDraft = true;
    });
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      // draftEmployeeAppraisal(retStr, selpKpiData);
      if (!mounted) return;
      alartDialogForSubmitOrDraft(context, retStr, selpKpiData, "draft");
    } else {
      setState(() {
        isDraft = false;
      });
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
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
                  "SL No",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            const DataColumn2(
                fixedWidth: 150,
                label: Center(
                    child: Text(
                  "KPI Name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 110,
                label: Center(
                    child: Text(
                  achievementData.previousAchievement ?? 'Current Year',
                  style: const TextStyle(fontWeight: FontWeight.bold),
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
                    child: Text(achievementData.targetValue1 ?? ''))),
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
                    child: Text(achievementData.soldValue1 ?? ''))),
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
                    child: Text("${achievementData.achievement2}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text("${achievementData.achievement2}%")))
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
                    child: Text("${achievementData.avgSalesEmr1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text("${achievementData.avgSalesEmr2}%")))
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
                    child: Text("${achievementData.avgSales4P1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text("${achievementData.avgSales4P2}%")))
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
                    child: Text("${achievementData.avgSalesEmr1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text("${achievementData.avgSalesEmr2}%")))
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
                    child: Text("${achievementData.chemistCov1}%"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text("${achievementData.chemistCov2}%")))
              ],
            ),
          ]),
    );
  }

  //======================================= Appraisal Master Widget==============================================
  Column appraisalMasterWidget(RetStr appraisalMaster) {
    return Column(
      children: [
        SizedBox(
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
              headingRowHeight: 80,
              columns: const [
                DataColumn2(
                    fixedWidth: 40,
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
                    fixedWidth: 100,
                    label: Center(
                        child: Text(
                      "Weightage(%)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
                DataColumn2(
                    fixedWidth: 120,
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
                      "Achievement %",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))),
              ],
              rows: kpiDataRow(appraisalMaster.kpiTable!)),
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

  List<DataRow> kpiDataRow(List<KpiTable>? kpiData) {
    return [
      ...kpiData!
          .map(
            (e) => DataRow(
              color: MaterialStateColor.resolveWith(
                (states) {
                  return e.kpiEdit == "NO"
                      ? Colors.transparent
                      : const Color.fromARGB(255, 250, 185, 100);
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
                        definationShowDialog(
                            context, e.definitionHead!, e.definition!);
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
                    : DataCell(Container(
                        width: 300.0,
                        height: 40,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 250, 250),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(0)),
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: dropdwonValueForSelfScore[e.sl],
                          textAlign: TextAlign.right,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp("[0-9]"),
                            ),
                          ],
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(right: 8),
                          ),
                          onChanged: (value) {
                            if (value.isEmpty) return;
                            if (double.parse(value) >
                                double.parse(e.weightage!)) {
                              AllServices().toastMessage(
                                  "Input value must be less than or equal to ${e.weightage!}",
                                  Colors.red,
                                  Colors.white,
                                  12);
                              // dropdwonValueForSelfScore[e.sl]!.value =
                              //     dropdwonValueForSelfScore[e.sl]!
                              //         .value
                              //         .copyWith(
                              //           text: value.substring(
                              //               0,
                              //               int.parse(e.weitage)
                              //                       .toString()
                              //                       .length -
                              //                   1),
                              //           selection:
                              //               TextSelection.collapsed(offset: 10),
                              supScoreErrorHandling[e.sl!] = true;
                            } else if (double.parse(value) <=
                                double.parse(e.weightage!)) {
                              supScoreErrorHandling[e.sl!] = false;
                            }
                            setState(() {
                              print(
                                  "data==================${dropdwonValueForSelfScore[e.sl]!.text.toString()}");

                              overalYesValuesMap[e.sl] = {
                                'weightage': e.weightage,
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
                            supDataForSubmit
                                .removeWhere((ele) => ele["row_id"] == e.rowId);

                            supDataForSubmit.add({
                              "row_id": e.rowId,
                              "self_score": value,
                              "self_overall_score": overallCount(
                                  e.weightage!,
                                  e.kpiEdit == "YES"
                                      ? dropdwonValueForSelfScore[e.sl]!
                                          .text
                                          .toString()
                                      : "0")
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
                        // child: DropdownButtonHideUnderline(
                        //   child: ButtonTheme(
                        //     alignedDropdown: true,
                        //     child: DropdownButton(
                        //       value: dropdwonValueForSelfScore[e.sl],
                        //       hint: const Text("Select"),
                        //       items: selfDropdownValue!
                        //           .map(
                        //               (String item) => DropdownMenuItem<String>(
                        //                     value: item,
                        //                     child: Text(item),
                        //                   ))
                        //           .toList(),
                        //       onChanged: (value) {
                        //         setState(() {
                        //           dropdwonValueForSelfScore[e.sl!] = value!;
                        //           overalYesValuesMap[e.sl] = {
                        //             'weightage': e.weightage,
                        //             'value': value
                        //           };
                        //           totalYesCount = 0;

                        //           overalYesValuesMap.values
                        //               .toList()
                        //               .forEach((element) {
                        //             totalYesCount += overallCount(
                        //                 element['weightage'],
                        //                 element['value'].toString());
                        //           });

                        //           supDataForSubmit.removeWhere(
                        //               (ele) => ele["row_id"] == e.rowId);

                        //           supDataForSubmit.add({
                        //             "row_id": e.rowId,
                        //             "self_score": value,
                        //             "self_overall_score": overalResult(
                        //                 e.weightage,
                        //                 dropdwonValueForSelfScore[e.sl!])
                        //           });
                        //         });
                        //       },
                        //     ),
                        //   ),
                        // ),
                      )),

                // DataCell(
                //   Align(
                //       alignment: Alignment.centerRight,
                //       child: Text(overallCount(
                //               e.weightage!,
                //               e.kpiEdit == "NO"
                //                   ? e.selfScore
                //                   : dropdwonValueForSelfScore[e.sl] == null
                //                       ? "0.0"
                //                       : dropdwonValueForSelfScore[e.sl])
                //           .toStringAsFixed(2))),
                // )
                DataCell(Container(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(e.kpiEdit == "YES"
                              ? overallCount(
                                      e.weightage!,
                                      e.kpiEdit == "YES"
                                          ? dropdwonValueForSelfScore[e.sl]!
                                              .text
                                              .toString()
                                          : "0")
                                  .toString()
                              : e.selfOverallScore.toString()
                          // child: Text(overallCount(
                          //         e.weitage,
                          //         e.kpiEdit == "NO"
                          //             ? e.selfScore
                          //             : dropdwonValueForSelfScore[e.sl] == null
                          //                 ? "0.0"
                          //                 : dropdwonValueForSelfScore[e.sl])
                          //     .toStringAsFixed(2)),
                          )),
                ))
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
          DataCell(Center(
              child: Text(
            totalScoreResult(
                    appraisalApprovalFfDetailsData!.resData!.retStr!.first)
                .toStringAsFixed(2),
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
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

  double kpitable(AppraisalApprovalFfDetailsDataModel selfDEtails) {
    totaOverallCount = 0.0;
    int counter = 0;
    List<KpiTable>? kpiTableData = selfDEtails.resData!.retStr!.first.kpiTable;
    for (var kpi in kpiTableData!) {
      totalWeightage = totalWeightage + double.parse(kpi.weightage!);
      // dropdwonValueForSelfScore[kpi.sl!] =
      //     kpi.selfScore == "0" ? null : kpi.selfScore;
      if (kpi.kpiEdit == "YES") {
        dropdwonValueForSelfScore[kpi.sl!] = kpi.selfScore != ""
            ? TextEditingController(text: "${kpi.selfScore}")
            : TextEditingController(text: "");

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
        totaOverallCount =
            totaOverallCount + double.parse(kpi.selfOverallScore.toString());
      }

      // if (kpi.kpiEdit == "NO") {
      //   // totaOverallCount = totaOverallCount +
      //   //     overallCount(
      //   //         kpi.weightage!, kpi.selfScore! == "0" ? "0.0" : kpi.selfScore!);
      // }

      feeddbackController.text = selfDEtails.resData!.retStr!.first.feedback!;
    }
    return totaOverallCount;
  }

  // //==================================================new================================================
  // double overallCount(String weightageKey, String scrore) {
  //   double overallCount =
  //       ((double.parse(weightageKey) / 100) * double.parse(scrore));

  //   return overallCount;
  // }

  // double overallCount(String weightageKey, String scrore) {
  //   double overallCount = ((double.parse(scrore == "" ? "0" : scrore) * 100) /
  //       double.parse(weightageKey));

  //   return overallCount;
  // }

  //=============================Increament upgration===========================================
  Container increametGradeUpgrationWidget(
    RetStr appraisalOthers2,
  ) {
    return Container(
      //color: Color.fromARGB(255, 180, 206, 184),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 222, 211, 235),
          borderRadius: BorderRadius.circular(5)),
      // height: 295,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                const Expanded(
                    flex: 5,
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
                      height: 45,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 250, 250),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: incrementController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp("[0-9]"),
                          ),
                        ],
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(right: 8),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
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
          const SizedBox(
            height: 8,
          ),
          // Padding(
          //   padding: const EdgeInsets.only(
          //     right: 8.0,
          //   ),
          //   child: Row(
          //     children: [
          //       const Expanded(
          //           flex: 5,
          //           child: Text(
          //             "Designation Change",
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
          //           child: Transform.scale(
          //             scale: 1.45,
          //             child: Theme(
          //               data: ThemeData(unselectedWidgetColor: Colors.white),
          //               child: Checkbox(
          //                 value: isDesignationChange,
          //                 activeColor: const Color(0xff38C172),
          //                 onChanged: (bool? value) {
          //                   setState(() {
          //                     isDesignationChange = value!;
          //                   });
          //                 },
          //               ),
          //             ),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
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
