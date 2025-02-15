import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/models/promo_model.dart';
import 'package:MREPORTING_OFFLINE/services/others/repositories.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key, required this.cid, required this.userPassword});
  final String cid;
  final String userPassword;

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  String cid = '';
  String userPassword = '';
  int currentIndex = 0;
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
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Promo'),
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
        body: FutureBuilder<PromoModel?>(
          future: Repositories().getPromo(dmpathData!.reportPromoUrl,
              widget.cid, userInfo!.userId, widget.userPassword),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // AllServices().toastMessage(
                //     'Data Not found!', Colors.red, Colors.white, 16);
                return const Text('Data Not found!');
              } else if (snapshot.data!.promoPbList.isNotEmpty) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //=====================for Bonus=========================
                        const SizedBox(height: 5),
                        Container(
                          width: screenWidth,
                          height: 40,
                          color: const Color.fromARGB(255, 21, 67, 218)
                              .withOpacity(.7),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Bonus:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 300,
                          child: DataTable2(
                            border: TableBorder.all(),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.teal.shade50),
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: screenWidth,
                            columns: dataColumn(),
                            rows: dataRow(snapshot.data!),
                          ),
                        ),
                        //================= for Special Rate ====================
                        const SizedBox(height: 5),
                        Container(
                          width: screenWidth,
                          height: 40,
                          color: const Color.fromARGB(255, 21, 67, 218)
                              .withOpacity(.7),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Special Rate:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                        // const Text('Special Rate:',
                        //     style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 300,
                          child: DataTable2(
                            border: TableBorder.all(),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.teal.shade50),
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: screenWidth,
                            columns: spDataColumn(),
                            rows: spDataRow(snapshot.data!),
                          ),
                        ),

                        //================= for Flat Rate ====================
                        const SizedBox(height: 5),
                        Container(
                          width: screenWidth,
                          height: 40,
                          color: const Color.fromARGB(255, 21, 67, 218)
                              .withOpacity(.7),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Flat Rate:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 5),
                        SizedBox(
                          height: 300,
                          child: DataTable2(
                            border: TableBorder.all(),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.teal.shade50),
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: screenWidth,
                            columns: flatDataColumn(),
                            rows: flatDataRow(snapshot.data!),
                          ),
                        ),

                        //================= for Approved Datte ====================
                        const SizedBox(height: 5),
                        Container(
                          width: screenWidth,
                          height: 40,
                          color: const Color.fromARGB(255, 21, 67, 218)
                              .withOpacity(.7),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Declared Item:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),

                        const SizedBox(height: 5),
                        SizedBox(
                          height: 300,
                          child: DataTable2(
                            border: TableBorder.all(),
                            headingRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.blue.shade200),
                            dataRowColor: MaterialStateColor.resolveWith(
                                (states) => Colors.teal.shade50),
                            columnSpacing: 12,
                            horizontalMargin: 12,
                            minWidth: screenWidth,
                            columns: declaredDataColumn(),
                            rows: declaredDataRow(snapshot.data!),
                          ),
                        ),
                      ],
                    ),
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

  //==================== For Promo ================

  List<DataColumn> dataColumn() {
    return [
      DataColumn2(
        fixedWidth: screenWidth / 1.32,
        label: const Center(
          child: Text(
            'Offer',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: screenWidth / 7.2,
        label: const Text(
          'MinQty',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> dataRow(PromoModel promoData) {
    return promoData.promoPbList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.promoDes)),
              DataCell(Text(e.minQty.toString()))
            ]))
        .toList();
  }
  //==================== For Special ================

  List<DataColumn> spDataColumn() {
    return [
      DataColumn2(
        fixedWidth: screenWidth / 1.65,
        label: const Center(
          child: Text(
            'Product',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: screenWidth / 6.5,
        label: const Text(
          'MinQty',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: screenWidth / 7.2,
        label: const Text(
          'Rate',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> spDataRow(PromoModel promoData) {
    return promoData.promoSpList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.promoDes)),
              DataCell(
                Text(e.minQty.toString()),
              ),
              DataCell(
                Text(e.specialRateTp.toString()),
              )
            ]))
        .toList();
  }

  //==================== For Flat Rate ================

  List<DataColumn> flatDataColumn() {
    return [
      DataColumn2(
        fixedWidth: screenWidth / 1.9,
        label: const Center(
          child: Text(
            'Product',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: screenWidth / 6.5,
        label: const Text(
          'MinQty',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: screenWidth / 5.0,
        label: const Text(
          'FlatRate',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> flatDataRow(PromoModel promoData) {
    return promoData.promoFlatList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.promoDes)),
              DataCell(
                Text(e.minQty.toString()),
              ),
              DataCell(
                Text(e.flatRate.toString()),
              )
            ]))
        .toList();
  }
  //==================== For Approved Date ===================

  List<DataColumn> declaredDataColumn() {
    return [
      DataColumn2(
        fixedWidth: screenWidth / 1.7,
        label: const Center(
          child: Text(
            'Product',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.L,
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: screenWidth / 3.5,
        label: const Text(
          'ApprovedDate',
          style: TextStyle(fontSize: 16),
        ),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> declaredDataRow(PromoModel promoData) {
    return promoData.promoDiList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.promoDes)),
              DataCell(
                Text(e.approvedDate.toString().substring(0, 10)),
              )
            ]))
        .toList();
  }
}
