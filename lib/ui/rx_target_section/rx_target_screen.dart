import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/services/order/order_services.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RxTargetScreen extends StatefulWidget {
  final List syncDoctorList;
  const RxTargetScreen({super.key, required this.syncDoctorList});

  @override
  State<RxTargetScreen> createState() => _RxTargetScreenState();
}

class _RxTargetScreenState extends State<RxTargetScreen> {
  UserLoginModel? userLoginInfo;
  final _formkey = GlobalKey<FormState>();
  Map<String, TextEditingController> controllers = {};
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();

  DmPathDataModel? dmpathData;
  final dcrRxTagetSavedBox = Boxes.dcrRxTargetToSave();
  // List<DcrDataModel> dcrRxTargetValueInputedList = [];
   bool  _isLoading = false;
  List dcrRxTargetValueInputedList = [];

  int _currentSelected = 2;
  List foundUsers = [];
  var orderamount = 0.0;
  var neworderamount = 0.0;
  int amount = 0;
  bool isInList = false;
  var total = 0.0;
  bool incLen = true;
  String cid = "";
  String deviceId="";

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
    
   
    /// The Hive Box key [dcrRxTargetValue] used for [dcrRxTagetSavedBox]
    dcrRxTargetValueInputedList =
        Boxes.dcrRxTargetToSave().get('dcrRxTargetValue') ?? [];

    foundUsers = widget.syncDoctorList;
    for (var element in foundUsers) {
      controllers[element['doc_id']] = TextEditingController();
    }

    if (dcrRxTargetValueInputedList.isNotEmpty) {
      for (var element in dcrRxTargetValueInputedList) {
        controllers[element.docId]!.text = element.rxTargetValue ?? '';
      }
    }
    

    super.initState();
  }

  _onItemTapped(int index) async {
    if (index == 0) {
      toSaveRxTargetValue();
      Navigator.pop(context);
      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 2) {
      //print("dataaaaaaaaaaaaaaaaaaaaaa");
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
    dcrRxTagetSavedBox.put('dcrRxTargetValue', dcrRxTargetValueInputedList);
  }

  submitRXTraget()async{
    String doctorlistString = '';
    if (dcrRxTargetValueInputedList.isNotEmpty) {
      for (var element in dcrRxTargetValueInputedList) {
   
        if (doctorlistString == '' && element.rxTargetValue !="" ) {
          doctorlistString = '${element.docId}|${element.areaId}|${element.rxTargetValue}';
        } else if (element.rxTargetValue != "") {
          doctorlistString += '||${element.docId}|${element.areaId}|${element.rxTargetValue}';
        }
        
      }
    }


    if (doctorlistString != '') {
      Map<String, dynamic> rxTargetWholeData = await DcrRepositories().rxTargetRepo(dmpathData!.submitUrl, cid, userId,userPassword, deviceId, doctorlistString);

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
            "Rx Target Submitted\n${rxTargetWholeData['ret_str']}",
            Colors.green.shade900,
            Colors.white,
            16);
      } else {
        setState(() {
          _isLoading = true;
        });
        AllServices().toastMessage(
            "${rxTargetWholeData['ret_str']}", 
            Colors.red,
            Colors.white,
            16);
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

  @override
  void dispose() {
    for (var element in foundUsers) {
      controllers[element['doc_id']]!.dispose();
    }

    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text('RX Target'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
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
          //Expanded(child: itemSearchTextFormWidget()),
          itemListViewBuilderWIdget(),
          const SizedBox(
            height: 5,
          ),
          // addtoCartButtonWidget(context)
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
                      value, widget.syncDoctorList, 'doc_name');
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                 // fillColor: Colors.white,
                  fillColor: Colors.teal.shade50,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: 'Search doctor by name....',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            foundUsers = AllServices().searchDynamicMethod(
                                '', widget.syncDoctorList, 'doc_name');
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Color.fromARGB(255, 239, 242, 239),
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
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
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
                                        'assets/images/doctor.png',
                                      ), 
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      // crossAxisAlignment: ,
                                      children: [
                                        Text(
                                          "${foundUsers[index]['doc_name']}(${foundUsers[index]['doc_id']})",
                                          style: const TextStyle(
                                              color: Color.fromARGB(255, 8, 18, 20),
                                              fontSize: 15),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${foundUsers[index]['area_name']}${foundUsers[index]['area_id']}|${foundUsers[index]['address']} ',
                                              style: const TextStyle(
                                                  color: Color.fromARGB(255, 86, 84, 84),
                                                  fontSize: 12),
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
                          Expanded(
                            flex: 2,
                            child: Column(
                              
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Card(
                                   
                                    child: Container(
                                      
                                      color:
                                          const Color.fromARGB(255, 138, 201, 149)
                                              .withOpacity(.3),
                                      width: 60,
                                      child: TextFormField(
                                        textDirection: TextDirection.ltr,
                                       
                                        textAlign: TextAlign.center,
                                        controller: controllers[foundUsers[index]
                                            ['doc_id']],
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                        ),
                                        onChanged: (value) {
                                        // itemCount(value, index);
                                        // Thats Added for Save
                                        if (value.isNotEmpty &&
                                            value.trim() != '') {
                                          var temp = DcrDataModel(
                                              docName: foundUsers[index]
                                                  ['doc_name'],
                                              docId: foundUsers[index]
                                                  ['doc_id'],
                                              areaId: foundUsers[index]
                                                  ['area_id'],
                                              areaName: foundUsers[index]
                                                  ['area_name'],
                                              address: foundUsers[index]
                                                  ['address'],
                                              dcrGspList: [],
                                              visitedWith: '',
                                              notes: '',
                                              rxTargetValue: controllers[
                                                      foundUsers[index]
                                                          ['doc_id']]!
                                                  .text);
                                          dcrRxTargetValueInputedList
                                              .removeWhere((element) =>
                                                  element.docId ==
                                                  foundUsers[index]['doc_id']);

                                          dcrRxTargetValueInputedList.add(temp);
                                        } else {
                                          dcrRxTargetValueInputedList
                                              .removeWhere((element) =>
                                                  element.docId ==
                                                  foundUsers[index]['doc_id']);
                                        }
                                      },
                                      ),
                                      
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(color: Colors.grey,
                      height: 0.7,)
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
