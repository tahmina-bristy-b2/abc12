import 'package:flutter/material.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({Key? key}) : super(key: key);

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  List ExpenseSummary = [
    {"exp_type": "FARE OTHERS", "exp_amt": 80.0},
    {"exp_type": "FARE TRAIN", "exp_amt": 120.0},
    {"exp_type": "FARE LUNCH", "exp_amt": 500.0},
    {"exp_type": "FARE RICKSHAW", "exp_amt": 50.0},
    {"exp_type": "FARE AUTO", "exp_amt": 250.0},
    {"exp_type": "FARE BUS", "exp_amt": 70.0},
    {"exp_type": "DOCTOR LIFT", "exp_amt": 500.0},
    {"exp_type": "STATIONARY", "exp_amt": 900.0},
    {"exp_type": "COURIER BILL", "exp_amt": 50.0},
    {"exp_type": "ANSAR BILL", "exp_amt": 50.0},
    {"exp_type": "NET BILL", "exp_amt": 100.0},
    {"exp_type": "MOTORCYCLE PARKING", "exp_amt": 100.0},
    {"exp_type": "SAMPLE CARRYING", "exp_amt": 100.0},
    {"exp_type": "COMPOSE PHOTOCOPY", "exp_amt": 500.0}
  ];

  TextEditingController dateController = TextEditingController();

  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Summary"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onTap: () async {
                FocusScope.of(context).requestFocus(FocusNode());
                final date = await pickDate();
                if (date == null) {
                  return;
                } else {
                  setState(
                    () {
                      dateTime = date;
                    },
                  );
                }
              },
              controller: dateController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: 'Enter Date',
                labelText: "${dateTime.year}-${dateTime.month}-${dateTime.day}",
                labelStyle: const TextStyle(color: Colors.black),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.blue[400]),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Date Range:",
                  style: TextStyle(fontSize: 16),
                ),
                // Text(
                //   "From",
                //   style: TextStyle(fontSize: 16),
                // ),
                SizedBox(
                  width: 90,
                  height: 45,
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
                Text(
                  "To",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 90,
                  height: 45,
                  child: TextField(
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
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text(
                    "Show",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            leading: Text(
              "Expense Head",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              "Amount",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: ExpenseSummary.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    // horizontalTitleGap: 0.0,
                    // minVerticalPadding: 0.0,
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    leading: Text(ExpenseSummary[index]["exp_type"]),
                    trailing: Text(ExpenseSummary[index]["exp_amt"].toString()),
                  );
                }),
          )
        ],
      ),
    );
  }

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Colors.white,
                surface: Colors.blue,
              ),
              // dialogBackgroundColor: Colors.white,
            ), // This will change to light theme.
            child: child!,
          );
        },
      );
}
