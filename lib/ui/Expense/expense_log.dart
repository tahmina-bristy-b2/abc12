// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ExpenseLogScreen extends StatefulWidget {
  List expenseLog;
  ExpenseLogScreen({
    Key? key,
    required this.expenseLog,
  }) : super(key: key);

  @override
  State<ExpenseLogScreen> createState() => _ExpenseLogScreenState();
}

class _ExpenseLogScreenState extends State<ExpenseLogScreen> {
  TextEditingController dateExp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Log"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.expenseLog.length,
                itemBuilder: (context, index) {
                  List ExpenseDetail = widget.expenseLog[index]["expDetList"];

                  // print(ExpenseDetail);
                  return
                      // Text(expenseLog["expList"][index]["exp_date"])
                      Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                    child: Card(
                      elevation: 2,
                      color: Colors.lightBlue[100],
                      child: ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: EdgeInsets.zero,
                        title: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: Container(
                              height: 40,
                              width: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green),
                                  color: Colors.greenAccent[100]),
                              child: Center(
                                child: Text(
                                  "Date: ${widget.expenseLog[index]["exp_date"]}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                          trailing: Container(
                            height: 40,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.green),
                                color: Colors.greenAccent[100]),
                            child: Center(
                              child: Text(
                                "Total: ${widget.expenseLog[index]["exp_amt_total"]}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  "DESCRIPTION",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 150, 55, 42),
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "AMOUNT",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 150, 55, 42),
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              // physics: const NeverScrollableScrollPhysics(),
                              itemCount: ExpenseDetail.length,
                              itemBuilder: (context, index) {
                                // print(ExpenseDetail.length);
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(12, 6, 12, 6),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(ExpenseDetail[index]["exp_type"]),
                                      Text(
                                          "${ExpenseDetail[index]["exp_amt"]}"),
                                    ],
                                  ),
                                );
                              })
                        ],
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
// Column(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                               child: ListTile(
//                                 leading: Container(
//                                   height: 50,
//                                   width: 85,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.greenAccent[100]),
//                                   child: Center(
//                                     child: Text(
//                                       "Date: ${widget.expenseLog[index]["exp_date"]}",
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                 ),
//                                 trailing: Container(
//                                   height: 50,
//                                   width: 85,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.greenAccent[100]),
//                                   child: Center(
//                                     child: Text(
//                                       "Total: ${widget.expenseLog[index]["exp_amt_total"]}",
//                                       style: TextStyle(fontSize: 16),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),

//                             // Row(
//                             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //   children: [
//                             //     Container(
//                             //       child: Text(expenseLog[index]["exp_date"]),
//                             //     ),
//                             //     Container(
//                             //       child:
//                             //           Text(expenseLog[index]["exp_amt_total"]),
//                             //     ),
//                             //   ],
//                             // ),
//                             Padding(
//                               padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     "DESCRIPTION",
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         color: Color.fromARGB(255, 150, 55, 42),
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                   Text(
//                                     "AMOUNT",
//                                     style: TextStyle(
//                                         fontSize: 15,
//                                         color:
//                                             Color.fromARGB(255, 151, 67, 230),
//                                         fontWeight: FontWeight.w600),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Expanded(
//                               child: ListView.builder(
//                                   // shrinkWrap: true,
//                                   // physics: const NeverScrollableScrollPhysics(),
//                                   itemCount: ExpenseDetail.length,
//                                   itemBuilder: (context, index) {
//                                     return Padding(
//                                       padding: const EdgeInsets.fromLTRB(
//                                           12, 6, 12, 0),
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Text(
//                                               ExpenseDetail[index]["exp_type"]),
//                                           Text(
//                                               "${ExpenseDetail[index]["exp_amt"]}"),
//                                           // Text(expenseLog[index]["expDetList"]
//                                           // [index]["exp_type"])
//                                         ],
//                                       ),
//                                     );
//                                   }),
//                             )
//                           ],
//                         ),
