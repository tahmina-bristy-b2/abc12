import 'dart:math';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClientCensusScreen extends StatefulWidget {
  final List syncClientList;
  const ClientCensusScreen({super.key,required this.syncClientList});

  @override
  State<ClientCensusScreen> createState() => _ClientCensusScreenState();
}

class _ClientCensusScreenState extends State<ClientCensusScreen> {
  UserLoginModel? userLoginInfo;
  final _formkey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {};
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();

  DmPathDataModel? dmpathData;
  final clientCensusSavedBox = Boxes.chemistRxTargetToSave();
  bool _isLoading = false;
  List clientRxTargetInputList = [];

  int _currentSelected = 2;
  List foundUsers = [];
  int doctorCount = 0;
  int initialDoctorCount = 0;
  int amount = 0;
  bool isInList = false;
  var total = 0.0;
  bool incLen = true;
  String cid = "";
  String deviceId = "";


 @override
  void initState() {
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID")!;
        deviceId = prefs.getString("deviceId") ?? '';
      });
    });

    /// The Hive Box key [dcrRxTargetValue] used for [clientCensusSavedBox]
    clientRxTargetInputList =
        Boxes.chemistRxTargetToSave().get('ChemistRxTarget') ?? [];

    foundUsers = widget.syncClientList;
    for (var element in foundUsers) {
  var clientId = element['client_id'];
  if (clientId != null) {
    controllers[clientId] = TextEditingController();
  }
}

