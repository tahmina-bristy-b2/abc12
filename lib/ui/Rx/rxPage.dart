import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:http/http.dart' as http;
import 'package:MREPORTING/ui/loginPage.dart';
import 'package:MREPORTING/ui/Rx/doctorListfromHive.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/hive_models/hive_data_model.dart';
import 'Medicine/medicineFromHive.dart';
import 'package:fluttertoast/fluttertoast.dart';

var quantity = "";

class RxPage extends StatefulWidget {
  int dcrKey;
  int uniqueId;
  String ck;
  String docName;
  String docId;
  String areaName;
  String areaId;
  String address;
  String image1;
  List<MedicineListModel> draftRxMedicinItem;

  RxPage({
    Key? key,
    required this.address,
    required this.areaId,
    required this.ck,
    required this.dcrKey,
    required this.uniqueId,
    required this.docName,
    required this.docId,
    required this.areaName,
    required this.draftRxMedicinItem,
    required this.image1,
  }) : super(key: key);

  @override
  State<RxPage> createState() => _RxPageState();
}

class _RxPageState extends State<RxPage> {
  Map<String, TextEditingController> controllers = {};
  // TextEditingController textController = TextEditingController();
  // List<TextEditingController> textController = [];

  late TransformationController controller;
  TapDownDetails? tapDownDetails;
  Box? box;
  List doctorData = [];
  List medicineData = [];
  List<RxDcrDataModel> finalDoctorList = [];
  List<MedicineListModel> finalMedicineList = [];
  List finalDraftDoctorList = [];
  List finalDraftMedicineList = [];
  List rxMedicineDataList = [];
  List tempMedicineList = [];
  File? imagePath;
  XFile? file;
  String a = '';
  // File? _image;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int _currentSelected = 3;
  int _currentSelected2 = 2;
  int counterForDoctor = 0;
  int _counterforRx = 0;
  bool _isCameraClick = false;
  int objectImageId = 0;

  String? submit_url;
  String? photo_submit_url;
  String? cid;
  String? userId;
  String? userPassword;
  String itemString = '';
  String userName = '';
  String user_id = '';
  String startTime = '';
  String endTime = '';
  int tempCount = 0;
  String? docId;
  double latitude = 0.0;
  double longitude = 0.0;
  String? deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  bool _isLoading = true;
  bool _activeCounter = false;
  String dropdownRxTypevalue = 'Rx Type';

  List<String> rxTypeList = [];

  String finalImage = '';

