import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/apiCall.dart';
import 'package:MREPORTING_OFFLINE/services/order/order_apis.dart';
import 'package:MREPORTING_OFFLINE/services/order/order_services.dart';
import 'package:MREPORTING_OFFLINE/ui/Expired_dated_section/expired_dated_add_screen.dart';
import 'package:MREPORTING_OFFLINE/ui/Widgets/common_in_app_web_view.dart';
import 'package:MREPORTING_OFFLINE/ui/order_sections/approved_page.dart';
import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:MREPORTING_OFFLINE/ui/order_sections/order_item_list.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:telephony/telephony.dart';

// import 'package:telephony/telephony.dart';

import 'package:url_launcher/url_launcher.dart';

// onBackgroundMessage(SmsMessage message) {
//   debugPrint("onBackgroundMessage called");
// }

DateTime DT = DateTime.now();
String dateSelected = DateFormat('yyyy-MM-dd').format(DT);

class NewOrderPage extends StatefulWidget {
  final String clientName;
  final String marketName;
  final String clientId;
  final String deliveryTime;
  final String deliveryDate;
  final String paymentMethod;
  final String? outStanding;
  final String? offer;
  final String note;

  final List<AddItemModel> draftOrderItem;
  const NewOrderPage(
      {Key? key,
      required this.draftOrderItem,
      required this.clientName,
      required this.clientId,
      this.outStanding,
      required this.deliveryDate,
      required this.deliveryTime,
      required this.paymentMethod,
      this.offer,
      required this.note,
      required this.marketName})
      : super(key: key);

  @override
  State<NewOrderPage> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  // final Telephony telephony = Telephony.instance;
  // final String _recipient =
  //     '+8801551093321'; // Replace with the recipient's number

