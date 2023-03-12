import 'package:flutter/material.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Hsitory"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text(
                        "DATA NOT FOUND",
                      ),
                    );
                  } else if (snapshot.hasData) {
                    // print(snapshot.data);

                    return const SizedBox(
                      // height: 200,
                      // width: double.infinity,
                      child: Center(
                        child: Text(
                          'ok',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  } else {
                    return const Text('Something is wrong');
                  }
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                      border: TableBorder.all(color: Colors.blue),
                      columns: const [
                        DataColumn(
                          label: Text("Date"),
                        ),
                        DataColumn(
                          label: Text("SL"),
                        ),
                        DataColumn(
                          label: Text("Term"),
                        ),
                        DataColumn(
                          label: Text("Amt"),
                        ),
                        DataColumn(
                          label: Text("OST"),
                        ),
                        DataColumn(
                          label: Text("%"),
                        ),
                      ],
                      rows: const [
                        DataRow(
                          cells: [
                            DataCell(
                              Text("data"),
                            ),
                            DataCell(
                              Text("data"),
                            ),
                            DataCell(
                              Text("data"),
                            ),
                            DataCell(
                              Text("data"),
                            ),
                            DataCell(
                              Text("data"),
                            ),
                            DataCell(
                              Text("data"),
                            ),
                          ],
                        )
                      ]),
                )
                    // Container(
                    //     alignment: Alignment.topCenter,
                    //     margin: const EdgeInsets.only(top: 20),
                    //     child: const CircularProgressIndicator(
                    //         // backgroundColor: BACKGROUND_COLOR,
                    //         // color: COLOR_PRIMARY,
                    //         ))
                    ;
              }),
            )
          ],
        ),
      ),
    );
  }
}
