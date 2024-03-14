import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/models/expired_dated/expired_submit_and_save_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/expired_dated/expired_repositories.dart';
import 'package:MREPORTING/services/expired_dated/expired_services.dart';
import 'package:MREPORTING/services/order/order_apis.dart';
import 'package:MREPORTING/services/order/order_repositories.dart';
import 'package:MREPORTING/services/order/order_services.dart';
import 'package:MREPORTING/ui/Expired_dated_section/expired_dated_items.dart';
import 'package:MREPORTING/ui/Expired_dated_section/show_dialog/expired_item_input_show_dialog.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/textform_field_custom.dart';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

DateTime DT = DateTime.now();
String dateSelected = DateFormat('yyyy-MM-dd').format(DT);

class ExpiredDatedAddScreen extends StatefulWidget {
  final List<AddItemModel> draftOrderItem;
  final String clientName;
  final String marketName;
  final String clientId;
  final String? outStanding;
  
  const ExpiredDatedAddScreen(
      {Key? key,
      required this.draftOrderItem,
      required this.clientName,
      required this.clientId,
      this.outStanding,
      
      required this.marketName})
      : super(key: key);

  @override
  State<ExpiredDatedAddScreen> createState() => _ExpiredDatedAddScreenState();
}

class _ExpiredDatedAddScreenState extends State<ExpiredDatedAddScreen> {
  Box? box;
  UserLoginModel? userLoginInfo;
  DmPathDataModel? dmPathData;
  //List<DynamicItemsWidgetB> batchItems=[];
  final customerExpiredItemsBox = Boxes.getExpiredItemSubmitItems();
  final itemBox = Boxes.getDraftOrderedData();
  bool isEdit=false;

  
  final List<TextEditingController> _itemController = [];
  final _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List<ExpiredItemSubmitModel> finalItemDataList = [];
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

  @override
  void initState() {
    super.initState();
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmPathData = Boxes.getDmpath().get('dmPathData');
    box = Boxes.getExpiredItemSubmitItems();
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

    customerExpiredItemsBox.toMap().forEach((key, value) {
      if(value.clientId==widget.clientId){
        finalItemDataList= value.expiredItemSubmitModel;
        isEdit=true;
      }
    });
    setState(() {
      
    });

    // FocusScope.of(context).requestFocus(FocusNode());
  }

  @override
  void dispose() {
    _quantityController.dispose();

    _itemController.map((element) {
      element.dispose();
    });

    super.dispose();
  }

  int _currentSelected = 2; 

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            resizeToAvoidBottomInset: false,
            key: _drawerKey,
            appBar: appBarDetailsWidget(context),
           
            body: SafeArea(
              child: Column(
                children: [
                  customerInfoWidget(),
                 
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
        'Expired Dated Add Screen',
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
        
      ],
    );
  }