  // void _sendSms() async {
  //   String message = "fjyfyuf";
  //   if (message.isNotEmpty) {
  //     await telephony.sendSms(
  //       to: _recipient,
  //       message: message,
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('SMS sent to $_recipient')),
  //     );
  //   }
  // }
  // Future<void> requestSmsPermission() async {
  //   var status = await Permission.sms.status;
  //   if (!status.isGranted) {
  //     await Permission.sms.request();
  //   }
  // }

  // void _sendSMS(String message, List<String> recipients) async {
  //   await requestSmsPermission();

  //   try {
  //     String result = await sendSMS(message: message, recipients: recipients);
  //     print("SMS sent: $result");
  //   } catch (e) {
  //     print("Error sending SMS: $e");
  //   }
  // }

  Box? box;
  UserLoginModel? userLoginInfo;
  DmPathDataModel? dmPathData;
  final customerBox = Boxes.getCustomerUsers();
  final itemBox = Boxes.getDraftOrderedData();

  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final List<TextEditingController> _itemController = [];
  final _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List<AddItemModel> finalItemDataList = [];
  List syncItemList = [];
  List<String> deliveryTime = ['Morning', 'Evening'];
  String selectedDeliveryTime = 'Morning';
  List<String> payMethod = ['CASH', 'CREDIT'];
  List<String> offer = ['_', 'Priority', 'Flex'];
  String slectedPayMethod = 'CASH';
  String initialOffer = '_';
  DateTime deliveryDate = DateTime.now();

  bool _isLoading = true;
  double orderAmount = 0;
  String totalAmount = '';
  double total = 0;

  String noteText = '';
  String cid = '';
  String userPassword = '';

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

  // String _message = "";
  // final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    // initPlatformState();

    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmPathData = Boxes.getDmpath().get('dmPathData');
    box = Boxes.getCustomerUsers();
    dateSelected = DateFormat('yyyy-MM-dd').format(DateTime.now());

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID") ?? '';
        userPassword = prefs.getString("PASSWORD") ?? '';
        latitude = prefs.getDouble("latitude") ?? 0.0;
        longitude = prefs.getDouble("longitude") ?? 0.0;
        deviceId = prefs.getString("deviceId");
        deviceBrand = prefs.getString("deviceBrand");
        deviceModel = prefs.getString("deviceModel");
      });
    });

    tempCount = widget.draftOrderItem.length;

    if (widget.deliveryDate != '' && widget.deliveryTime != '') {
      finalItemDataList = widget.draftOrderItem;
      selectedDeliveryTime = widget.deliveryTime;
      dateSelected = widget.deliveryDate;
      slectedPayMethod = widget.paymentMethod;
      initialOffer = widget.offer ?? 'Offer';
      noteController.text = widget.note;
    }
    if (widget.draftOrderItem.isNotEmpty) {
      for (var element in finalItemDataList) {
        controllers[element.item_id] = TextEditingController();
        for (var e in widget.draftOrderItem) {
          controllers.forEach((key, value) {
            if (key == e.item_id) {
              value.text = e.quantity.toString();
            }
          });
        }
      }
    }
    setState(() {
      itemString = OrderServices().ordertotalAmount(itemString, orderAmount,
          finalItemDataList, total, totalAmount)["ItemString"];
      totalAmount = OrderServices().ordertotalAmount(itemString, orderAmount,
          finalItemDataList, total, totalAmount)["TotalAmount"];
    });
  }

  //============================================

  Future<void> sendSMS(String bodyMessage) async {
    try {
      final Telephony telephony = Telephony.instance;
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      debugPrint(permissionsGranted.toString());

      await telephony.sendSms(to: "+8809617612744", message: bodyMessage);
      setState(() {
        _isLoading = true;
      });

      OrderServices()
          .deleteOrderItem(customerBox, finalItemDataList, widget.clientId);

      if (!mounted) return;
      Navigator.of(context).pop();
      Navigator.of(context).pop();
      AllServices().toastMessage(
          "Order Submitted by SMS", Colors.green, Colors.white, 16);
    } catch (e) {
      setState(() {
        _isLoading = true;
      });
      AllServices().toastMessage(
          "Order Failed (${e.toString()})", Colors.red, Colors.white, 16);

      // debugPrint("SMS Failed $e");
    }
  }

  // onMessage(SmsMessage message) async {
  //   setState(() {
  //     _message = message.body ?? "Error reading message body.";
  //   });
  // }

  // onSendStatus(SendStatus status) {
  //   setState(() {
  //     _message = status == SendStatus.SENT ? "sent" : "delivered";
  //   });
  // }

  // // Platform messages are asynchronous, so we initialize in an async method.
  // Future<void> initPlatformState() async {
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.

  //   final bool? result = await telephony.requestPhoneAndSmsPermissions;

  //   if (result != null && result) {
  //     telephony.listenIncomingSms(
  //         onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
  //   }

  //   if (!mounted) return;
  // }

  @override
  void dispose() {
    _quantityController.dispose();
    noteController.dispose();
    _itemController.map((element) {
      element.dispose();
    });

    super.dispose();
  }

  int _currentSelected = 2; // this variable used for  bottom navigation bar

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            key: _drawerKey,
            appBar: appBarDetailsWidget(context),
            endDrawer: EndDrawerWidget(),
            body: SafeArea(
              child: Column(
                children: [
                  customerInfoWidget(),
                  itemDeliveryDetailsWidget(),
                  customerNotesTextFieldWidget(),
                  Expanded(child: perItemCalculationListViewWidget()),
                ],
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

  //************************************ WIDGETS ***************************************/
  //************************************************************************************/
  //************************************************************************************/

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

  //************************************ DIALOG ******************************************/
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

//************************************ END DRAWER ****************************************/
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
          reportLastInvoiceShowWidget(),
          approvedShowWidget(),

          userLoginInfo!.expiredFlag == true
              ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      //   setState(() {
                      //   _counter = OrderServices().incrementCounter(_counter);
                      // });

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ExpiredDatedAddScreen(
                                    draftOrderItem: [],
                                    // deliveryDate: '',
                                    // deliveryTime: '',
                                    // paymentMethod: '',
                                    outStanding: widget.outStanding,
                                    clientName: widget.clientName,
                                    clientId: widget.clientId,
                                    marketName: widget.marketName,
                                    // note: '',
                                  )));
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
                      "Track Expired",
                      style: TextStyle(fontSize: 16),
                    ),
                  ))
              : const SizedBox()

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

