import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
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
  TextEditingController addModeDescripController = TextEditingController();

  EdsrDataModel? eDSRSettingsData;
  List<BrandList>? eBrandList = [];
  List<String> eCatergoryList = [];
  List<String> ePayModeList = [];
  List<String> ePayScheduleList = [];
  List<String> ePurposeList = [];
  List<String> eSubpurposeList = [];
  List<String> eRxDurationMonthList = [];
  List<String> eRxDurationMonthListTo = [];
  List<String> eDsrDurationMonthList = [];
  List<String> eDsrDurationMonthListTo = [];

  String? initialBrand;
  String? initialCategory;
  String? initialPurpose;
  String? initialSubPurpose;
  String? initialPayMode;
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
  //var prefs;

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
    });
  }

  //===============================All Settings Data get Method============================
  allSettingsDataGet(EdsrDataModel? eDSRsettingsData) {
    eCatergoryList = eDSRsettingsData!.categoryList;

    ePayModeList = eDSRSettingsData!.payModeList;
    ePayScheduleList = eDSRSettingsData!.payScheduleList;
    eBrandList = eDSRsettingsData.brandList;
    eRxDurationMonthList =
        eDSRSettingsData!.rxDurationMonthList.map((e) => e.nextDateV).toList();
    eDsrDurationMonthList =
        eDSRsettingsData.dsrDurationMonthList.map((e) => e.nextDateV).toList();
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
    return eRxDurationMonthListTo;
  }

  //============================  get dsrDurationMonthList ==========================
  List<String> getDsrDurationMonthListTo(String value) {
    int selectedIndex = eDsrDurationMonthList.indexOf(value);
    eDsrDurationMonthListTo = [];
    if (selectedIndex == -1) {
      eDsrDurationMonthListTo = [];
    } else {
      eDsrDurationMonthListTo = eDsrDurationMonthList.sublist(selectedIndex);
      initialdsrDurationMonthListTo = eDsrDurationMonthListTo.first;
    }
    return eDsrDurationMonthListTo;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xff8AC995),
        title: const Text(
          "eDSR Add",
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(Icons.person, size: 40, color: Color(0xff8AC995)),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.docInfo[widget.index]["doc_name"]}",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${widget.docInfo[widget.index]["address"]}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 64, 64, 64)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 25,
              ),

              SizedBox(
                child: SingleChildScrollView(
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
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButton<String>(
                                value: initialCategory,
                                hint: const Text("Select Category"),
                                items: eCatergoryList.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: Text(item)),
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
                                height: ePurposeList.isNotEmpty ? 15 : 0,
                              ),
                              ePurposeList.isNotEmpty
                                  ? const Text(
                                      "Select Purpose",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.w600),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: ePurposeList.isNotEmpty ? 5 : 0,
                              ),
                              ePurposeList.isNotEmpty
                                  ? DropdownButton<String>(
                                      value: initialPurpose,
                                      hint: const Text("Select Purpose"),
                                      items: ePurposeList.map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              child: Text(item)),
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
                                      height: 15,
                                    )
                                  : const SizedBox(),
                              eSubpurposeList.isNotEmpty
                                  ? const Text(
                                      "Select Sub-purpose",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.w600),
                                    )
                                  : const SizedBox(),
                              SizedBox(
                                height: eSubpurposeList.isNotEmpty ? 5 : 0,
                              ),
                              eSubpurposeList.isNotEmpty
                                  ? DropdownButton<String>(
                                      //isExpanded: true,
                                      value: initialSubPurpose,
                                      hint: const Text("Select Sub-purpose"),
                                      items: eSubpurposeList.map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  1.2,
                                              child: Text(item)),
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
                                              // print(
                                              //     "rx data======================$dsrFromdate   $dsrTodate");
                                            }
                                          }
                                        });
                                      },
                                    )
                                  : const SizedBox(),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Select DSR Schedule*",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButton<String>(
                                value: initialPaySchdedule,
                                hint: const Text("Select Pay Schedule*"),
                                items: ePayScheduleList.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: Text(item)),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    initialPaySchdedule = value!;
                                  });
                                },
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Number Of Patient*",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 35,
                                  child: TextField(
                                    controller: noOfPatientController,
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Add Descripton*",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 35,
                                  child: TextField(
                                    controller: addDescriptionController,
                                  )),
                              const SizedBox(
                                height: 15,
                              ),
                              const Text(
                                "Select RX Duration*",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: initialRxDurationMonthList,
                                    hint: const Text("Select  Schedule"),
                                    items:
                                        eRxDurationMonthList.map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.9,
                                            child: Text(item)),
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
                                            // print(
                                            //     "rx data======================$rxFromDate   $rxToDate");
                                          }
                                        }
                                      });
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
                                    value: initialRxDurationMonthListTo,
                                    hint: const Text("Select  Schedule"),
                                    items: eRxDurationMonthListTo
                                        .map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.9,
                                            child: Text(item)),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        initialRxDurationMonthListTo = value!;
                                        for (var date in eDSRSettingsData!
                                            .rxDurationMonthList) {
                                          if (date.nextDateV == value) {
                                            rxToDate = date.nextDate;
                                            // print(
                                            //     "rx data to======================$rxFromDate   $rxToDate");
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
                                "Select DSR Duration*",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  DropdownButton<String>(
                                    value: initialdsrDurationMonthList,
                                    hint: const Text("Select DSR From"),
                                    items: eDsrDurationMonthList
                                        .map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.9,
                                            child: Text(item)),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        initialdsrDurationMonthList = value!;
                                        getDsrDurationMonthListTo(value);
                                        for (var date in eDSRSettingsData!
                                            .dsrDurationMonthList) {
                                          if (date.nextDateV == value) {
                                            dsrFromdate = date.nextDate;
                                            dsrTodate = date.nextDate;

                                            // print(
                                            //     "rx data======================$dsrFromdate   $dsrTodate");
                                          }
                                        }
                                      });
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
                                    value: initialdsrDurationMonthListTo,
                                    hint: const Text("Select DSR To"),
                                    items: eDsrDurationMonthListTo
                                        .map((String item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2.9,
                                            child: Text(item)),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        initialdsrDurationMonthListTo = value!;
                                        for (var date in eDSRSettingsData!
                                            .dsrDurationMonthList) {
                                          if (date.nextDateV == value) {
                                            dsrTodate = date.nextDate;
                                            // print(
                                            //     "rx data======================$dsrFromdate   $dsrTodate");
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
                                "Select Mode",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              DropdownButton<String>(
                                value: initialPayMode,
                                hint: const Text("Select Pay Mode"),
                                items: ePayModeList.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: Text(item)),
                                  );
                                }).toList(),
                                onChanged: (String? value) {
                                  setState(() {
                                    initialPayMode = value!;
                                  });
                                },
                              ),
                              SizedBox(
                                height: initialPayMode != null ? 15 : 0,
                              ),
                              initialPayMode != null
                                  ? const Text(
                                      "Mode Description*",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(255, 0, 0, 0),
                                          fontWeight: FontWeight.w600),
                                    )
                                  : const SizedBox(),
                              initialPayMode != null
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.1,
                                      height: 35,
                                      child: TextField(
                                        controller: addModeDescripController,
                                      ))
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 170,
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
                      onTap: () {},
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 170,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 44, 114, 66),
                        ),
                        child: const Center(
                            child: Text("Continue",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))),
                      ),
                      onTap: () {
                        eDseSubmit();
                      },
                    ),
                  ],
                ),
              )
              // TextFormField()
            ],
          ),
        ),
      ),
    );
  }

  //eDseSubmit() {}
  //=============================================== get Territory Based Doctor Button (Api call)================================
  eDseSubmit() async {
    String data = await eDSRRepository().submitEDSR(
        dmpathData!.submitUrl,
        cid!,
        userInfo!.userId,
        password!,
        "123",
        "AGGRA|4|500",
        widget.docInfo[widget.index]["area_id"],
        widget.docInfo[widget.index]["doc_name"],
        widget.docInfo[widget.index]["doc_id"],
        initialCategory!,
        "0",
        "0",
        doctorType!,
        initialCategory!,
        purposeId,
        subPurposeId,
        noOfPatientController.text,
        rxFromDate,
        rxToDate,
        noOfPatientController.text,
        dsrFromdate,
        dsrTodate,
        initialPaySchdedule!,
        "0",
        initialPayMode!,
        "",
        "0");
    print("submit data===========$data");
    // if (data["res_data"]["status"] == "Success") {
    //List doctorData = data["res_data"]["doctorList"];

    //   result = doctorData;
    //   doctroList.clear();

    //   for (var disco in result) {
    //     box?.add(disco);
    //   }
    //   widget.callbackData["dsr_Type"] = initialDoctorType;
    //   widget.callbackData["Region"] = initialRegion;
    //   widget.callbackData["Area"] = initialDocroeArea;
    //   widget.callbackData["Territory"] = initialTerritory;
    //   widget.callbackFuc(widget.callbackData);

    //   var pref = await SharedPreferences.getInstance();
    //   pref.setString("Region", regionID);
    //   pref.setString("Area", areaID);
    //   pref.setString("Territory", terrorID);
    //   pref.setString("DoctorType", initialDoctorType!);
    // } else {
    //   Fluttertoast.showToast(
    //       msg: '${data["res_data"]["ret_str"]}',
    //       toastLength: Toast.LENGTH_LONG,
    //       gravity: ToastGravity.BOTTOM,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
  }
}
