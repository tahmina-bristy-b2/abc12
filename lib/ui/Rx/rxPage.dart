import 'dart:io';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/rx/rx_repositories.dart';
import 'package:MREPORTING/services/rx/rx_services.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:MREPORTING/ui/Rx/doctorListfromHive.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'medicineFromHive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'package:gallery_saver/gallery_saver.dart';

class RxPage extends StatefulWidget {
  final bool isRxEdit;
  final RxDcrDataModel? draftRxData;

  const RxPage({
    Key? key,
    required this.isRxEdit,
    this.draftRxData,
  }) : super(key: key);

  @override
  State<RxPage> createState() => _RxPageState();
}

class _RxPageState extends State<RxPage> {
  Map<String, TextEditingController> controllers = {};

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  final rxDcrBox = Boxes.rxdDoctor();

  Box? box;
  File? imagePath;
  File? rxSmallImage;
  XFile? file;

  List<RxDcrDataModel> finalDoctorList = [];
  List<MedicineListModel> finalMedicineList = [];

  double screenHeight = 0.0;
  double screenWidth = 0.0;
  int _currentSelected = 3;
  int _currentSelected2 = 2;

  int objectImageId = 0;

  String cid = '';
  String userPassword = '';

  String itemString = "";

  String startTime = '';
  String endTime = '';

  double latitude = 0.0;
  double longitude = 0.0;
  String deviceId = '';
  String deviceBrand = '';
  String deviceModel = '';
  bool _isLoading = true;

  String dropdownRxTypevalue = 'Rx Type';

  String finalImage = '';
  String rxShortImage = ''; //for image comming from draft

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    dropdownRxTypevalue = userInfo!.rxTypeList.first;

    // from draft
    if (widget.isRxEdit) {
      finalDoctorList.add(widget.draftRxData!);
      finalMedicineList = widget.draftRxData!.rxMedicineList;
      finalImage = widget.draftRxData!.presImage; // for original size image
      rxShortImage = widget.draftRxData!.rxSmallImage; //for small size image

      // int space = widget.draftRxData!.presImage.indexOf(" ");
      // String removeSpace = widget.draftRxData!.presImage
      //     .substring(space + 1, widget.draftRxData!.presImage.length);
      // finalImage = removeSpace.replaceAll("'", '');

      dropdownRxTypevalue = widget.draftRxData!.rxType;
    }

    // from SharedPred
    SharedPreferences.getInstance().then((prefs) {
      setState(() {});
      cid = prefs.getString("CID") ?? '';
      userPassword = prefs.getString("PASSWORD") ?? '';
      latitude = prefs.getDouble("latitude") ?? 0.0;
      longitude = prefs.getDouble("longitude") ?? 0.0;
      deviceId = prefs.getString("deviceId") ?? '';
      deviceBrand = prefs.getString("deviceBrand") ?? '';
      deviceModel = prefs.getString("deviceModel") ?? '';
    });

