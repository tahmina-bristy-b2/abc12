// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/order/order_repositories.dart';
import 'package:MREPORTING/services/order/order_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/ui/loginPage.dart';
import 'package:MREPORTING/ui/order_sections/order_item_list.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

DateTime DT = DateTime.now();
String dateSelected = DateFormat('yyyy-MM-dd').format(DT);

class NewOrderPage extends StatefulWidget {
  //String  ckey;
  String clientName;
  String marketName;
  String clientId;
  // int uniqueId;
  String deliveryTime;
  String deliveryDate;
  String paymentMethod;
  String? outStanding;
  String? offer;

  List<AddItemModel> draftOrderItem;
  NewOrderPage(
      {Key? key,
      //required this.ckey,
      //required this.uniqueId,
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
  Box? box;
  UserLoginModel? userLoginInfo;
  DmPathDataModel? dmPathData;
  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final List<TextEditingController> _itemController = [];
  final _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  final customerBox = Boxes.getCustomerUsers();
  final itemBox = Boxes.getDraftOrderedData();

  String userName = '';
  String user_id = '';

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  bool isSaved = false;
  bool isSaved2 = false;

  List<AddItemModel> finalItemDataList = [];
  List<CustomerDataModel> orderCustomerList = [];
  List<CustomerDataModel> customerdatalist = [];
  Map<String, dynamic> mapData = {};

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

  // String submit_url = '';
  // String client_edit_url = '';
  // // String client_outst_url = '';
  // String repOutsUrl = '';
  // String repLastOrdUrl = '';
  // String repLastInvUrl = '';

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
    super.initState();
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmPathData = Boxes.getDmpath().get('dmPathData');

    print("client_edit_flag=${userLoginInfo!.clientEditFlag}");

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        // client_outst_url = prefs.getString("client_outst_url") ?? "";
        // submit_url = prefs.getString("submit_url")!;
        // client_edit_url = prefs.getString("client_edit_url")!;

        cid = prefs.getString("CID");
        userId = prefs.getString("USER_ID");
        userPassword = prefs.getString("PASSWORD");
        userName = prefs.getString("userName")!;
        user_id = prefs.getString("user_id")!;
        // offer_flag = prefs.getBool("offer_flag")!;
        // note_flag = prefs.getBool("note_flag")!;
        // client_edit_flag = prefs.getBool("client_edit_flag")!;
        // os_show_flag = prefs.getBool("os_show_flag")!;
        // os_details_flag = prefs.getBool("os_details_flag")!;
        // ord_history_flag = prefs.getBool("ord_history_flag")!;
        // inv_histroy_flag = prefs.getBool("inv_histroy_flag")!;
        latitude = prefs.getDouble("latitude")!;
        longitude = prefs.getDouble("longitude")!;
        deviceId = prefs.getString("deviceId");
        deviceBrand = prefs.getString("deviceBrand");
        deviceModel = prefs.getString("deviceModel");
        // repOutsUrl = prefs.getString("report_outst_url") ?? "";
        // repLastOrdUrl = prefs.getString("report_last_ord_url") ?? "";
        // repLastInvUrl = prefs.getString("report_last_inv_url") ?? "";
      });
    });

    tempCount = widget.draftOrderItem.length;
    // print(widget.draftOrderItem.first.quantity);

    // print(finalItemDataList.first.quantity);

    box = Boxes.getCustomerUsers();
    orderCustomerList = box!.toMap().values.toList().cast<CustomerDataModel>();

    if (widget.deliveryDate != '' && widget.deliveryTime != '') {
      finalItemDataList = widget.draftOrderItem;
      selectedDeliveryTime = widget.deliveryTime;
      dateSelected = widget.deliveryDate;
      slectedPayMethod = widget.paymentMethod;
      initialOffer = widget.offer ?? 'Offer';

      print("mapData====$mapData");

      print("itemString====$itemString");
    } else {
      return;
    }
    if (widget.draftOrderItem.isNotEmpty) {
      for (var element in finalItemDataList) {
        controllers[element.item_id] = TextEditingController();
        for (var e in widget.draftOrderItem) {
          // print(e.quantity.toString());
          controllers.forEach((key, value) {
            if (key == e.item_id) {
              value.text = e.quantity.toString();
            }
          });
        }
        // controllers[element.item_id]?.text = widget.draftOrderItem.toString();
        // controllers[
        //  finalItemDataList[index].item_id].text
        print("controller ${controllers[element.item_id]!.text}");
      }
    }
    setState(() {
      // mapData = OrderServices().ordertotalAmount(
      //     itemString, orderAmount, finalItemDataList, total, totalAmount);
      itemString = OrderServices().ordertotalAmount(itemString, orderAmount,
          finalItemDataList, total, totalAmount)["ItemString"];
      totalAmount = OrderServices().ordertotalAmount(itemString, orderAmount,
          finalItemDataList, total, totalAmount)["TotalAmount"];
      print("itemString= $itemString");
    });
    setState(() {});

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

  // deleteSingleOrderItem(int dcrUniqueKey, int index) {
  //   final box = Hive.box<AddItemModel>("orderedItem");

  //   final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
  //   dynamic desiredKey;
  //   deliveriesMap.forEach((key, value) {
  //     if (value.uiqueKey1 == dcrUniqueKey) desiredKey = key;
  //   });
  //   box.delete(desiredKey);
  //   finalItemDataList.removeAt(index);

  //   setState(() {});
  // }

  int _currentSelected = 2; // this variable used for  bottom navigation bar

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            key: _drawerKey,
            appBar: appBarDetailsWidget(context),
            endDrawer: EndDrawerWidget(),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    customerInfoWidget(),
                    itemDeliveryDetailsWidget(),
                    userLoginInfo!.noteFlag
                        ? customerNotesTextFieldWidget()
                        : Container(),
                    SizedBox(
                      height: screenHeight / 1.7,
                      child: perItemCalculationListViewWidget(),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: bottomNavigation(),
          )
        : Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
  //************************************ WIDGETS **********************************************************/
  //*******************************************************************************************************/
  //*******************************************************************************************************/

  AppBar appBarDetailsWidget(BuildContext context) {
    return AppBar(
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
    );
  }

  //************************************ BOTTOMBAR WIDGETS **********************************************************/
  BottomNavigationBar bottomNavigation() {
    return BottomNavigationBar(
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
    );
  }

