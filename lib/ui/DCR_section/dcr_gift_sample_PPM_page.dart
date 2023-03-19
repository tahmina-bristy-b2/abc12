import 'dart:convert';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_discussionData.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_gitfData.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_ppmData.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_sampleData.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DcrGiftSamplePpmPage extends StatefulWidget {
  final int dcrKey;
  final int uniqueId;
  final String ck;
  final String docName;
  final String docId;
  final String areaName;
  final String areaId;
  final String address;
  final List<DcrGSPDataModel> draftOrderItem;
  const DcrGiftSamplePpmPage({
    Key? key,
    required this.address,
    required this.areaId,
    required this.ck,
    required this.dcrKey,
    required this.uniqueId,
    required this.docName,
    required this.docId,
    required this.areaName,
    required this.draftOrderItem,
  }) : super(key: key);

  @override
  State<DcrGiftSamplePpmPage> createState() => _DcrGiftSamplePpmPageState();
}

class _DcrGiftSamplePpmPageState extends State<DcrGiftSamplePpmPage> {
  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  List<DcrGSPDataModel> addedDcrGSPList = [];

  List addedDcrsample = [];
  List addedDcrPpm = [];

  Box? box;

  int _currentSelected = 2;

  List doctorGiftlist = [];
  List doctorSamplelist = [];
  List doctorPpmlist = [];
  List doctorDiscussionlist = [];
  List<String> dcrVisitedWithList = [];
  int dropDownNumber = 0;
  String noteText = '';

  String? cid = '';
  String? userPassword = '';
  String itemString = '';
  String userName = '';
  String startTime = '';
  String endTime = '';
  List visitedWith = [];
  double? latitude = 0.0;
  double? longitude = 0.0;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  String? dropdownVisitWithValue = '_';

  bool _isLoading = true;
  bool dcrDiscussion = true;
  bool firstValue = false;
  String dcrString = '';
  String newString = '';
  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    // dcr_visitedWithList.clear();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        startTime = prefs.getString("startTime") ?? '';
        endTime = prefs.getString("endTime") ?? '';
        cid = prefs.getString("CID");
        userPassword = prefs.getString("PASSWORD");
        userName = prefs.getString("userName")!;
        latitude = prefs.getDouble("latitude");
        longitude = prefs.getDouble("longitude");
        deviceId = prefs.getString("deviceId");
        deviceBrand = prefs.getString("deviceBrand");
        deviceModel = prefs.getString("deviceModel");
        dcrDiscussion = prefs.getBool("dcr_discussion") ?? false;
        dcrVisitedWithList = prefs.getStringList("dcr_visit_with_list")!;

