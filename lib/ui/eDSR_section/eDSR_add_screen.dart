import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/ui/eDSR_section/eDSR_add_preview_screen.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final GlobalKey<FormState> _form1Key = GlobalKey();
  TextEditingController noOfPatientController = TextEditingController();
  TextEditingController addDescriptionController = TextEditingController();
  TextEditingController issueToController = TextEditingController(text: "");
  TextEditingController rxPerDayController = TextEditingController();
  TextEditingController dSrController = TextEditingController();
  TextEditingController emrRXController = TextEditingController();
  TextEditingController p4RXController = TextEditingController();
  TextEditingController doctorMobileNumberController = TextEditingController();
  final brandSelectedController = TextEditingController();

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
  final RegExp phoneRegex = RegExp(r'^\d{13}$');
  bool isMobileUpdate = false;

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    eDSRSettingsData = Boxes.geteDSRsetData().get("eDSRSettingsData")!;
    doctorMobileNumberController.text = widget.docInfo[widget.index]["mobile"];

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
    String newDsrType = (dsrType == "OTHERS") ? "DCC" : dsrType;
    ePurposeList = eDSRSettingsData!.purposeList
        .where((e) => e.dsrCategory == categoryName! && e.dsrType == newDsrType)
        .map((e) => e.purposeName)
        .toList();
    //print("dsrType1=========================$newDsrType");
    dsrType = dsrType;
    // print("dsrType1  =========================$dsrType");
    initialSubPurpose = null;
    eSubpurposeList = [];
  }

  //================================ get sub Purpose List=====================================
  getEDsrSubPurposeList(String purposeId, String category, String doctorType) {
    String newDsrType = (doctorType == "OTHERS") ? "DCC" : doctorType;
    eSubpurposeList = eDSRSettingsData!.subPurposeList
        .where((element) =>
            element.sDsrCategory == category &&
            element.sDsrType == newDsrType &&
            element.sPurposeId == purposeId)
        .map((e) => e.sPurposeSubName)
        .toList();
    doctorType = doctorType;
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
    brandSelectedController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  Padding(
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
                                  child: Form(
                                    key: _form1Key,
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
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.1,
                                          height: 45,
                                          child: TextFormField(
                                            keyboardType: TextInputType.number,
                                            controller:
                                                doctorMobileNumberController,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.deny(
                                                RegExp(r'^\d{14,}$'),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Mobile Number is required";
                                              }
                                              if (value.length < 11 ||
                                                  value.length > 13 ||
                                                  value.length == 12) {
                                                return "Mobile Number should be  11 or 13 digits";
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: InkWell(
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              170,
                                                              172,
                                                              170),
                                                    ),
                                                    child: const Center(
                                                        child: Text("Cancel",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                            ))),
                                                  ),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    doctorMobileNumberController
                                                        .text = widget
                                                            .docInfo[
                                                        widget.index]["mobile"];
                                                  }),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: InkWell(
                                                  child: Container(
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      color:
                                                          const Color.fromARGB(
                                                              255, 44, 114, 66),
                                                    ),
                                                    child: const Center(
                                                        child: Text("Update",
                                                            style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      255,
                                                                      255,
                                                                      255),
                                                            ))),
                                                  ),
                                                  onTap: () async {
                                                    if (_form1Key.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        isMobileUpdate = true;
                                                      });
                                                      bool result =
                                                          await InternetConnectionChecker()
                                                              .hasConnection;
                                                      if (result == true) {
                                                        Map<String, dynamic>
                                                            responsData =
                                                            await EDSRRepositories().getMobileNumberUpdation(
                                                                dmpathData!
                                                                    .submitUrl,
                                                                cid!,
                                                                userInfo!
                                                                    .userId,
                                                                userPassword,
                                                                widget.docInfo[
                                                                        widget
                                                                            .index]
                                                                    ["doc_id"],
                                                                doctorType!,
                                                                doctorMobileNumberController
                                                                    .text,
                                                                widget.docInfo[
                                                                        widget
                                                                            .index]
                                                                    [
                                                                    "area_id"]);
                                                        if (responsData
                                                            .isNotEmpty) {
                                                          if (responsData[
                                                                  "status"] ==
                                                              "Success") {
                                                            widget.docInfo[widget
                                                                        .index]
                                                                    ["mobile"] =
                                                                doctorMobileNumberController
                                                                    .text;
                                                            setState(() {
                                                              isMobileUpdate =
                                                                  false;
                                                            });
                                                            AllServices()
                                                                .toastMessage(
                                                                    responsData[
                                                                        "ret_str"],
                                                                    Colors
                                                                        .green,
                                                                    Colors
                                                                        .white,
                                                                    14);

                                                            if (!mounted) {
                                                              return;
                                                            }
                                                            Navigator.pop(
                                                                context);
                                                          } else {
                                                            setState(() {
                                                              isMobileUpdate =
                                                                  false;
                                                            });
                                                            AllServices()
                                                                .toastMessage(
                                                                    responsData[
                                                                        "ret_str"],
                                                                    Colors.red,
                                                                    Colors
                                                                        .white,
                                                                    14);
                                                          }
                                                        } else {
                                                          setState(() {
                                                            isMobileUpdate =
                                                                false;
                                                          });
                                                        }
                                                      } else {
                                                        setState(() {
                                                          isMobileUpdate =
                                                              false;
                                                        });
                                                        AllServices()
                                                            .toastMessage(
                                                                interNetErrorMsg,
                                                                Colors.red,
                                                                Colors.white,
                                                                16);
                                                      }
                                                    }
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

                                  purposeId = '';
                                  subPurposeId = '';

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
                                                    child:
                                                        SingleChildScrollView(
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
                                                          Row(
                                                            children: [
                                                              StatefulBuilder(
                                                                builder: (context,
                                                                    setState2) {
                                                                  return DropdownButtonHideUnderline(
                                                                    child:
                                                                        DropdownButton2(
                                                                      isExpanded:
                                                                          true,
                                                                      iconEnabledColor:
                                                                          const Color(
                                                                              0xff8AC995),
                                                                      hint:
                                                                          Text(
                                                                        'Select Brand',
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color:
                                                                              Theme.of(context).hintColor,
                                                                        ),
                                                                      ),
                                                                      items: eBrandList!
                                                                          .map((item) => DropdownMenuItem<String>(
                                                                                value: item,
                                                                                child: Text(
                                                                                  item,
                                                                                  style: const TextStyle(
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              ))
                                                                          .toList(),
                                                                      value:
                                                                          initialBrand,
                                                                      onChanged:
                                                                          (value) {
                                                                        setState2(
                                                                            () {
                                                                          initialBrand =
                                                                              value;
                                                                        });
                                                                      },
                                                                      buttonHeight:
                                                                          50,
                                                                      buttonWidth:
                                                                          MediaQuery.of(context).size.width /
                                                                              1.5,
                                                                      itemHeight:
                                                                          40,
                                                                      dropdownMaxHeight:
                                                                          252,
                                                                      searchController:
                                                                          brandSelectedController,
                                                                      searchInnerWidgetHeight:
                                                                          50,
                                                                      searchInnerWidget:
                                                                          Container(
                                                                        height:
                                                                            50,
                                                                        padding:
                                                                            const EdgeInsets.only(
                                                                          top:
                                                                              8,
                                                                          bottom:
                                                                              4,
                                                                          right:
                                                                              8,
                                                                          left:
                                                                              8,
                                                                        ),
                                                                        child:
                                                                            TextFormField(
                                                                          expands:
                                                                              true,
                                                                          maxLines:
                                                                              null,
                                                                          controller:
                                                                              brandSelectedController,
                                                                          decoration:
                                                                              InputDecoration(
                                                                            isDense:
                                                                                true,
                                                                            contentPadding:
                                                                                const EdgeInsets.symmetric(
                                                                              horizontal: 6,
                                                                              vertical: 8,
                                                                            ),
                                                                            hintText:
                                                                                'Search Brand here...',
                                                                            hintStyle:
                                                                                const TextStyle(fontSize: 14),
                                                                            border:
                                                                                OutlineInputBorder(
                                                                              borderRadius: BorderRadius.circular(8),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      searchMatchFn:
                                                                          (item,
                                                                              searchValue) {
                                                                        return (item
                                                                            .value
                                                                            .toString()
                                                                            .startsWith(searchValue.toUpperCase()));
                                                                      },
                                                                      onMenuStateChange:
                                                                          (isOpen) {
                                                                        if (!isOpen) {
                                                                          brandSelectedController
                                                                              .clear();
                                                                        }
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ],
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
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(
                                                                    RegExp(
                                                                        "[A-Za-z0-9]"),
                                                                  ),
                                                                ],
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
                                                                        BorderRadius.circular(
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
                                                              "EMR RX*",
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
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(
                                                                    RegExp(
                                                                        "[A-Za-z0-9]"),
                                                                  ),
                                                                ],
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
                                                                        BorderRadius.circular(
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
                                                                inputFormatters: [
                                                                  FilteringTextInputFormatter
                                                                      .allow(
                                                                    RegExp(
                                                                        "[A-Za-z0-9]"),
                                                                  ),
                                                                ],
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
                                                                        BorderRadius.circular(
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
                                                              "DSR*",
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
                                                                        BorderRadius.circular(
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
                                                                      height:
                                                                          40,
                                                                      //width: 160,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: const Color.fromARGB(
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
                                                                      height:
                                                                          40,
                                                                      //width: 160,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(10),
                                                                        color: const Color.fromARGB(
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
                                                                        if (emrRXController.text !=
                                                                            '') {
                                                                          if (p4RXController.text !=
                                                                              "") {
                                                                            dynamicRowsListForBrand.add([
                                                                              initialBrand,
                                                                              rxPerDayController.text == "" ? "0" : rxPerDayController.text,
                                                                              dSrController.text == "" ? "0" : dSrController.text,
                                                                              emrRXController.text,
                                                                              p4RXController.text
                                                                            ]);

                                                                            finalBrandListAftrRemoveDuplication =
                                                                                removeDuplicationForBrand(dynamicRowsListForBrand);

                                                                            Navigator.pop(context);
                                                                            setState(() {
                                                                              initialBrand = null;
                                                                              rxPerDayController.clear();
                                                                              dSrController.clear();
                                                                              emrRXController.clear();
                                                                              p4RXController.clear();
                                                                            });
                                                                          } else {
                                                                            AllServices().toastMessage(
                                                                                "Please Enter 4P RX ",
                                                                                Colors.red,
                                                                                Colors.white,
                                                                                16);
                                                                          }
                                                                        } else {
                                                                          AllServices().toastMessage(
                                                                              "Please Enter EMR RX ",
                                                                              Colors.red,
                                                                              Colors.white,
                                                                              16);
                                                                        }
                                                                      } else {
                                                                        AllServices().toastMessage(
                                                                            "Please Select Brand First",
                                                                            Colors.red,
                                                                            Colors.white,
                                                                            16);
                                                                      }
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
                                                        : "Monthly Avg.Sales**",
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
                                                    "EMR RX",
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
                                                child: const Center(
                                                  child: Text(
                                                    "DSR",
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
                              height: 10,
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
                                if (value == "APC" ||
                                    value == "CT" ||
                                    value == "CC") {
                                  isCheck = true;
                                  int indexNo = widget.docInfo[widget.index]
                                          ["doc_name"]
                                      .indexOf("(");
                                  issueToController.text =
                                      "${widget.docInfo[widget.index]["doc_name"].replaceRange(indexNo, widget.docInfo[widget.index]["doc_name"].length, "")}";
                                } else {
                                  isCheck = false;
                                  issueToController.clear();
                                }
                                setState(() {
                                  initialIssueMode = value!;
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
                            SizedBox(
                              height: isCheck == true ? 6 : 0,
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
                            SizedBox(
                              height: isCheck == true ? 2 : 0,
                            ),
                            isCheck == true
                                ? const Text(
                                    "**Please Fill With The Correct Name**",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  )
                                : const SizedBox()
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
                                      color: const Color.fromARGB(
                                          255, 44, 114, 66),
                                    ),
                                    child: const Center(
                                        child: Text("Preview",
                                            style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                            ))),
                                  ),
                                  onTap: () async {
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
                                                                                                            ? readyForPreviewMethod()
                                                                                                            : AllServices().toastMessage("Enter Issue To First", Colors.red, Colors.white, 16)
                                                                                                        : readyForPreviewMethod()
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
                                  }),
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

  readyForPreviewMethod() {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> readyForPreviewData = {
      "submit_url": dmpathData!.submitUrl,
      "cid": cid!,
      "userId": userInfo!.userId,
      "password": password,
      "brandString": brandString,
      "area_id": widget.docInfo[widget.index]["area_id"],
      "doc_id": widget.docInfo[widget.index]["doc_id"],
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "doc_name": widget.docInfo[widget.index]["doc_name"],
      "degree": widget.docInfo[widget.index]["degree"],
      "specialty": widget.docInfo[widget.index]["specialty"],
      "address": widget.docInfo[widget.index]["address"],
      "mobile": widget.docInfo[widget.index]["mobile"],
      "Category": initialCategory,
      "purposeName": initialPurpose,
      "purposeId": purposeId,
      "Sub_purpose_Name": initialSubPurpose,
      "Sub_purpose": subPurposeId,
      "Descripton": addDescriptionController.text,
      "RX_Duration_from_Name": initialRxDurationMonthList,
      "RX_Duration_from": rxFromDate,
      "RX_Duration_to": rxToDate,
      "RX_Duration_to_name": initialRxDurationMonthListTo,
      "DSR_Schedule": initialPaySchdedule,
      "DSR_Duration_from_name": initialdsrDurationMonthList,
      "DSR_Duration_from": dsrFromdate,
      "DSR_Duration_to": dsrTodate,
      "DSR_Duration_to_name": initialdsrDurationMonthListTo,
      "Number_of_Patient": noOfPatientController.text,
      "Issue_Mode": initialIssueMode,
      "Issue_To": issueToController.text,
      "Brand": finalBrandListAftrRemoveDuplication,
      "dsr_type": doctorType
    };

    if (readyForPreviewData.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PreviewEDSRADDScreen(
            previewData: readyForPreviewData,
          ),
        ),
      );
    }
  }
}
