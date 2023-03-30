// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:MREPORTING/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:MREPORTING/ui/Expense/expense_section.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:flutter/services.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:MREPORTING/ui/Expense/expense_draft.dart';
import 'package:MREPORTING/services/apiCall.dart';

// List<ExpenseModel> temp = [];
Map draftListTOhive = {};

// ignore: must_be_immutable
class ExpenseEntry extends StatefulWidget {
  List tempExpList;
  List expenseTypelist;
  String expDraftDate;
  Function callback;
  // List<ExpenseModel> tempExpenseList;
  ExpenseEntry({
    Key? key,
    required this.expDraftDate,
    required this.tempExpList,
    required this.expenseTypelist,
    required this.callback,
  }) : super(key: key);

  @override
  State<ExpenseEntry> createState() => _ExpenseEntryState();
}

class _ExpenseEntryState extends State<ExpenseEntry> {
  TextEditingController dateController = TextEditingController();

  Map<String, TextEditingController> costController = {};

  String userId = "";
  String userName = "";
  String userPass = "";
  String? startTime;
  DateTime dateTime = DateTime.now();

  final _formkey = GlobalKey<FormState>();

  List expData = [];
  String expType = "";

  Box? box;

  int _currentSelected = 2;

  var newInput;
  bool oncilck = true;

  _onItemTapped(int index) async {
    if (index == 0) {
      _formkey.currentState?.save();
      costController.forEach((key, value) {
        if (value.text != "") {
          for (var element in widget.expenseTypelist) {
            if (element["cat_type_id"] == key.toString()) {
              expType = element["exp_type"];
              Map<String, dynamic> draftData = {
                "exp_type": element["exp_type"],
                "cat_type_id": key.toString(),
                "expQuantity": value.text.toString(),
              };
              expData.add(draftData);
            }
            draftListTOhive = {
              "expDate": dateController.text == ""
                  ? widget.expDraftDate
                  : dateController.text,
              "expData": expData
            };
          }
        }
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => ExpenseDraft(temp: draftListTOhive)),
          (route) => false);

      setState(() {
        _currentSelected = index;
      });
    } else {}

    if (index == 1) {
      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 2 && oncilck) {
      oncilck = false;
      _formkey.currentState?.save();

      var itemString = "";
      dynamic desireKey;
      box = Hive.box("draftForExpense");
      var expDAteforSubmit =
          widget.expDraftDate == "" ? dateController.text : widget.expDraftDate;

      if (startTime != "") {
        if (expDAteforSubmit != "") {
          costController.forEach((key, value) async {
            if (value.text != "") {
              // if (widget.tempExpList.isNotEmpty) {
              //   widget.tempExpList.forEach((e) {});
              // }

              if (itemString == '') {
                itemString = '$key|${value.text}';
              } else {
                itemString += '||$key|${value.text}';
              }
            }
          });

          var expSubmission =
              await SubmitToExpense(expDAteforSubmit, itemString);
          var retString = expSubmission["ret_str"];

          if (expSubmission["status"] == "Success") {
            box!.toMap().forEach((key, value) {
              if (value["expDate"] == dateController.text) {
                desireKey = key;
              }
            });
            box!.delete(desireKey);
            AllServices().toastMessage(
                "Expense Submitted", Colors.green.shade900, Colors.white, 16.0);

            if (!mounted) return;
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const ExpensePage()),
                (route) => false);
          } else {
            AllServices()
                .toastMessage(retString, Colors.red, Colors.white, 16.0);
          }
        } else {
          AllServices().toastMessage(
              "Please Select Date First", Colors.red, Colors.white, 16.0);
        }
        setState(() {
          _currentSelected = index;
        });
      } else {
        AllServices().toastMessage(
            "Please Give Meter Reading First", Colors.red, Colors.white, 16.0);
      }
      oncilck = true;
    }
  }

  @override
  void initState() {
    super.initState();

    dateController.text = widget.expDraftDate;

    for (var item in widget.expenseTypelist) {
      costController["${item['cat_type_id']}"] = TextEditingController();
    }

    for (var element in widget.tempExpList) {
      costController.forEach((key, value) {
        if (key == element['cat_type_id']) {
          value.text = element['expQuantity'].toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Expense Entry"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: TextFormField(
                controller: dateController,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final date = await pickDate();
                  newInput = date;
                  if (date == null) {
                    return;
                  } else {
                    setState(
                      () {
                        dateController.text = DateFormat.yMd().format(date);
                      },
                    );
                  }
                },
                style: const TextStyle(color: Colors.black, fontSize: 18),
                decoration: InputDecoration(
                  hintText: dateController.text == ""
                      ? "Select Expense Date"
                      : dateController.text,
                  hintStyle: const TextStyle(color: Colors.black, fontSize: 18),
                  border: const OutlineInputBorder(),
                  suffixIcon:
                      const Icon(Icons.calendar_today, color: Colors.teal),
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: _formkey,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.expenseTypelist.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: SizedBox(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.expenseTypelist[index]["exp_type"],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(
                                  color:
                                      const Color.fromARGB(255, 138, 201, 149)
                                          .withOpacity(.3),
                                  width: 70,
                                  height: 50,
                                  child: TextField(
                                    controller: costController[
                                        "${widget.expenseTypelist[index]['cat_type_id']}"],
                                    onChanged: (value) {},
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _currentSelected,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[800],
        selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Save Drafts',
            icon: Icon(Icons.drafts),
          ),
          BottomNavigationBarItem(
            label: '',
            backgroundColor: Colors.white,
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Submit',
            icon: Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(dateTime.year, dateTime.month - 1, dateTime.day),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFE2EFDA),
                surface: Color.fromARGB(255, 37, 199, 78),
              ),
              dialogBackgroundColor: const Color.fromARGB(255, 38, 187, 233),
            ),
            child: child!,
          );
        },
      );
}
