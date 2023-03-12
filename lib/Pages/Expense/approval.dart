// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

import 'package:mrap7/Pages/Expense/expense_log.dart';

class ApprovalPage extends StatefulWidget {
  List expenseLog;
  ApprovalPage({
    Key? key,
    required this.expenseLog,
  }) : super(key: key);

  @override
  State<ApprovalPage> createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  TextEditingController initialController = TextEditingController();
  TextEditingController lastController = TextEditingController();
  final jobRoleCtrl = TextEditingController();
  List<String> ff_type = ["MPO", "FM", "ZM", "RM"];
  List approvalList = [
    {
      "territory": "DK11",
      "ff_name": "Kamal",
      "amount": "1500",
      "status": "false"
    },
    {
      "territory": "DK12",
      "ff_name": "Jamal",
      "amount": "3000",
      "status": "false"
    },
    {
      "territory": "DK13",
      "ff_name": "Selim",
      "amount": "1200",
      "status": "false"
    },
  ];
  List newApprovalList = [];
  String role = "";
  // initialController = 22 / 12 / 2022;
  var lastDate = 22 / 12 / 2022;
  bool approved = false;

  @override
  void initState() {
    initialController.text = "22/12/2022";
    lastController.text = "22/12/2022";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approval"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date Range:",
                  style: TextStyle(fontSize: 16),
                ),
                // Text(
                //   "From",
                //   style: TextStyle(fontSize: 16),
                // ),
                Container(
                  padding: EdgeInsets.zero,
                  width: 120,
                  height: 45,
                  color: Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
                  child: TextField(
                    controller: initialController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                Text(
                  "To",
                  style: TextStyle(fontSize: 16),
                ),
                Container(
                  padding: EdgeInsets.zero,
                  width: 120,
                  height: 45,
                  color: Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
                  child: TextField(
                    controller: lastController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                // ElevatedButton(onPressed: () {}, child: Text("Show")),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                // DropdownButtonFormField(items: items, onChanged: (onChanged){
                Flexible(
                  // flex: 2,
                  child: Text("FF Type:"),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  // flex: 3,
                  child: CustomDropdown(
                    // hintText: ff_type[0],
                    hintText: "Select Job Role",
                    fillColor:
                        Color.fromARGB(255, 138, 201, 149).withOpacity(.3),
                    items: ff_type,

                    controller: jobRoleCtrl,
                    onChanged: (p0) {
                      role = p0;
                      print("developer select list $role");
                    },
                  ),
                )
                // })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    "Show",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          DataTable(
              columnSpacing: 40.0,
              columns: [
                DataColumn(
                  label: Text("Territory"),
                ),
                DataColumn(
                  label: Text("FF"),
                ),
                DataColumn(
                  label: Text("Amount"),
                ),
                DataColumn(
                  label: Text("Status"),
                ),
              ],
              rows: approvalList.map((e) {
                return DataRow(
                  cells: [
                    DataCell(
                      Text(e["territory"]),
                    ),
                    DataCell(
                      Row(
                        children: [
                          Text(e["ff_name"]),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  (MaterialPageRoute(
                                    builder: (context) => ExpenseLogScreen(
                                        expenseLog: widget.expenseLog),
                                  )),
                                );
                              },
                              icon: Icon(Icons.double_arrow_sharp))
                        ],
                      ),
                    ),
                    DataCell(
                      Text(e["amount"]),
                    ),
                    DataCell(
                      Checkbox(
                        value: approved,
                        onChanged: (value) {
                          setState(() {
                            // e["status"]== true?
                            approved = !approved;
                            print("approval ashbe $approved");

                            // if (approved == true) {
                            //   newApprovalList.add(approved);
                            // } else {
                            //   newApprovalList.removeAt();
                            // }
                            // print("approval ashbe $newApprovalList");
                          });
                        },
                      ),
                    ),
                  ],
                );
              }).toList()),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(onPressed: () {}, child: Text("Reject")),
              SizedBox(
                width: 15,
              ),
              ElevatedButton(onPressed: () {}, child: Text("Approve")),
              SizedBox(
                width: 15,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
