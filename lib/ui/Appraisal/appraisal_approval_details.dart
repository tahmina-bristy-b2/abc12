import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class AppraisalApprovalDetails extends StatefulWidget {
  const AppraisalApprovalDetails({super.key});

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
  bool isUpgrade = false;
  bool isDesignationChange = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appraisal Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: const [
                  Expanded(
                      child: Icon(Icons.person,
                          size: 35, color: Color.fromARGB(255, 153, 197, 161))),
                  SizedBox(
                    width: 8,
                  ),
                  Expanded(
                      flex: 8,
                      child: Text(
                        "Mr. Ratan Kumar Roy",
                        style: TextStyle(
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
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Emplpyee Id",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("11863293864896"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Designation",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("MSO"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Total Full Point",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("400"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Achieved Point",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("40%"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Present Grade",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("O-02"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "TR-Code",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("DT22"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Business Segment",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("Pharma"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Date of Joining",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("7th June 2023"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Last Promotion",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("7th June 2023"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Length of Service",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("4 year"))
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                children: const [
                  Expanded(
                      flex: 4,
                      child: Text(
                        "Base Territory",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      flex: 7,
                      child: Text(
                          "SETABGONJ SUKUBDEVPUR,SULTANPUR,RAMPURHAT,MADODPUR,PRITIVA"))
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
                        "Length of Present TR Service",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Expanded(
                      child: Text(
                    ":",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(flex: 7, child: Text("4 year"))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              firstTableWidget(),
              const SizedBox(
                height: 8,
              ),
              secondTableWidget(),
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
              )
              // Container(height: 100,color: Colors.,)
            ],
          ),
        ),
      ),
    );
  }

  SizedBox firstTableWidget() {
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

  SizedBox secondTableWidget() {
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
      color: Color.fromARGB(255, 170, 196, 220),
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
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 250, 250, 250),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(5)),
                      child: const TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
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
}
