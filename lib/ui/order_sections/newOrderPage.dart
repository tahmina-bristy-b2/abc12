// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/ui/loginPage.dart';
import 'package:MREPORTING/ui/order_sections/invoice_history.dart';
import 'package:MREPORTING/ui/order_sections/order_history.dart';
import 'package:MREPORTING/ui/order_sections/outst_history.dart';

import 'package:MREPORTING/ui/order_sections/order_item_list.dart';

import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

DateTime DT = DateTime.now();
String dateSelected = DateFormat('yyyy-MM-dd').format(DT);

class NewOrderPage extends StatefulWidget {
  int ckey;
  String clientName;
  String marketName;
  String clientId;
  int uniqueId;
  String deliveryTime;
  String deliveryDate;
  String paymentMethod;
  String? outStanding;
  String? offer;

  List<AddItemModel> draftOrderItem;
  NewOrderPage(
      {Key? key,
      required this.ckey,
      required this.uniqueId,
      required this.draftOrderItem,
      required this.clientName,
      required this.clientId,
      this.outStanding,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.paymentMethod,
      this.offer,
      required this.marketName})
      : super(key: key);

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final List<TextEditingController> _itemController = [];
  final _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  String userName = '';
  String user_id = '';

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isSaved = false;
  bool isSaved2 = false;

  List<AddItemModel> finalItemDataList = [];
  List<CustomerDataModel> orderCustomerList = [];
  List<CustomerDataModel> customerdatalist = [];

  Box? box;

  List syncItemList = [];
  List<String> deliveryTime = ['Morning', 'Evening'];
  String selectedDeliveryTime = 'Morning';
  List<String> payMethod = ['CASH', 'CREDIT'];
  List<String> offer = ['_', 'Priority', 'Flex'];
  String slectedPayMethod = 'CASH';
  String initialOffer = '_';
  DateTime deliveryDate = DateTime.now();
  bool dr = false;
  double orderAmount = 0;
  String totalAmount = '';
  double unitPrice = 0;
  double vat = 0;
  double total = 0;
  String submit_url = '';
  String client_edit_url = '';
  String client_outst_url = '';
  String repOutsUrl = '';
  String repLastOrdUrl = '';
  String repLastInvUrl = '';
  String noteText = '';
  String? cid;
  String? userId;
  String? userPassword;
  // bool offer_flag = false;
  // bool note_flag = false;
  // bool client_edit_flag = false;
  // bool os_show_flag = false;
  // bool os_details_flag = false;
  // bool ord_history_flag = false;
  // bool inv_histroy_flag = false;
  var body = "";
  var resultofOuts = "";
  String itemString = '';
  String startTime = '';
  String endTime = '';
  int tempCount = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  Map<String, TextEditingController> controllers = {};

  bool _isLoading = true;

  @override
  void initState() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        client_outst_url = prefs.getString("client_outst_url") ?? "";
        submit_url = prefs.getString("submit_url")!;
        client_edit_url = prefs.getString("client_edit_url")!;