//************************************ DIALOG ****************************************************/
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
                  // .final uniqueKey = widget.clientId;
                  OrderServices().deleteSingleOrderItem(customerBox, itemBox,
                      widget.clientId, finalItemDataList[index].item_id);

                  itemString = OrderServices().ordertotalAmount(
                      itemString,
                      orderAmount,
                      finalItemDataList,
                      total,
                      totalAmount)["ItemString"];
                  totalAmount = OrderServices().ordertotalAmount(
                      itemString,
                      orderAmount,
                      finalItemDataList,
                      total,
                      totalAmount)["TotalAmount"];

                  setState(() {});
                } else {
                  finalItemDataList.removeAt(index);

                  itemString = OrderServices().ordertotalAmount(
                      itemString,
                      orderAmount,
                      finalItemDataList,
                      total,
                      totalAmount)["ItemString"];
                  totalAmount = OrderServices().ordertotalAmount(
                      itemString,
                      orderAmount,
                      finalItemDataList,
                      total,
                      totalAmount)["TotalAmount"];

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

//************************************ END DRAWER **********************************************************/
  Drawer EndDrawerWidget() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          drawerHeaderDetails(),
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
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          ),

          userLoginInfo!.osShowFlag ? clientOutStandingWidget() : Container(),
          outstandingURLShowWidget(),
          reportLastOrderShowWidget(),
          reportLastInvoiceShowWidget()
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
    );
  }

  DrawerHeader drawerHeaderDetails() {
    return DrawerHeader(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 15),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 138, 201, 149),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 25, 8, 0),
        child: Column(
          children: [
            FittedBox(
              child: Text(
                widget.clientName,
                style: const TextStyle(
                    color: Color.fromARGB(255, 11, 22, 13),
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            Text(widget.clientId,
                style: const TextStyle(
                    color: Color.fromARGB(255, 11, 22, 13),
                    fontWeight: FontWeight.w500,
                    fontSize: 15))
            // Image.asset('assets/images/logo-black.png'),
            // Expanded(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [
            //       FittedBox(
            //         child: Text(
            //           widget.clientName,
            //           style: const TextStyle(
            //               color: Color.fromARGB(255, 11, 22, 13),
            //               fontWeight: FontWeight.bold,
            //               fontSize: 20),
            //         ),
            //       ),
            //       userLoginInfo!.clientEditFlag
            //           ? customerEditUrlWidget()
            //           : Container(
            //               width: 70,
            //             )
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: Text(widget.clientId,
            //       style: const TextStyle(
            //           color: Color.fromARGB(255, 11, 22, 13),
            //           fontWeight: FontWeight.w500,
            //           fontSize: 15)),
            // )
          ],
        ),
      ),
    );
  }

  Padding reportLastInvoiceShowWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () async {
          var url =
              '${dmPathData!.reportLastInvUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch $url';
          }

          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 27, 43, 23),
          backgroundColor: const Color.fromARGB(223, 146, 212, 157),
          fixedSize: const Size(20, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Last Invoice",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Padding reportLastOrderShowWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
          onPressed: () async {
            var url =
                '${dmPathData!.reportLastOrdUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
            if (await canLaunchUrl(Uri.parse(url))) {
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Could not launch $url';
            }

            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Color.fromARGB(255, 27, 43, 23),
            backgroundColor: Color.fromARGB(223, 146, 212, 157),
            fixedSize: const Size(20, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: const Text(
            "Last Order",
            style: TextStyle(fontSize: 16),
          )),
    );
  }

  Padding outstandingURLShowWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () async {
          var url =
              '${dmPathData!.reportOutstUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
          print(
              "outStandingurl=${dmPathData!.reportOutstUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}");
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url));
          } else {
            throw 'Could not launch $url';
          }

          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 27, 43, 23),
          backgroundColor: const Color.fromARGB(223, 146, 212, 157),
          fixedSize: const Size(20, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Outstanding",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  IconButton customerEditUrlWidget() {
    return IconButton(
      onPressed: () async {
        print(
            "clentEditUrl=${dmPathData!.clientEditUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword");
        var url =
            '${dmPathData!.clientEditUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword';
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url));
        } else {
          throw 'Could not launch $url';
        }
      },
      icon: const Icon(
        Icons.edit,
        color: Colors.white,
        // size: 15,
      ),
    );
  }

  Padding clientOutStandingWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () async {
          var body = await outstanding(widget.clientId);
          if (body["outstanding"] == "") {
            resultofOuts = "No Outstanding";
          } else {
            if (body["outstanding"] != 0) {
              resultofOuts =
                  body["outstanding"].replaceAll(", ", "\n").toString();
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
          foregroundColor: Color.fromARGB(255, 27, 43, 23),
          backgroundColor: Color.fromARGB(223, 146, 212, 157),
          fixedSize: const Size(20, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Card itemDeliveryDetailsWidget() {
    return Card(
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
                        'Amt: ${OrderServices().ordertotalAmount(itemString, orderAmount, finalItemDataList, total, totalAmount)["TotalAmount"]}',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
                    userLoginInfo!.offerFlag
                        ? offerDrapdownWidget()
                        : Container(),
                  ],
                ),
              ),
              // const SizedBox(height: 5.0),
              Expanded(
                child: Row(
                  children: [
                    deliveryDatePickerWidget(),
                    deliveryShiftWidget(),
                    paymentDropdownWidget(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded deliveryDatePickerWidget() {
    return Expanded(
      flex: 3,
      child: TextField(
        autofocus: false,
        controller: initialValue(dateSelected),
        focusNode: AlwaysDisabledFocusNode(),
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          hintText: 'Start Date',
          contentPadding: const EdgeInsets.all(2.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
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
    );
  }

  Expanded deliveryShiftWidget() {
    return Expanded(
      flex: 3,
      child: SizedBox(
        // width: 220,
        child: Center(
          child: DropdownButton<String>(
            value: selectedDeliveryTime,
            items: deliveryTime
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                )
                .toList(),
            onChanged: (item) => setState(
              () {
                selectedDeliveryTime = item.toString();
              },
            ),
          ),
        ),
      ),
    );
  }

  Expanded paymentDropdownWidget() {
    return Expanded(
      flex: 3,
      child: SizedBox(
        // width: 220,
        child: Center(
          child: DropdownButton<String>(
            value: slectedPayMethod,
            items: payMethod
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                )
                .toList(),
            onChanged: (item) => setState(
              () {
                slectedPayMethod = item.toString();
              },
            ),
          ),
        ),
      ),
    );
  }

  Expanded offerDrapdownWidget() {
    return Expanded(
      flex: 2,
      child: SizedBox(
        // width: 220,
        child: Center(
          child: DropdownButton<String>(
            value: initialOffer,
            items: offer
                .map(
                  (String item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                )
                .toList(),
            onChanged: (item) => setState(
              () {
                initialOffer = item.toString();
              },
            ),
          ),
        ),
      ),
    );
  }

  Container customerInfoWidget() {
    return Container(
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
                        '${widget.clientName}(${widget.clientId})',
                        style: const TextStyle(
                            color: Color.fromARGB(255, 23, 41, 23),
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
                          color: Color.fromARGB(255, 26, 66, 28), fontSize: 16),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding customerNotesTextFieldWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: SizedBox(
        height: 55,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromARGB(255, 138, 201, 149).withOpacity(.5),
          ),
          // elevation: 6,

          child: TextFormField(
            // keyboardType: TextInputType.text,
            // inputFormatters: <TextInputFormatter>[
            //   FilteringTextInputFormatter.deny(
            //       RegExp(r'[@#%^!~\\/:;]'))
            // ],

            style: const TextStyle(fontSize: 18, color: Colors.black),
            controller: noteController,
            focusNode: FocusNode(),
            autofocus: false,
            decoration: const InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide.none),
                labelText: '  Notes...',
                labelStyle: TextStyle(color: Colors.blueGrey)),
            onChanged: (value) {
              noteText =
                  (noteController.text).replaceAll(RegExp('[^A-Za-z0-9]'), " ");
            },
          ),
        ),
      ),
    );
  }

  ListView perItemCalculationListViewWidget() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: finalItemDataList.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (BuildContext itemBuilder, index) {
        // _itemController.add(TextEditingController());

        // _itemController[index].text =
        //     finalItemDataList[index].quantity.toString();
        return Card(
          elevation: 15,
          color: const Color.fromARGB(255, 222, 233, 243),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 1),
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
                              color: Colors.black, fontSize: 16),
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
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: const Color.fromARGB(255, 200, 250, 207),
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
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Container(
                              color: const Color.fromARGB(255, 138, 201, 149)
                                  .withOpacity(.3),
                              child: TextFormField(
                                textAlign: TextAlign.center,
                                controller: controllers[
                                    finalItemDataList[index].item_id],

                                keyboardType: TextInputType.number,
                                // focusNode: FocusNode(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                ),
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),

                                onChanged: (value) {
                                  //_itemController[index].clear();
                                  finalItemDataList[index].quantity =
                                      controllers[finalItemDataList[index]
                                                      .item_id]
                                                  ?.text !=
                                              ''
                                          ? int.parse(controllers[
                                                  finalItemDataList[index]
                                                      .item_id]!
                                              .text)
                                          : 0;

                                  setState(() {
                                    itemString = OrderServices()
                                        .ordertotalAmount(
                                            itemString,
                                            orderAmount,
                                            finalItemDataList,
                                            total,
                                            totalAmount)["ItemString"];
                                    totalAmount = OrderServices()
                                        .ordertotalAmount(
                                            itemString,
                                            orderAmount,
                                            finalItemDataList,
                                            total,
                                            totalAmount)["TotalAmount"];

                                    print("itemSTring= $itemString");
                                  });
                                  setState(() {});
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
                              OrderServices()
                                  .totalCount(finalItemDataList[index])
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
    );
  }

  _onItemTapped(int index) async {
    if (index == 0) {
      await orderSaveAndDraftData();

      Navigator.pop(context);
      Navigator.pop(context);
      setState(() {
        _currentSelected = index;
      });
    }

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
  deleteOrderItem(String id) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.item_id == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  deleteOrderCustomer(String id) {
    final box = Hive.box<CustomerDataModel>("customerHive");

    final Map<dynamic, CustomerDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.clientId == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

//************************************************************************************ */

  // Submit order..............................
  Future orderSubmit() async {
    print("AMi eikhne= $itemString");
    if (itemString != '') {
      String status;
      Map<String, dynamic> orderInfo = await OrderRepositories().OrderSubmit(
          dmPathData!.submitUrl,
          cid,
          userId,
          userPassword,
          deviceId,
          widget.clientId,
          dateSelected,
          selectedDeliveryTime,
          slectedPayMethod,
          initialOffer,
          noteText,
          itemString,
          latitude,
          longitude);
      status = orderInfo['status'];

      String ret_str = orderInfo['ret_str'];

      if (status == "Success") {
        setState(() {
          _isLoading = true;
        });
        OrderServices()
            .deleteOrderItem(customerBox, finalItemDataList, widget.clientId);

        AllServices().toastMessage(ret_str, Colors.green, Colors.white, 16);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        AllServices()
            .toastMessage("Order Failed", Colors.red, Colors.white, 16);
        setState(() {
          _isLoading = true;
        });
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      AllServices()
          .toastMessage('Please Order something', Colors.red, Colors.white, 16);
    }
  }

//outstanding Api///////////////////////////////////////////////////////////////////////
//************************************************************************************ */
  Future outstanding(String id) async {
    print(
        "'${dmPathData!.clientOutstUrl}?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$id'");
    try {
      final http.Response response = await http.get(
        Uri.parse(
            '${dmPathData!.clientOutstUrl}?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$id'),
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

              setState(() {
                itemString = OrderServices().ordertotalAmount(
                    itemString,
                    orderAmount,
                    finalItemDataList,
                    total,
                    totalAmount)["ItemString"];
                totalAmount = OrderServices().ordertotalAmount(
                    itemString,
                    orderAmount,
                    finalItemDataList,
                    total,
                    totalAmount)["TotalAmount"];
                print("itemSTring= $itemString");
              });
            },
          ),
        ),
      );
    }
  }

  // order Amount calculation....................................................

  // ordertotalAmount() {
  //   itemString = '';
  //   orderAmount = 0.0;
  //   if (finalItemDataList.isNotEmpty) {
  //     finalItemDataList.forEach((element) {
  //       total = (element.tp + element.vat) * element.quantity;
  //       // print(total);

  //       if (itemString == '' && element.quantity != 0) {
  //         itemString =
  //             element.item_id.toString() + '|' + element.quantity.toString();
  //       } else if (element.quantity != 0) {
  //         itemString += '||' +
  //             element.item_id.toString() +
  //             '|' +
  //             element.quantity.toString();
  //       }

  //       orderAmount = orderAmount + total;

  //       totalAmount = orderAmount.toStringAsFixed(2);

  //       // print(itemString);

  //       setState(() {});
  //     });
  //     // print(itemString);
  //   } else {
  //     setState(() {
  //       totalAmount = '';
  //     });
  //   }
  // }

//================================================Save & draft Order Data===========================================================
  Future orderSaveAndDraftData() async {
    if (widget.deliveryDate != '' && finalItemDataList.isNotEmpty) {
      OrderServices().orderDraftDataUpdate(
          finalItemDataList, customerBox, widget.clientId);
    } else {
      customerBox.add(CustomerDataModel(
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
          paymentMethod: slectedPayMethod,
          itemList: finalItemDataList));
    }
  }

//=============================================================Date Time Picker==================================================================
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