//===================================================================End Drawer Head======================================================================
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

//========================================================= Last Invoice Report==========================================================
  Padding reportLastInvoiceShowWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommonInAppWebView(
                  title: "Last Invoice",
                  cid: cid,
                  userId: userLoginInfo!.userId,
                  userPassword: userPassword,
                  url: dmPathData!.reportLastInvUrl,
                  clientId: widget.clientId),
            ),
          );
          // var url =
          //     '${dmPathData!.reportLastInvUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
          // var url = OrderApis.lastInvoiceApi(dmPathData!.reportLastInvUrl, cid,
          //     userLoginInfo!.userId, userPassword, widget.clientId);
          // if (await canLaunchUrl(Uri.parse(url))) {
          //   await launchUrl(Uri.parse(url));
          // } else {
          //   throw 'Could not launch $url';
          // }

          // setState(() {});
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

//========================================================= Last Invoice Report==========================================================
  Padding approvedShowWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => ApprovedPage(
                      cid: cid,
                      userPassword: userPassword,
                      clientId: widget.clientId,
                      clientName: widget.clientName,
                    ))),
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color.fromARGB(255, 27, 43, 23),
          backgroundColor: const Color.fromARGB(223, 146, 212, 157),
          fixedSize: const Size(20, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: const Text(
          "Approved",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

//===============================Last Order Report==================================
  Padding reportLastOrderShowWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
          onPressed: () async {
            // var url =
            //     '${dmPathData!.reportLastOrdUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword&client_id=${widget.clientId}';
            // var url = OrderApis.lastOrderInvoice(dmPathData!.reportLastOrdUrl,
            //     cid, userLoginInfo!.userId, userPassword, widget.clientId);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CommonInAppWebView(
                    title: "Last Order",
                    cid: cid,
                    userId: userLoginInfo!.userId,
                    userPassword: userPassword,
                    url: dmPathData!.reportLastOrdUrl,
                    clientId: widget.clientId),
              ),
            );
            // print('lastOrderApi=$url');
            // if (await canLaunchUrl(Uri.parse(url))) {
            //   await launchUrl(Uri.parse(url));
            // } else {
            //   throw 'Could not launch $url';
            // }

            // setState(() {});
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
            "Last Order",
            style: TextStyle(fontSize: 16),
          )),
    );
  }

//=================================================================outStanding Report===========================================================
  Padding outstandingURLShowWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CommonInAppWebView(
                  title: 'Outstanding',
                  cid: cid,
                  userId: userLoginInfo!.userId,
                  userPassword: userPassword,
                  url: dmPathData!.reportOutstUrl,
                  clientId: widget.clientId),
            ),
          );
          // var url = OrderApis.outstandingReport(dmPathData!.reportOutstUrl, cid,
          //     userLoginInfo!.userId, userPassword, widget.clientId);
          // // print("outStandingurl=$url");
          // if (await canLaunchUrl(Uri.parse(url))) {
          //   await launchUrl(Uri.parse(url));
          // } else {
          //   throw 'Could not launch $url';
          // }

          // setState(() {});
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

