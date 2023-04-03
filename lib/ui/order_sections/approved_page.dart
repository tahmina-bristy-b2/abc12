import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/models/stock_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class ApprovedPage extends StatefulWidget {
  const ApprovedPage(
      {super.key, required this.cid, required this.userPassword});
  final String cid;
  final String userPassword;

  @override
  State<ApprovedPage> createState() => _ApprovedPageState();
}

class _ApprovedPageState extends State<ApprovedPage> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  String cid = '';
  String userPassword = '';
  int currentIndex = 0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Approved Rate'),
          centerTitle: true,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => _onTap(index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.refresh), label: 'Refresh'),
          ],
        ),
        body: FutureBuilder<StockModel?>(
          future: Repositories().getStock(dmpathData!.reportStockUrl,
              widget.cid, userInfo!.userId, widget.userPassword),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                AllServices().toastMessage(
                    'Data Not found!', Colors.red, Colors.white, 16);
                return const Text('');
              } else if (snapshot.data!.stockList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 5),
                      Container(
                        width: screenWidth,
                        height: screenHeight / 13,
                        color: const Color.fromARGB(223, 171, 241, 153),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: FittedBox(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Depot Id: ${snapshot.data!.depotId}',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 23, 41, 23),
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Depot Name: ${snapshot.data!.depotName}',
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 26, 66, 28),
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Text('Depot Id: ${snapshot.data!.depotId}'),
                      // Text('Depot Name: ${snapshot.data!.depotName}'),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 9,
                        child: DataTable2(
                          border: TableBorder.all(),
                          headingRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.blue.shade200),
                          dataRowColor: MaterialStateColor.resolveWith(
                              (states) => Colors.teal.shade50),
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 600,
                          columns: dataColumn(),
                          rows: dataRow(snapshot.data!),
                        ),
                      ),
                    ],
                  ),
                );
              }
            }
            return const Text('Data Not found!',
                style: TextStyle(fontSize: 16));
          },
        ));
  }

  _onTap(index) {
    if (index == 0) {
      Navigator.pop(context);
      currentIndex = index;
      setState(() {});
    }

    if (index == 1) {
      setState(() {
        currentIndex = index;
      });
    }
  }

  List<DataColumn> dataColumn() {
    return const [
      DataColumn2(
        numeric: true,
        fixedWidth: 60,
        label: Center(
          child: Text(
            'Stock',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.S,
      ),
      DataColumn2(
        // numeric: true,
        fixedWidth: 310,
        label: Center(
          child: Text(
            'Product',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.M,
      ),
    ];
  }

  List<DataRow> dataRow(StockModel promoData) {
    return promoData.stockList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.stockQty.toString())),
              DataCell(Text(e.itemDes))
            ]))
        .toList();
  }
}
