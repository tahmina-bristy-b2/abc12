// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EDsrDoctorSelection extends StatefulWidget {
  final Map<String, dynamic> callbackData;
  Function(Map<String, dynamic>) callbackFuc;
  EDsrDoctorSelection({required this.callbackData, required this.callbackFuc});

  @override
  State<EDsrDoctorSelection> createState() => _EDsrDoctorSelectionState();
}

class _EDsrDoctorSelectionState extends State<EDsrDoctorSelection> {
  Box? box;

  List<RegionList> regionList = [];

  List<RegionList> filterRegionList = [];
  List<AreaList> areaListoregion = [];
  List<TerritoryList> territoryListM = [];

  DmPathDataModel? dmPathData;
  UserLoginModel? loginDataInfo;
  List<RxDcrDataModel> doctroList = [];
  List<RegionList>? regionListData;
  List<String>? dcrTypeList;

  // RegionListModel? regionListData;

  TextEditingController doctorController = TextEditingController();
  TextEditingController adressController = TextEditingController();

  List territoryList = [];
  List regionName = [];
  List areaNameList = [];
  List terrolist = [];
  String? initialDoctorType;
  String? initialRegion;
  String? initialDocroeArea;
  String? initialTerritory;

  String regionID = "";
  String areaID = " ";
  String terrorID = "";
  String? cid;
  String? userId;
  String? password;

  @override
  void initState() {
    dmPathData = Boxes.getDmpath().get('dmPathData');

    loginDataInfo = Boxes.getLoginData().get('UserLoginData');

    regionListData = Boxes.geteDSRsetData().get("eDSRSettingsData")!.regionList;
    dcrTypeList = Boxes.geteDSRsetData().get("eDSRSettingsData")!.dsrTypeList;
    if (regionListData != null) {
      regionList = regionListData!;
      regionName = regionList.map((e) => e.regionName).toList();
      initialRegion = null;
    }
    SharedPreferences.getInstance().then((prefs) {
      cid = prefs.getString("CID")!;
      userId = prefs.getString("USER_ID");
      password = prefs.getString("PASSWORD");
    });
    setState(() {});
    super.initState();
  }

  //===================================================MOdel Get Doctor Region List ======================================
  doctorArea(String area) {
    filterRegionList =
        regionList.where((element) => element.regionName == area).toList();
    areaListoregion = filterRegionList.first.areaList;
    areaNameList =
        filterRegionList.first.areaList.map((e) => e.areaName).toList();
    if (filterRegionList.first.areaList.isNotEmpty) {
      setState(() {
        initialDocroeArea = null;
      });
    }
  }

  //=================================================== Get Doctor Territory List ======================================
  getTerritory() {
    var areaID1 = '';
    for (var element in areaListoregion) {
      if (element.areaName == areaID) {
        areaID1 = element.areaId;
      }
    }

    List<AreaList> areaNamewiseID =
        areaListoregion.where((element) => element.areaId == areaID1).toList();
    territoryListM = areaNamewiseID.first.territoryList;
    for (var element in areaNamewiseID) {
      terrolist = element.territoryList.map((e) => e.territoryName).toList();
      setState(() {
        initialTerritory = null;
      });
    }
  }

