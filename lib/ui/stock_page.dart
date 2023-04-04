import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/models/stock_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key, required this.cid, required this.userPassword});
  final String cid;
  final String userPassword;

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final _searchController = TextEditingController();
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  StockModel? stockData;
  List<StockList> stockList = [];

  String cid = '';
  String userPassword = '';
  int currentIndex = 0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  bool _sortNameAsc = true;
  bool _sortAsc = true;
  int _sortColumnIndex = 0;

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getStock();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  void getStock() async {
    stockData = await Repositories().getStock(dmpathData!.reportStockUrl,
        widget.cid, userInfo!.userId, widget.userPassword);

    setState(() {
      stockList = stockData!.stockList;
    });
  }

  @override
  Widget build(BuildContext context) {
    // screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return stockData == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Stock'),
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
            body: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Container(
                    width: screenWidth,
                    height: screenHeight / 1,
                    color: const Color.fromARGB(223, 171, 241, 153),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
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
                                      'Depot Id: ${stockData!.depotId}',
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 23, 41, 23),
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
                                    'Depot Name: ${stockData!.depotName}',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 26, 66, 28),
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
                  // Text(
                  //   'Depot Id: ${stockData!.depotId}',
                  //   style: const TextStyle(
                  //       color: Color.fromARGB(255, 23, 41, 23),
                  //       fontSize: 17,
                  //       fontWeight: FontWeight.bold),
                  // ),
                  // Text(
                  //   'Depot Name: ${stockData!.depotName}',
                  //   style: const TextStyle(
                  //       color: Color.fromARGB(255, 26, 66, 28), fontSize: 16),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                          // color: Color.fromARGB(255, 188, 223, 191),
                          // border: Border.all(
                          //   color: Colors.teal.shade100,
                          // ),
                          borderRadius: BorderRadius.circular(10)),
                      child: TextFormField(
                        controller: _searchController,
                        onChanged: (value) {
                          stockList = AllServices()
                              .searchStockProduct(value, stockData!);
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'Product Search',
                          suffixIcon: _searchController.text.isEmpty &&
                                  _searchController.text == ''
                              ? const Icon(Icons.search)
                              : IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    stockList = AllServices()
                                        .searchStockProduct('', stockData!);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.clear,
                                    color: Colors.black,
                                    // size: 28,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    // flex: 9,
                    child: DataTable2(
                      border: TableBorder.all(),
                      headingRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.blue.shade200),
                      dataRowColor: MaterialStateColor.resolveWith(
                          (states) => Colors.teal.shade50),
                      columnSpacing: 12,
                      horizontalMargin: 12,
                      minWidth: screenWidth,
                      sortColumnIndex: _sortColumnIndex,
                      sortAscending: _sortAsc,
                      columns: dataColumn(),
                      rows: dataRow(stockList),
                    ),
                  ),
                ],
              ),
            ));
  }

  _onTap(index) {
    if (index == 0) {
      Navigator.pop(context);
      currentIndex = index;
      setState(() {});
    }

    if (index == 1) {
      getStock();
      setState(() {
        currentIndex = index;
      });
    }
  }

  List<DataColumn> dataColumn() {
    return [
      DataColumn2(
        fixedWidth: screenWidth / 1.30,
        label: const Center(
          child: Text(
            'Product',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.M,
        onSort: (columnIndex, sortAscending) {
          setState(() {
            print(columnIndex);
            print(sortAscending);

            _sortAsc = sortAscending;

            stockList.sort((a, b) => a.itemDes.compareTo(b.itemDes));
            if (!_sortAsc) {
              stockList = stockList.reversed.toList();
            }
          });
        },
      ),
      DataColumn2(
        numeric: true,
        fixedWidth: screenWidth / 7.5,
        label: const Center(
          child: Text(
            'Stock',
            style: TextStyle(fontSize: 16),
          ),
        ),
        size: ColumnSize.S,
      ),
    ];
  }

  List<DataRow> dataRow(List<StockList> stockList) {
    return stockList
        .map((e) => DataRow(cells: [
              DataCell(Text(e.itemDes)),
              DataCell(Text(e.stockQty.toString())),
            ]))
        .toList();
  }
}
