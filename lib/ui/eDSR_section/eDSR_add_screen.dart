import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/ui/eDSR_section/eDCR_screen.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EDSRScreen extends StatefulWidget {
  List<dynamic> docInfo;
  String dsrType;
  int index;
  EDSRScreen(
      {super.key,
      required this.docInfo,
      required this.index,
      required this.dsrType});

  @override
  State<EDSRScreen> createState() => _EDSRScreenState();
}

class _EDSRScreenState extends State<EDSRScreen> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  TextEditingController noOfPatientController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();
  TextEditingController issueToController = TextEditingController();
  TextEditingController rxPerDayController = TextEditingController();
  TextEditingController dSrController = TextEditingController();
  TextEditingController emrRXController = TextEditingController();
  TextEditingController p4RXController = TextEditingController();
  TextEditingController doctorMobileNumberController = TextEditingController();

  EdsrDataModel? eDSRSettingsData;
  List<String>? eBrandList = [];
  List<String> eCatergoryList = [];
  List<String> ePayModeList = [];
  List<String> ePayScheduleList = [];
  List<String> ePurposeList = [];
  List<String> eSubpurposeList = [];
  List<String> eRxDurationMonthList = [];
  List<String> eRxDurationMonthListTo = [];
  List<String> eDsrDurationMonthList = [];
  List<String> eDsrDurationMonthListTo = [];
  List<List<dynamic>> dynamicRowsListForBrand = [];
  List<List<dynamic>> finalBrandListAftrRemoveDuplication = [];

  String? initialBrand;
  String? initialCategory;
  String? initialPurpose;
  String? initialSubPurpose;
  String? initialIssueMode;
  String? initialPaySchdedule;
  String? initialRxDurationMonthList;
  String? initialRxDurationMonthListTo;
  String? initialdsrDurationMonthList;
  String? initialdsrDurationMonthListTo;

  String? cid;
  String? password;

  String categoryId = "";
  String purposeId = "";
  String subPurposeId = "";
  String? doctorType;
  String dsrFromdate = '';
  String dsrTodate = '';
  String rxFromDate = '';
  String rxToDate = '';
  String brandString = '';
  String territoryid = '';
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLoading = false;
  bool isAPC = false;
  bool isCheck = false;

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    eDSRSettingsData = Boxes.geteDSRsetData().get("eDSRSettingsData")!;
    print(
        "mobile number ===============${widget.docInfo[widget.index]["mobile"]}");

    allSettingsDataGet(eDSRSettingsData);

    SharedPreferences.getInstance().then((prefs) {
      password = prefs.getString("PASSWORD") ?? '';
      cid = prefs.getString("CID") ?? '';
      doctorType = prefs.getString("DoctorType") ?? '';
      territoryid = prefs.getString("Territory") ?? '';
      latitude = prefs.getDouble("latitude") ?? 0.0;
      longitude = prefs.getDouble("longitude") ?? 0.0;
    });
  }

  //===============================All Settings Data get Method============================
  allSettingsDataGet(EdsrDataModel? eDSRsettingsData) {
    eCatergoryList = eDSRSettingsData!.categoryList;
    ePayModeList = eDSRSettingsData!.payModeList;
    ePayScheduleList = eDSRSettingsData!.payScheduleList;
    eBrandList = eDSRsettingsData!.brandList.map((e) => e.brandName).toList();
    eRxDurationMonthList =
        eDSRSettingsData!.rxDurationMonthList.map((e) => e.nextDateV).toList();
  }

  //================================ get Purpose List=====================================
  getEDsrPurposeList(String dsrType, String? categoryName) {
    ePurposeList = eDSRSettingsData!.purposeList
        .where((e) => e.dsrCategory == categoryName! && e.dsrType == dsrType)
        .map((e) => e.purposeName)
        .toList();
    initialSubPurpose = null;
    eSubpurposeList = [];
  }

  //================================ get sub Purpose List=====================================
  getEDsrSubPurposeList(String purposeId, String category, String doctorType) {
    eSubpurposeList = eDSRSettingsData!.subPurposeList
        .where((element) =>
            element.sDsrCategory == category &&
            element.sDsrType == doctorType &&
            element.sPurposeId == purposeId)
        .map((e) => e.sPurposeSubName)
        .toList();
  }

  //============================  get rxDurationMonthList ==========================
  List<String> getRXDurationMonthListTo(String value) {
    int selectedIndex = eRxDurationMonthList.indexOf(value);
    eRxDurationMonthListTo = [];
    if (selectedIndex == -1) {
      eRxDurationMonthListTo = [];
    } else {
      eRxDurationMonthListTo = eRxDurationMonthList.sublist(selectedIndex);
      initialRxDurationMonthListTo = eRxDurationMonthListTo.first;
    }
    setState(() {});
    return eRxDurationMonthListTo;
  }

  //============================  get dsrDurationMonthList from ==========================
  getDSRDurationMonthListFrom() {
    eDsrDurationMonthList =
        eDSRSettingsData!.dsrDurationMonthList.map((e) => e.nextDateV).toList();
    setState(() {});
  }

  //============================  get dsrDurationMonthList to ==========================
  List<String> getDsrDurationMonthListTo(String value) {
    int selectedIndex = eDsrDurationMonthList.indexOf(value);
    eDsrDurationMonthListTo = [];

    if (selectedIndex == -1) {
      eDsrDurationMonthListTo = [];
    } else {
      if (initialPaySchdedule == "MONTHLY") {
        eDsrDurationMonthListTo = eDsrDurationMonthList.sublist(selectedIndex);
        initialdsrDurationMonthListTo = eDsrDurationMonthListTo.first;
      } else {
        eDsrDurationMonthListTo =
            eDsrDurationMonthList.sublist(selectedIndex, selectedIndex + 1);
        initialdsrDurationMonthListTo = eDsrDurationMonthListTo.first;
      }
    }
    setState(() {});
    return eDsrDurationMonthListTo;
  }

  //=============================== get brand String ===============================
  String getbrandString() {
    brandString = '';

    for (var element1 in eDSRSettingsData!.brandList) {
      if (finalBrandListAftrRemoveDuplication.isNotEmpty) {
        for (int i = 0; i < finalBrandListAftrRemoveDuplication.length; i++) {
          if (element1.brandName == finalBrandListAftrRemoveDuplication[i][0]) {
            if (brandString == "") {
              brandString +=
                  "${element1.brandId}|${element1.brandName}|${finalBrandListAftrRemoveDuplication[i][1]}|${finalBrandListAftrRemoveDuplication[i][2]}|${finalBrandListAftrRemoveDuplication[i][3]}|${finalBrandListAftrRemoveDuplication[i][4]}";
            } else {
              brandString +=
                  "||${element1.brandId}|${element1.brandName}|${finalBrandListAftrRemoveDuplication[i][1]}|${finalBrandListAftrRemoveDuplication[i][2]}|${finalBrandListAftrRemoveDuplication[i][3]}|${finalBrandListAftrRemoveDuplication[i][4]}";
            }
          }
        }
      } else {
        brandString = "";
      }
    }
    setState(() {});
    return brandString;
  }

  // String _validatePhoneNumber(String value) {
  //   final RegExp _validPhoneNumber = RegExp(r'^\d{11,13}$');
  //   if (!_validPhoneNumber.hasMatch(value)) {
  //     return 'Invalid phone number (11 to 13 digits required)';
  //   }
  //   return null;
  // }

  //=============================== Unique brand List ===============================
  List<List<dynamic>> removeDuplicationForBrand(
      List<List<dynamic>> actualBrandList) {
    Map<String, List<dynamic>> uniqueBrandMap = {};
    for (var subList in actualBrandList) {
      uniqueBrandMap[subList[0]] = subList;
    }
    return uniqueBrandMap.values.toList();
  }

  @override
  void dispose() {
    noOfPatientController.dispose();
    addDescriptionController.dispose();
    issueToController.dispose();
    rxPerDayController.dispose();
    dSrController.dispose();
    p4RXController.dispose();
    emrRXController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    double wholeHeight = MediaQuery.of(context).size.height;
    double wholeWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff8AC995),
        title: const Text(
          "eDSR Add",
        ),
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              SizedBox(
                height: wholeHeight / 75.927,
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 40, color: Color(0xff8AC995)),
                  SizedBox(
                    width: wholeWidth / 39.272,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "${widget.docInfo[widget.index]["doc_name"]}|${widget.docInfo[widget.index]["degree"]}|${widget.docInfo[widget.index]["specialty"]}",
                          style: const TextStyle(
                              fontSize: 16,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${widget.docInfo[widget.index]["address"]}|$territoryid",
                          style: const TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 64, 64, 64)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${widget.docInfo[widget.index]["mobile"]}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 64, 64, 64)),
                        ),
                      ],
                    ),
                  ),
                  widget.docInfo[widget.index]["mobile"] == "0"
                      ? Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: IconButton(
                            icon: const Icon(Icons.edit,
                                size: 20, color: Color(0xff8AC995)),
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      scrollable: true,
                                      title: Center(
                                          child: Text(
                                              "${widget.docInfo[widget.index]["doc_name"]}")),
                                      content: SizedBox(
                                        height: 150,
                                        child: FormBuilder(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 15,
                                              ),
                                              const Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Mobile Number*",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              FormBuilderTextField(
                                                key: _formKey,
                                                name: 'phone_number',
                                                decoration:
                                                    const InputDecoration(
                                                        labelText:
                                                            'Phone Number'),
                                                validator: (val) {
                                                  if (val != null &&
                                                      val.isNotEmpty) {
                                                    final RegExp phoneRegex =
                                                        RegExp(r'^\d{13}$');
                                                    if (!phoneRegex
                                                        .hasMatch(val)) {
                                                      return 'Invalid phone number format';
                                                    }
                                                  }
                                                  return null;
                                                },
                                              ),
                                              // SizedBox(
                                              //   width: MediaQuery.of(context)
                                              //           .size
                                              //           .width /
                                              //       1.1,
                                              //   height: 45,
                                              //   child: FormBuilderTextField(
                                              //     name: 'phone_number',
                                              //     decoration: InputDecoration(
                                              //         labelText:
                                              //             'Phone Number'),
                                              //     validator:
                                              //         FormBuilderValidators
                                              //             .compose([
                                              //       FormBuilderValidators
                                              //           .required(context),
                                              //       (val) {
                                              //         if (val != null &&
                                              //             val.isNotEmpty) {
                                              //           final RegExp
                                              //               phoneRegex =
                                              //               RegExp(r'^\d{13}$');
                                              //           if (!phoneRegex
                                              //               .hasMatch(val)) {
                                              //             return 'Invalid phone number format';
                                              //           }
                                              //         }
                                              //         return null;
                                              //       },
                                              //     ]),
                                              //   ),
                                              //   // child:FormBuilderTextField(
                                              //   //         attribute: 'phone_number',
                                              //   //         decoration: InputDecoration(labelText: 'Phone Number'),
                                              //   //         validators: [
                                              //   //           FormBuilderValidators.required(),
                                              //   //           (val) {
                                              //   //             if (val != null && val.isNotEmpty) {
                                              //   //               // Define a regular expression for a 13-digit phone number.
                                              //   //               final RegExp phoneRegex = RegExp(r'^\d{13}$');

                                              //   //               if (!phoneRegex.hasMatch(val)) {
                                              //   //                 return 'Invalid phone number format';
                                              //   //               }
                                              //   //             }
                                              //   //             return null;
                                              //   //           },
                                              //   // //                               child: TextFormField(
                                              //   // // attribute: 'phone_number',
                                              //   // // decoration: InputDecoration(labelText: 'Phone Number'),
                                              //   // // validators: [
                                              //   // //   FormBuilderValidators.required(),
                                              //   // //   (val) {
                                              //   // //     if (val != null && val.isNotEmpty) {
                                              //   // //       // Define a regular expression for a 13-digit phone number.
                                              //   // //       final RegExp phoneRegex = RegExp(r'^\d{13}$');

                                              //   // //       if (!phoneRegex.hasMatch(val)) {
                                              //   // //         return 'Invalid phone number format';
                                              //   // //       }
                                              //   // //     }
                                              //   // //     return null;
                                              //   // //   },
                                              //   // // child: TextFormField(
                                              //   // //   keyboardType:
                                              //   // //       TextInputType.number,
                                              //   // //   controller:
                                              //   // //       doctorMobileNumberController,
                                              //   // //   onChanged: (v) {
                                              //   // //     if (RegExp(r"\s").hasMatch(
                                              //   // //         doctorMobileNumberController
                                              //   // //             .text)) {
                                              //   // //       doctorMobileNumberController
                                              //   // //               .text =
                                              //   // //           doctorMobileNumberController
                                              //   // //               .text
                                              //   // //               .substring(
                                              //   // //                   0,
                                              //   // //                   doctorMobileNumberController
                                              //   // //                           .text
                                              //   // //                           .length -
                                              //   // //                       1);

                                              //   // //       doctorMobileNumberController
                                              //   // //               .selection =
                                              //   // //           TextSelection.collapsed(
                                              //   // //               offset:
                                              //   // //                   doctorMobileNumberController
                                              //   // //                       .text
                                              //   // //                       .length);

                                              //   // //       ScaffoldMessenger.of(
                                              //   // //               context)
                                              //   // //           .showSnackBar(
                                              //   // //         const SnackBar(
                                              //   // //           content: Text(
                                              //   // //               "Please do not type space"),
                                              //   // //           duration: Duration(
                                              //   // //               milliseconds: 200),
                                              //   // //         ),
                                              //   // //       );
                                              //   // //     }
                                              //   // //   },
                                              //   //   // validators: [
                                              //   //   //   FormBuilderValidators
                                              //   //   //       .required(),
                                              //   //   //   (val) {
                                              //   //   //     if (val != null &&
                                              //   //   //         val.isNotEmpty) {
                                              //   //   //       // Define a regular expression for a 13-digit phone number.
                                              //   //   //       final RegExp
                                              //   //   //           phoneRegex =
                                              //   //   //           RegExp(r'^\d{13}$');

                                              //   //   //       if (!phoneRegex
                                              //   //   //           .hasMatch(val)) {
                                              //   //   //         return 'Invalid phone number format';
                                              //   //   //       }
                                              //   //   //     }
                                              //   //   //     return null;
                                              //   //   //   },
                                              //   //   // ],
                                              //   //   // inputFormatters: [
                                              //   //   //   FilteringTextInputFormatter
                                              //   //   //       .digitsOnly,
                                              //   //   //   LengthLimitingTextInputFormatter(
                                              //   //   //       13), // Maximum of 13 digits
                                              //   //   //   TextInputFormatter
                                              //   //   //       .withFunction(
                                              //   //   //     (oldValue, newValue) {
                                              //   //   //       print(
                                              //   //   //           "okkkkkkkkkkkkkkkkkkkk");
                                              //   //   //       final RegExp
                                              //   //   //           _phoneNumberRegExp =
                                              //   //   //           RegExp(
                                              //   //   //               r'^\d{11,13}$');
                                              //   //   //       // Validate against the RegExp
                                              //   //   //       if (_phoneNumberRegExp
                                              //   //   //           .hasMatch(
                                              //   //   //               newValue.text)) {
                                              //   //   //         return newValue;
                                              //   //   //       }
                                              //   //   //       return oldValue;
                                              //   //   //     },
                                              //   //   //   ),
                                              //   //   // ],
                                              //   //   // validator: (value) {
                                              //   //   //   final RegExp
                                              //   //   //       _validPhoneNumber =
                                              //   //   //       RegExp(r'^\d{11,13}$');
                                              //   //   //   if (value == null ||
                                              //   //   //       !_validPhoneNumber
                                              //   //   //           .hasMatch(value)) {
                                              //   //   //     return 'Invalid phone number (11 to 13 digits required)';
                                              //   //   //   }
                                              //   //   //   return null;
                                              //   //   // },
                                              //   //   decoration, name: '',: InputDecoration(
                                              //   //     border: OutlineInputBorder(
                                              //   //       borderSide:
                                              //   //           const BorderSide(
                                              //   //               color:
                                              //   //                   Colors.white),
                                              //   //       borderRadius:
                                              //   //           BorderRadius.circular(
                                              //   //               5.0),
                                              //   //     ),
                                              //   //   ),
                                              //   // ),
                                              // ),
                                              // const SizedBox(
                                              //   height: 15,
                                              // ),
                                              // const Align(
                                              //   alignment: Alignment.centerLeft,
                                              //   child: Text(
                                              //     "Customer ID",
                                              //     style: TextStyle(
                                              //         fontWeight: FontWeight.w500),
                                              //   ),
                                              // ),
                                              // const SizedBox(
                                              //   height: 5,
                                              // ),
                                              // SizedBox(
                                              //     width: MediaQuery.of(context)
                                              //             .size
                                              //             .width /
                                              //         1.1,
                                              //     height: 45,
                                              //     child: TextFormField(
                                              //       keyboardType: TextInputType.number,
                                              //       decoration: InputDecoration(
                                              //         border: OutlineInputBorder(
                                              //           borderSide: const BorderSide(
                                              //               color: Colors.white),
                                              //           borderRadius:
                                              //               BorderRadius.circular(5.0),
                                              //         ),
                                              //       ),
                                              //     )),
                                              // const SizedBox(
                                              //   height: 15,
                                              // ),
                                              // const Align(
                                              //   alignment: Alignment.centerLeft,
                                              //   child: Text(
                                              //     "4P ID",
                                              //     style: TextStyle(
                                              //         fontWeight: FontWeight.w500),
                                              //   ),
                                              // ),
                                              // const SizedBox(
                                              //   height: 5,
                                              // ),
                                              // SizedBox(
                                              //     width: MediaQuery.of(context)
                                              //             .size
                                              //             .width /
                                              //         1.1,
                                              //     height: 45,
                                              //     child: TextFormField(
                                              //       keyboardType: TextInputType.number,
                                              //       decoration: InputDecoration(
                                              //         border: OutlineInputBorder(
                                              //           borderSide: const BorderSide(
                                              //               color: Colors.white),
                                              //           borderRadius:
                                              //               BorderRadius.circular(5.0),
                                              //         ),
                                              //       ),
                                              //     )),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                        child: Container(
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                170,
                                                                172,
                                                                170),
                                                          ),
                                                          child: const Center(
                                                              child: Text(
                                                                  "Cancel",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                  ))),
                                                        ),
                                                        onTap: () {}),
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  Expanded(
                                                    child: InkWell(
                                                        child: Container(
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            color: const Color
                                                                    .fromARGB(
                                                                255,
                                                                44,
                                                                114,
                                                                66),
                                                          ),
                                                          child: const Center(
                                                              child: Text(
                                                                  "Update",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            255,
                                                                            255,
                                                                            255),
                                                                  ))),
                                                        ),
                                                        onTap: () {
                                                          widget.docInfo[widget
                                                                      .index]
                                                                  ["mobile"] =
                                                              doctorMobileNumberController
                                                                  .text;
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              SizedBox(
                height: wholeHeight / 25.309,
              ),
              SizedBox(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Category*",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButton<String>(
                              iconEnabledColor: const Color(0xff8AC995),
                              value: initialCategory,
                              hint: const Text(
                                "Select Category",
                                style: TextStyle(fontSize: 14),
                              ),
                              items: eCatergoryList.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: Text(
                                        item,
                                        style: const TextStyle(fontSize: 14),
                                      )),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  initialCategory = value!;

                                  initialPurpose = null;
                                  initialSubPurpose = null;
                                  ePurposeList = [];
                                  eSubpurposeList = [];

                                  initialPurpose = null;
                                  initialSubPurpose = null;
                                  ePurposeList = [];
                                  eSubpurposeList = [];

                                  getEDsrPurposeList(
                                      doctorType!, initialCategory);
                                });
                              },
                            ),
                            SizedBox(
                              height: wholeHeight / 75.927,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Brand",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  width: wholeWidth / 1.45,
                                ),
                                Container(
                                  height: wholeHeight / 18.98,
                                  width: wholeWidth / 9.8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xff8AC995),
                                  ),
                                  child: Center(
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  scrollable: true,
                                                  title: const Text(
                                                      "Brand Details"),
                                                  content: SizedBox(
                                                    height: 470,
                                                    child: Column(
                                                      children: [
                                                        const Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "Brand*",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        DropdownButtonHideUnderline(
                                                          child: ButtonTheme(
                                                            alignedDropdown:
                                                                true,
                                                            child:
                                                                DropdownButtonFormField<
                                                                    String>(
                                                              isExpanded: true,
                                                              iconEnabledColor:
                                                                  const Color(
                                                                      0xff8AC995),
                                                              value:
                                                                  initialBrand,
                                                              hint: const Text(
                                                                  "Select Brand",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600)),
                                                              items: eBrandList!
                                                                  .map((String
                                                                      item) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: item,
                                                                  child: SizedBox(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          1.2,
                                                                      child: Text(
                                                                          item,
                                                                          style:
                                                                              const TextStyle(fontSize: 14))),
                                                                );
                                                              }).toList(),
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {
                                                                  initialBrand =
                                                                      value!;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            doctorType ==
                                                                    "DOCTOR"
                                                                ? "RX/Day*"
                                                                : "Sales Objective*",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 45,
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  rxPerDayController,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              Colors.white),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            )),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        const Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "EMR_RX*",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 45,
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  emrRXController,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              Colors.white),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            )),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        const Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            "4P RX*",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 45,
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  p4RXController,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              Colors.white),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            )),
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                            doctorType ==
                                                                    "DOCTOR"
                                                                ? "DSR*"
                                                                : "Monthly Avg.Sales*",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.1,
                                                            height: 45,
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                  dSrController,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderSide:
                                                                      const BorderSide(
                                                                          color:
                                                                              Colors.white),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              5.0),
                                                                ),
                                                              ),
                                                            )),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: InkWell(
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    //width: 160,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          170,
                                                                          172,
                                                                          170),
                                                                    ),
                                                                    child: const Center(
                                                                        child: Text("Cancel",
                                                                            style: TextStyle(
                                                                              color: Color.fromARGB(255, 255, 255, 255),
                                                                            ))),
                                                                  ),
                                                                  onTap: () {
                                                                    initialBrand =
                                                                        null;
                                                                    rxPerDayController
                                                                        .clear();
                                                                    dSrController
                                                                        .clear();
                                                                    Navigator.pop(
                                                                        context);
                                                                  }),
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            Expanded(
                                                              child: InkWell(
                                                                  child:
                                                                      Container(
                                                                    height: 40,
                                                                    //width: 160,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              10),
                                                                      color: const Color
                                                                              .fromARGB(
                                                                          255,
                                                                          44,
                                                                          114,
                                                                          66),
                                                                    ),
                                                                    child: const Center(
                                                                        child: Text("Add",
                                                                            style: TextStyle(
                                                                              color: Color.fromARGB(255, 255, 255, 255),
                                                                            ))),
                                                                  ),
                                                                  onTap: () {
                                                                    if (initialBrand !=
                                                                        null) {
                                                                      dynamicRowsListForBrand
                                                                          .add([
                                                                        initialBrand,
                                                                        rxPerDayController.text ==
                                                                                ""
                                                                            ? "0"
                                                                            : rxPerDayController.text,
                                                                        dSrController.text ==
                                                                                ""
                                                                            ? "0"
                                                                            : dSrController.text,
                                                                        emrRXController
                                                                            .text,
                                                                        p4RXController
                                                                            .text
                                                                      ]);

                                                                      finalBrandListAftrRemoveDuplication =
                                                                          removeDuplicationForBrand(
                                                                              dynamicRowsListForBrand);

                                                                      Navigator.pop(
                                                                          context);
                                                                      setState(
                                                                          () {
                                                                        initialBrand =
                                                                            null;
                                                                        rxPerDayController
                                                                            .clear();
                                                                        dSrController
                                                                            .clear();
                                                                        emrRXController
                                                                            .clear();
                                                                        p4RXController
                                                                            .clear();
                                                                      });
                                                                    } else {
                                                                      AllServices().toastMessage(
                                                                          "Please Select Brand First",
                                                                          Colors
                                                                              .red,
                                                                          Colors
                                                                              .white,
                                                                          16);
                                                                    }
                                                                  }),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                        )),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            dynamicRowsListForBrand.isNotEmpty
                                ? Column(
                                    children: [
                                      Container(
                                        color: const Color(0xff8AC995),
                                        width: wholeWidth / 1.073,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: wholeWidth / 7,
                                              height: wholeHeight / 25.309,
                                              child: const Center(
                                                child: Text(
                                                  "Name",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: SizedBox(
                                                width: wholeWidth / 7,
                                                height: wholeHeight / 25.309,
                                                child: Center(
                                                  child: Text(
                                                    doctorType == "DOCTOR"
                                                        ? "Rx/Day"
                                                        : "Sales Objective*",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: SizedBox(
                                                width: wholeWidth / 7,
                                                height: wholeHeight / 25.309,
                                                child: const Center(
                                                  child: Text(
                                                    "EMR_RX",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: SizedBox(
                                                width: wholeWidth / 7,
                                                height: wholeHeight / 25.309,
                                                child: const Center(
                                                  child: Text(
                                                    "4P RX",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: SizedBox(
                                                width: wholeWidth / 7,
                                                height: wholeHeight / 25.309,
                                                child: Center(
                                                  child: Text(
                                                    doctorType == "DOCTOR"
                                                        ? "DSR"
                                                        : "Monthly Avg.Sales*",
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 5,
                                              ),
                                              child: SizedBox(
                                                width: wholeWidth / 7,
                                                height: wholeHeight / 25.309,
                                                child: const Center(
                                                  child: Text(
                                                    "Action",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Color.fromARGB(
                                                            255, 0, 0, 0),
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            finalBrandListAftrRemoveDuplication
                                                    .length *
                                                40,
                                        width: wholeWidth / 1.073,
                                        child: ListView.builder(
                                            itemCount:
                                                finalBrandListAftrRemoveDuplication
                                                    .length,
                                            itemBuilder: (context, index) {
                                              return SizedBox(
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: wholeWidth / 7,
                                                      height:
                                                          wholeHeight / 25.309,
                                                      child: Center(
                                                        child: Text(
                                                          finalBrandListAftrRemoveDuplication[
                                                              index][0],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child: SizedBox(
                                                        width: wholeWidth / 7,
                                                        height: wholeHeight /
                                                            25.309,
                                                        child: Center(
                                                          child: Text(
                                                            finalBrandListAftrRemoveDuplication[
                                                                            index]
                                                                        [1] ==
                                                                    ""
                                                                ? "0"
                                                                : finalBrandListAftrRemoveDuplication[
                                                                    index][1],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child: SizedBox(
                                                        width: wholeWidth / 7,
                                                        height: wholeHeight /
                                                            25.309,
                                                        child: Center(
                                                          child: Text(
                                                            finalBrandListAftrRemoveDuplication[
                                                                index][3],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child: SizedBox(
                                                        width: wholeWidth / 7,
                                                        height: wholeHeight /
                                                            25.309,
                                                        child: Center(
                                                          child: Text(
                                                            finalBrandListAftrRemoveDuplication[
                                                                index][4],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child: SizedBox(
                                                        width: wholeWidth / 7,
                                                        height: wholeHeight /
                                                            25.309,
                                                        child: Center(
                                                          child: Text(
                                                            finalBrandListAftrRemoveDuplication[
                                                                            index]
                                                                        [2] ==
                                                                    ""
                                                                ? "0"
                                                                : finalBrandListAftrRemoveDuplication[
                                                                    index][2],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 13,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child: SizedBox(
                                                        width: wholeWidth / 7,
                                                        height: wholeHeight /
                                                            25.309,
                                                        child: Center(
                                                          child: IconButton(
                                                            icon: const Icon(
                                                              Icons
                                                                  .delete_forever,
                                                              color: Colors.red,
                                                            ),
                                                            onPressed: () {
                                                              dynamicRowsListForBrand
                                                                  .removeAt(
                                                                      index);
                                                              finalBrandListAftrRemoveDuplication
                                                                  .removeAt(
                                                                      index);

                                                              setState(() {});
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: ePurposeList.isNotEmpty ? 10 : 0,
                            ),
                            ePurposeList.isNotEmpty
                                ? const Text(
                                    "Purpose*",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w600),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: ePurposeList.isNotEmpty ? 5 : 0,
                            ),
                            ePurposeList.isNotEmpty
                                ? DropdownButton<String>(
                                    iconEnabledColor: const Color(0xff8AC995),
                                    value: initialPurpose,
                                    hint: const Text("Select Purpose",
                                        style: TextStyle(fontSize: 14)),
                                    items: ePurposeList.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            child: Text(
                                              item,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            )),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        initialPurpose = value!;
                                        for (var data
                                            in eDSRSettingsData!.purposeList) {
                                          if (data.purposeName == value) {
                                            purposeId = data.purposeId;
                                          }
                                        }
                                        initialSubPurpose = null;
                                        eSubpurposeList = [];
                                        getEDsrSubPurposeList(purposeId,
                                            initialCategory!, doctorType!);
                                      });
                                    },
                                  )
                                : const SizedBox(),
                            eSubpurposeList.isNotEmpty
                                ? const SizedBox(
                                    height: 10,
                                  )
                                : const SizedBox(),
                            eSubpurposeList.isNotEmpty
                                ? const Text(
                                    "Sub-purpose*",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w600),
                                  )
                                : const SizedBox(),
                            SizedBox(
                              height: eSubpurposeList.isNotEmpty ? 5 : 0,
                            ),
                            eSubpurposeList.isNotEmpty
                                ? DropdownButton<String>(
                                    iconEnabledColor: const Color(0xff8AC995),
                                    value: initialSubPurpose,
                                    hint: const Text("Sub-purpose",
                                        style: TextStyle(fontSize: 14)),
                                    items: eSubpurposeList.map((
                                      String item,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.2,
                                            child: Text(
                                              item,
                                              style:
                                                  const TextStyle(fontSize: 14),
                                            )),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        initialSubPurpose = value!;
                                        for (var sPurpose in eDSRSettingsData!
                                            .subPurposeList) {
                                          if (sPurpose.sPurposeSubName ==
                                              value) {
                                            subPurposeId =
                                                sPurpose.sPurposeSubId;
                                          }
                                        }
                                      });
                                    },
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 0,
                            ),
                            const Text(
                              "Add Descripton*",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 1.1,
                                height: 45,
                                child: TextFormField(
                                  controller: addDescriptionController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "RX Duration*",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                DropdownButton<String>(
                                  iconEnabledColor: const Color(0xff8AC995),
                                  value: initialRxDurationMonthList,
                                  hint: const Text("Select RX From",
                                      style: TextStyle(fontSize: 14)),
                                  items:
                                      eRxDurationMonthList.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.9,
                                          child: Text(
                                            item,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          )),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      initialRxDurationMonthList = value!;

                                      getRXDurationMonthListTo(value);
                                      for (var date in eDSRSettingsData!
                                          .rxDurationMonthList) {
                                        if (date.nextDateV == value) {
                                          if (date.nextDate == "-") {
                                            rxFromDate = '';
                                            rxToDate = '';
                                          } else {
                                            rxFromDate = date.nextDate;
                                            rxToDate = date.nextDate;
                                          }
                                        }
                                      }
                                    });
                                  },
                                ),
                                const Text(
                                  "   To   ",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w600),
                                ),
                                DropdownButton<String>(
                                  iconEnabledColor: const Color(0xff8AC995),
                                  value: initialRxDurationMonthListTo,
                                  hint: const Text("Select RX to",
                                      style: TextStyle(fontSize: 14)),
                                  items:
                                      eRxDurationMonthListTo.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.9,
                                          child: Text(
                                            item,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          )),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      initialRxDurationMonthListTo = value!;
                                      for (var date in eDSRSettingsData!
                                          .rxDurationMonthList) {
                                        if (date.nextDateV == value) {
                                          rxToDate = date.nextDate;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: wholeHeight / 50.618,
                            ),
                            const Text(
                              "DSR Schedule*",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButton<String>(
                              iconEnabledColor: const Color(0xff8AC995),
                              value: initialPaySchdedule,
                              hint: const Text("Select DSR Schedule*",
                                  style: TextStyle(fontSize: 14)),
                              items: ePayScheduleList.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: Text(
                                        item,
                                        style: const TextStyle(fontSize: 14),
                                      )),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                initialPaySchdedule = value!;
                                eDsrDurationMonthList = [];
                                eDsrDurationMonthListTo = [];
                                initialdsrDurationMonthListTo = null;
                                initialdsrDurationMonthList = null;
                                dsrFromdate = "";
                                dsrTodate = "";

                                getDSRDurationMonthListFrom();
                                setState(() {});
                              },
                            ),
                            SizedBox(
                              height: wholeHeight / 50.618,
                            ),
                            const Text(
                              "DSR Duration*",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                DropdownButton<String>(
                                  iconEnabledColor: const Color(0xff8AC995),
                                  value: initialdsrDurationMonthList,
                                  hint: const Text("Select DSR From",
                                      style: TextStyle(fontSize: 14)),
                                  items:
                                      eDsrDurationMonthList.map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.9,
                                          child: Text(
                                            item,
                                            style:
                                                const TextStyle(fontSize: 14),
                                          )),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    initialdsrDurationMonthList = value!;
                                    eDsrDurationMonthListTo = [];
                                    getDsrDurationMonthListTo(value);

                                    for (var date in eDSRSettingsData!
                                        .dsrDurationMonthList) {
                                      if (date.nextDateV == value) {
                                        if (date.nextDate == "-") {
                                          dsrFromdate = '';
                                          dsrTodate = '';
                                        } else {
                                          dsrFromdate = date.nextDate;
                                          dsrTodate = date.nextDate;
                                        }
                                      }
                                    }
                                    setState(() {});
                                  },
                                ),
                                const Text(
                                  "   To   ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      fontWeight: FontWeight.w600),
                                ),
                                DropdownButton<String>(
                                  iconEnabledColor: const Color(0xff8AC995),
                                  value: initialdsrDurationMonthListTo,
                                  hint: const Text("Select DSR To",
                                      style: TextStyle(fontSize: 14)),
                                  items: eDsrDurationMonthListTo
                                      .map((String item) {
                                    return DropdownMenuItem<String>(
                                      value: item,
                                      child: SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.9,
                                          child: Text(item,
                                              style: const TextStyle(
                                                  fontSize: 14))),
                                    );
                                  }).toList(),
                                  onChanged: (String? value) {
                                    setState(() {
                                      initialdsrDurationMonthListTo = value!;
                                      for (var date in eDSRSettingsData!
                                          .dsrDurationMonthList) {
                                        if (date.nextDateV == value) {
                                          dsrTodate = date.nextDate;
                                        }
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: wholeHeight / 50.618,
                            ),
                            const Text(
                              "Number Of Patient*",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 1.1,
                                height: 45,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: noOfPatientController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderSide:
                                          const BorderSide(color: Colors.white),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Issue Mode*",
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            DropdownButton<String>(
                              iconEnabledColor: const Color(0xff8AC995),
                              value: initialIssueMode,
                              hint: const Text("Select Issue Mode",
                                  style: TextStyle(fontSize: 14)),
                              items: ePayModeList.map((String item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: Text(item,
                                          style:
                                              const TextStyle(fontSize: 14))),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                if (value == "APC" || value == "CT") {
                                  isCheck = true;
                                } else {
                                  isCheck = false;
                                }
                                setState(() {
                                  initialIssueMode = value!;
                                  issueToController.clear();
                                });
                              },
                            ),
                            SizedBox(
                              height: initialIssueMode != null ? 10 : 0,
                            ),
                            isCheck == true
                                ? const Text(
                                    "Issue To*",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w600),
                                  )
                                : const SizedBox(),
                            const SizedBox(
                              height: 6,
                            ),
                            isCheck == true
                                ? SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1.1,
                                    height: 45,
                                    child: TextFormField(
                                      controller: issueToController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.white),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                    ))
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              isLoading == false
                  ? SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  height: 55,
                                  //width: 160,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: const Border(
                                        top: BorderSide(
                                          color:
                                              Color.fromARGB(255, 44, 114, 66),
                                          width: 2,
                                        ),
                                        bottom: BorderSide(
                                          color:
                                              Color.fromARGB(255, 44, 114, 66),
                                          width: 2,
                                        ),
                                        left: BorderSide(
                                          color:
                                              Color.fromARGB(255, 44, 114, 66),
                                          width: 2,
                                        ),
                                        right: BorderSide(
                                          color:
                                              Color.fromARGB(255, 44, 114, 66),
                                          width: 2,
                                        ),
                                      )),
                                  child: const Center(
                                      child: Text("Cancel",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 44, 114, 66),
                                          ))),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Expanded(
                              child: InkWell(
                                child: Container(
                                  height: 55,
                                  //width: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        const Color.fromARGB(255, 44, 114, 66),
                                  ),
                                  child: const Center(
                                      child: Text("Submit",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          ))),
                                ),
                                onTap: () async {
                                  bool result =
                                      await InternetConnectionChecker()
                                          .hasConnection;
                                  if (result == true) {
                                    getbrandString() != ""
                                        ? widget.docInfo[widget.index]
                                                    ["area_id"] !=
                                                ""
                                            ? widget.docInfo[widget.index]
                                                        ["doc_id"] !=
                                                    ""
                                                ? widget.docInfo[widget.index]
                                                            ["doc_name"] !=
                                                        ""
                                                    ? initialCategory != null
                                                        ? initialCategory !=
                                                                null
                                                            ? purposeId != ""
                                                                ? subPurposeId !=
                                                                        ""
                                                                    ? addDescriptionController.text !=
                                                                            ""
                                                                        ? rxFromDate !=
                                                                                ""
                                                                            ? rxToDate != ""
                                                                                ? initialPaySchdedule != null
                                                                                    ? dsrFromdate != ""
                                                                                        ? dsrTodate != ""
                                                                                            ? noOfPatientController.text != ""
                                                                                                ? initialIssueMode != null
                                                                                                    ? isCheck == true
                                                                                                        ? issueToController.text != ""
                                                                                                            ? eDsrSubmit()
                                                                                                            : AllServices().toastMessage("Enter Issue To First", Colors.red, Colors.white, 16)
                                                                                                        : eDsrSubmit()
                                                                                                    : AllServices().toastMessage("Select Issue Mode First", Colors.red, Colors.white, 16)
                                                                                                : AllServices().toastMessage("Enter The No of Patient First", Colors.red, Colors.white, 16)
                                                                                            : AllServices().toastMessage("Select DSR Duration To First", Colors.red, Colors.white, 16)
                                                                                        : AllServices().toastMessage("Select DSR Duration From First", Colors.red, Colors.white, 16)
                                                                                    : AllServices().toastMessage("Select DSR Schdule First", Colors.red, Colors.white, 16)
                                                                                : AllServices().toastMessage("Select Rx Duration To First", Colors.red, Colors.white, 16)
                                                                            : AllServices().toastMessage("Select Rx Duration From First", Colors.red, Colors.white, 16)
                                                                        : AllServices().toastMessage("Enter Description First", Colors.red, Colors.white, 16)
                                                                    : AllServices().toastMessage("Select Sub-Purpose First", Colors.red, Colors.white, 16)
                                                                : AllServices().toastMessage("Select Purpose First", Colors.red, Colors.white, 16)
                                                            : AllServices().toastMessage("Select Category First", Colors.red, Colors.white, 16)
                                                        : AllServices().toastMessage("Select Category First", Colors.red, Colors.white, 16)
                                                    : AllServices().toastMessage("Doctor Doctor ID Missing", Colors.red, Colors.white, 16)
                                                : AllServices().toastMessage("Doctor Name ID Missing", Colors.red, Colors.white, 16)
                                            : AllServices().toastMessage("Doctor Area ID Missing", Colors.red, Colors.white, 16)
                                        : AllServices().toastMessage("Please Select Brand First", Colors.red, Colors.white, 16);
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });
                                    AllServices().toastMessage(interNetErrorMsg,
                                        Colors.red, Colors.white, 16);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const CircularProgressIndicator()
            ],
          ),
        ),
      ),
    );
  }

  //=============================================== get Territory Based Doctor Button (Api call)================================
  eDsrSubmit() async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> data = await EDSRRepositories().submitEDSR(
        dmpathData!.submitUrl,
        cid!,
        userInfo!.userId,
        password!,
        "123",
        brandString,
        widget.docInfo[widget.index]["area_id"],
        widget.docInfo[widget.index]["doc_id"],
        widget.docInfo[widget.index]["doc_name"],
        "",
        latitude.toString(),
        longitude.toString(),
        doctorType!,
        initialCategory!,
        purposeId,
        subPurposeId,
        addDescriptionController.text,
        rxFromDate,
        rxToDate,
        noOfPatientController.text,
        dsrFromdate,
        dsrTodate,
        initialPaySchdedule!,
        "0",
        initialIssueMode!,
        "",
        "0",
        issueToController.text);
    if (data["status"] == "Success") {
      setState(() {
        isLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.green, Colors.white, 16);
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      setState(() {
        isLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.red, Colors.white, 16);
    }
  }
}