  //************************************ DIALOG ******************************************/
  Future<void> showMyDialog(String itemId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 70,
                child: Image.asset('assets/images/alert.png'),
              ),
              const SizedBox(height: 10,),
              const Text(
                "Are you sure to delete this item ?",
                style:  TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                finalItemDataList.removeWhere((element) =>element.itemId== itemId);
                Navigator.of(context).pop();
                  setState(() {
                  });
               
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




//=======================================================Customer Edit Url============================================================
  IconButton customerEditUrlWidget() {
    return IconButton(
      onPressed: () async {
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




//============================================Customer Info Details================================================================
  Container customerInfoWidget() {
    return Container(
      width: screenWidth,
      height: 60,
      // height: screenHeight / 13,
      color: const Color.fromARGB(223, 212, 241, 205),
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
                            fontSize: 15,
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
                          color: Color.fromARGB(255, 26, 66, 28), fontSize: 15),
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



//============================================Item Per Calculation LisView builder================================================================
  ListView perItemCalculationListViewWidget() {
  return ListView.builder(
  shrinkWrap: true,
  itemCount: finalItemDataList.length,
  physics: const BouncingScrollPhysics(),
  itemBuilder: (BuildContext context, index) {
    ExpiredItemListDataModel? expiredItems =  Boxes.getExpiredDatedIItems().get('expiredDatedItemSync');
    //print("")
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 8,
                  child: Text(
                    finalItemDataList[index].itemName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
                Expanded(child: Center(child: IconButton(onPressed: (){
                  showMyDialog(finalItemDataList[index].itemId);

                }, icon: const Icon(Icons.delete,color: Colors.red,)),)),
                const SizedBox(width: 10,),
                Expanded(
                  child: Center(
                    child: IconButton(
                      onPressed: () async {
                        ExpiredItemSubmitModel? expiredItemModel;
                        ExpiredItemList? expiredItem;
                        
                        for (var element in expiredItems!.expiredItemList) { 
                          if(element.itemId==finalItemDataList[index].itemId){
                            expiredItem=element;
                          }
                        }
                      for (var element in finalItemDataList) {
                        if(element.itemId==finalItemDataList[index].itemId ){
                          expiredItemModel=element; 
                        }  
                      }
                      if(expiredItem!=null){
                       await showDialog(context: context, builder:(BuildContext context){
                        return Theme( data: ThemeData(
                                 dialogBackgroundColor: Colors.white,
                                 dialogTheme: DialogTheme(
                                   shape: RoundedRectangleBorder(
                                     borderRadius: BorderRadius.circular(16.0),
                                   ),
                                 ),
                                ), 
                               child: ExpiredIteminputShowDialogScreen(
                                  expiredItem: expiredItem!,
                                  expiredItemSubmitModel: expiredItemModel, 
                                  callbackFunction: (value) {
                                     if(value == null){
                                      return;
                                     }
                                     if(value.batchWiseItem.isEmpty){
                                        finalItemDataList.removeAt(index);
                                        setState(() {  
                                      });
                                      return;
                                    
                                     }
                                     finalItemDataList[index] = value;
                                      
                                     setState(() {
                                       
                                     });
                                   
                                   }, clinetId: widget.clientId, itemId: finalItemDataList[index].itemId, 

                               ));
                        
                      } ,
                     );
                      setState(() {
                        
                      });
                      }
                        
                      },
                      icon: const Icon(Icons.edit, color: Color.fromARGB(255, 82, 179, 98)),
                    ),
                  ),
                ),
              ],
            ),
            fixedRowWidget(), 
            Column(
              children: finalItemDataList[index].batchWiseItem.map((batchItem) {
                return SizedBox(
                  height: 30,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Text(batchItem.batchId),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(child: Text(batchItem.expiredDate)),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Center(child: Text(batchItem.unitQty)),
                        ),
                      ),
                      
                    ],
                  ),
                );
              }).toList(),
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
      await ExpiredServices().orderSaveAndDraftData(isEdit,finalItemDataList,customerExpiredItemsBox, widget.clientName, widget.marketName, widget.clientId, widget.outStanding!);
      if (!mounted) return;
      Navigator.pop(context);
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
       expiredItemSubmit();
      } else {
        AllServices().toastMessage(
            "No Internet Connection\nPlease check your internet connection.",
            Colors.red,
            Colors.white,
            16);
        setState(() {
          _isLoading = true;
        });
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

  getData() async {
    ExpiredItemListDataModel? expiredItems =  Boxes.getExpiredDatedIItems().get('expiredDatedItemSync');
    if(expiredItems!=null){
    List<ExpiredItemList> expiredItemList= expiredItems.expiredItemList;
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ItemsExpiredDatedScreen(
          syncItem: expiredItemList,
          customerInfo: {
            "client_name": widget.clientName,
            "client_id": widget.clientId,
            "market_name": widget.marketName,
            "outStanding": widget.outStanding,

          },
          expiredItemSubmitModel: finalItemDataList,
          callbackMethod: (value) {
            value?.removeWhere((element) => element.batchWiseItem.isEmpty);
            finalItemDataList = value!;
            setState(() {
              
            });
           
          }, 
        ),
      ),
    );

    }
    
  }


  Container fixedRowWidget() {
                  return Container(
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color : const Color.fromARGB(255, 138, 201, 149)
                                          .withOpacity(.3) ,
                                              spreadRadius : 2,
                                              blurStyle :BlurStyle.outer,
                                              blurRadius: 1,
                                            ),
                                          ], 
                                          borderRadius: BorderRadius.circular(12),
                                          color:  const Color.fromARGB(255, 138, 201, 149)
                                          .withOpacity(.3),
                                          
                                        ),
                                        
                                          child: Row(
                                            children:const [
                                              Expanded(
                                                flex: 2,
                                                child: Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child:  Center(child: Text("Batch Id",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                              )),
                                               Expanded(
                                                flex: 2,
                                                child: Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child:  Center(child: Text("Expired Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                              )),
                                               Expanded(flex: 2,
                                                child: Padding(
                                                padding:  EdgeInsets.all(8.0),
                                                child:  Center(child: Text("Qty",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 14),)),
                                              )),
                                             
                                            ],  
                                          )
                                          
                                       
                                      );
  }



  //===========================Submit Api call==============================================

  Future expiredItemSubmit() async {
    String itemString="";
    if(finalItemDataList.isNotEmpty){
    for (var element1 in finalItemDataList) {
          for (var element2 in element1.batchWiseItem) {
            if(itemString.isEmpty){
              itemString="${element1.itemId}|${element2.batchId}|${element2.expiredDate}|${element2.unitQty}";
            }
            else{
              itemString+="||${element1.itemId}|${element2.batchId}|${element2.expiredDate}|${element2.unitQty}";
            }
            
          }  
    }
    }
    print("itemString =$itemString");

    if (itemString != '') {
      String status;
      Map<String, dynamic> orderInfo = await ExpiredRepositoryRepo().expiredSubmitRepo(
          dmPathData!.submitUrl,
          cid,
          userLoginInfo!.userId,
          userPassword,
          deviceId,
          widget.clientId,
          "",
          itemString,
          latitude,
          longitude);
      if (orderInfo.isNotEmpty) {
        status = orderInfo['status'];
        var ret_str = orderInfo['ret_str']; 

        if (status == "Success") {
          setState(() {
            _isLoading = true;
          });
         ExpiredServices().deleteOrderItem(customerExpiredItemsBox, finalItemDataList, widget.clientId);
          AllServices().toastMessage("Expired items submission done\n${orderInfo['ret_str']}", Colors.green,
              Colors.white, 16); 
          if (!mounted) return;
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } else {
          AllServices().toastMessage(
              ret_str, Colors.red, Colors.white, 16); 
          setState(() {
            _isLoading = true;
          });
        }
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
 

//===========================================================end========================================================================================================

  initialValue(String val) {
    return TextEditingController(text: val);
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
