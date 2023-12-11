import 'dart:math';

import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/services/dcr/dcr_services.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:getwidget/getwidget.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_discussionData.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_gitfData.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_ppmData.dart';
import 'package:MREPORTING/ui/DCR_section/show_dcr_sampleData.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:math' as math;

class DcrGiftSamplePpmPage extends StatefulWidget {
  // final int dcrKey;
  // final int uniqueId;
  final bool isDraft;
  final String docName;
  final String docId;
  final String areaName;
  final String areaId;
  final String address;
  final List<DcrGSPDataModel> draftOrderItem;
  final String notes;
  final String visitedWith;
  final bool magic;
  final List? magicBrand;

  const DcrGiftSamplePpmPage(
      {Key? key,
      required this.address,
      required this.areaId,
      required this.isDraft,
      required this.docName,
      required this.docId,
      required this.areaName,
      required this.draftOrderItem,
      required this.notes,
      required this.visitedWith,
      required this.magic,
      this.magicBrand})
      : super(key: key);

  @override
  State<DcrGiftSamplePpmPage> createState() => _DcrGiftSamplePpmPageState();
}

class _DcrGiftSamplePpmPageState extends State<DcrGiftSamplePpmPage>
    with TickerProviderStateMixin {
  final TextEditingController datefieldController = TextEditingController();
  final TextEditingController timefieldController = TextEditingController();
  final TextEditingController paymentfieldController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
//  late ConfettiController _confettiController;
//  late AnimationController _animationController;
//  late Animation<double>_animation;

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  final gspBox = Boxes.selectedDcrGSP();
  final dcrBox = Boxes.dcrUsers();
  List magicBrandList = [];

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
  List<int> dcrVisitedWithIInt = [];
  // List<String> dcrTypeList = [];

  int dropDownNumber = 0;
  String noteText = '';

  String cid = '';
  String userPassword = '';
  String itemString = '';
  String userName = '';
  String startTime = '';
  String endTime = '';
  double latitude = 0.0;
  double longitude = 0.0;
  String deviceId = '';
  String deviceBrand = '';
  String deviceModel = '';
  String dropdownVisitWithValue = '_';

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
    getMagicBrandList();

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        startTime = prefs.getString("startTime") ?? '';
        endTime = prefs.getString("endTime") ?? '';
        cid = prefs.getString("CID") ?? '';
        userPassword = prefs.getString("PASSWORD") ?? '';
        latitude = prefs.getDouble("latitude") ?? 0.0;
        longitude = prefs.getDouble("longitude") ?? 0.0;
        deviceId = prefs.getString("deviceId") ?? '';
        deviceBrand = prefs.getString("deviceBrand") ?? '';
        deviceModel = prefs.getString("deviceModel") ?? '';
      });
    });
    userName = userInfo!.userName;
    dcrDiscussion = userInfo!.dcrDiscussion;
    dcrVisitedWithList = userInfo!.dcrVisitWithList;
    dropdownVisitWithValue = dcrVisitedWithList.first;
    // if (widget.magic == true) {
    //   _confettiController =
    //       ConfettiController(duration: const Duration(milliseconds: 800));
    //   _confettiController.play();
    //   _animationController = AnimationController(
    //       vsync: this, duration: const Duration(seconds: 5));
    //   _animation =
    //       CurvedAnimation(parent: _animationController, curve: Curves.easeIn);
    //   _animationController.forward();
    // }

    if (widget.isDraft) {
      addedDcrGSPList = widget.draftOrderItem;
      noteController.text = widget.notes;
      noteText = widget.notes;
      dcrString = widget.visitedWith;

      List dcrStringList = dcrString.split("|");

      for (int i = 0; i < dcrVisitedWithList.length; i++) {
        for (var e in dcrStringList) {
          if (dcrVisitedWithList[i] == e) {
            dcrVisitedWithIInt.add(i);
          }
        }
      }

      itemString = DcrServices().calculatingGspItemString(addedDcrGSPList);

      setState(() {});
    } else {
      return;
    }
  }

  void getMagicBrandList() async {
    magicBrandList = await AllServices().getSyncSavedData('DcrMagicBrand');
    setState(() {});
  }

  @override
  void dispose() {
    _quantityController.dispose();
    datefieldController.dispose();
    timefieldController.dispose();
    paymentfieldController.dispose();
    noteController.dispose();
    // if (widget.magic) {
    //   _confettiController.dispose();
    //   _animationController.dispose();
    // }

    super.dispose();
  }

  initialValue(String val) {
    return TextEditingController(text: val);
  }

  _onItemTapped(int index) async {
    if (index == 0) {
      putAddedDcrGSPData();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userId: userInfo!.userId,
                    userName: userName,
                    userPassword: userPassword,
                  )),
          (route) => false);
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
        dcrGSPSubmit();
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
            resizeToAvoidBottomInset: false,
            key: _drawerKey,
            appBar: AppBar(
              // backgroundColor: const Color.fromARGB(255, 138, 201, 149),
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
                  // fontWeight: FontWeight.w500,
                  // fontSize: 20,
                ),
              ),
              centerTitle: true,
              actions: [
                // Container(
                //   margin:
                //       const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                //   // height: 10,
                //   // width: 60,
                //   // decoration: const BoxDecoration(
                //   //   color: Colors.white,
                //   //   borderRadius: BorderRadius.all(
                //   //     Radius.circular(10),
                //   //   ),
                //   // ),
                //   child: Image.asset(
                //     'assets/icons/brand_3.png',
                //     // height: 40,
                //     width: 35,
                //   ),
                // ),
                widget.magic
                    ? InkWell(
                        onTap: () {
                          magicDoctorBrandShow(context);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 13),
                          // height: 10,
                          // width: 60,
                          // decoration: const BoxDecoration(
                          //   color: Colors.white,
                          //   borderRadius: BorderRadius.all(
                          //     Radius.circular(10),
                          //   ),
                          // ),
                          child: Image.asset(
                            'assets/icons/brand_2.png',
                            // height: 40,
                            width: 35,
                            // color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
              ],
            ),
            body: SafeArea(
                child: Column(
                  children: [
                    Card(
                      color: const Color(0xff56CCF2).withOpacity(.3),
                      // color: Color.fromARGB(255, 163, 92, 176),
                      // decoration: BoxDecoration(
                      //     borderRadius: BorderRadius.circular(10),
                      //     color: const Color(0xff56CCF2).withOpacity(.3),
                      //   ),
                      child: SizedBox(
                        width: screenWidth,
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.docName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    ),

                                    Text(
                                      "${widget.areaName} (${widget.areaId}), ${widget.address}",
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 12),
                                    ),
                                    // Text(
                                    //   "  ${widget.docName}",
                                    //   style: const TextStyle(
                                    //     color: Colors.black,
                                    //     fontSize: 16,
                                    //   ),
                                    // ),
                                    // Text(
                                    //   "   ${widget.areaName} (${widget.areaId}), ${widget.address}",
                                    //   style: const TextStyle(
                                    //       color: Colors.black, fontSize: 14),
                                    // ),
                                  ],
                                ),
                              ),
                              widget.magic == true
                                  ? Expanded(
                                    child: SizedBox(
                                                height:50,
                                                child: Image.asset(
                                                  'assets/images/m.png',
                                                  //color: Colors.deepOrange,
                                                )),
                                    //   child: InkWell(
                                    //     onTap: () {
                                    //    _confettiController.play();
                                    //    _animationController.reset();
                                    //    _animationController.forward();
                                    // },
                                    //     child: RotationTransition(
                                    //       turns: _animation,
                                    //       child: Transform(
                                    //         alignment: Alignment.center,
                                    //         transform: Matrix4.rotationZ(
                                    //             3.1415926535897932 / 4),
                                    //         child: SizedBox(
                                    //             height: 65,
                                    //             child: Image.asset(
                                    //               'assets/images/hat_picture.png',
                                    //               //color: Colors.deepOrange,
                                    //             )),
                                    //       ),
                                    //     ),
                                    //   ),
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ),
                    dcrVisitedWithList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              color: Colors.teal.shade100,
                              // height: 40,

                              child: Row(
                                children: [
                                  const Expanded(
                                      child: Text(
                                    "Visited With : ",
                                    // style: TextStyle(
                                    //   color: Colors.black,
                                    //   fontSize: 16,
                                    // ),
                                  )),
                                  Expanded(
                                    flex: 2,
                                    child: GFMultiSelect(
                                      initialSelectedItemsIndex:
                                          dcrVisitedWithIInt,
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
                                      dropdownTitleTileText: 'Select',
                                      dropdownTitleTileMargin: EdgeInsets.zero,
                                      dropdownTitleTilePadding:
                                          const EdgeInsets.fromLTRB(
                                              10, 0, 10, 0),
                                      dropdownUnderlineBorder: const BorderSide(
                                          color: Colors.transparent, width: 2),
                                      expandedIcon: const Icon(
                                        Icons.keyboard_arrow_down,
                                        color: Colors.teal,
                                      ),
                                      collapsedIcon: const Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.teal,
                                      ),
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
                            ),
                          )
                        : Container(),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
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
                          textInputAction: TextInputAction.done,
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
                    // Doctor Gift section..................................
                    Expanded(
                      child: SizedBox(
                        // height: screenHeight / 2.2,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: addedDcrGSPList.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (BuildContext itemBuilder, index) {
                            return Card(
                              // elevation: 15,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    color: Colors.white70, width: 1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 80,
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
                                                      // style: const TextStyle(
                                                      //     color: Color.fromARGB(
                                                      //         255, 9, 38, 61),
                                                      //     fontWeight:
                                                      //         FontWeight.w400,
                                                      //     fontSize: 16),
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
                                                        // style: TextStyle(
                                                        //     fontSize: 16,
                                                        //     color:
                                                        //         Color.fromARGB(
                                                        //             255,
                                                        //             9,
                                                        //             38,
                                                        //             61)),
                                                      ),
                                                      Text(
                                                        addedDcrGSPList[index]
                                                            .quantity
                                                            .toString(),
                                                        // style: const TextStyle(
                                                        //     color:
                                                        //         Color.fromARGB(
                                                        //             255,
                                                        //             9,
                                                        //             38,
                                                        //             61),
                                                        //     fontSize: 16,
                                                        //     fontWeight:
                                                        //         FontWeight
                                                        //             .bold),
                                                      ),
                                                    ],
                                                  )
                                                : const Text(""),
                                            const Spacer(),
                                            Row(
                                              children: [
                                                Text(
                                                  '(${addedDcrGSPList[index].giftType})',
                                                  // style: const TextStyle(
                                                  //   color: Color.fromARGB(
                                                  //       255, 9, 38, 61),
                                                  //   fontSize: 16,
                                                  // ),
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
                    ),

                    // const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // GestureDetector(
                        //   onTap: () async {
                        //     List doctorGiftlist = await AllServices()
                        //         .getSyncSavedData('dcrGiftListData');

                        //     if (!mounted) return;

                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => DcrGiftDataPage(
                        //           // uniqueId: widget.uniqueId,
                        //           doctorGiftlist: doctorGiftlist,
                        //           tempList: addedDcrGSPList,
                        //           tempListFunc: (value) {
                        //             addedDcrGSPList = value;
                        //             itemString = DcrServices()
                        //                 .calculatingGspItemString(
                        //                     addedDcrGSPList);

                        //             setState(() {});
                        //           },
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height / 16,
                        //     width: screenWidth / 5.7,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: const Color.fromARGB(255, 138, 201, 149),
                        //     ),
                        //     child: const Center(
                        //       child: FittedBox(
                        //         child: Text(
                        //           'Gift',
                        //           style: TextStyle(
                        //               color: Color.fromARGB(255, 8, 15, 9),
                        //               fontWeight: FontWeight.w500,
                        //               fontSize: 16),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        // GestureDetector(
                        //   onTap: () async {
                        //     List doctorSamplelist = await AllServices()
                        //         .getSyncSavedData('dcrSampleListData');

                        //     if (!mounted) return;

                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (_) => DcrSampleDataPage(
                        //           // uniqueId: widget.uniqueId,
                        //           doctorSamplelist: doctorSamplelist.isNotEmpty
                        //               ? doctorSamplelist
                        //               : [],
                        //           tempList: addedDcrGSPList,
                        //           tempListFunc: (value) {
                        //             addedDcrGSPList = value;
                        //             itemString = DcrServices()
                        //                 .calculatingGspItemString(
                        //                     addedDcrGSPList);

                        //             setState(() {});
                        //           },
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //   child: Container(
                        //     height: MediaQuery.of(context).size.height / 16,
                        //     width: screenWidth / 4,
                        //     decoration: BoxDecoration(
                        //       borderRadius: BorderRadius.circular(10),
                        //       color: const Color.fromARGB(255, 138, 201, 149),
                        //     ),
                        //     child: const Center(
                        //       child: Text(
                        //         'Sample',
                        //         style: TextStyle(
                        //             color: Color.fromARGB(255, 7, 14, 8),
                        //             fontWeight: FontWeight.w500,
                        //             fontSize: 16),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        ElevatedButton(
                          onPressed: () async {
                            List doctorGiftlist = await AllServices()
                                .getSyncSavedData('dcrGiftListData');

                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DcrGiftDataPage(
                                  // uniqueId: widget.uniqueId,
                                  doctorGiftlist: doctorGiftlist,
                                  tempList: addedDcrGSPList,
                                  tempListFunc: (value) {
                                    addedDcrGSPList = value;
                                    itemString = DcrServices()
                                        .calculatingGspItemString(
                                            addedDcrGSPList);

                                    setState(() {});
                                  },
                                ),
                              ),
                            );
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
                              'Gift',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 9, 19, 11),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            List doctorSamplelist = await AllServices()
                                .getSyncSavedData('dcrSampleListData');

                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DcrSampleDataPage(
                                  // uniqueId: widget.uniqueId,
                                  doctorSamplelist: doctorSamplelist.isNotEmpty
                                      ? doctorSamplelist
                                      : [],
                                  tempList: addedDcrGSPList,
                                  tempListFunc: (value) {
                                    addedDcrGSPList = value;
                                    itemString = DcrServices()
                                        .calculatingGspItemString(
                                            addedDcrGSPList);

                                    setState(() {});
                                  },
                                ),
                              ),
                            );
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
                              'Sample',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 9, 19, 11),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16),
                            ),
                          ),
                        ),

                        ElevatedButton(
                          onPressed: () async {
                            List doctorPpmlist = await AllServices()
                                .getSyncSavedData('dcrPpmListData');

                            if (!mounted) return;

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DcrPpmDataPage(
                                  doctorPpmlist: doctorPpmlist.isNotEmpty
                                      ? doctorPpmlist
                                      : [],
                                  tempList: addedDcrGSPList,
                                  tempListFunc: (value) {
                                    addedDcrGSPList = value;
                                    itemString = DcrServices()
                                        .calculatingGspItemString(
                                            addedDcrGSPList);

                                    setState(() {});
                                  },
                                ),
                              ),
                            );
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
                                onPressed: () async {
                                  List doctorDiscussionlist =
                                      await AllServices()
                                          .getSyncSavedData('syncItemData');
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DcrDiscussionPage(
                                        // uniqueId: widget.uniqueId,
                                        doctorDiscussionlist:
                                            doctorDiscussionlist,
                                        tempList: addedDcrGSPList,
                                        tempListFunc: (value) {
                                          addedDcrGSPList = value;
                                          itemString = DcrServices()
                                              .calculatingGspItemString(
                                                  addedDcrGSPList);

                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  );
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
                    const SizedBox(
                      height: 5,
                    )
                  ],
                )),
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

  Future<dynamic> magicDoctorBrandShow(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        // barrierColor: Colors.greenAccent,
        // backgroundColor: Colors.amber,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isScrollControlled: true,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: MediaQuery.of(context).size.height * 0.85,
            child: ListView.builder(
                itemCount: magicBrandList.length,
                shrinkWrap: true,
                itemBuilder: (itemBuilder, index) {
                  return SizedBox(
                    // height: magicBrandList[index]['team'] == 'AB' ? 250 : 150,
                    height: (magicBrandList[index]['brand'].length / 5).ceil() *
                        50.0,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 3, vertical: 5),
                            decoration: BoxDecoration(
                                // color: const Color.fromARGB(255, 176, 208, 193),
                                gradient: LinearGradient(
                                  stops: const [
                                    0.3,
                                    0.45,
                                    0.70,
                                    0.85,
                                  ],
                                  colors: [
                                    // const Color(0xff027DFD),
                                    const Color(0xff0C9F63).withOpacity(.7),
                                    const Color(0xff4100E0).withOpacity(.7),
                                    const Color(0xff1CDAC5).withOpacity(.7),
                                    const Color(0xffF2DD22).withOpacity(.6)
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'Team ${magicBrandList[index]['team']}',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        // const Divider(
                        //   color: Colors.grey,
                        //   // thickness: 2,
                        // ),
                        Expanded(
                          child: GridView.builder(
                              shrinkWrap: false,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 80,
                                childAspectRatio: 5 / 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: magicBrandList[index]['brand'].length,
                              itemBuilder: (itemBuilder, index2) {
                                return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 2),
                                    decoration: BoxDecoration(
                                        // color: Colors.green,
                                        // color: Color(
                                        //         (math.Random().nextDouble() *
                                        //                 0xFFFFFF)
                                        //             .toInt())
                                        //     .withOpacity(.8),
                                        color: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)]
                                            .withOpacity(.4),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: FittedBox(
                                      child: Text(
                                        magicBrandList[index]['brand'][index2],
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 50, 49, 49),
                                        ),
                                      ),
                                    ));
                              }),
                        )
                      ],
                    ),
                  );
                }),
          );
        });
  }

  // Saved Added Gift, Sample, PPM to Hive

  Future putAddedDcrGSPData() async {
    if (widget.isDraft) {
      DcrServices.updateDcrWithGspToDraft(
          dcrBox, addedDcrGSPList, dcrString, noteText, widget.docId);
    } else {
      dcrBox.add(DcrDataModel(
          docName: widget.docName,
          docId: widget.docId,
          areaId: widget.areaId,
          areaName: widget.areaName,
          address: 'address',
          dcrGspList: addedDcrGSPList,
          visitedWith: dcrString,
          notes: noteText,
          magic: widget.magic));
    }
  }

  Future<dynamic> dcrGSPSubmit() async {
    itemString = DcrServices().calculatingGspItemString(addedDcrGSPList);
    if (itemString != '') {
      Map<String, dynamic> dcrResponsedata = await DcrRepositories()
          .dcrGspSubmit(
              dmpathData!.submitUrl,
              cid,
              userId,
              userPassword,
              deviceId,
              widget.docId,
              widget.areaId,
              dcrString,
              latitude,
              longitude,
              itemString,
              noteText);

      if (dcrResponsedata['status'] == "Success") {
        if (dcrBox.isNotEmpty && widget.isDraft) {
          DcrServices.deleteDcrGspFromDraft(dcrBox, widget.docId);
        }

        if (!mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      userName: userName,
                      userId: userInfo!.userId,
                      userPassword: userPassword,
                    )),
            (Route<dynamic> route) => false);

        AllServices().toastMessageForSubmitData(
            "DCR Submitted\n${dcrResponsedata['ret_str']}", //dcr submit success return message
            Colors.green.shade900,
            Colors.white,
            16);
      } else {
        setState(() {
          _isLoading = true;
        });
        AllServices().toastMessage(
            "${dcrResponsedata['ret_str']}", // dcr submit falid return message
            // "DCR Submit Failed\n${dcrResponsedata['ret_str']}",
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
                if (widget.isDraft) {
                  DcrServices.singleDeleteGspItemFromDraft(
                      dcrBox, widget.docId, addedDcrGSPList[index].giftId);
                  itemString =
                      DcrServices().calculatingGspItemString(addedDcrGSPList);

                  setState(() {});
                } else {
                  addedDcrGSPList.removeAt(index);
                  itemString =
                      DcrServices().calculatingGspItemString(addedDcrGSPList);
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
