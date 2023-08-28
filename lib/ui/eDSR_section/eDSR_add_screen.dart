import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/ui/eDSR_section/eDCR_screen.dart';
import 'package:flutter/material.dart';
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
  List dynamicRowsListForBrand = [];

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

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    eDSRSettingsData = Boxes.geteDSRsetData().get("eDSRSettingsData")!;
    allSettingsDataGet(eDSRSettingsData);
    SharedPreferences.getInstance().then((prefs) {
      password = prefs.getString("PASSWORD") ?? '';
      cid = prefs.getString("CID") ?? '';
      doctorType = prefs.getString("DoctorType") ?? '';
      territoryid = prefs.getString("Territory") ?? '';
    });
  }

  //===============================All Settings Data get Method============================
  allSettingsDataGet(EdsrDataModel? eDSRsettingsData) {
    eCatergoryList = eDSRsettingsData!.categoryList;

    ePayModeList = eDSRSettingsData!.payModeList;
    ePayScheduleList = eDSRSettingsData!.payScheduleList;
    eBrandList = eDSRsettingsData.brandList.map((e) => e.brandName).toList();
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
      if (dynamicRowsListForBrand.isNotEmpty) {
        for (int i = 0; i < dynamicRowsListForBrand.length; i++) {
          if (element1.brandName == dynamicRowsListForBrand[i][0]) {
            if (brandString == "") {
              brandString +=
                  "${element1.brandId}|${element1.brandName}|${dynamicRowsListForBrand[i][1]}|${dynamicRowsListForBrand[i][2]}";
            } else {
              brandString +=
                  "||${element1.brandId}|${element1.brandName}|${dynamicRowsListForBrand[i][1]}|${dynamicRowsListForBrand[i][2]}";
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

  @override
  void dispose() {
    noOfPatientController.dispose();
    addDescriptionController.dispose();
    issueToController.dispose();
    rxPerDayController.dispose();
    dSrController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xff8AC995),
        title: const Text(
          "eDSR Add",
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottom),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(Icons.person,
                        size: 40, color: Color(0xff8AC995)),
                    const SizedBox(
                      width: 10,
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
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),

                SizedBox(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Select Category*",
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
                                        width:
                                            MediaQuery.of(context).size.width /
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
                              const SizedBox(
                                height: 10,
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
                                  const SizedBox(
                                    width: 250,
                                  ),
                                  Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: const Color(0xff8AC995),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return SizedBox(
                                                    child: AlertDialog(
                                                      title: const Text(
                                                          "Brand Details"),
                                                      content: SizedBox(
                                                        height: 300,
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
                                                              child:
                                                                  ButtonTheme(
                                                                alignedDropdown:
                                                                    true,
                                                                child:
                                                                    DropdownButtonFormField<
                                                                        String>(
                                                                  isExpanded:
                                                                      true,
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
                                                                              FontWeight.w600)),
                                                                  items: eBrandList!
                                                                      .map((String
                                                                          item) {
                                                                    return DropdownMenuItem<
                                                                        String>(
                                                                      value:
                                                                          item,
                                                                      child: SizedBox(
                                                                          width: MediaQuery.of(context).size.width /
                                                                              1.2,
                                                                          child: Text(
                                                                              item,
                                                                              style: const TextStyle(fontSize: 14))),
                                                                    );
                                                                  }).toList(),
                                                                  onChanged:
                                                                      (String?
                                                                          value) {
                                                                    setState(
                                                                        () {
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
                                                            const Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                "RX/Day*",
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
                                                                      rxPerDayController,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    border:
                                                                        OutlineInputBorder(
                                                                      borderSide:
                                                                          const BorderSide(
                                                                              color: Colors.white),
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
                                                                              color: Colors.white),
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
                                                                      child: Container(
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
                                                                        Navigator.pop(
                                                                            context);
                                                                      }),
                                                                ),
                                                                const SizedBox(
                                                                  width: 15,
                                                                ),
                                                                Expanded(
                                                                  child: InkWell(
                                                                      child: Container(
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
                                                                          dynamicRowsListForBrand
                                                                              .add([
                                                                            initialBrand,
                                                                            rxPerDayController.text == ""
                                                                                ? "0"
                                                                                : rxPerDayController.text,
                                                                            dSrController.text == ""
                                                                                ? "0"
                                                                                : dSrController.text
                                                                          ]);

                                                                          Navigator.pop(
                                                                              context);
                                                                          setState(
                                                                              () {
                                                                            initialBrand =
                                                                                null;
                                                                            rxPerDayController.clear();
                                                                            dSrController.clear();
                                                                          });
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
                              dynamicRowsListForBrand.isNotEmpty
                                  ? Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8, bottom: 8),
                                      child: Column(
                                        children: [
                                          Container(
                                            color: const Color(0xff8AC995),
                                            child: Row(
                                              children: const [
                                                SizedBox(
                                                  width: 75,
                                                  height: 35,
                                                  child: Center(
                                                    child: Text(
                                                      "Name",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                  child: SizedBox(
                                                    width: 75,
                                                    height: 35,
                                                    child: Center(
                                                      child: Text(
                                                        "Rx/Day",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                  child: SizedBox(
                                                    width: 75,
                                                    height: 35,
                                                    child: Center(
                                                      child: Text(
                                                        "DSR",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    left: 20,
                                                  ),
                                                  child: SizedBox(
                                                    width: 75,
                                                    height: 35,
                                                    child: Center(
                                                      child: Text(
                                                        "Action",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                dynamicRowsListForBrand.length *
                                                    35,
                                            width: 360,
                                            child: ListView.builder(
                                                itemCount:
                                                    dynamicRowsListForBrand
                                                        .length,
                                                itemBuilder: (context, index) {
                                                  return Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 75,
                                                        height: 35,
                                                        child: Center(
                                                          child: Text(
                                                            dynamicRowsListForBrand[
                                                                index][0],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                              color: Color
                                                                  .fromARGB(255,
                                                                      0, 0, 0),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 20,
                                                        ),
                                                        child: SizedBox(
                                                          width: 75,
                                                          height: 35,
                                                          child: Center(
                                                            child: Text(
                                                              dynamicRowsListForBrand[
                                                                              index]
                                                                          [1] ==
                                                                      ""
                                                                  ? "0"
                                                                  : dynamicRowsListForBrand[
                                                                      index][1],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 20,
                                                        ),
                                                        child: SizedBox(
                                                          width: 75,
                                                          height: 35,
                                                          child: Center(
                                                            child: Text(
                                                              dynamicRowsListForBrand[
                                                                              index]
                                                                          [2] ==
                                                                      ""
                                                                  ? "0"
                                                                  : dynamicRowsListForBrand[
                                                                      index][2],
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 14,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        0,
                                                                        0,
                                                                        0),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                          left: 20,
                                                        ),
                                                        child: SizedBox(
                                                          width: 75,
                                                          height: 35,
                                                          child: Center(
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_forever,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              onPressed: () {
                                                                dynamicRowsListForBrand
                                                                    .removeAt(
                                                                        index);
                                                                //removePerItem();

                                                                setState(() {});
                                                                print(
                                                                    "dynamicRowsListForBrand========================$dynamicRowsListForBrand");
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          )
                                        ],
                                      ),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: ePurposeList.isNotEmpty ? 10 : 0,
                              ),
                              ePurposeList.isNotEmpty
                                  ? const Text(
                                      "Select Purpose",
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
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              )),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() {
                                          initialPurpose = value!;
                                          for (var data in eDSRSettingsData!
                                              .purposeList) {
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
                                      "Select Sub-purpose",
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
                                      hint: const Text("Select Sub-purpose",
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
                                                style: const TextStyle(
                                                    fontSize: 14),
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
                                                  sPurpose.sPurposeId;
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: TextFormField(
                                    controller: addDescriptionController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Select RX Duration*",
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
                                    hint: const Text("Select  Schedule",
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
                                            rxFromDate = date.nextDate;
                                            rxToDate = date.nextDate;
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
                                    hint: const Text("Select  Schedule",
                                        style: TextStyle(fontSize: 14)),
                                    items: eRxDurationMonthListTo
                                        .map((String item) {
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
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Select DSR Schedule*",
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
                                        width:
                                            MediaQuery.of(context).size.width /
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
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Select DSR Duration*",
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
                                    items: eDsrDurationMonthList
                                        .map((String item) {
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
                                          dsrFromdate = date.nextDate;
                                          dsrTodate = date.nextDate;
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
                              const SizedBox(
                                height: 15,
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
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: noOfPatientController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                  )),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Select Issue Mode*",
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: Text(item,
                                            style:
                                                const TextStyle(fontSize: 14))),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    initialIssueMode = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: initialIssueMode != null ? 10 : 0,
                              ),
                              initialIssueMode != null
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
                              initialIssueMode != null
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
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

                SizedBox(
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
                                      color: Color.fromARGB(255, 44, 114, 66),
                                      width: 2,
                                    ),
                                    bottom: BorderSide(
                                      color: Color.fromARGB(255, 44, 114, 66),
                                      width: 2,
                                    ),
                                    left: BorderSide(
                                      color: Color.fromARGB(255, 44, 114, 66),
                                      width: 2,
                                    ),
                                    right: BorderSide(
                                      color: Color.fromARGB(255, 44, 114, 66),
                                      width: 2,
                                    ),
                                  )),
                              child: const Center(
                                  child: Text("Back",
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 44, 114, 66),
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
                                color: const Color.fromARGB(255, 44, 114, 66),
                              ),
                              child: const Center(
                                  child: Text("Continue",
                                      style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ))),
                            ),
                            onTap: () {
                              getbrandString() != ""
                                  ? widget.docInfo[widget.index]["area_id"] !=
                                          ""
                                      ? widget.docInfo[widget.index]
                                                  ["doc_id"] !=
                                              ""
                                          ? widget.docInfo[widget.index]
                                                      ["doc_name"] !=
                                                  ""
                                              ? initialCategory != null
                                                  ? initialCategory != null
                                                      ? purposeId != ""
                                                          ? subPurposeId != ""
                                                              ? addDescriptionController
                                                                          .text !=
                                                                      ""
                                                                  ? rxFromDate !=
                                                                          ""
                                                                      ? rxToDate !=
                                                                              ""
                                                                          ? initialPaySchdedule != null
                                                                              ? dsrFromdate != ""
                                                                                  ? dsrTodate != ""
                                                                                      ? noOfPatientController.text != ""
                                                                                          ? initialIssueMode != null
                                                                                              ? issueToController.text != ""
                                                                                                  ? eDsrSubmit()
                                                                                                  : AllServices().toastMessage("Enter Issue To First", Colors.red, Colors.white, 16)
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
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                // TextFormField()
              ],
            ),
          ),
        ),
      ),
    );
  }

  //=============================================== get Territory Based Doctor Button (Api call)================================
  eDsrSubmit() async {
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
        "0",
        "0",
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

    print("submit data===========$data");
    if (data["status"] == "Success") {
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.green, Colors.white, 16);
      if (!mounted) return;
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const EDcrScreen()));
    } else {
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.red, Colors.white, 16);
    }
  }
}