        dropdownVisitWithValue = dcrVisitedWithList.first;
      });
    });
    addedDcrGSPList = widget.draftOrderItem;
    setState(() {});
    if (widget.ck != '') {
      calculatingTotalitemString();
    } else {
      return;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    datefieldController.dispose();
    timefieldController.dispose();
    paymentfieldController.dispose();
    noteController.dispose();

    super.dispose();
  }

  initialValue(String val) {
    return TextEditingController(text: val);
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
                if (widget.ck != '') {
                  final uniqueKey = widget.dcrKey;
                  deleteSingleGSPItem(uniqueKey, index);

                  setState(() {});
                } else {
                  addedDcrGSPList.removeAt(index);
                  setState(() {});
                }
                // print('Confirmed');
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

  deleteSingleGSPItem(int rxDcrUniqueKey, int index) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == rxDcrUniqueKey) desiredKey = key;
    });
    box.delete(desiredKey);
    addedDcrGSPList.removeAt(index);

    setState(() {});
  }

  _onItemTapped(int index) async {
    if (index == 0) {
      putAddedDcrGSPData();
      Navigator.pop(context);
      setState(() {
        _currentSelected = index;
      });
    } else {}

    if (index == 2) {
      setState(() {
        _isLoading = false;
      });
      bool result = await InternetConnectionChecker().hasConnection;
      if (result == true) {
        orderGSPSubmit();
      } else {
        AllServices()
            .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
        setState(() {
          _isLoading = true;
        });
        // print(InternetConnectionChecker().lastTryResults);
      }

      setState(() {
        _currentSelected = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return _isLoading
        ? Scaffold(
            key: _drawerKey,
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 138, 201, 149),

              // flexibleSpace: Container(
              //   decoration: const BoxDecoration(
              //     // LinearGradient
              //     gradient: LinearGradient(
              //       // colors for gradient
              //       colors: [
              //         Color(0xff70BA85),
              //         Color(0xff56CCF2),
              //       ],
              //     ),
              //   ),
              // ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              title: const Text(
                'Visit Doctor',
                style: TextStyle(
                    color: Color.fromARGB(255, 27, 56, 34),
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              ),
              centerTitle: true,
            ),
            // endDrawer: Drawer(

            //   child: ListView(

            //     padding: EdgeInsets.zero,
            //     children: [
            //       const DrawerHeader(
            //         decoration: BoxDecoration(
            //           color: Colors.blueGrey,
            //         ),
            //         child: Text('Drawer Header'),
            //       ),
            //       ListTile(
            //         leading:
            //             const Icon(Icons.sync_outlined, color: Colors.black),
            //         title: const Text('Sync Data'),
            //         onTap: () {},
            //       ),
            //       ListTile(
            //         leading: const Icon(Icons.home, color: Colors.black),
            //         title: const Text('Change password'),
            //         onTap: () {
            //           // Update the state of the app.
            //         },
            //       ),
            //       ListTile(
            //         leading: const Icon(Icons.logout, color: Colors.black),
            //         title: const Text('Logout'),
            //         onTap: () {
            //           // Navigator.pushReplacement(context,
            //           //     MaterialPageRoute(builder: (_) => LoginScreen()));
            //         },
            //       ),
            //     ],
            //   ),
            // ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Card(
                      elevation: 5,
                      child: Container(
                        width: screenWidth,
                        height: screenHeight / 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xff56CCF2).withOpacity(.3),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 6,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "  ${widget.docName}",
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 2, 3, 2),
                                        fontSize: 16,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        "   ${widget.areaName} (${widget.areaId}), ${widget.address}",
                                        style: const TextStyle(
                                            color:
                                                Color.fromARGB(255, 5, 10, 6),
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // const Spacer(),
                              // const SizedBox(
                              //   width: 30,
                              // ),
                              // dcr_visitedWithList.isNotEmpty
                              //     ? Expanded(
                              //         flex: 3,
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.start,
                              //           children: [
                              //             const SizedBox(
                              //               height: 10,
                              //             ),
                              //             const Text(
                              //               "Visited With :",
                              //               style: TextStyle(
                              //                 color:
                              //                     Color.fromARGB(255, 3, 7, 4),
                              //                 fontSize: 16,
                              //               ),
                              //             ),
                              //             const SizedBox(
                              //               height: 10,
                              //             ),
                              //             Expanded(
                              //               child: InkWell(
                              //                 onTap: () {
                              //                   showDialog(
                              //                       context: context,
                              //                       builder:
                              //                           (BuildContext context) {
                              //                         return AlertDialog(
                              //                           content: Container(
                              //                             height: 300,
                              //                             child: GFMultiSelect(
                              //                               items:
                              //                                   dcr_visitedWithList,
                              //                               onSelect: (value) {
                              //                                 dcrString = '';
                              //                                 if (value
                              //                                     .isNotEmpty) {
                              //                                   for (var e
                              //                                       in value) {
                              //                                     if (dcrString ==
                              //                                         '') {
                              //                                       dcrString =
                              //                                           dcr_visitedWithList[
                              //                                               e];
                              //                                     } else {
                              //                                       dcrString += '|' +
                              //                                           dcr_visitedWithList[
                              //                                               e];
                              //                                     }
                              //                                   }
                              //                                 }

                              //                                 print(
                              //                                     'selected $value ');
                              //                                 print(dcrString);
                              //                               },
                              //                               // submitButton:
                              //                               //     submButton(),
                              //                               cancelButton:
                              //                                   cancalButton(),
                              //                               dropdownTitleTileText:
                              //                                   '',
                              //                               // dropdownTitleTileColor: Colors.grey[200],
                              //                               dropdownTitleTileMargin:
                              //                                   EdgeInsets.zero,
                              //                               dropdownTitleTilePadding:
                              //                                   EdgeInsets
                              //                                       .fromLTRB(
                              //                                           10,
                              //                                           0,
                              //                                           10,
                              //                                           0),
                              //                               dropdownUnderlineBorder:
                              //                                   const BorderSide(
                              //                                       color: Colors
                              //                                           .transparent,
                              //                                       width: 2),
                              //                               // dropdownTitleTileBorder:
                              //                               //     Border.all(color: Colors.grey, width: 1),
                              //                               // dropdownTitleTileBorderRadius: BorderRadius.circular(5),
                              //                               expandedIcon:
                              //                                   const Icon(
                              //                                 Icons
                              //                                     .keyboard_arrow_down,
                              //                                 color: Colors
                              //                                     .black54,
                              //                               ),
                              //                               collapsedIcon:
                              //                                   const Icon(
                              //                                 Icons
                              //                                     .keyboard_arrow_up,
                              //                                 color: Colors
                              //                                     .black54,
                              //                               ),

                              //                               // dropdownTitleTileTextStyle: const TextStyle(
                              //                               //     fontSize: 14, color: Colors.black54),
                              //                               padding:
                              //                                   const EdgeInsets
                              //                                       .all(0),
                              //                               margin:
                              //                                   const EdgeInsets
                              //                                       .all(0),
                              //                               type: GFCheckboxType
                              //                                   .basic,
                              //                               activeBgColor: Colors
                              //                                   .green
                              //                                   .withOpacity(
                              //                                       0.5),
                              //                               inactiveBorderColor:
                              //                                   Colors.grey,
                              //                             ),
                              //                           ),
                              //                         );
                              //                       });
                              //                   print("ok");
                              //                 },
                              //                 child: dcrString == null
                              //                     ? Text("Select")
                              //                     : Text(dcrString),
                              //               ),
                              //             ),

                              //             //=================================================Experiment
                              //             // Expanded(
                              //             //   // flex: 2,
                              //             //   child: DropdownButton(
                              //             //     isExpanded: true,
                              //             //     dropdownColor:
                              //             //         const Color.fromARGB(
                              //             //             255, 187, 234, 250),
                              //             //     // Initial Value
                              //             //     value: dropdownVisitWithValue,

                              //             //     // Down Arrow Icon
                              //             //     icon: const Icon(
                              //             //       Icons.keyboard_arrow_down,
                              //             //       color: Color.fromARGB(
                              //             //           255, 27, 56, 34),
                              //             //     ),

                              //             //     // Array list of items

                              //             //     items: dcr_visitedWithList
                              //             //         .map((item) {
                              //             //       return DropdownMenuItem(
                              //             //         value: item,
                              //             //         child: Row(
                              //             //           children: [
                              //             //             StatefulBuilder(builder:
                              //             //                 (BuildContext context,
                              //             //                     StateSetter
                              //             //                         stateSetter) {
                              //             //               return Checkbox(
                              //             //                 onChanged: (value) {
                              //             //                   stateSetter(() {
                              //             //                     _firstValue =
                              //             //                         value!;
                              //             //                     print(value);
                              //             //                   });
                              //             //                 },
                              //             //                 value: _firstValue,
                              //             //               );
                              //             //             }),
                              //             //             Text(
                              //             //               item,
                              //             //               style: const TextStyle(
                              //             //                 color: Color.fromARGB(
                              //             //                     255, 9, 19, 11),
                              //             //                 fontSize: 16,
                              //             //               ),
                              //             //             ),
                              //             //           ],
                              //             //         ),
                              //             //       );
                              //             //     }).toList(),

                              //             //     onChanged: (String? newValue) {
                              //             //       setState(() {
                              //             //         dropdownVisitWithValue =
                              //             //             newValue!;
                              //             //         print(dropdownVisitWithValue);
                              //             //       });
                              //             //     },
                              //             //   ),
                              //             // ),
                              //       ],
                              //     ),
                              //   )
                              // : const Text("")
                            ],
                          ),
                        ),
                      ),
                    ),
                    dcrVisitedWithList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                            child: Row(
                              children: [
                                const Expanded(
                                    child: Text(
                                  "Visited With",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                )),
                                Expanded(
                                  child: GFMultiSelect(
                                    items: dcrVisitedWithList,
                                    onSelect: (value) {
                                      dcrString = '';
                                      if (value.isNotEmpty) {
                                        for (var e in value) {
                                          if (dcrString == '') {
                                            dcrString = dcrVisitedWithList[e];
                                          } else {
                                            dcrString +=
                                                '|${dcrVisitedWithList[e]}';
                                          }
                                        }
                                      }
                                    },
                                    cancelButton: cancalButton(),
                                    dropdownTitleTileText: '',
                                    // dropdownTitleTileColor: Colors.grey[200],
                                    dropdownTitleTileMargin: EdgeInsets.zero,
                                    dropdownTitleTilePadding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    dropdownUnderlineBorder: const BorderSide(
                                        color: Colors.transparent, width: 2),
                                    // dropdownTitleTileBorder:
                                    //     Border.all(color: Colors.grey, width: 1),
                                    // dropdownTitleTileBorderRadius: BorderRadius.circular(5),
                                    expandedIcon: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.black54,
                                    ),
                                    collapsedIcon: const Icon(
                                      Icons.keyboard_arrow_up,
                                      color: Colors.black54,
                                    ),
                                    // submitButton: Text('OK'),
                                    // dropdownTitleTileTextStyle: const TextStyle(
                                    //     fontSize: 14, color: Colors.black54),
                                    padding: const EdgeInsets.all(0),
                                    margin: const EdgeInsets.all(0),
                                    type: GFCheckboxType.basic,
                                    activeBgColor:
                                        Colors.green.withOpacity(0.5),
                                    inactiveBorderColor: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const Text(""),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: SizedBox(
                        height: 55,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color.fromARGB(255, 138, 201, 149)
                                .withOpacity(.5),
                          ),
                          // elevation: 6,

                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.deny(
                                  RegExp(r'[@#%^!~\\/:;]'))
                            ],
                            style: const TextStyle(
                                fontSize: 18, color: Colors.black),
                            controller: noteController,
                            focusNode: FocusNode(),
                            autofocus: false,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none),
                                labelText: '  Notes...',
                                labelStyle: TextStyle(color: Colors.blueGrey)),
                            onChanged: (value) {
                              noteText = (noteController.text)
                                  .replaceAll(RegExp('[^A-Za-z0-9]'), " ");
                            },
                          ),
                        ),
                      ),
                    ),
                    // Doctor Gift section..................................
                    SizedBox(
                      height: screenHeight / 2.2,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: addedDcrGSPList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext itemBuilder, index) {
                          return Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 10,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    addedDcrGSPList[index]
                                                        .giftName,
                                                    style: const TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 9, 38, 61),
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                                // Text(
                                                //   '(${addedDcrGSPList[index].giftType})',
                                                //   style: const TextStyle(
                                                //       fontSize: 16),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              _showMyDialog(index);
                                            },
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          addedDcrGSPList[index].giftType !=
                                                  "Discussion"
                                              ? Row(
                                                  children: [
                                                    const Text(
                                                      'Qt:  ',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color.fromARGB(
                                                              255, 9, 38, 61)),
                                                    ),
                                                    Text(
                                                      addedDcrGSPList[index]
                                                          .quantity
                                                          .toString(),
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255, 9, 38, 61),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : const Text(""),
                                          const Spacer(),
                                          Row(
                                            children: [
                                              Text(
                                                '(${addedDcrGSPList[index].giftType})',
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 9, 38, 61),
                                                  fontSize: 16,
                                                ),
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
                          );
                        },
                      ),
                    ),

                    // const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            getDcrGitData();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 16,
                            width: screenWidth / 5.7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 138, 201, 149),
                            ),
                            child: const Center(
                              child: FittedBox(
                                child: Text(
                                  'Gift',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 8, 15, 9),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            getDcrSampleData();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 16,
                            width: screenWidth / 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color.fromARGB(255, 138, 201, 149),
                            ),
                            child: const Center(
                              child: Text(
                                'Sample',
                                style: TextStyle(
                                    color: Color.fromARGB(255, 7, 14, 8),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            getDcrPpmData();
                          },
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(screenWidth / 4.8,
                                MediaQuery.of(context).size.height / 16),
                            backgroundColor:
                                const Color.fromARGB(255, 138, 201, 149),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10), // <-- Radius
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'PPM',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 9, 19, 11),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        dcrDiscussion == true
                            ? ElevatedButton(
                                onPressed: () {
                                  getDcrDiscussionData();
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(screenWidth / 4,
                                      MediaQuery.of(context).size.height / 16),
                                  backgroundColor:
                                      const Color.fromARGB(255, 138, 201, 149),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10), // <-- Radius
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Discus.',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 7, 14, 8),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16),
                                  ),
                                ),
                              )
                            : Container()
                      ],
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
          )
        : Container(
            padding: const EdgeInsets.all(100),
            color: Colors.white,
            child: const Center(child: CircularProgressIndicator()));
  }

  // dcr gift section...........................
  getDcrGitData() async {
    List doctorGiftlist =
        await AllServices().getSyncSavedData('dcrGiftListData');

    if (doctorGiftlist.isNotEmpty) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DcrGiftDataPage(
            uniqueId: widget.uniqueId,
            doctorGiftlist: doctorGiftlist,
            tempList: addedDcrGSPList,
            tempListFunc: (value) {
              addedDcrGSPList = value;
              calculatingTotalitemString();

              setState(() {});
            },
          ),
        ),
      );
    } else {
      AllServices()
          .toastMessage('Dcr Gift List Empty!', Colors.red, Colors.white, 16);
    }
  }

  // doctor Sample section.......................................................

  getDcrSampleData() async {
    List doctorSamplelist =
        await AllServices().getSyncSavedData('dcrSampleListData');

    if (doctorSamplelist.isNotEmpty) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DcrSampleDataPage(
            uniqueId: widget.uniqueId,
            doctorSamplelist: doctorSamplelist,
            tempList: addedDcrGSPList,
            tempListFunc: (value) {
              addedDcrGSPList = value;
              calculatingTotalitemString();

              setState(() {});
            },
          ),
        ),
      );
    } else {
      AllServices()
          .toastMessage('Dcr Sample List Empty!', Colors.red, Colors.white, 16);
    }
  }

  // Doctor PPM section..........................................

  Future ppmOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrPpmListData');
  }

  getDcrPpmData() async {
    List doctorPpmlist = await AllServices().getSyncSavedData('dcrPpmListData');

    if (doctorPpmlist.isNotEmpty) {
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DcrPpmDataPage(
            uniqueId: widget.uniqueId,
            doctorPpmlist: doctorPpmlist,
            tempList: addedDcrGSPList,
            tempListFunc: (value) {
              addedDcrGSPList = value;
              calculatingTotalitemString();

              setState(() {});
            },
          ),
        ),
      );
    } else {
      AllServices()
          .toastMessage('Dcr PPM List Empty!', Colors.red, Colors.white, 16);
    }
  }
