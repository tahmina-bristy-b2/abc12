import 'package:MREPORTING/services/others/repositories.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/Expense/expense_entry.dart';
import 'package:MREPORTING/ui/Expense/expense_section.dart';
import 'package:MREPORTING/ui/expense_page.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/services/apiCall.dart';

class ExpenseDraft extends StatefulWidget {
  Map temp;

  ExpenseDraft({Key? key, required this.temp}) : super(key: key);

  @override
  State<ExpenseDraft> createState() => _ExpenseDraftState();
}

class _ExpenseDraftState extends State<ExpenseDraft> {
  Box? box;
  List newList = [];
  var element_ids;
  List expenseDraftList = [];
  List finalExpenselist = [];
  List showDraftList = [];
  @override
  void initState() {
    // print("draft page is having temp file of expense${widget.temp}");
    box = Hive.box("draftForExpense");
    dynamic desireKey;
    box!.toMap().forEach((key, value) {
      if (value["expDate"] == widget.temp["expDate"]) {
        desireKey = key;
      }
    });
    box!.delete(desireKey);
    finalExpenselist.add(widget.temp);

    if (widget.temp.isNotEmpty) {
      for (var disco in finalExpenselist) {
        if (expenseDraftList.contains(disco)) {
          box?.delete(disco);
        } else {
          box?.add(disco);
        }
      }
    }

    expenseDraftList.addAll(box!.toMap().values.toSet().toList());

    // print(expenseDraftList);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Draft"),
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ExpensePage()),
                    (route) => false);
              },
              icon: const Icon(Icons.arrow_back_sharp)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Expanded(
              child: expenseDraftList.isNotEmpty
                  ? ListView.builder(
                      itemCount: expenseDraftList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ExpansionTile(
                              title: Text(expenseDraftList[index]["expDate"]),
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton.icon(
                                      onPressed: () {
                                        dynamic desireKey;

                                        box!.toMap().forEach((key, value) {
                                          if (value["expDate"] ==
                                              expenseDraftList[index]
                                                  ["expDate"]) {
                                            desireKey = key;
                                          }
                                        });
                                        box!.delete(desireKey);

                                        expenseDraftList.removeAt(index);
                                        // print(expenseDraftList);
                                        setState(() {});
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      label: const Text(
                                        "Delete",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () async {
                                        //         newList = await Repositories().expenseEntryRepo(
                                        // dmpathData!.expTypeUrl,
                                        // cid,
                                        // userInfo!.userId,
                                        // userPass);

                                        //         Navigator.push(
                                        //           context,
                                        //           MaterialPageRoute(
                                        //             builder: (_) => ExpenseEntry(
                                        //                 expenseTypelist: newList,
                                        //                 callback: (value) {},
                                        //                 tempExpList:
                                        //                     expenseDraftList[index]
                                        //                         ["expData"],
                                        //                 expDraftDate:
                                        //                     expenseDraftList[index]
                                        //                         ["expDate"]),
                                        //           ),
                                        //         );
                                      },
                                      icon: const Icon(
                                        Icons.arrow_forward_outlined,
                                        color: Colors.blue,
                                      ),
                                      label: const Text(
                                        "Details",
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                )
                              ]),
                        );
                      })
                  : const Center(
                      child: Text(
                        "No Data Found",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
            )
          ],
        ));
  }
}