if (clientRxTargetInputList.isNotEmpty) {
  for (var element in clientRxTargetInputList) {
    var clientId = element.clientId;
    var controller = controllers[clientId];
    if (controller != null) {
      controller.text = element.chemistRxTargetValue ?? '';
    }
  }
}
   

    super.initState();
  }

  _onItemTapped(int index) async {
    if (index == 0) {
      toSaveRxTargetValue();
      Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      userName: userLoginInfo!.userName,
                      userId: userLoginInfo!.userId,
                      userPassword: userPassword,
                    )),
            (Route<dynamic> route) => false);
      // Navigator.pop(context);
      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 2) {
     
      setState(() {
        _isLoading = false;
      });
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        submitRXTraget();
      } else {
        AllServices()
            .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
        setState(() {
          _isLoading = true;
        });
      }

      setState(() {
        _currentSelected = index;
      });
    }
  }

  Future toSaveRxTargetValue() async {
    clientCensusSavedBox.put('ChemistRxTarget', clientRxTargetInputList);
  }

  submitRXTraget() async {
    String clientLIistString = '';
    if (clientRxTargetInputList.isNotEmpty) {
      for (var element in clientRxTargetInputList) {
        if (clientLIistString == '' && element.chemistRxTargetValue != "") {
          clientLIistString =
              '${element.areaId}|${element.clientId}|${element.chemistRxTargetValue}';
        } else if (element.chemistRxTargetValue != "") {
          clientLIistString +=
              '||${element.areaId}|${element.clientId}|${element.chemistRxTargetValue}';
        }
      }
    }
    print("chemist ==================$clientLIistString");

    if (clientLIistString != '') {
      Map<String, dynamic> rxTargetWholeData = await DcrRepositories().clientCensusRepo(dmpathData!.submitUrl, cid, userId,userPassword, deviceId, clientLIistString);
      if (rxTargetWholeData['status'] == "Success") {
        if (!mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      userName: userLoginInfo!.userName,
                      userId: userLoginInfo!.userId,
                      userPassword: userPassword,
                    )),
            (Route<dynamic> route) => false);

        AllServices().toastMessageForSubmitData(
            "Chemist Census Submitted\n${rxTargetWholeData['ret_str']}",
            Colors.green.shade900,
            Colors.white,
            16);
            clientCensusSavedBox.clear();
            
      } else {
        setState(() {
          _isLoading = true;
        });
        AllServices().toastMessage(
            "${rxTargetWholeData['ret_str']}", Colors.red, Colors.white, 16);
      }
    } else {
      setState(() {
        _isLoading = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Please Add something',
          ),
          backgroundColor: Colors.red));
    }
  }
 String updateCount() {
 int doctorCount = 0;
  for (var element in clientRxTargetInputList) {
    doctorCount += int.parse(element.chemistRxTargetValue==""?"0":element.chemistRxTargetValue);
  }
 
  return doctorCount.toString();
}

  

  @override
  void dispose() {
    for (var element in foundUsers) {
      controllers[element['client_id']]!.dispose();
    }

    searchController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text('Chemist Census'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
        actions: [
        
             Padding(
                padding: const EdgeInsets.fromLTRB(8, 18, 8, 8),
                child: Text(
                  
                  updateCount(),
                  style: const TextStyle(
                      color: Color.fromARGB(255, 27, 56, 34),
                      fontWeight: FontWeight.w500,
                      fontSize: 18),
                ),
              )
            
      ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _currentSelected,
        showUnselectedLabels: true,
        unselectedItemColor: Colors.grey[800],
        selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
        backgroundColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            label: 'Save Drafts',
            icon: Icon(Icons.drafts),
          ),
          BottomNavigationBarItem(
            label: '',
            icon: Icon(
              Icons.clear,
              color: Color.fromRGBO(255, 254, 254, 1),
            ),
          ),
          BottomNavigationBarItem(
            label: 'Submit',
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          itemSearchTextFormWidget(),
          listTileHeadingWidget(),
          itemListViewBuilderWIdget(),
          const SizedBox(
            height: 5,
          ),
          // addtoCartButtonWidget(context)
        ],
      ),
    );
  }

  Container listTileHeadingWidget() {
    return  Container(
         // color:const Color.fromARGB(255, 116, 188, 180) ,
          height: 35,
          child: Row(
                     
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children:const [
                                   
                               SizedBox(
                                width: 10,
                              ),
                                  Expanded(
                                    child:  Center(child: Text("Chemists ",style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Colors.black),))
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Center(
                                    child:    Container(
                                    
                                      child: const Center(child: FittedBox(child:  Text("           Monthly \n   Business Target",style: TextStyle(fontSize: 11,fontWeight: FontWeight.bold,color: Colors.black),))),
                                      
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
        );
  }

  //==================================================== doctor seacrch===================================
  SizedBox itemSearchTextFormWidget() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  foundUsers = AllServices().searchDynamicMethod(
                      value, widget.syncClientList, 'client_name');
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  // fillColor: Colors.white,
                  fillColor: Colors.teal.shade50,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: 'Search chemist by name....',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            foundUsers = AllServices().searchDynamicMethod(
                                '', widget.syncClientList, 'client_name');
                              
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.grey,
                            // size: 28,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //=======================================================ListView Builder=================================================
  Expanded itemListViewBuilderWIdget() {
    return Expanded(
      flex: 9,
      child: Form(
        key: _formkey,
        child: foundUsers.isNotEmpty
            ? ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: foundUsers.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 7,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Opacity(
                                    opacity: 0.7,
                                    child: Container(
                                      decoration: const ShapeDecoration(
                                        shape: CircleBorder(),
                                        // color: Color.fromARGB(255, 138, 201, 149),
                                        image: DecorationImage(
                                          image: AssetImage(
                                            'assets/images/shop_icons.png',
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      height: 45,
                                      width: 45,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // crossAxisAlignment: ,
                                      children: [
                                        Text(
                                          "${foundUsers[index]['client_name']} (${foundUsers[index]['client_id']})",
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 8, 18, 20),
                                              fontSize: 14),
                                        ),
                                        Wrap(
                                          children: [
                                            Text(
                                              '${foundUsers[index]['market_name']} | ${foundUsers[index]['area_id']} | ${foundUsers[index]['address']} | ${foundUsers[index]['outstanding']}',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 86, 84, 84),
                                                  fontSize: 11),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 4.0),
                                child: Card(
                                  child: Container(
                                    color:
                                        const Color.fromARGB(255, 138, 201, 149)
                                            .withOpacity(.3),
                                    width: 60,
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(
                                                                    RegExp(
                                                                        "[0-9]"),
                                                                  ),
                                                                ],
                                      textAlign: TextAlign.center,
                                      controller: controllers[foundUsers[index]
                                          ['client_id']],
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        if (value.isNotEmpty &&
                                            value.trim() != '') {
                                              var temp= CustomerDataModel(
                                                  clientName: foundUsers[index] ['client_name'],
                                                  marketName: foundUsers[index] ['market_name'],
                                                  areaId: foundUsers[index] ['area_id'],
                                                  clientId: foundUsers[index] ['client_id'],
                                                  outstanding: foundUsers[index] ['outstanding'],
                                                  thana: foundUsers[index] ['thana'],
                                                  address: 'address',
                                                  deliveryDate: '',
                                                  deliveryTime: '',
                                                  offer: '',
                                                  paymentMethod: '',
                                                  note: '',
                                                  itemList: [],
                                                  chemistRxTargetValue:controllers[
                                                      foundUsers[index]
                                                          ['client_id']]!
                                                  .text
                                                  );
                                              
                                          
                                          clientRxTargetInputList
                                              .removeWhere((element) =>
                                                  element.clientId ==
                                                  foundUsers[index]['client_id']);


                                                  

                                          clientRxTargetInputList.add(temp);
                                          
                                               
                       
                        //  if (clientRxTargetInputList.isNotEmpty) {
                        //           for (var element in clientRxTargetInputList) {
                        //          doctorCount= doctorCount + int.parse(element.rxTargetValue);
                        //              }
                        //         }


                          
                           //updateCount();
      
                                    
                                        } else {
                                          clientRxTargetInputList
                                              .removeWhere((element) =>
                                                  element.clientId ==
                                                  foundUsers[index]['client_id']);
                                                  // doctorCountMethod('0');
                            //  doctorCount=0;
                            //  doctorCount= doctorCount + int.parse('');
                            //  setState(() {
                            //   updateCount();
                               
                            //  });

                                
                                        }
                                        setState(() {
                                          
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // foundUsers[index]['magic_brand'].isNotEmpty
                      // magicBrandList.isNotEmpty
                      //     ? Padding(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 8.0, vertical: 8.0),
                      //         child: Row(children: [
                      //           Expanded(
                      //               child: Wrap(
                      //             spacing: 3.0,
                      //             runSpacing: 3.0,
                      //             children: magicBrandList
                      //                 .map(
                      //                   (e) => Container(
                      //                     // margin: EdgeInsets.all(3.0),
                      //                     padding: const EdgeInsets.all(3.0),
                      //                     decoration: BoxDecoration(
                      //                         // color: Colors.green,
                      //                         // color: Color(
                      //                         //         (math.Random().nextDouble() *
                      //                         //                 0xFFFFFF)
                      //                         //             .toInt())
                      //                         //     .withOpacity(.8),
                      //                         color: Colors
                      //                             .primaries[Random().nextInt(
                      //                                 Colors.primaries.length)]
                      //                             .withOpacity(.4),
                      //                         borderRadius:
                      //                             BorderRadius.circular(5)),

                      //                     child: Text(
                      //                       e,
                      //                       style: const TextStyle(
                      //                         fontSize: 9,
                      //                         color: Color.fromARGB(
                      //                             255, 50, 49, 49),
                      //                       ),
                      //                     ),
                      //                   ),
                      //                 )
                      //                 .toList(),
                      //           ))
                      //         ]),
                      //       )
                      //     : const SizedBox.shrink(),
                      Container(
                        color: Colors.grey,
                        height: 0.7,
                      )
                    ],
                  );
                })
            : const Text(
                'No Data found',
                style: TextStyle(fontSize: 24),
              ),
      ),
    );
  }
}