//=======================================================Customer Edit Url============================================================
  IconButton customerEditUrlWidget() {
    return IconButton(
      onPressed: () async {
        // print(
        //     "clentEditUrl=${dmPathData!.clientEditUrl}?cid=$cid&rep_id=$userLoginInfo!.userId&rep_pass=$userPassword");
        // var url =
        //     '${dmPathData!.clientEditUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword';
        var url = OrderApis.cutomerEditUrlApi(dmPathData!.clientEditUrl, cid,
            userLoginInfo!.userId, userPassword);
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

//======================================================= Show OutStanding Url=============================================================
  Padding clientOutStandingWidget() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        onPressed: () async {
          resultofOuts = await OrderServices().getOutstandingData(
              dmPathData!.clientOutstUrl,
              cid,
              userLoginInfo!.userId,
              userPassword,
              deviceId,
              widget.clientId);
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
          "Show Outstanding",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

//============================================Item Delivery Details================================================================
  itemDeliveryDetailsWidget() {
    return SizedBox(
      // height: screenHeight / 9,
      height: 100,

      width: screenWidth,

      child: Column(
        children: [
          Expanded(
            child: Card(
              color: const Color.fromARGB(255, 196, 209, 231),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      'CPP: ${OrderServices().ordertotalAmount(itemString, orderAmount, finalItemDataList, total, totalAmount)["TotalAmount"]}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(13, 106, 129, 1),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'TP: ${OrderServices().orderTotalTPAmount(finalItemDataList)}',
                      // style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      ' R.DiscOnTP: ${OrderServices().regDiscOnTp(finalItemDataList)}',
                      // style: TextStyle(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Count: ${finalItemDataList.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(13, 106, 129, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // const SizedBox(height: 5.0),
          Expanded(
            child: Card(
              child: Row(
                children: [
                  deliveryDatePickerWidget(),
                  deliveryShiftWidget(),
                  paymentDropdownWidget(),
                  offerDrapdownWidget()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//============================================Item Delivery Date================================================================
  Expanded deliveryDatePickerWidget() {
    return Expanded(
      flex: 2,
      child: TextField(
        autofocus: false,
        controller: initialValue(dateSelected),
        focusNode: AlwaysDisabledFocusNode(),
        style: const TextStyle(color: Colors.black),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          fillColor: Colors.teal.shade50,
          filled: true,
          hintText: 'Delivery Date',
          labelText: 'Delivery Date',
          labelStyle: const TextStyle(color: Color.fromARGB(255, 1, 99, 89)),
          contentPadding: const EdgeInsets.all(2.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.0),
              borderSide: const BorderSide(color: Colors.green)),
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

//============================================Item Delivery Shift================================================================
  Expanded deliveryShiftWidget() {
    return Expanded(
      flex: 2,
      child: Card(
        color: Colors.teal.shade50,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedDeliveryTime,
              iconEnabledColor: Colors.teal,
              iconDisabledColor: Colors.grey,
              iconSize: 28,
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
      ),
    );
  }

//============================================Item Delivery Payment Method================================================================
  Expanded paymentDropdownWidget() {
    return Expanded(
      flex: 2,
      child: Card(
        color: Colors.teal.shade50,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: slectedPayMethod,
              iconEnabledColor: Colors.teal,
              iconDisabledColor: Colors.grey,
              iconSize: 28,
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
      ),
    );
  }

//============================================Item Offer ================================================================
  Expanded offerDrapdownWidget() {
    return Expanded(
      flex: 2,
      child: Card(
        color: Colors.teal.shade50,
        child: Center(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: initialOffer,
              iconEnabledColor: Colors.teal,
              iconDisabledColor: Colors.grey,
              iconSize: 28,
              // borderRadius: BorderRadius.circular(5),
              // underline: ,
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
      ),
    );
  }

//============================================Customer Info Details================================================================
  Container customerInfoWidget() {
    return Container(
      width: screenWidth,
      height: 60,
      // height: screenHeight / 13,
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

//============================================Note================================================================
  Padding customerNotesTextFieldWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: userLoginInfo!.noteFlag
          ? SizedBox(
              height: 60,
              width: screenWidth,
              // color: const Color.fromARGB(255, 138, 201, 149).withOpacity(.5),
              child: TextFormField(
                maxLength: 100,
                keyboardType: TextInputType.text,

                style: const TextStyle(color: Colors.black),
                controller: noteController,
                // focusNode: FocusNode(),
                autofocus: false,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color.fromARGB(255, 167, 209, 174)
                        .withOpacity(.5),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    labelText: 'Notes',
                    labelStyle: const TextStyle(color: Colors.blueGrey)),
                onChanged: (value) {
                  // value.replaceAll(RegExp('[^A-Za-z0-9]'), " ");
                  (noteController.text).replaceAll(RegExp('[^A-Za-z0-9]'), " ");
                },
              ),
            )
          : const Text(''),
    );
  }

//============================================Item Per Calculation LisView builder================================================================
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
          // elevation: 15,
          color: const Color.fromARGB(255, 222, 233, 243),
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70, width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      // flex: 10,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(
                              finalItemDataList[index].item_name,
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 16),
                            ),
                          ),
                          userLoginInfo!.promoFlag &&
                                  finalItemDataList[index].promo != '' &&
                                  finalItemDataList[index].promo != null
                              ? Card(
                                  color: Colors.yellow,
                                  child: Text(
                                    finalItemDataList[index].promo!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
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
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: const Color.fromARGB(255, 200, 250, 207),
                  // elevation: 2,
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
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                      // flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: Container(
                          height: 30,
                          color: const Color.fromARGB(255, 138, 201, 149)
                              .withOpacity(.3),
                          child: TextFormField(
                            textAlign: TextAlign.center,
                            controller:
                                controllers[finalItemDataList[index].item_id],

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
                                  controllers[finalItemDataList[index].item_id]
                                              ?.text !=
                                          ''
                                      ? int.parse(controllers[
                                              finalItemDataList[index].item_id]!
                                          .text)
                                      : 0;

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
              ],
            ),
          ),
        );
      },
    );
  }

//============================================Bottom Navigation Bar Index Function================================================================

  _onItemTapped(int index) async {
    if (index == 0) {
      await orderSaveAndDraftData();
      if (!mounted) return;
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

      orderSubmit();

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

  getData() async {
    List mymap = await AllServices().getSyncSavedData('syncItemData');
    syncItemList = mymap;
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShowSyncItemData(
          syncItemList: syncItemList,
          tempList: finalItemDataList,
          tempListFunc: (value) {
            finalItemDataList = value;
            for (var element in finalItemDataList) {
              controllers[element.item_id] = TextEditingController();
              controllers[element.item_id]?.text = element.quantity.toString();
            }
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
            });
          },
        ),
      ),
    );
  }

//================================================Save & draft Order Data===========================================================
  Future orderSaveAndDraftData() async {
    if (widget.deliveryDate != '' && finalItemDataList.isNotEmpty) {
      OrderServices().orderDraftDataUpdate(
        finalItemDataList,
        customerBox,
        widget.clientId,
        dateSelected,
        selectedDeliveryTime,
        initialOffer,
        noteController.text,
        slectedPayMethod,
      );
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
          note: noteController.text,
          itemList: finalItemDataList));
    }
  }

//=============================================================Date Time Picker==================================================================
  pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: DT,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            primaryColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;

    DT = newDate;
    dateSelected = DateFormat('yyyy-MM-dd').format(newDate);
    setState(() => DT = newDate);
  }

  //===========================Submit Api call==============================================

  Future orderSubmit() async {
    String smsItemString = "";
    if (finalItemDataList.isNotEmpty) {
      for (var element in finalItemDataList) {
        if (smsItemString == '' && element.quantity != 0) {
          smsItemString = '${element.item_id}.${element.quantity}';
        } else if (element.quantity != 0) {
          smsItemString += '.${element.item_id}.${element.quantity}';
        }
      }
    }
    String finalString =
        "ORDER.${cid.toUpperCase()}.${userLoginInfo!.userId}.${widget.clientId}.$dateSelected.$smsItemString";

    if (smsItemString != '') {
      if (finalString.length > 150 && finalItemDataList.length > 150) {
        setState(() {
          _isLoading = true;
        });
        AllServices().toastMessage(
            'Your SMS is too long. Please split your order into shorter parts & order again',
            Colors.red,
            Colors.white,
            16);
      } else {
        await sendSMS(finalString);
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      AllServices()
          .toastMessage('Please Order something', Colors.red, Colors.white, 16);
    }
  }

//===========================================================end========================================================================================================

  initialValue(String val) {
    return TextEditingController(text: val);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