  timeStamp() {
    String id;
    DateTime time = DateTime.now();
    id = time.millisecondsSinceEpoch.toString();
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
        height: 470,
        child: StatefulBuilder(builder: (context, setState2) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Doctor List Area",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.grey,
                  height: 0.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Doctor Type *"),
                ),
                const SizedBox(
                  height: 10,
                ),
                dcrTypeList == null
                    ? const CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black54, width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    value: initialDoctorType,
                                    hint: const Text("Select Doctor Type"),
                                    iconSize: 30,
                                    items: dcrTypeList!.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item.toString(),
                                        child: Text(
                                          item,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) async {
                                      initialDoctorType = newValue as String?;

                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Region *"),
                ),
                const SizedBox(
                  height: 10,
                ),
                regionName.isEmpty
                    ? const CircularProgressIndicator()
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Colors.black54, width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: DropdownButtonHideUnderline(
                                child: ButtonTheme(
                                  alignedDropdown: true,
                                  child: DropdownButtonFormField(
                                    isExpanded: true,
                                    value: initialRegion,
                                    hint: const Text("Select Region"),
                                    iconSize: 30,
                                    items: regionName.map((item) {
                                      return DropdownMenuItem<String>(
                                        value: item.toString(),
                                        child: Text(
                                          item,
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) async {
                                      initialRegion = newValue as String?;
                                      for (var element in regionList) {
                                        if (element.regionName == newValue) {
                                          regionID = element.regionId;
                                        }
                                      }

                                      initialDocroeArea = null;
                                      areaID = "";
                                      initialTerritory = null;
                                      terrorID = "";
                                      terrolist = [];

                                      doctorArea(newValue!);
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Area *"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black54, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StatefulBuilder(builder: (context, setState3) {
                        return Expanded(
                          child: DropdownButtonHideUnderline(
                            child: ButtonTheme(
                              alignedDropdown: true,
                              child: DropdownButtonFormField(
                                isExpanded: true,
                                value: initialDocroeArea,
                                hint: const Text("Select Area"),
                                iconSize: 30,
                                items: areaNameList.map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item.toString(),
                                    child: Text(
                                      item,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newValue) async {
                                  areaID = newValue as String;
                                  initialTerritory = null;
                                  terrorID = "";
                                  for (var element in areaListoregion) {
                                    if (element.areaName == newValue) {
                                      areaID = element.areaId;
                                    }
                                  }
                                  getTerritory();
                                  setState(() {
                                    initialDocroeArea = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Territory"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.black54, width: 1)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: ButtonTheme(
                            alignedDropdown: true,
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              iconSize: 30,
                              value: initialTerritory,
                              hint: const Text("Select Territory"),
                              items: terrolist.map((item) {
                                return DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(
                                    item,
                                  ),
                                );
                              }).toList(),
                              onChanged: (newValue) async {
                                terrorID = newValue as String;

                                for (var element in areaListoregion) {
                                  if (element.areaName == areaID) {
                                    areaID = element.areaId;
                                  }
                                }
                                List<AreaList> areaNamewiseID = areaListoregion
                                    .where(
                                        (element) => element.areaId == areaID)
                                    .toList();
                                for (var element in areaNamewiseID) {
                                  for (var element in element.territoryList) {
                                    if (element.territoryName == terrorID) {
                                      terrorID = element.territoryId;
                                      setState(() {
                                        initialTerritory = newValue;
                                      });
                                    }
                                  }
                                }

                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      if (regionID != "") {
                        if (areaID != "") {
                          getTerriBaesdDoctor();
                        } else {
                          Fluttertoast.showToast(
                              msg: 'Please Select Area ',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: 'Please Select Region ',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: const Text("Get Doctor List"))
              ],
            ),
          );
        }),
      ),
    );
  }

  //=============================================== get Territory Based Doctor Button (Api call)================================
  getTerriBaesdDoctor() async {
    box = Hive.box("doctorList");
    box?.clear();
    Map<String, dynamic> data = await EDSRRepositories()
        .getTerritoryBasedDoctor(dmPathData!.submitUrl, cid!, userId!,
            password!, regionID, areaID, terrorID, initialDoctorType!);
    if (data["res_data"]["status"] == "Success") {
      List doctorData = data["res_data"]["doctorList"];

      result = doctorData;
      doctroList.clear();

      for (var disco in result) {
        box?.add(disco);
      }
      widget.callbackData["dsr_Type"] = initialDoctorType;
      widget.callbackData["Region"] = initialRegion;
      widget.callbackData["Area"] = initialDocroeArea;
      widget.callbackData["Territory"] = initialTerritory;
      widget.callbackFuc(widget.callbackData);

      var pref = await SharedPreferences.getInstance();
      pref.setString("Region", regionID);
      pref.setString("Area", areaID);
      pref.setString("Territory", terrorID);
      pref.setString("DoctorType", initialDoctorType!);
    } else {
      Fluttertoast.showToast(
          msg: '${data["res_data"]["ret_str"]}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    if (!mounted) return;
    Navigator.pop(context);
  }
}
