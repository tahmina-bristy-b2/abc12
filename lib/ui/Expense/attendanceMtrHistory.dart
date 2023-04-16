import 'package:flutter/material.dart';

class AttendanceMeterHistory extends StatefulWidget {
  const AttendanceMeterHistory({Key? key}) : super(key: key);

  @override
  State<AttendanceMeterHistory> createState() => _AttendanceMeterHistoryState();
}

class _AttendanceMeterHistoryState extends State<AttendanceMeterHistory> {
  TextEditingController dateController = TextEditingController();

  DateTime dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Meter History"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: TextField(
          //     onTap: () async {
          //       FocusScope.of(context).requestFocus(FocusNode());
          //       final date = await pickDate();
          //       if (date == null) {
          //         return;
          //       } else {
          //         setState(
          //           () {
          //             dateTime = date;
          //           },
          //         );
          //       }
          //     },
          //     controller: dateController,
          //     decoration: InputDecoration(
          //       border: const OutlineInputBorder(),
          //       hintText: 'Enter Date',
          //       labelText: "${dateTime.year}-${dateTime.month}-${dateTime.day}",
          //       labelStyle: const TextStyle(color: Colors.black),
          //       suffixIcon: Icon(Icons.calendar_today, color: Colors.blue[400]),
          //     ),
          //   ),
          // ),

          const SizedBox(
            height: 20,
          ),

          Card(
            color: const Color.fromARGB(255, 162, 220, 243),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  Text(
                    "DateTime",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Metar Reating",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Location",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "12-12-12",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "1120",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "Dhaka",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
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

  Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1990),
        lastDate: DateTime(2060),
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