    setState(() {});
  }

  //===================================== Rx Submit Validations===========================================

  rxValidationSubmit() async {
    if (widget.isRxEdit == false && imagePath == null) {
      setState(() {
        _isLoading = true;
      });
      AllServices()
          .toastMessage('Please Take Image', Colors.red, Colors.white, 16);
    } else if (finalMedicineList.isEmpty &&
        RxServices().calculateRxItemString(finalMedicineList) == '') {
      setState(() {
        _isLoading = true;
      });
      AllServices()
          .toastMessage('Please Select Medicine', Colors.red, Colors.white, 16);
    } else {
      if (await InternetConnectionChecker().hasConnection) {
        if (userInfo!.rxDocMust) {
          if (finalDoctorList.first.docId != '') {
            await rxSubmit();
          } else {
            setState(() {
              _isLoading = true;
            });
            AllServices().toastMessage(
                'Please  Select Doctor', Colors.red, Colors.white, 16);
          }
        } else {
          await rxSubmit();
        }
      } else {
        AllServices().toastMessage(
            'No Internet Connection\nPlease check your internet connection.',
            Colors.red,
            Colors.white,
            16);
        setState(() {
          _isLoading = true;
        });
      }
    }
  }

  //===================================== 4 item bottomnavbar===========================================
  void _onItemTapped(int index) async {
    if (index == 0) {
      setState(() {
        _isLoading = false;
      });
      await rxValidationSubmit();
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

    if (index == 2) {
      if (imagePath != null || finalImage != '') {
        putAddedRxData();
      } else {
        AllServices().toastMessage('Please Take Image and Select Medicine',
            Colors.red, Colors.white, 16);
      }

      setState(() {
        _currentSelected = index;
      });
    }

    if (index == 3) {
      _cameraFuntionality();
      setState(() {
        _currentSelected = index;
      });
    }
  }

  //===================================== 3 item bottomnavbar===========================================
  void _onItemTapped2(int index) async {
    if (index == 0) {
      setState(() {
        _isLoading = false;
      });
      await rxValidationSubmit();

      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 1) {
      if (imagePath != null || finalImage != '') {
        putAddedRxData();
      } else {
        AllServices().toastMessage('Please Take Image and Select Medicine',
            Colors.red, Colors.white, 16);
      }
      setState(() {
        _currentSelected2 = index;
      });
    }

    if (index == 2) {
      _cameraFuntionality();
      setState(() {
        _currentSelected2 = index;
      });
    }
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
                          // elevation: 5,
                          child: Container(
                            height: screenHeight / 3.3,
                            width: screenWidth / 1.8,
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: finalImage != ''
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
                                      child: ExtendedImage.file(
                                        File(rxShortImage),
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
                                          child:
                                              ExtendedImage.file(rxSmallImage!),
                                          // child: Image.file(imagePath!),
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
                        Center(
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  List dcrList = await AllServices()
                                      .getSyncSavedData('dcrListData');

                                  if (imagePath != null || finalImage != "") {
                                    if (!mounted) return;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DoctorListFromHiveData(
                                          doctorData: dcrList,
                                          tempList: finalDoctorList,
                                          tempListFunc: (value) {
                                            finalDoctorList = value;

                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
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
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    // elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
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
                                            height: screenHeight / 8,

                                            // color: const Color(0xffDDEBF7),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
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
                                onTap: () async {
                                  setState(() {});
                                  List medList = await AllServices()
                                      .getSyncSavedData('medicineList');
                                  if (imagePath != null || finalImage != "") {
                                    if (!mounted) return;

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            MedicineListFromHiveData1(
                                          medicineData: medList,
                                          medicinTempList: finalMedicineList,
                                          tempListFunc: (value) {
                                            finalMedicineList = value;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    );
                                    // getMedicine();
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
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    // elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
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
                                            height: screenHeight / 8,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/images/cap.png',
                                                  width: screenWidth / 7,
                                                  height: screenWidth / 7,
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
                                        ],
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

                    ///*********************************doctor info******************************************///
                    finalDoctorList.isNotEmpty
                        ? SizedBox(
                            height: screenHeight / 9,
                            child: Card(
                              color: const Color(0xffDDEBF7),
                              // elevation: 10,
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
                                        // flex: 5,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${finalDoctorList[0].docName}(${finalDoctorList[0].docId})',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            // SizedBox(height: 10),
                                            FittedBox(
                                              child: Text(
                                                '${finalDoctorList[0].areaName}(${finalDoctorList[0].areaId}) , ${finalDoctorList[0].address}',
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
                                      userInfo!.rxTypeMust
                                          ? Expanded(
                                              child: DropdownButtonFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        enabled: false),
                                                isExpanded: true,
                                                value: dropdownRxTypevalue,

                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                ),

                                                // Array list of items
                                                items: userInfo!.rxTypeList
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(
                                                      items,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        // fontSize: 16,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),

                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownRxTypevalue =
                                                        newValue!;
                                                  });
                                                },
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
                              // elevation: 5,
                              shape: const RoundedRectangleBorder(
                                side:
                                    BorderSide(color: Colors.white70, width: 1),
                                // borderRadius: BorderRadius.circular(10),
                              ),
                              child: SizedBox(
                                height: 70,
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        // flex: 5,
                                        child: Text(
                                          'No Doctor Selected',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      userInfo!.rxTypeMust
                                          ? Expanded(
                                              child: DropdownButtonFormField(
                                                decoration:
                                                    const InputDecoration(
                                                        enabled: false),
                                                isExpanded: true,
                                                // Initial Value
                                                value:
                                                    userInfo!.rxTypeList.first,

                                                // Down Arrow Icon
                                                icon: const Icon(
                                                  Icons.keyboard_arrow_down,
                                                  color: Colors.black,
                                                ),

                                                // Array list of items
                                                items: userInfo!.rxTypeList
                                                    .map((String items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(
                                                      items,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        // fontSize: 16,
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                                // After selecting the desired option,it will
                                                // change button value to selected value
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownRxTypevalue =
                                                        newValue!;
                                                  });
                                                },
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
                            // elevation: 15,
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
                                    // elevation: 10,
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
                                                    '${finalMedicineList[index].name} '
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
                                                    finalMedicineList[index]
                                                        .quantity++;

                                                    setState(() {});
                                                  },
                                                  icon: const Icon(Icons.add),
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
            bottomNavigationBar: userInfo!.rxGalleryAllow
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

  //to Draaft
  Future putAddedRxData() async {
    if (widget.isRxEdit) {
      RxServices.updateRxDcrMedicineToDraft(rxDcrBox, finalDoctorList,
          finalMedicineList, widget.draftRxData!.uid, dropdownRxTypevalue);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userName: userInfo!.userName,
                    userId: userInfo!.userId,
                    userPassword: userPassword,
                  )),
          (route) => false);
    } else {
      RxServices.updateRxDcrMedicineToDraft(rxDcrBox, finalDoctorList,
          finalMedicineList, finalDoctorList.first.uid, dropdownRxTypevalue);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    userName: userInfo!.userName,
                    userId: userInfo!.userId,
                    userPassword: userPassword,
                  )),
          (route) => false);
    }
  }

  //to Dialog for delete medicine

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
                if (widget.isRxEdit) {
                  RxServices.singleDeleteRxMedicineFromDraft(rxDcrBox,
                      widget.draftRxData!.uid, finalMedicineList[index].itemId);

                  setState(() {});
                } else {
                  finalMedicineList.removeAt(index);
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

  ///*********************************Unique Id == time stamp for image*****************************************///

  int uniqueIdForImage() {
    int id = 0;
    id = int.parse(
        DateFormat('HH:mm:ssss').format(DateTime.now()).replaceAll(":", ''));
    setState(() {
      objectImageId = id;
    });
    return id;
  }

  ///*********************************RxSubmit w/ Image Function*****************************************///

  Future rxSubmit() async {
    String fileName = "";
    // if (finalDoctorList[0].docId != "") {
    // _rxImageSubmit();
    File? rxImageFile = await RxServices().getImageFrom(
        imageFile: widget.isRxEdit ? File(finalImage) : imagePath);

    final jsonData = await RxRepositories().rxImageSubmitRepo(
        dmpathData!.photoSubmitUrl, rxImageFile!.path.toString());
    if (jsonData['res_data']['status'] == 'Success') {
      fileName = jsonData['res_data']["ret_str"];
    }

    if (fileName != "") {
      final orderInfo = await RxRepositories().rxSubmit(
          dmpathData!.submitUrl,
          fileName,
          cid,
          userInfo!.userId,
          userPassword,
          deviceId,
          finalDoctorList,
          dropdownRxTypevalue,
          latitude,
          longitude,
          RxServices().calculateRxItemString(finalMedicineList));
      String retStr = '';
      if (orderInfo.isNotEmpty && orderInfo['status'] == "Success") {
        retStr = orderInfo['ret_str'];
        RxServices.deleteRxDataFromDraft(
            rxDcrBox,
            widget.isRxEdit
                ? widget.draftRxData!.uid
                : finalDoctorList.first.uid);
        if (!mounted) return;

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                      userName: userInfo!.userName,
                      userId: userInfo!.userId,
                      userPassword: userPassword,
                    )),
            (route) => false);

        AllServices().toastMessage(
            "Rx Submitted\n$retStr",
            Colors.green.shade900,
            Colors.white,
            16); //Rx submit success return message
      } else {
        retStr = orderInfo['ret_str'];
        AllServices().toastMessage(retStr, Colors.red, Colors.white,
            16); //Rx submit faild return message
        setState(() {
          _isLoading = true;
        });
      }

      ///RXSUBMIT FUNCTION
      // } else {
      //   setState(() {
      //     _isLoading = true;
      //   });
      //   if (!mounted) return;
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(
      //         content: Text('Rx Image submit Failed'),
      //         backgroundColor: Colors.red),
      //   );
      // }

      ///ImageRXSUBMIT FUNCTION
    } else {
      AllServices()
          .toastMessage("Image didn't submit!", Colors.red, Colors.white, 16);

      setState(() {
        _isLoading = true;
      });
    }
  }

  ///*********************************Camera FUnction*****************************************///

  Future<void> _cameraFuntionality() async {
    file = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      // maxHeight: 800,
      // maxWidth: 700,
    );
    if (file != null) {
      imagePath = File(file!.path);
      rxSmallImage = await RxServices.compress2(image: imagePath!);

      if (imagePath != null &&
          rxSmallImage != null &&
          widget.isRxEdit == false) {
        await GallerySaver.saveImage(imagePath!.path); // image save to gallery
        if (finalDoctorList.isEmpty) {
          final rxDcrDataModel = RxDcrDataModel(
              uid: const Uuid().v1(),
              docName: uniqueIdForImage().toString(),
              docId: '',
              areaId: '',
              areaName: 'areaName',
              address: 'address',
              presImage: imagePath!.path,
              rxSmallImage: rxSmallImage!.path, //for small size image
              rxMedicineList: [],
              rxType: dropdownRxTypevalue);
          finalDoctorList.add(rxDcrDataModel); // add to list

          rxDcrBox.add(rxDcrDataModel); // add to draft

          setState(() {});
        } else if (finalDoctorList.first.docId == '') {
          finalDoctorList.clear();

          final rxDcrDataModel = RxDcrDataModel(
              uid: const Uuid().v1(),
              docName: uniqueIdForImage().toString(),
              docId: '',
              areaId: '',
              areaName: 'areaName',
              address: 'address',
              presImage: imagePath!.path,
              rxSmallImage: rxSmallImage!.path, //for small size image
              rxMedicineList: [],
              rxType: dropdownRxTypevalue);
          finalDoctorList.add(rxDcrDataModel); // add to list

          rxDcrBox.add(rxDcrDataModel); // add to draft

          setState(() {});
        } else {
          finalDoctorList[0].presImage = imagePath!.path;
          finalDoctorList[0].rxSmallImage = rxSmallImage!.path;
          setState(() {});
        }
      } else if (imagePath != null && widget.isRxEdit) {
        await GallerySaver.saveImage(imagePath!.path); // image save to gallery
        finalDoctorList[0].presImage = imagePath!.path;
        finalDoctorList[0].rxSmallImage = rxSmallImage!.path;
        finalImage = imagePath!.path;
        setState(() {});
      }
    }
  }

  ///*********************************gallery function*****************************************///

  Future<void> _galleryFunctionality() async {
    file = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 90,
      //preferredCameraDevice: CameraDevice.rear,
      // maxHeight: 800,
      // maxWidth: 700,
    );
    if (file != null) {
      // file;
      imagePath = File(file!.path);
      rxSmallImage = await RxServices.compress2(image: imagePath!);
      if (imagePath != null &&
          rxSmallImage != null &&
          widget.isRxEdit == false) {
        // await GallerySaver.saveImage(imagePath!.path); // image save to gallery
        if (finalDoctorList.isEmpty) {
          final rxDcrDataModel = RxDcrDataModel(
              uid: const Uuid().v1(),
              docName: uniqueIdForImage().toString(),
              docId: '',
              areaId: '',
              areaName: 'areaName',
              address: 'address',
              presImage: imagePath!.path,
              rxSmallImage: rxSmallImage!.path, //for small size image
              rxMedicineList: [],
              rxType: dropdownRxTypevalue);
          finalDoctorList.add(rxDcrDataModel); // add to list

          rxDcrBox.add(rxDcrDataModel); // add to draft

          setState(() {});
        } else if (finalDoctorList.first.docId == '') {
          finalDoctorList.clear();

          final rxDcrDataModel = RxDcrDataModel(
              uid: const Uuid().v1(),
              docName: uniqueIdForImage().toString(),
              docId: '',
              areaId: '',
              areaName: 'areaName',
              address: 'address',
              presImage: imagePath!.path,
              rxSmallImage: rxSmallImage!.path, //for small size image
              rxMedicineList: [],
              rxType: dropdownRxTypevalue);
          finalDoctorList.add(rxDcrDataModel); // add to list

          rxDcrBox.add(rxDcrDataModel); // add to draft

          setState(() {});
        } else {
          finalDoctorList[0].presImage = imagePath!.path;
          finalDoctorList[0].rxSmallImage = rxSmallImage!.path;
          setState(() {});
        }
      } else if (imagePath != null && widget.isRxEdit) {
        // await GallerySaver.saveImage(imagePath!.path); // image save to gallery
        finalDoctorList[0].presImage = imagePath!.path;
        finalDoctorList[0].rxSmallImage = rxSmallImage!.path;
        finalImage = imagePath!.path;
        rxShortImage = rxSmallImage!.path;
        setState(() {});
      }
    }
  }
}

class ZoomForRxImage extends StatelessWidget {
  final File? img;
  const ZoomForRxImage(this.img, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
              tag: 'img',
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
  final String? draftFinalImage;
  const ZoomForRxDraftImage(this.draftFinalImage, {super.key});

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
