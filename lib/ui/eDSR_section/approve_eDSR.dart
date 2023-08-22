import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ApproveEDSR extends StatefulWidget {
  const ApproveEDSR({super.key});

  @override
  State<ApproveEDSR> createState() => _ApproveEDSRState();
}

class _ApproveEDSRState extends State<ApproveEDSR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve eDSR'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                constraints: const BoxConstraints(maxHeight: double.infinity),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.blue[900]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Budget :',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '10000000000',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'Expense :',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '10000000',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                constraints: const BoxConstraints(maxHeight: double.infinity),
                // color: Colors.blue[900],
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue[900]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: const [
                      Expanded(
                          child: Text('FM',
                              style: TextStyle(color: Colors.white))),
                      Expanded(
                          child: Text('Territory',
                              style: TextStyle(color: Colors.white))),
                      Expanded(
                          child: Center(
                              child: Text('Due',
                                  style: TextStyle(color: Colors.white)))),
                      Expanded(
                          child: Center(
                              child: Text('Doctor',
                                  style: TextStyle(color: Colors.white)))),
                      Expanded(
                          child: Center(
                              child: Text('Dcc',
                                  style: TextStyle(color: Colors.white)))),
                      Expanded(
                          flex: 2,
                          child: Center(
                              child: Text('Amount',
                                  style: TextStyle(color: Colors.white)))),
                      Expanded(
                          child: Center(
                              child: Text('Action',
                                  style: TextStyle(color: Colors.white)))),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (itemBuilder, index) {
                      return Container(
                        constraints:
                            const BoxConstraints(maxHeight: double.infinity),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:
                              index % 2 == 0 ? Colors.grey[300] : Colors.white,
                        ),
                        // color: index % 2 == 0 ? Colors.grey[300] : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: const [
                              Expanded(child: Text('ITFM')),
                              Expanded(child: Text('DEMO')),
                              Expanded(child: Center(child: Text('1'))),
                              Expanded(child: Center(child: Text('0'))),
                              Expanded(child: Center(child: Text('1'))),
                              Expanded(
                                  flex: 2,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('500.00'))),
                              Expanded(
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.arrow_forward_ios))),
                            ],
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
