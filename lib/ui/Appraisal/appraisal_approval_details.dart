import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_FF_details_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppraisalApprovalDetails extends StatefulWidget {
  const AppraisalApprovalDetails(
      {super.key,
      required this.cid,
      required this.userPass,
      this.callBackFuntion});
  final String cid;
  final String userPass;
  final Function? callBackFuntion;

  @override
  State<AppraisalApprovalDetails> createState() =>
      _AppraisalApprovalDetailsState();
}

class _AppraisalApprovalDetailsState extends State<AppraisalApprovalDetails> {
  TextEditingController honestintegrityController = TextEditingController();
  TextEditingController disciplineController = TextEditingController();
  TextEditingController skillController = TextEditingController();
  TextEditingController qualityofSellsController = TextEditingController();
  TextEditingController incrementController = TextEditingController();
  TextEditingController feeddbackController = TextEditingController();

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  AppraisalApprovalFfDetailsDataModel? appraisalApprovalFfDetailsData;
  bool _isLoading = false;
  bool isUpgrade = false;
  bool isDesignationChange = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getAppraisalApprovalFFDetailsdata(); // FF means Field force
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
                    context, appraisalApprovalFfDetailsData!.resData!.retStr),
      ),
    );
  }

  ListView fieldForceAppraisalview(
      BuildContext context, List<RetStr>? appraisalDetails) {
    return ListView.builder(
        itemCount: appraisalDetails!.length,
        itemBuilder: (itemBuilder, index) {
          return Padding(
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
                    staticKey: "Total Full Point", value: '400'),
                const FfInformationWidget(
                    staticKey: "Achieved Point", value: '180'),
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
                    value:
                        appraisalDetails[index].lengthOfPresentTrService ?? ''),

                const SizedBox(
                  height: 20,
                ),
                appraisalAchievement(appraisalDetails[index]),
                const SizedBox(
                  height: 8,
                ),
                appraisalMaster(),
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
                    Container(
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
                    Container(
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
                  ],
                ),
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
          );
        });
  }

  SizedBox appraisalAchievement(RetStr achievementData) {
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
                    child: Text(achievementData.achievement1 ?? ''))),
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
                    child: Text(achievementData.avgSales1 ?? ''))),
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
                    child: Text(achievementData.avgSales4P1 ?? ''))),
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
                    child: Text(achievementData.avgSalesEmr1 ?? ''))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.avgSalesEmr2 ?? '')))
              ],
            ),
            const DataRow2(
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
                const DataCell(Center(child: Text("8"))),
                const DataCell(Align(
                    alignment: Alignment.centerLeft,
                    child: Text("No. of Month Achieved"))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.noMonthAchiev1 ?? ''))),
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
                    child: Text(achievementData.chemistCov1 ?? ''))),
                DataCell(Align(
                    alignment: Alignment.centerRight,
                    child: Text(achievementData.chemistCov2 ?? '')))
              ],
            ),
          ]),
    );
  }

  SizedBox appraisalMaster() {
    return SizedBox(
      height: 11 * 40,
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
                fixedWidth: 120,
                label: Center(
                    child: Text(
                  "Achieved Points",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ))),
            DataColumn2(
                fixedWidth: 120,
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
                          color: Color.fromARGB(255, 157, 191, 219),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: honestintegrityController,
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
                          color: Color.fromARGB(255, 157, 191, 219),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: disciplineController,
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
                          color: Color.fromARGB(255, 157, 191, 219),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          controller: skillController,
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
                          color: Color.fromARGB(255, 157, 191, 219),
                          shape: BoxShape.rectangle,
                        ),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: qualityofSellsController,
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

//========================================reason action widget======================================
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

  //=============================Increament upgration===========================================
  Container increametGradeUpgrationWidget() {
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
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                        height: 28,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 250, 250, 250),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text('Increment Amount')
                        // const TextField(
                        //   textAlign: TextAlign.center,
                        //   decoration: InputDecoration(
                        //     border: InputBorder.none,
                        //   ),
                        // ),
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

  getAppraisalApprovalFFDetailsdata() async {
    appraisalApprovalFfDetailsData = await AppraisalRepository()
        .getAppraisalApprovalFFDetails(
            dmpathData!.syncUrl, widget.cid, userInfo!.userId, widget.userPass);

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