  @override
  void initState() {
    // Boxes.rxdDoctor().clear();
    // Boxes.getMedicine().clear();
    print("id ${widget.uniqueId}");
    print("counterrx ${_counterforRx}");
    // print(widget.uniqueId);
    if (widget.docId != '') {
      docId = widget.docId;
      counterForDoctor = widget.uniqueId;
    }

    // for (int i = 0; i < widget.draftRxMedicinItem.length; i++) {
    //   int a = widget.draftRxMedicinItem[i].quantity;
    //   print("r bolo ki khbr ${a}");
    //   if (a != "") {
    //     textController[index].text = a.toString();
    //     print("accha accha ${textController[index].text}");
    //   }
    // }
    // textController.text = widget.draftRxMedicinItem[index].quantity;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        photo_submit_url = prefs.getString('photo_submit_url');
        latitude = prefs.getDouble("latitude") ?? 0.0;
        longitude = prefs.getDouble("longitude") ?? 0.0;
        submit_url = prefs.getString("submit_url");
        cid = prefs.getString("CID");
        userId = prefs.getString("USER_ID");
        userPassword = prefs.getString("PASSWORD");
        userName = prefs.getString("userName")!;
        user_id = prefs.getString("user_id")!;
        deviceId = prefs.getString("deviceId");
        deviceBrand = prefs.getString("deviceBrand");
        deviceModel = prefs.getString("deviceModel");
        rx_doc_must = prefs.getBool("rx_doc_must") ?? false;
        rx_type_must = prefs.getBool("rx_type_must") ?? false;
        rx_gallery_allow = prefs.getBool("rx_gallery_allow") ?? false;

        rxTypeList = prefs.getStringList("rx_type_list")!;
        dropdownRxTypevalue = rxTypeList.first;
        // if (widget.uniqueId == 0) {
        //   int? a = prefs.getInt('DCLCounter') ?? 0;

        //   setState(() {
        //     widget.uniqueId = a;
        //   });
        // }
      });
      // if (prefs.getInt('RxCounter') != null) {
      //   int? a = prefs.getInt('RxCounter');
      //   setState(() {
      //     _counterforRx = a!;
      //   });
      // }
    });
    finalMedicineList = widget.draftRxMedicinItem;
    tempCount = widget.draftRxMedicinItem.length;
    setState(() {});
    if (widget.ck != '') {
      setState(() {
        _activeCounter = true;
      });

      int space = widget.image1.indexOf(" ");
      String removeSpace =
          widget.image1.substring(space + 1, widget.image1.length);
      finalImage = removeSpace.replaceAll("'", '');

      finalDoctorList.add(RxDcrDataModel(
        uiqueKey: widget.uniqueId,
        docName: widget.docName,
        docId: widget.docId,
        areaId: widget.areaId,
        areaName: widget.areaName,
        address: widget.address,
        presImage: finalImage,
      ));
    } else {
      return;
    }

    super.initState();
  }

  int _rxCounter() {
    var dt = DateFormat('HH:mm:ssss').format(DateTime.now());

    String time = dt.replaceAll(":", '');

    setState(() {
      _counterforRx = int.parse(time);
    });

    return _counterforRx;
  }

  void calculateRxItemString() {
    if (finalMedicineList.isNotEmpty) {
      finalMedicineList.forEach((element) {
        if (itemString == '') {
          itemString =
              element.itemId.toString() + '|' + element.quantity.toString();
        } else {
          itemString += '||' +
              element.itemId.toString() +
              '|' +
              element.quantity.toString();
        }
      });
    }
  }

  void _onItemTapped(int index) async {
    if (index == 0) {
      setState(() {
        _isLoading = false;
      });
      // orderSubmit();
      if ((widget.image1 != '' || imagePath != null) &&
          finalMedicineList.isNotEmpty) {
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          if (rx_doc_must == true) {
            if (finalDoctorList[0].docId != "") {
              _rxImageSubmit();
            } else {
              _submitToastforDoctor();
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            _rxImageSubmit();
          }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // print(InternetConnectionChecker().lastTryResults);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforphoto();
      }

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 2) {
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
      } else {
        _submitToastforphoto();
      }
      //   putAddedRxData();
      // } else if ((imagePath != null || widget.image1 != '') &&
      //     finalMedicineList.isNotEmpty) {

      // } else {
      //   _submitToastforphoto();
      // }
      // putAddedRxData();

      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 1) {
      _galleryFunctionality();
      setState(() {
        _currentSelected = index;
      });
    }
    if (index == 3) {
      // if ((imagePath != null || widget.image1 != '')) {
      //   print("image will save on draft");
      //   finalDoctorList.add(
      //     RxDcrDataModel(
      //       uiqueKey: widget.uniqueId > 0 ? widget.uniqueId : _counterforRx,
      //       docName: widget.uniqueId > 0
      //           ? widget.uniqueId.toString()
      //           : _counterforRx.toString(),
      //       docId: '',
      //       areaId: '',
      //       areaName: 'areaName',
      //       address: 'address',
      //       presImage: imagePath.toString(),
      //     ),
      //   );
      //   for (var dcr in finalDoctorList) {
      //     final box = Boxes.rxdDoctor();

      //     box.add(dcr);
      //   }
      //   for (var d in finalMedicineList) {
      //     final box = Boxes.getMedicine();

      //     box.add(d);
      //   }
      // }
      if (widget.uniqueId == 0) {
        widget.uniqueId++;
      } else if (_counterforRx == 0) {
        _counterforRx++;
      }

      _cameraFuntionality();
      setState(() {
        _currentSelected = index;
      });
    }
  }

  void _onItemTapped2(int index) async {
    if (index == 0) {
      setState(() {
        _isLoading = false;
      });
      // orderSubmit();
      if ((widget.image1 != '' || imagePath != null) &&
          finalMedicineList.isNotEmpty) {
        bool result = await InternetConnectionChecker().hasConnection;
        if (result == true) {
          if (rx_doc_must == true) {
            if (finalDoctorList[0].docId != "") {
              _rxImageSubmit();
            } else {
              _submitToastforDoctor();
              setState(() {
                _isLoading = true;
              });
            }
          } else {
            _rxImageSubmit();
          }
        } else {
          _submitToastforOrder3();
          setState(() {
            _isLoading = true;
          });
          // print(InternetConnectionChecker().lastTryResults);
        }
      } else {
        setState(() {
          _isLoading = true;
        });
        _submitToastforphoto();
      }

      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 1) {
      if (imagePath != null || widget.image1 != '') {
        putAddedRxData();
      } else {
        _submitToastforphoto();
      }
      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 2) {
      // if (widget.uniqueId == 0) {
      //   widget.uniqueId++;
      // } else if (_counterforRx == 0) {
      //   _counterforRx++;
      // }
      _cameraFuntionality();
      setState(() {
        _currentSelected2 = index;
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

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return _isLoading
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Rx Capture'),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    //////////////////camera////////////////////
                    Row(
                      children: [
                        Card(
                          elevation: 5,
                          child: Container(
                            height: screenHeight / 3.3,
                            width: screenWidth / 1.8,
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: widget.image1 != ''
                                ? InkWell(
                                    onDoubleTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ZoomForRxDraftImage(finalImage),
                                        ),
                                      );
                                    },
                                    child: Hero(
                                      tag: "imageForDraft",
                                      child: Image.file(
                                        File(finalImage),
                                      ),
                                    ),
                                  )
                                // ? FullScreenWidget(
                                //     child: PhotoView(
                                //         imageProvider:
                                //             gFileImage(File(finalImage))
                                //
                                //         // Image.file(File(finalImage)),
                                //         ))
                                : file == null
                                    ? Column(
                                        children: [
                                          Expanded(
                                            flex: 4,
                                            child: Image.asset(
                                              'assets/images/default_document.png',
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          Expanded(
                                              // flex: 4,
                                              child: Container(
                                            width: screenWidth / 1.8,
                                            color: Colors.white,
                                            child: const Center(
                                              child: Text(
                                                "Double tap to zoom",
                                                style: TextStyle(fontSize: 18),
                                              ),
                                            ),
                                          ))
                                        ],
                                      )
                                    : InkWell(
                                        onDoubleTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ZoomForRxImage(imagePath),
                                            ),
                                          );
                                        },
                                        child: Hero(
                                          tag: "img",
                                          child: Image.file(imagePath!),
                                        ),
                                      ),
                            // : FullScreenWidget(
                            //     child: PhotoView(
                            //     imageProvider: FileImage(
                            //       imagePath!,
                            //     ),
                            //
                            //     // Image.file(File(finalImage)),
                            //   )),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        Container(
                          child: Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    // if (_activeCounter == true) {
                                    //   setState(() {
                                    //     counterForDoctor = _counterforRx;
                                    //   });
                                    // }
                                    // print('drcounter:$counterForDoctor');
                                    setState(() {});
                                    if (imagePath != null) {
                                      getRxDoctorData();
                                    } else if (widget.image1 != "") {
                                      getRxDoctorData();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please Take Image First ',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Center(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                                color: Colors.white,
                                              ),
                                              width: screenWidth / 5,
                                              height: screenHeight / 9,

                                              // color: const Color(0xffDDEBF7),
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/doctor.png',
                                                      // color: Colors.teal,
                                                      width: screenWidth / 7,
                                                      height: screenWidth / 7,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        'Doctor',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.teal,
                                                          fontSize:
                                                              screenHeight / 45,
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print(imagePath.toString());
                                    setState(() {});

                                    if (imagePath != null) {
                                      if (widget.uniqueId >= 0 &&
                                          finalDoctorList.isNotEmpty) {
                                        getMedicine();
                                        // print(widget.uniqueId);
                                      } else if (_activeCounter == false) {
                                        // print('activeCounter:$_activeCounter');
                                        _rxCounter();
                                        getMedicine();
                                        // print('test:${widget.uniqueId}');
                                        setState(() {
                                          _activeCounter = true;
                                        });
                                      } else if (_activeCounter == true) {
                                        getMedicine();
                                      }
                                    } else if (widget.image1 != "") {
                                      if (widget.uniqueId >= 0 &&
                                          finalDoctorList.isNotEmpty) {
                                        getMedicine();
                                        // print(widget.uniqueId);
                                      } else if (_activeCounter == false) {
                                        // print('activeCounter:$_activeCounter');
                                        _rxCounter();
                                        getMedicine();
                                        // print('test:${widget.uniqueId}');
                                        setState(() {
                                          _activeCounter = true;
                                        });
                                      } else if (_activeCounter == true) {
                                        getMedicine();
                                      }
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please Take Image First ',
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  },
                                  child: Center(
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      elevation: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: screenWidth / 5,
                                              height: screenHeight / 10,

                                              // color: const Color(0xffDDEBF7),
                                              child: Container(
                                                color: Colors.white,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.asset(
                                                      'assets/images/cap.png',
                                                      // color: Colors.teal,
                                                      width: screenWidth / 10,
                                                      height: screenWidth / 8,
                                                      fit: BoxFit.cover,
                                                    ),
                                                    FittedBox(
                                                      child: Text(
                                                        'Medicine',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.teal,
                                                          fontSize:
                                                              screenHeight / 45,
                                                        ),
                                                      ),
                                                    )
                                                    // Image.asset(
                                                    //   'assets/images/doctor.jpg',
                                                    //   // width: 60,
                                                    //   // height: 40,
                                                    //   fit: BoxFit.cover,
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    ///*********************************doctor info******************************************///
                    finalDoctorList.isNotEmpty
                        ? SizedBox(
                            height: screenHeight / 9,
                            child: Card(
                              color: const Color(0xffDDEBF7),
                              elevation: 10,
                              shape: const RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white70, width: 1),
                                // borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 70,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xffDDEBF7),
                                  //borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${finalDoctorList[0].docName}' +
                                                  '(${finalDoctorList[0].docId})',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            // SizedBox(height: 10),
                                            FittedBox(
                                              child: Text(
                                                '${finalDoctorList[0].areaName}' +
                                                    '(${finalDoctorList[0].areaId}) ,' +
                                                    ' ${finalDoctorList[0].address}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  // fontSize: 19,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      rx_type_must == true
                                          ? Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child:
                                                        DropdownButtonFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              enabled: false),
                                                      isExpanded: true,
                                                      value:
                                                          dropdownRxTypevalue,

                                                      icon: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Colors.black,
                                                      ),

                                                      // Array list of items
                                                      items: rxTypeList
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                          value: items,
                                                          child: Text(
                                                            items,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: 16,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),

                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          dropdownRxTypevalue =
                                                              newValue!;
                                                        });
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        : SizedBox(
                            height: screenHeight / 9,
                            child: Card(
                              color: const Color(0xffDDEBF7),
                              elevation: 10,
                              shape: const RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white70, width: 1),
                                // borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                height: 70,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                  color: Color(0xffDDEBF7),
                                  //borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 5,
                                        child: Text(
                                          'No Doctor Selected',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                      rx_type_must == true
                                          ? Expanded(
                                              flex: 3,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // const Text(
                                                  //   "Rx Type : ",
                                                  //   style: TextStyle(
                                                  //       color: Colors.black,
                                                  //       fontSize: 16),
                                                  // ),
                                                  Expanded(
                                                    child:
                                                        DropdownButtonFormField(
                                                      decoration:
                                                          const InputDecoration(
                                                              enabled: false),
                                                      isExpanded: true,
                                                      // Initial Value
                                                      value:
                                                          dropdownRxTypevalue,

                                                      // Down Arrow Icon
                                                      icon: const Icon(
                                                        Icons
                                                            .keyboard_arrow_down,
                                                        color: Colors.black,
                                                      ),

                                                      // Array list of items
                                                      items: rxTypeList
                                                          .map((String items) {
                                                        return DropdownMenuItem(
                                                          value: items,
                                                          child: Text(
                                                            items,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              // fontSize: 16,
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                      // After selecting the desired option,it will
                                                      // change button value to selected value
                                                      onChanged:
                                                          (String? newValue) {
                                                        setState(() {
                                                          dropdownRxTypevalue =
                                                              newValue!;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                    ////////////////////////////////medicine List View////////////////
                    finalMedicineList.isNotEmpty
                        ? Card(
                            elevation: 15,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(0),
                            ),
                            color: const Color(0xffDDEBF7),
                            child: SizedBox(
                              height: screenHeight / 1.5,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: finalMedicineList.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (BuildContext itemBuilder, index) {
                                  return Card(
                                    elevation: 10,
                                    color: const Color.fromARGB(
                                        255, 217, 248, 219),
                                    shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: Colors.white70, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    '${finalMedicineList[index].name} ' +
                                                        '(${finalMedicineList[index].itemId})',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      // fontWeight:
                                                      // FontWeight.bold,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                    onPressed: () {
                                                      // var x =
                                                      if (finalMedicineList[
                                                                  index]
                                                              .quantity >
                                                          1) {
                                                        finalMedicineList[index]
                                                            .quantity--;
                                                      }

                                                      // calculateRxItemString(
                                                      //     x.toString());
                                                      setState(() {});
                                                    },
                                                    icon: const Icon(
                                                        Icons.remove)),
                                                Container(
                                                  width: 40,
                                                  height: 30,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: Colors
                                                              .blueAccent)),
                                                  // color: !pressAttention
                                                  //     ? Colors.white
                                                  //     : Colors.blueAccent,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 8, 0, 0),
                                                    child: Text(
                                                      finalMedicineList[index]
                                                          .quantity
                                                          .toString(),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    // var y =
                                                    finalMedicineList[index]
                                                        .quantity++;
                                                    // calculateRxItemString(
                                                    //     y.toString());
                                                    setState(() {});
                                                  },
                                                  icon: const Icon(Icons.add),
                                                ),
                                                IconButton(
                                                  // color: Colors.red,
                                                  onPressed: () {
                                                    _showMyDialog(index);
                                                  },
                                                  icon: const Icon(
                                                    Icons.clear,
                                                    // size: 20,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : const SizedBox(
                            height: 5,
                          ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: rx_gallery_allow == true
                ? BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    onTap: _onItemTapped,
                    currentIndex: _currentSelected,
                    showUnselectedLabels: true,
                    unselectedItemColor: Colors.grey[800],
                    selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        label: 'Submit',
                        icon: Icon(Icons.save),
                      ),
                      BottomNavigationBarItem(
                        label: 'Gallery',
                        icon: Icon(Icons.add_photo_alternate),
                      ),
                      BottomNavigationBarItem(
                        label: 'Save Drafts',
                        icon: Icon(Icons.drafts),
                      ),
                      BottomNavigationBarItem(
                        label: 'Camera',
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  )
                : BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    onTap: _onItemTapped2,
                    currentIndex: _currentSelected2,
                    showUnselectedLabels: true,
                    unselectedItemColor: Colors.grey[800],
                    selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
                    items: const <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        label: 'Submit',
                        icon: Icon(Icons.save),
                      ),
                      BottomNavigationBarItem(
                        label: 'Save Drafts',
                        icon: Icon(Icons.drafts),
                      ),
                      BottomNavigationBarItem(
                        label: 'Camera',
                        icon: Icon(Icons.camera_alt),
                      ),
                    ],
                  ),
          )
        : Container(
            padding: const EdgeInsets.all(100),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }

  // rx Submitt................................................
  Future<dynamic> rxSubmit(String fileName) async {
    print(submit_url! +
        'api_rx_submit/submit_data?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&doctor_id=${finalDoctorList.isEmpty ? '' : finalDoctorList[0].docId}&area_id=${finalDoctorList.isEmpty ? '' : finalDoctorList[0].areaId}&rx_type=$dropdownRxTypevalue&latitude=$latitude&longitude=$longitude&image_name=$fileName&cap_time=${"dt"}&item_list=$itemString');
    // if (itemString != '') {
    // print(itemString);
    var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    String time = dt.replaceAll(":", '');
    String a = user_id + '_' + time;

    try {
      final http.Response response = await http.post(
        Uri.parse(submit_url! + 'api_rx_submit/submit_data'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(
          <String, dynamic>{
            'cid': cid,
            'user_id': userId,
            'user_pass': userPassword,
            'device_id': deviceId,
            'doctor_id':
                finalDoctorList.isEmpty ? '' : finalDoctorList[0].docId,
            'area_id': finalDoctorList.isEmpty ? '' : finalDoctorList[0].areaId,
            'rx_type': dropdownRxTypevalue,
            "latitude": latitude,
            'longitude': longitude,
            'image_name': fileName,
            'cap_time': dt.toString(),
            "item_list": itemString,
          },
        ),
      );

      var orderInfo = json.decode(response.body);
      String status = orderInfo['status'];
      print(orderInfo['status']);
      String ret_str = orderInfo['ret_str'];

      if (status == "Success") {
        if (widget.ck != '') {
          for (int i = 0; i <= finalMedicineList.length; i++) {
            deleteMedicinItem(widget.dcrKey);

            // finalItemDataList.clear();
            setState(() {});
          }

          deleteRxDoctor(widget.dcrKey);
        }

        setState(() {});

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => MyHomePage(
                userName: userName,
                user_id: user_id,
                userPassword: userPassword ?? '',
              ),
            ),
            (Route<dynamic> route) => false);

        _submitToastforOrder(ret_str);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Rx submit Failed'), backgroundColor: Colors.red),
        );
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    //       content: Text(
    //         'Please Order something',
    //       ),
    //       backgroundColor: Color.fromARGB(255, 180, 59, 109)));
    // }
  }

  // ..........Rx Image Submit................................

  Future<dynamic> _rxImageSubmit() async {
    setState(() {
      calculateRxItemString();
    });

    var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    String time = dt.replaceAll(":", '');

    var postUri = Uri.parse(photo_submit_url!);

    http.MultipartRequest request = http.MultipartRequest("POST", postUri);
    if (widget.image1 != '') {
      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'productImage', finalImage.toString(),
        // filename: a,
        // filename: finalImage.split("-").last
      );

      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();
      var res = await http.Response.fromStream(response);
      final jsonData = json.decode(res.body);
      final fileName = jsonData['fileName'];

      // print(fileName);
      if (fileName != '') {
        rxSubmit(fileName);
      } else {
        setState(() {
          _isLoading = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Rx Image submit Failed'),
              backgroundColor: Colors.red),
        );
      }
      // print(response.statusCode);
    } else {
      String rxImage = '';

      setState(() {
        rxImage = imagePath.toString();
      });

      int space = rxImage.indexOf(" ");
      String removeSpace = rxImage.substring(space + 1, rxImage.length);
      finalImage = removeSpace.replaceAll("'", '');

      http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
        'productImage', finalImage,
        // filename: a,
        // filename: finalImage.split("-").last
      );

      //request.fields["rxImage"] = finalImage;
      request.files.add(multipartFile);
      http.StreamedResponse response = await request.send();

      var res = await http.Response.fromStream(response);
      final jsonData = json.decode(res.body);
      final fileName = jsonData['fileName'];

      // print(fileName);
      if (fileName != '') {
        rxSubmit(fileName);
      } else {
        setState(() {
          _isLoading = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Rx Image submit Failed'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  // .......... Submit Toast messege..............
  void _submitToastforOrder(String ret_str) {
    Fluttertoast.showToast(
        msg: "Rx Submitted\n$ret_str",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.green.shade900,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  deleteRxDoctor(int id) {
    final box = Hive.box<RxDcrDataModel>("RxdDoctor");

    final Map<dynamic, RxDcrDataModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

// Save RX data to Hive......................................

  deleteMedicinItem(int id) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");

    final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }

  Future putAddedRxData() async {
    if (widget.ck != '') {
      for (int i = 0; i <= finalMedicineList.length; i++) {
        deleteMedicinItem(widget.dcrKey);

        setState(() {});
      }
      // deleteRxDoctor(widget.uniqueId);

      final Doctorbox = Boxes.rxdDoctor();
      Doctorbox.toMap().forEach((key, value) {
        if (value.uiqueKey == widget.dcrKey) {
          value.docName = finalDoctorList[0].docName;
          value.docId = finalDoctorList[0].docId;
          value.address = finalDoctorList[0].address;
          value.areaId = finalDoctorList[0].areaId;
          value.areaName = finalDoctorList[0].areaName;

          Doctorbox.put(key, value);
        }
      });
      // for (var dcr in finalDoctorList) {
      //   final box = Boxes.rxdDoctor();

      //   box.add(dcr);
      // }

      for (var d in finalMedicineList) {
        d.uiqueKey = widget.dcrKey;
        final box = Boxes.getMedicine();
        box.add(d);
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userName: userName,
                    user_id: user_id,
                    userPassword: userPassword ?? '',
                  )),
          (route) => false);
    } else {
      for (var dcr in finalDoctorList) {
        print('uiniquIdD:${dcr.uiqueKey}');
        final box = Boxes.rxdDoctor();
        final medicineBox = Boxes.getMedicine();
        dcr.uiqueKey = objectImageId;
        box.toMap().forEach((key, value) {
          if (dcr.uiqueKey == value.uiqueKey) {
            value.docName = dcr.docName;
            value.docId = dcr.docId;
            value.areaName = dcr.areaName;
            value.areaId = dcr.areaId;
            value.address = dcr.address;
            box.put(key, value);
            if (finalMedicineList.isNotEmpty) {
              for (var element in finalMedicineList) {
                element.uiqueKey = objectImageId;
                medicineBox.add(element);
              }
            }
          }
        });
      }

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userName: userName,
                    user_id: user_id,
                    userPassword: userPassword ?? '',
                  )),
          (route) => false);
    }

    // if (finalMedicineList.isEmpty) {
    //   print("medicine is not selected");
    //   // for (int i = 0; i <= tempCount; i++) {
    //   //   deleteMedicinItem(widget.dcrKey);

    //   //   // finalItemDataList.clear();
    //   //   setState(() {});
    //   // }

    //   // setState(() {});

    //   // // Navigator.pushAndRemoveUntil(
    //   // //     context,
    //   // //     MaterialPageRoute(
    //   // //         builder: (context) => MyHomePage(
    //   // //               userName: userName,
    //   // //               user_id: user_id,
    //   // //               userPassword: userPassword ?? '',
    //   // //             )),
    //   // //     (route) => false);
    // } else {
    //   print("dr is not selected");
    //   // if (finalDoctorList.isEmpty) {
    //   //   finalDoctorList.add(
    //   //     RxDcrDataModel(
    //   //       uiqueKey: _counterforRx,
    //   //       docName: 'UnKnownDoctor',
    //   //       docId: '',
    //   //       areaId: '',
    //   //       areaName: 'areaName',
    //   //       address: 'address',
    //   //       presImage: imagePath.toString(),
    //   //     ),
    //   //   );
    //   //   for (var dcr in finalDoctorList) {
    //   //     final box = Boxes.rxdDoctor();

    //   //     box.add(dcr);
    //   //   }
    //   //   for (var d in finalMedicineList) {
    //   //     final box = Boxes.getMedicine();

    //   //     box.add(d);
    //   //   }

    //   //   Navigator.pop(context);
    //   // } else {
    //   //   finalDoctorList[0].presImage = imagePath.toString();
    //   //   for (var dcr in finalDoctorList) {
    //   //     print('uiniquIdD:${dcr.uiqueKey}');
    //   //     final box = Boxes.rxdDoctor();
    //   //     box.toMap().forEach((key, value) {
    //   //       if (dcr.uiqueKey == value.uiqueKey) {
    //   //         value.docName = dcr.docName;
    //   //         value.docId = dcr.docId;
    //   //         value.areaName = dcr.areaName;
    //   //         value.areaId = dcr.areaId;
    //   //         value.address = dcr.address;
    //   //         box.put(key, value);
    //   //       }
    //   //     });

    //   //     // box.add(dcr);
    //   //   }

    //   //   for (var d in finalMedicineList) {
    //   //     print('uiniquIdM:${d.uiqueKey}');
    //   //     final box = Boxes.getMedicine();

    //   //     box.add(d);
    //   //   }

    //   //   Navigator.pop(context);
    //   // }
    // }
  }

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrListData');
  }

////////////////////////////docotr//////////////////////////
  getRxDoctorData() async {
    // print('dra doc:${widget.uniqueId}');

    await openBox();
    var mymap = box!.toMap().values.toList();
    if (mymap.isNotEmpty) {
      doctorData = mymap;

      if (_activeCounter == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorListFromHiveData(
              counterCallback: (value) {
                counterForDoctor = value;

                setState(() {});
              },
              a: a,
              doctorData: doctorData,
              tempList: finalDoctorList,
              counterForDoctorList: widget.uniqueId > 0
                  ? widget.uniqueId
                  : _isCameraClick == true
                      ? objectImageId
                      : _counterforRx,
              tempListFunc: (value) {
                finalDoctorList = value;
                finalDoctorList.forEach((element) {
                  docId = element.docId;
                });

                setState(() {});
              },
            ),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorListFromHiveData(
              counterCallback: (value) {
                counterForDoctor = value;

                setState(() {});
              },
              a: a,
              doctorData: doctorData,
              tempList: finalDoctorList,
              counterForDoctorList:
                  widget.uniqueId > 0 ? widget.uniqueId : counterForDoctor,
              tempListFunc: (value) {
                finalDoctorList = value;
                finalDoctorList.forEach((element) {
                  docId = element.docId;
                });

                setState(() {});
              },
            ),
          ),
        );
      }
    } else {
      doctorData.add('Empty');
    }
  }

///////////////////////////////medicine///////////////////////////////
  Future openBox1() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('medicineList');
  }

  getMedicine() async {
    await openBox1();
    var mymap = box!.toMap().values.toList();
    if (mymap.isNotEmpty) {
      medicineData = mymap;
      // print('test1:$counterForDoctor');
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MedicineListFromHiveData1(
                  counter: (finalDoctorList.isNotEmpty &&
                          finalDoctorList[0].docId != '')
                      ? counterForDoctor
                      : _isCameraClick == true
                          ? objectImageId
                          : widget.uniqueId > 0
                              ? widget.uniqueId
                              : _counterforRx,
                  medicineData: medicineData,
                  tempList: finalMedicineList,
                  tempListFunc: (value) {
                    finalMedicineList = value;
                    setState(() {});
                  },
                )),
      );
    } else {
      medicineData.add('Empty');
    }
  }

  deleteMedicineItem(int id, int index) {
    final box = Hive.box<MedicineListModel>("draftMdicinList");
    final Map<dynamic, MedicineListModel> medicineMap = box.toMap();
    dynamic newKey;
    medicineMap.forEach((key, value) {
      if (value.uiqueKey == id) {
        newKey = key;
      }
    });
    box.delete(newKey);
    finalMedicineList.removeAt(index);
  }

  // void _submitToastforSelectDoctor() {
  //   Fluttertoast.showToast(
  //       msg: 'Please Select Doctor First',
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.CENTER,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

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
                Text('Do you want to delete this medicine?'),
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
                  final medicineUniqueKey = finalMedicineList[index].uiqueKey;

                  deleteMedicineItem(medicineUniqueKey, index);
                  setState(() {});
                } else {
                  finalMedicineList.removeAt(index);
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

  int uniqueIdForImage() {
    int id = 0;
    id = int.parse(
        DateFormat('HH:mm:ssss').format(DateTime.now()).replaceAll(":", ''));
    setState(() {
      objectImageId = id;
    });
    return id;
  }

  Future<void> _cameraFuntionality() async {
    setState(() {
      print('changebefore: $_isCameraClick');
      _isCameraClick = true;
      print('changeafter: $_isCameraClick');
    });
    file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      //preferredCameraDevice: CameraDevice.rear,
      maxHeight: 800,
      maxWidth: 700,
    );
    if (file != null) {
      setState(() {
        file;
        imagePath = File(file!.path);
        widget.image1 = '';

        if (imagePath != null && widget.ck == "") {
          // if (finalDoctorList.)
          print("image will save on draft");
          if (finalDoctorList.isEmpty) {
            finalDoctorList.add(
              RxDcrDataModel(
                uiqueKey:
                    widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName: objectImageId.toString(),
                docId: '',
                areaId: '',
                areaName: 'areaName',
                address: 'address',
                presImage: imagePath.toString(),
              ),
            );

            for (var dcr in finalDoctorList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          } else {
            finalDoctorList.clear();
            finalDoctorList.add(
              RxDcrDataModel(
                uiqueKey:
                    widget.image1 != '' ? widget.uniqueId : uniqueIdForImage(),
                docName: objectImageId.toString(),
                docId: '',
                areaId: '',
                areaName: 'areaName',
                address: 'address',
                presImage: imagePath.toString(),
              ),
            );

            for (var dcr in finalDoctorList) {
              final box = Boxes.rxdDoctor();

              box.add(dcr);
            }
            for (var d in finalMedicineList) {
              final box = Boxes.getMedicine();

              box.add(d);
            }
          }
        } else if (imagePath != null && widget.ck != '') {
          final Doctorbox = Boxes.rxdDoctor();
          Doctorbox.toMap().forEach((key, value) {
            if (value.uiqueKey == widget.dcrKey) {
              value.presImage = imagePath.toString();
              Doctorbox.put(key, value);
            }
          });
          // widget.image1 = imagePath.toString();
        }
      });
    }
  }

  Future<void> _galleryFunctionality() async {
    file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      //preferredCameraDevice: CameraDevice.rear,
      maxHeight: 800,
      maxWidth: 700,
    );
    if (file != null) {
      setState(() {
        file;
        imagePath = File(file!.path);
      });
    }
  }

  void _submitToastforphoto() {
    Fluttertoast.showToast(
        msg: 'Please Take Image and Select Medicine',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _submitToastforDoctor() {
    Fluttertoast.showToast(
        msg: 'Please Select Doctor.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class ZoomForRxImage extends StatelessWidget {
  File? img;
  ZoomForRxImage(this.img);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'imageHero',
              child: PhotoView(
                imageProvider: FileImage(img!),
              )),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

class ZoomForRxDraftImage extends StatelessWidget {
  String? draftFinalImage;
  ZoomForRxDraftImage(this.draftFinalImage);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageForDraft',
            child: PhotoView(
              imageProvider: FileImage(File(draftFinalImage!)),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context);
        },
      ),
    );
  }
}