        cid = prefs.getString("CID");
        userId = prefs.getString("USER_ID");
        userPassword = prefs.getString("PASSWORD");
        userName = prefs.getString("userName")!;
        user_id = prefs.getString("user_id")!;
        offer_flag = prefs.getBool("offer_flag")!;
        note_flag = prefs.getBool("note_flag")!;
        client_edit_flag = prefs.getBool("client_edit_flag")!;
        os_show_flag = prefs.getBool("os_show_flag")!;
        os_details_flag = prefs.getBool("os_details_flag")!;
        ord_history_flag = prefs.getBool("ord_history_flag")!;
        inv_histroy_flag = prefs.getBool("inv_histroy_flag")!;
        latitude = prefs.getDouble("latitude")!;
        longitude = prefs.getDouble("longitude")!;
        deviceId = prefs.getString("deviceId");
        deviceBrand = prefs.getString("deviceBrand");
        deviceModel = prefs.getString("deviceModel");
        repOutsUrl = prefs.getString("report_outst_url") ?? "";
        repLastOrdUrl = prefs.getString("report_last_ord_url") ?? "";
        repLastInvUrl = prefs.getString("report_last_inv_url") ?? "";
      });
    });

    tempCount = widget.draftOrderItem.length;
    finalItemDataList = widget.draftOrderItem;
    if (widget.draftOrderItem.isNotEmpty) {
      finalItemDataList.forEach((element) {
        controllers[element.item_id] = TextEditingController();
        controllers[element.item_id]?.text = element.quantity.toString();
      });
    }

    box = Boxes.getCustomerUsers();
    orderCustomerList = box!.toMap().values.toList().cast<CustomerDataModel>();

    if (widget.deliveryDate != '' && widget.deliveryTime != '') {
      selectedDeliveryTime = widget.deliveryTime;
      dateSelected = widget.deliveryDate;
      slectedPayMethod = widget.paymentMethod;
      initialOffer = widget.offer ?? 'Offer';
      ordertotalAmount();
    } else {
      return;
    }
    setState(() {});
    super.initState();
    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    noteController.dispose();
    _itemController.map((element) {
      element.dispose();
    });

    super.dispose();
  }

  initialValue(String val) {
    return TextEditingController(text: val);
  }

  double totalCount(AddItemModel model) {
    double total = (model.tp + model.vat) * model.quantity;
    return total;
  }

  Future<void> _showMyDialog(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please Confirm'),
          content: SingleChildScrollView(
            child: Column(
              children: const <Widget>[
                Text('Are you sure to remove the Item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                if (widget.deliveryDate != '') {
                  final uniqueKey = widget.ckey;
                  deleteSingleOrderItem(uniqueKey, index);
                  ordertotalAmount();

                  setState(() {});
                } else {
                  finalItemDataList.removeAt(index);
                  ordertotalAmount();
                  setState(() {});
                }

                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteSingleOrderItem(int dcrUniqueKey, int index) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey1 == dcrUniqueKey) desiredKey = key;
    });
    box.delete(desiredKey);
    finalItemDataList.removeAt(index);

    setState(() {});
  }

  int _currentSelected = 2;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            key: _drawerKey,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 138, 201, 149),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: const Text(
                'Order Cart',
              ),
              titleTextStyle: const TextStyle(
                  color: Color.fromARGB(255, 27, 56, 34),
                  fontWeight: FontWeight.w500,
                  fontSize: 20),
              centerTitle: true,
            ),
            endDrawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 138, 201, 149),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/images/mRep7_logo.png'),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FittedBox(
                                child: Text(
                                  widget.clientName,
                                  // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 11, 22, 13),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20),
                                ),
                              ),
                              // const SizedBox(
                              //   width: 10,
                              // ),
                              client_edit_flag == true
                                  ? IconButton(
                                      onPressed: () async {
                                        var url =
                                            '$client_edit_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        // size: 15,
                                      ),
                                    )
                                  : Container(
                                      width: 70,
                                    )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(widget.clientId,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 11, 22, 13),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15)),
                        )
                      ],
                    ),
                  ),
                  // ListTile(
                  //   leading:
                  //       const Icon(Icons.sync_outlined, color: Colors.black),
                  //   title: const Text('Outstanding'),
                  //   onTap: () {},
                  // ),
                  // ListTile(
                  //   leading: const Icon(Icons.document_scanner_outlined,
                  //       color: Colors.black),
                  //   title: const Text('Report'),
                  //   onTap: () {
                  //     // Update the state of the app.
                  //   },
                  // ),
                  // const Center(child: Text("SHOW OUTSTANDING")),
                  // const SizedBox(
                  //   height: 200,
                  // ),

                  SizedBox(
                    height: 80,
                    child: Center(
                      child: Text(
                        resultofOuts,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  os_show_flag == true
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              var body = await outstanding(widget.clientId);
                              if (body["outstanding"] == "") {
                                resultofOuts = "No Outstanding";
                              } else {
                                if (body["outstanding"] != 0) {
                                  resultofOuts = body["outstanding"]
                                      .replaceAll(", ", "\n")
                                      .toString();
                                } else {
                                  resultofOuts = body["outstanding"].toString();
                                }
                              }

                              setState(() {});
                            },
                            child: const Text(
                              "Show Outstanding",
                              style: TextStyle(fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              fixedSize: const Size(20, 50),
                              primary: Color.fromARGB(223, 146, 212, 157),
                              onPrimary: Color.fromARGB(255, 27, 43, 23),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        var url =
                            '$repOutsUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }

                        setState(() {});
                      },
                      child: const Text(
                        "Outstanding",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 50),
                        primary: Color.fromARGB(223, 146, 212, 157),
                        onPrimary: Color.fromARGB(255, 27, 43, 23),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        var url =
                            '$repLastOrdUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }

                        setState(() {});
                      },
                      child: const Text(
                        "Last Order",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 50),
                        primary: Color.fromARGB(223, 146, 212, 157),
                        onPrimary: Color.fromARGB(255, 27, 43, 23),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: () async {
                        var url =
                            '$repLastInvUrl?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }

                        setState(() {});
                      },
                      child: const Text(
                        "Last Invoice",
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(20, 50),
                        primary: Color.fromARGB(223, 146, 212, 157),
                        onPrimary: Color.fromARGB(255, 27, 43, 23),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  )
                  // widget.os_details_flag == true
                  //     ? Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: ElevatedButton(
                  //           onPressed: () {
                  //             setState(() {
                  //               Navigator.push(
                  //                   context,
                  //                   MaterialPageRoute(
                  //                       builder: (context) =>
                  //                           const OutStandingHistory()));
                  //             });
                  //           },
                  //           child: const Text("Show Outstanding Details"),
                  //           style: ElevatedButton.styleFrom(
                  //             fixedSize: const Size(20, 50),
                  //             primary: Color.fromARGB(255, 55, 129, 167),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(15),
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : Container(),

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Row(children: [
                  //     widget.ord_history_flag == true
                  //         ? Expanded(
                  //             child: ElevatedButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               const OrderHistory()));
                  //                 });
                  //               },
                  //               child: const Text("Order History"),
                  //               style: ElevatedButton.styleFrom(
                  //                 fixedSize: const Size(20, 50),
                  //                 primary: Color.fromARGB(255, 55, 129, 167),
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //         : Container(),
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     widget.inv_histroy_flag == true
                  //         ? Expanded(
                  //             child: ElevatedButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   Navigator.push(
                  //                       context,
                  //                       MaterialPageRoute(
                  //                           builder: (context) =>
                  //                               const InvoiceHistory()));
                  //                 });
                  //               },
                  //               child: const Text("Invoice History"),
                  //               style: ElevatedButton.styleFrom(
                  //                 fixedSize: const Size(20, 50),
                  //                 primary: Color.fromARGB(255, 55, 129, 167),
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                 ),
                  //               ),
                  //             ),
                  //           )
                  //         : Container(),
                  //   ]),
                  // )
                ],
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: screenWidth,
                      height: screenHeight / 13,
                      color: Color.fromARGB(223, 171, 241, 153),
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
                                        widget.clientName +
                                            '(${widget.clientId})',
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
                                      widget.marketName,
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
                    Card(
                      color: const Color(0xFFDDEBF7),
                      elevation: 5,
                      child: SizedBox(
                        // height: screenHeight / 9,
                        height: 80,

                        width: screenWidth,

                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: Column(
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Text(
                                        'Count:  ${finalItemDataList.length} ',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        'Amt: $totalAmount',
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    offer_flag == true
                                        ? Expanded(
                                            flex: 2,
                                            child: SizedBox(
                                              // width: 220,
                                              child: Center(
                                                child: DropdownButton<String>(
                                                  value: initialOffer,
                                                  items: offer
                                                      .map(
                                                        (String item) =>
                                                            DropdownMenuItem<
                                                                String>(
                                                          value: item,
                                                          child: Text(
                                                            item,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          ),
                                                        ),
                                                      )
                                                      .toList(),
                                                  onChanged: (item) => setState(
                                                    () {
                                                      initialOffer =
                                                          item.toString();
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 5.0),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: TextField(
                                        autofocus: false,
                                        controller: initialValue(dateSelected),
                                        focusNode: AlwaysDisabledFocusNode(),
                                        style: const TextStyle(
                                            color: Colors.black),
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          filled: true,
                                          hintText: 'Start Date',
                                          contentPadding:
                                              const EdgeInsets.all(2.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(2.0)),
                                        ),
                                        onChanged: (String value) {
                                          setState(() {});
                                          dateSelected = value;
                                          //dateSelected;
                                        },
                                        onTap: () {
                                          pickDate();
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(
                                        // width: 220,
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: selectedDeliveryTime,
                                            items: deliveryTime
                                                .map(
                                                  (String item) =>
                                                      DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (item) => setState(
                                              () {
                                                selectedDeliveryTime =
                                                    item.toString();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: SizedBox(
                                        // width: 220,
                                        child: Center(
                                          child: DropdownButton<String>(
                                            value: slectedPayMethod,
                                            items: payMethod
                                                .map(
                                                  (String item) =>
                                                      DropdownMenuItem<String>(
                                                    value: item,
                                                    child: Text(
                                                      item,
                                                      style: const TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                            onChanged: (item) => setState(
                                              () {
                                                slectedPayMethod =
                                                    item.toString();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///*************************************** Note ***********************************************/
                    note_flag == true
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: SizedBox(
                              height: 55,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color:
                                      const Color.fromARGB(255, 138, 201, 149)
                                          .withOpacity(.5),
                                ),
                                // elevation: 6,

                                child: TextFormField(
                                  // keyboardType: TextInputType.text,
                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.deny(
                                  //       RegExp(r'[@#%^!~\\/:;]'))
                                  // ],

                                  style: const TextStyle(
                                      fontSize: 18, color: Colors.black),
                                  controller: noteController,
                                  focusNode: FocusNode(),
                                  autofocus: false,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none),
                                      labelText: '  Notes...',
                                      labelStyle:
                                          TextStyle(color: Colors.blueGrey)),
                                  onChanged: (value) {
                                    noteText = (noteController.text).replaceAll(
                                        RegExp('[^A-Za-z0-9]'), " ");
                                  },
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: screenHeight / 1.7,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: finalItemDataList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext itemBuilder, index) {
                          // _itemController.add(TextEditingController());

                          // _itemController[index].text =
                          //     finalItemDataList[index].quantity.toString();
                          return Card(
                            elevation: 15,
                            color: Color.fromARGB(255, 222, 233, 243),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 10,
                                          child: Text(
                                            finalItemDataList[index].item_name,
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            _showMyDialog(index);
                                          },
                                          icon: const Icon(
                                            Icons.clear,
                                            size: 20,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        color: const Color.fromARGB(
                                            255, 200, 250, 207),
                                        elevation: 2,
                                        child: Row(
                                          children: const [
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  'QT',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  'TP',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  'Vat',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  'Total',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            // flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 0, 8, 0),
                                              child: Container(
                                                color: const Color.fromARGB(
                                                        255, 138, 201, 149)
                                                    .withOpacity(.3),
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,
                                                  controller: controllers[
                                                      finalItemDataList[index]
                                                          .item_id],

                                                  keyboardType:
                                                      TextInputType.number,
                                                  // focusNode: FocusNode(),
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                  ),
                                                  decoration:
                                                      const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),

                                                  onChanged: (value) {
                                                    // _itemController[index].clear();
                                                    finalItemDataList[index]
                                                        .quantity = controllers[
                                                                    finalItemDataList[
                                                                            index]
                                                                        .item_id]
                                                                ?.text !=
                                                            ''
                                                        ? int.parse(controllers[
                                                                finalItemDataList[
                                                                        index]
                                                                    .item_id]!
                                                            .text)
                                                        : 0;

                                                    ordertotalAmount();
                                                    // setState(() {});
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                '${finalItemDataList[index].tp}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                '${finalItemDataList[index].vat}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Center(
                                              child: Text(
                                                totalCount(finalItemDataList[
                                                        index])
                                                    .toStringAsFixed(2),
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
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
                  label: 'Submit',
                  icon: Icon(Icons.save),
                ),
                BottomNavigationBarItem(
                  label: 'Add Item',
                  icon: Icon(Icons.add),
                ),
                // BottomNavigationBarItem(
                //   label: 'Drawer',
                //   icon: Icon(Icons.menu),
                // )
              ],
            ),
          )
        : Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  _onItemTapped(int index) async {
    if (index == 0) {
      await orderPutData();
      // Navigator.pop(context);
      setState(() {
        _currentSelected = index;
      });
    } else {}

    if (index == 1) {
      setState(() {
        _isLoading = false;
      });

      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        orderSubmit();
      } else {
        _submitToastforOrder3();
        setState(() {
          _isLoading = true;
        });
        // print(InternetConnectionChecker().lastTryResults);
      }

      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 2) {
      getData();

      setState(() {
        _currentSelected = index;
      });
    }
  }

  void _submitToastforOrder3() {
    Fluttertoast.showToast(
        msg: 'No Internet Connection\nPlease check your internet connection.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

// Delete data from Hive by id...................................
  deleteOrderItem(int id) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey1 == widget.ckey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  deleteOrderCustomer(int id) {
    final box = Hive.box<CustomerDataModel>("customerHive");

    final Map<dynamic, CustomerDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.ckey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

//outstanding Api///////////////////////////////////////////////////////////////////////
  Future outstanding(String id) async {
    try {
      final http.Response response = await http.get(
        Uri.parse(
            '$client_outst_url?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$id'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var status = data['status'];
        // var a = data["outstanding"];

        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Order Failed'), backgroundColor: Colors.red));
      }
    } on Exception catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please check connection or data!'),
          backgroundColor: Colors.red));
      setState(() {
        _isLoading = true;
      });
      throw Exception("Error on server");
    }

    // return status;
  }

  // Submit order..............................
  Future orderSubmit() async {
    if (itemString != '') {
      String status;

      try {
        print("$submit_url api_order_submit/submit_data");
        final http.Response response = await http.post(
          Uri.parse('$submit_url/api_order_submit/submit_data'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8'
          },
          body: jsonEncode(
            <String, dynamic>{
              'cid': cid,
              'user_id': userId,
              'user_pass': userPassword,
              'device_id': deviceId,
              'client_id': widget.clientId,
              'delivery_date': dateSelected,
              'delivery_time': selectedDeliveryTime,
              'payment_mode': slectedPayMethod,
              'offer': initialOffer,
              'note': noteText,
              "item_list": itemString,
              "latitude": latitude,
              'longitude': longitude,
            },
          ),
        );

        var orderInfo = json.decode(response.body);
        status = orderInfo['status'];

        String ret_str = orderInfo['ret_str'];

        if (status == "Success") {
          setState(() {
            _isLoading = true;
          });
          for (int i = 0; i <= finalItemDataList.length; i++) {
            deleteOrderItem(widget.ckey);

            setState(() {});
          }

          deleteOrderCustomer(widget.ckey);

          setState(() {});

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        userName: userName,
                        userId: user_id,
                        userPassword: userPassword ?? '',
                      )),
              (Route<dynamic> route) => false);

          _submitToastforOrder(ret_str);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Order Failed'), backgroundColor: Colors.red));
          setState(() {
            _isLoading = true;
          });
        }
      } on Exception catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Please check connection or data!'),
            backgroundColor: Colors.red));
        setState(() {
          _isLoading = true;
        });
        throw Exception("Error on server");
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Please Order something',
          ),
          backgroundColor: Colors.red));
    }
    // return status;
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('syncItemData');
  }

  getData() async {
    await openBox();
    var mymap = box!.toMap().values.toList();

    if (mymap.isEmpty) {
      syncItemList.add('empty');
    } else {
      syncItemList = mymap;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ShowSyncItemData(
            uniqueId: widget.uniqueId,
            syncItemList: syncItemList,
            tempList: finalItemDataList,
            tempListFunc: (value) {
              finalItemDataList = value;
              finalItemDataList.forEach((element) {
                controllers[element.item_id] = TextEditingController();
                controllers[element.item_id]?.text =
                    element.quantity.toString();
              });
              // finalItemDataList.forEach((element) {

              // });

              ordertotalAmount();
              setState(() {});
            },
          ),
        ),
      );
    }
  }

  // order Amount calculation....................................................

  ordertotalAmount() {
    itemString = '';
    orderAmount = 0.0;
    if (finalItemDataList.isNotEmpty) {
      finalItemDataList.forEach((element) {
        total = (element.tp + element.vat) * element.quantity;
        // print(total);

        if (itemString == '' && element.quantity != 0) {
          itemString =
              element.item_id.toString() + '|' + element.quantity.toString();
        } else if (element.quantity != 0) {
          itemString += '||' +
              element.item_id.toString() +
              '|' +
              element.quantity.toString();
        }

        orderAmount = orderAmount + total;

        totalAmount = orderAmount.toStringAsFixed(2);

        // print(itemString);

        setState(() {});
      });
      // print(itemString);
    } else {
      setState(() {
        totalAmount = '';
      });
    }
  }

// Save OrderCustomer and ordered item to Hive..................................
  Future<dynamic> orderPutData() async {
    if (widget.deliveryDate != '' && finalItemDataList.isNotEmpty) {
      for (int i = 0; i <= finalItemDataList.length; i++) {
        deleteOrderItem(widget.ckey);

        setState(() {});
      }

      setState(() {});

      // print('object');

      for (var d in finalItemDataList) {
        final box = Boxes.getDraftOrderedData();

        box.add(d);
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              userName: userName,
              userId: user_id,
              userPassword: userPassword ?? '',
            ),
          ),
          (route) => false);
    } else if (finalItemDataList.isEmpty) {
      for (int i = 0; i <= tempCount; i++) {
        deleteOrderItem(widget.ckey);

        setState(() {});
      }

      setState(() {});

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(
              userName: userName,
              userId: user_id,
              userPassword: userPassword ?? '',
            ),
          ),
          (route) => false);
    } else {
      var customer = CustomerDataModel(
          uiqueKey: widget.uniqueId,
          clientName: widget.clientName,
          marketName: widget.marketName,
          areaId: 'areaId',
          clientId: widget.clientId,
          outstanding: widget.outStanding ?? "",
          thana: 'thana',
          address: 'address',
          deliveryDate: dateSelected,
          deliveryTime: selectedDeliveryTime,
          offer: initialOffer,
          paymentMethod: slectedPayMethod);

      customerdatalist.add(customer);

      for (var c in customerdatalist) {
        final box = Boxes.getCustomerUsers();
        box.add(c);
      }

      for (var d in finalItemDataList) {
        final box = Boxes.getDraftOrderedData();

        box.add(d);
      }

      Navigator.pop(context);
    }
  }

// Date pick function.................................................................
  pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DT,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.white,
          ), // This will change to light theme.
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    DT = newDate;
    dateSelected = DateFormat('yyyy-MM-dd').format(newDate);
    setState(() => DT = newDate);
  }

  // Status Message...................................................................
  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(
        msg: "Order Submitted\n$ret_str",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
