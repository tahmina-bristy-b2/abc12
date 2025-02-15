import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/models/stock_model.dart';
import 'package:MREPORTING_OFFLINE/models/user_depot_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/order/order_repositories.dart';
import 'package:MREPORTING_OFFLINE/services/others/repositories.dart';
import 'package:MREPORTING_OFFLINE/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
  UserDepotModel? userDepotList;

  String cid = '';
  String userPassword = '';
  int currentIndex = 0;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List<String> tempList = ['_'];
  // bool _sortNameAsc = true;
  bool _sortAsc = true;
  final int _sortColumnIndex = 0;
  bool _isLoading = false;
  // bool _isLoading2 = false;
  String? depotValue;
  String depotId = '';

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    // getStock();
    // refreshTimeDiffrence();
    getDepotList();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  Future<int> refreshTimeDiffrence() async {
    var refReshTimeBox = await Hive.openBox('StockRefreshTime');

    DateTime endTime = DateTime(2023, 4, 8, 00, 00); // 11:15 AM
    DateTime now = DateTime.now(); // 11:15 AM
    // print(now);

    DateTime lastRefreshTime = refReshTimeBox.get('lastRefreshTime') ?? endTime;
    // print(lastRefreshTime);

    Duration difference = now.difference(lastRefreshTime);
    int minutes = difference.inMinutes;
    // print(minutes);
    return minutes;

    // print('The difference between start and end time is $minutes minutes.');
  }

  getDepotList() async {
    userDepotList = await Repositories().getUserDepotList(
        dmpathData!.reportUserDepotUrl,
        widget.cid,
        userInfo!.userId,
        widget.userPassword);
    if (userDepotList == null) {
      AllServices()
          .toastMessage('Depot data not found.', Colors.red, Colors.white, 16);
      // setState(() {
      //   _isLoading2 = false;
      // });
    }
    setState(() {});
  }

  void getStock(String depoId) async {
    var refReshTimeBox = await Hive.openBox('StockRefreshTime');
    if (depotId == '') {
      setState(() {
        _isLoading = false;
      });
      AllServices()
          .toastMessage('Please select Depot.', Colors.teal, Colors.white, 16);
    } else {
      if (await refreshTimeDiffrence() >= 5) {
        setState(() {
          _isLoading = true;
        });
        bool result = await InternetConnectionChecker().hasConnection;
        if (result) {
          StockModel? stockData2 = await Repositories().getStock(
              dmpathData!.reportStockUrl,
              widget.cid,
              userInfo!.userId,
              widget.userPassword,
              depoId);

          if (stockData2 != null) {
            List itemList = await OrderRepositories().syncItem(
                dmpathData!.syncUrl,
                widget.cid,
                userInfo!.userId,
                widget.userPassword);
            if (itemList.isNotEmpty) {
              DateTime now = DateTime.now();

              refReshTimeBox.put('lastRefreshTime', now);

              // print(itemList);
              // AllServices().toastMessage(
              //     'Sync Item data Done.', Colors.teal, Colors.white, 16);
              setState(() {
                _isLoading = false;
                stockData = stockData2;
                stockList = stockData2.stockList;
                stockList.sort((a, b) => a.itemDes.compareTo(b.itemDes));
              });
            } else {
              AllServices().toastMessage(
                  'Didn\'t sync Item Data', Colors.red, Colors.white, 16);

              setState(() {
                _isLoading = false;
              });
            }

            // setState(() {
            //   _isLoading = false;
            //   stockData = stockData2;
            //   stockList = stockData2.stockList;
            // });
          } else {
            setState(() {
              _isLoading = false;
            });
          }
        } else {
          AllServices()
              .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        AllServices().toastMessage('Pleease refresh after 10 minutes.',
            Colors.yellow, Colors.black, 16);
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            SizedBox(
              width: screenWidth,
              height: 50,
              // height: screenHeight / 14,
              // color: const Color.fromARGB(223, 171, 241, 153),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Depot: ',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 23, 41, 23),
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Card(
                              color: Colors.teal.shade50,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  iconEnabledColor: Colors.teal,
                                  iconDisabledColor: Colors.grey,
                                  iconSize: 28,
                                  // decoration:
                                  //     const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? value) {
                                    setState(() {
                                      depotValue = value!;
                                    });
                                    for (var element
                                        in userDepotList!.depotList) {
                                      if (element.depotName == depotValue) {
                                        depotId = element.depotId;
                                      }
                                    }
                                    setState(() {});
                                  },
                                  value: depotValue,
                                  items: userDepotList != null
                                      ? userDepotList!.depotList
                                          .map((e) => DropdownMenuItem(
                                              value: e.depotName,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(e.depotName)))
                                          .toList()
                                      : tempList
                                          .map((String e) => DropdownMenuItem(
                                              value: e,
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: Text(e)))
                                          .toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 60,
                          ),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                getStock(depotId);
                              },
                              child: const FittedBox(child: Text('Show')),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ),
                    // Expanded(
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //         child: Text(
                    //           'Depot Name: ${stockData!.depotName}',
                    //           style: const TextStyle(
                    //               color: Color.fromARGB(
                    //                   255, 26, 66, 28),
                    //               fontSize: 16),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : stockData == null
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                          child: Text('No Data found!'),
                        ),
                      )
                    : Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                              child: Container(
                                height: 45,
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
                                    filled: true,
                                    fillColor: Colors.teal.shade50,
                                    border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    labelText: 'Product Search',
                                    suffixIcon:
                                        _searchController.text.isEmpty &&
                                                _searchController.text == ''
                                            ? const Icon(Icons.search)
                                            : IconButton(
                                                onPressed: () {
                                                  _searchController.clear();
                                                  stockList = AllServices()
                                                      .searchStockProduct(
                                                          '', stockData!);
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
                      ),
          ],
        ));
  }

  _onTap(index) {
    if (index == 0) {
      Navigator.pop(context);
      currentIndex = index;
      setState(() {});
    }

    if (index == 1) {
      getStock(depotId);
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
