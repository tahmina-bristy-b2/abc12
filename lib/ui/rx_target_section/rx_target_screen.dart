import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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
  final dcrRxTagetSavedBox = Boxes.dcrUsers();
  List<DcrDataModel> dcrRxTargetValueInputedList = [];

  int _currentSelected = 2;
  List foundUsers = [];
  var orderamount = 0.0;
  var neworderamount = 0.0;
  int amount = 0;
  bool isInList = false;
  var total = 0.0;
  bool incLen = true;
  bool promo_flag = false;

  @override
  void initState() {
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    foundUsers = widget.syncDoctorList;
    for (var element in foundUsers) {
      controllers[element['doc_id']] = TextEditingController();
    }
    // for (var element in widget.tempList) {
    //   controllers.forEach((key, value) {
    //     if (key == element.item_id) {
    //       value.text = element.quantity.toString();
    //     }
    //   });
    // }

    // for (var element in widget.tempList) {
    //   total = (element.tp + element.vat) * element.quantity;

    //   orderamount = orderamount + total;
    // }

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

    // if (index == 2) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    //   bool result = await InternetConnectionChecker().hasConnection;
    //   if (result == true) {
    //     // dcrGSPSubmit();
    //   } else {
    //     AllServices()
    //         .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    //     setState(() {
    //       _isLoading = true;
    //     });
    //     // print(InternetConnectionChecker().lastTryResults);
    //   }

    //   setState(() {
    //     _currentSelected = index;
    //   });
    // }
  }

  Future toSaveRxTargetValue() async {
    // dcrRxTagetSavedBox.put('dcrRxTargetValue', dcrRxTargetValueInputedList);
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
          //  Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: SizedBox(
          //               height: 50,
          //               child: TextFormField(
          //                 onChanged: (value) {
          //                   // setState(() {
          //                   //   foundUsers = AllServices().searchDynamicMethod(
          //                   //       value, magicDcrDataList, "doc_name");
          //                   // });

          //                   setState(() {
          //                     foundUsers = AllServices().searchDoctor(
          //                         value,
          //                         widget.syncDoctorList,
          //                         "doc_name",
          //                         "area_name",
          //                         "doc_id");
          //                   });
          //                 },
          //                 controller: searchController,
          //                 decoration: InputDecoration(
          //                   border: OutlineInputBorder(
          //                       borderRadius: BorderRadius.circular(10)),
          //                   hintText: 'Search Magic Doctor by name/id/area...',
          //                   suffixIcon: searchController.text.isEmpty &&
          //                           searchController.text == ''
          //                       ? const Icon(Icons.search)
          //                       : IconButton(
          //                           onPressed: () {
          //                             searchController.clear();
          //                             setState(() {
          //                               foundUsers = AllServices().searchDoctor(
          //                                   "",
          //                                   widget.syncDoctorList,
          //                                   "doc_name",
          //                                   "area_name",
          //                                   "doc_id");
          //                             });

          //                             // setState(() {
          //                             //   foundUsers = AllServices()
          //                             //       .searchDynamicMethod("",
          //                             //           magicDcrDataList, "doc_name");
          //                             // });
          //                           },
          //                           icon: const Icon(
          //                             Icons.clear,
          //                             color: Colors.black,
          //                             // size: 28,
          //                           ),
          //                         ),
          //                 ),
          //               ),
          //             ),
          //           ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  foundUsers = AllServices().searchDynamicMethod(
                      value, widget.syncDoctorList, 'item_name');
                  setState(() {});
                },
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.teal.shade50,
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  labelText: 'Doctor Search',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            foundUsers = AllServices().searchDynamicMethod(
                                '', widget.syncDoctorList, 'item_name');
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
                  return Card(
                    // color: Colors.yellow.shade50,
                    // elevation: 2,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                          color: Color.fromARGB(108, 255, 255, 255), width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // crossAxisAlignment: ,
                              children: [
                                Text(
                                  foundUsers[index]['doc_id'],
                                  style: const TextStyle(
                                      color: Color.fromARGB(255, 8, 18, 20),
                                      fontSize: 14),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${foundUsers[index]['area_name']}${foundUsers[index]['area_id']}|${foundUsers[index]['address']} ',
                                      style: const TextStyle(
                                          color: Color.fromARGB(255, 8, 18, 20),
                                          fontSize: 12),
                                    ),
                                    // Container(
                                    //   color:
                                    //       const Color.fromARGB(255, 4, 60, 105),
                                    //   child: Text(
                                    //     'Stock: ${foundUsers[index]['stock']}',
                                    //     style: const TextStyle(
                                    //         color: Colors.white, fontSize: 14),
                                    //   ),
                                    // )
                                  ],
                                ),
                                // userLoginInfo!.promoFlag &&
                                //         foundUsers[index]['promo'] != ''
                                //     ? Card(
                                //         color: Colors.yellow,
                                //         child: Text(
                                //           foundUsers[index]['promo'],
                                //           style: const TextStyle(
                                //               color:
                                //                   // Colors.teal,
                                //                   Color.fromARGB(
                                //                       255, 238, 4, 4),
                                //               fontSize: 14),
                                //         ),
                                //       )
                                // ? Padding(
                                //     padding: const EdgeInsets.all(4.0),
                                //     child: AnimatedTextKit(
                                //       repeatForever: true,
                                //       animatedTexts: [
                                //         ColorizeAnimatedText(
                                //           foundUsers[index]['promo'],
                                //           textStyle: const TextStyle(
                                //               color: Color.fromARGB(
                                //                   255, 8, 18, 20),
                                //               fontSize: 15),
                                //           colors: [
                                //             const Color.fromARGB(
                                //                 255, 18, 137, 235),
                                //             Colors.red
                                //           ],
                                //         ),
                                //       ],
                                //     ),
                                //   )
                                // : Container(),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Card(
                                  // elevation: 1,
                                  child: Container(
                                    // height: 50,
                                    color:
                                        const Color.fromARGB(255, 138, 201, 149)
                                            .withOpacity(.3),
                                    width: 60,
                                    child: TextFormField(
                                      textDirection: TextDirection.ltr,
                                      // maxLength: 1000,
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
                                        if (value.isNotEmpty && value != '') {
                                          var temp = DcrDataModel(
                                              docName: foundUsers[index]
                                                  ['doc_name'],
                                              docId: foundUsers[index]
                                                  ['doc_id'],
                                              areaId: foundUsers[index]
                                                  ['doc_id'],
                                              areaName: foundUsers[index]
                                                  ['doc_id'],
                                              address: 'address',
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
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