//=====================Discussion ====================================================
//=========================================================================================

  Future discussionOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('syncItemData');
  }

  getDcrDiscussionData() async {
    discussionOpenBox();

    var mymap = box!.toMap().values.toList();

    if (mymap.isEmpty) {
      Fluttertoast.showToast(
          msg: "No Discussion Found", backgroundColor: Colors.red);
      doctorDiscussionlist.add('empty');
    } else {
      doctorDiscussionlist = mymap;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DcrDiscussionPage(
            uniqueId: widget.uniqueId,
            doctorDiscussionlist: doctorDiscussionlist,
            tempList: addedDcrGSPList,
            tempListFunc: (value) {
              addedDcrGSPList = value;
              calculatingTotalitemString();

              setState(() {});
            },
          ),
        ),
      );
    }
  }

  calculatingTotalitemString() {
    itemString = '';

    if (addedDcrGSPList.isNotEmpty) {
      for (var element in addedDcrGSPList) {
        if (itemString == '') {
          itemString =
              '${element.giftId}|${element.quantity}|${element.giftType}';
        } else {
          itemString +=
              '||${element.giftId}|${element.quantity}|${element.giftType}';
        }

        setState(() {});
      }
    } else {}
  }

  cancalButton() {
    dcrString = "";
  }

  submButton() {
    if (dcrString.contains("|")) {
      newString = dcrString.replaceAll(",", "|");
      print(newString);
    }
    Navigator.pop(context);
  }

  // Saved Added Gift, Sample, PPM to Hive

  // Save Gift data to hive
  Future addedSampleOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('addedDcrSampletData');
  }

  Future putAddedDcrGSPData() async {
    List<DcrDataModel> doctorList = [];
    if (widget.ck != '') {
      for (int i = 0; i <= addedDcrGSPList.length; i++) {
        deleteDcrGSPItem(widget.dcrKey);

        setState(() {});
      }

      setState(() {});

      Navigator.pop(context);

      for (var d in addedDcrGSPList) {
        final box = Boxes.selectedDcrGSP();

        box.add(d);
      }
    } else {
      var doctor = DcrDataModel(
          uiqueKey: widget.uniqueId,
          docName: widget.docName,
          docId: widget.docId,
          areaId: widget.areaId,
          areaName: widget.areaName,
          address: 'address');
      doctorList.add(doctor);

      for (var dcr in doctorList) {
        final box = Boxes.dcrUsers();
        box.add(dcr);
      }

      for (var d in addedDcrGSPList) {
        final box = Boxes.selectedDcrGSP();

        box.add(d);
      }
    }
  }

  deleteDcrGSPItem(int id) {
    final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

    final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.dcrKey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  deleteDoctor(int id) {
    final box = Hive.box<DcrDataModel>("selectedDcr");

    final Map<dynamic, DcrDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == widget.dcrKey) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  Future<dynamic> orderGSPSubmit() async {
    final gspBox = Boxes.selectedDcrGSP();
    final dcrBox = Boxes.dcrUsers();

    if (itemString != '') {
      Map<String, dynamic> dcrResponsedata = await DcrRepositories()
          .dcrGspSubmit(
              dmpathData!.submitUrl,
              cid!,
              userId,
              userPassword!,
              deviceId!,
              widget.docId,
              widget.areaId,
              dcrString,
              latitude!,
              longitude!,
              itemString,
              noteText);

      if (dcrResponsedata['status'] == "Success") {
        if (dcrBox.isNotEmpty) {
          Boxes.deleteItemFromBoxTable(gspBox, widget.dcrKey);
          Boxes.deleteItemFromBoxTable(dcrBox, widget.dcrKey);
        }

        if (!mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      userName: userName,
                      userId: userInfo!.userId,
                      userPassword: userPassword ?? '',
                    )),
            (Route<dynamic> route) => false);

        AllServices().toastMessage(
            "DCR Submitted\n${dcrResponsedata['ret_str']}",
            Colors.green.shade900,
            Colors.white,
            16);
      } else {
        setState(() {
          _isLoading = true;
        });
        AllServices()
            .toastMessage("DCR Submit Failed", Colors.red, Colors.white, 16);
      }
      // try {
      //   final http.Response response = await http.post(
      //     Uri.parse('${dmpathData!.submitUrl}api_dcr_submit/submit_data'),
      //     headers: <String, String>{
      //       'Content-Type': 'application/json; charset=UTF-8'
      //     },
      //     body: jsonEncode(
      //       <String, dynamic>{
      //         'cid': cid,
      //         'user_id': userInfo!.userId,
      //         'user_pass': userPassword,
      //         'device_id': deviceId,
      //         'doc_id': widget.docId,
      //         'doc_area_id': widget.areaId,
      //         'visit_with': dcrString,
      //         "latitude": latitude,
      //         'longitude': longitude,
      //         "item_list_gsp": itemString,
      //         "remarks": noteText,
      //       },
      //     ),
      //   );
      //   var orderInfo = json.decode(response.body);
      //   String status = orderInfo['status'];
      //   String ret_str = orderInfo['ret_str'];

      //   if (status == "Success") {
      //     for (int i = 0; i <= addedDcrGSPList.length; i++) {
      //       deleteDcrGSPItem(widget.dcrKey);

      //       setState(() {});
      //     }

      //     deleteDoctor(widget.dcrKey);

      //     setState(() {});
      //     if (!mounted) return;

      //     Navigator.of(context).pushAndRemoveUntil(
      //         MaterialPageRoute(
      //             builder: (context) => MyHomePage(
      //                   userName: userName,
      //                   userId: userInfo!.userId,
      //                   userPassword: userPassword ?? '',
      //                 )),
      //         (Route<dynamic> route) => false);

      //     AllServices().toastMessage("DCR Submitted\n$ret_str",
      //         Colors.green.shade900, Colors.white, 16);
      //   } else {
      //     setState(() {
      //       _isLoading = true;
      //     });
      //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      //         content: Text('Submit Failed'), backgroundColor: Colors.red));
      //   }
      // } on Exception catch (e) {
      //   print(e);
      //   setState(() {
      //     _isLoading = true;
      //   });
      //   // throw Exception("Error on server");
      // }
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
