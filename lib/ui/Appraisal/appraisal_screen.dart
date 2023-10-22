import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class ApprisalScreen extends StatefulWidget {
  const ApprisalScreen({super.key});

  @override
  State<ApprisalScreen> createState() => _ApprisalScreenState();
}

class _ApprisalScreenState extends State<ApprisalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Employee Information"),
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
                      child: Icon(
                    Icons.person,
                    size: 35,
                    color: Colors.grey,
                  )),
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
              Container(
                height: 700,
                child: DataTable2(
                    border: TableBorder.all(),
                    columnSpacing: 12,
                    horizontalMargin: 8,
                    dataRowHeight: 35,
                    minWidth: 600,
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
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("2"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Sold (Value in Lac)"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("3"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Achievement (%)"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("4"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Avg. Sales/Month "))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("5"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Avg. Rx Share (4P) "))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("6"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Avg. Rx Share (EMR) "))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("7"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Avg. Rx Growth "))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("8"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("No. of Month Achieved"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                      DataRow2(
                        cells: [
                          DataCell(Center(child: Text("9"))),
                          DataCell(Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Chemist Coverage"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("60.65"))),
                          DataCell(Align(
                              alignment: Alignment.centerRight,
                              child: Text("67.06")))
                        ],
                      ),
                    ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
