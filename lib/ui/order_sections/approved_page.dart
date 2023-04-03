import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/approved_promo_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/models/stock_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class ApprovedPage extends StatefulWidget {
  const ApprovedPage(
      {super.key,
      required this.cid,
      required this.userPassword,
      required this.clientId,
      required this.clientName});
  final String cid;
  final String userPassword;
  final String clientId;
  final String clientName;

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
        // bottomNavigationBar: BottomNavigationBar(
        //   currentIndex: currentIndex,
        //   onTap: (index) => _onTap(index),
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.refresh), label: 'Refresh'),
        //   ],
        // ),
        body: FutureBuilder<ApprovedPromoModel?>(
          future: Repositories().getApprovedRate(
              dmpathData!.reportPromoApUrl,
              widget.cid,
              userInfo!.userId,
              widget.userPassword,
              widget.clientId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Center(
                  child:
                      Text('Data Not found!', style: TextStyle(fontSize: 16)),
                );
              } else if (snapshot.data!.apPromoList.isNotEmpty) {
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
                                          'Customer Id: ${widget.clientId}',
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
                                        'Customer Name: ${widget.clientName}',
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
                          columnSpacing: 5,
                          horizontalMargin: 5,
                          minWidth: 1000,
                          columns: dataColumn(),
                          rows: dataRow(snapshot.data!),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child:
                      Text('No Approved Rate!', style: TextStyle(fontSize: 16)),
                );
              }
            }
            return const Center(
              child: Text('Data Not found!', style: TextStyle(fontSize: 16)),
            );
          },
        ));
  }

  // _onTap(index) {
  //   if (index == 0) {
  //     Navigator.pop(context);
  //     currentIndex = index;
  //     setState(() {});
  //   }

  //   if (index == 1) {
  //     setState(() {
  //       currentIndex = index;
  //     });
  //   }
  // }

  List<DataColumn> dataColumn() {
    return const [
      DataColumn2(
        fixedWidth: 80,
        label: Center(
          child: Text(
            'From',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.S,
      ),
      DataColumn2(
        fixedWidth: 85,
        label: Center(
          child: Text(
            'to',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.S,
      ),
      DataColumn2(
        fixedWidth: 60,
        label: Text(
          'Pr. Id',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
      DataColumn2(
        // numeric: true,
        fixedWidth: 200,
        label: Center(
          child: Text(
            'Product Name',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.M,
      ),
      DataColumn2(
        fixedWidth: 85,
        label: Text(
          'BonusType',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: 80,
        label: Center(
          child: Text(
            'F. Percent',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> dataRow(ApprovedPromoModel promoData) {
    return promoData.apPromoList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.fromDate)),
              DataCell(Text(e.toDate)),
              DataCell(Text(e.productId)),
              DataCell(Text(e.productName)),
              DataCell(Text(e.bonusType)),
              DataCell(Text(e.fixedPercentRate.toString())),
            ]))
        .toList();
  }
}
