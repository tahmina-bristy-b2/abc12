// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/confirm_widget.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECMETypeSelection extends StatefulWidget {
  final Map<String, dynamic> callbackData;
  Function(Map<String, dynamic>) callbackFuction;
  ECMETypeSelection({required this.callbackData, required this.callbackFuction});

  @override
  State<ECMETypeSelection> createState() => _ECMETypeSelectionState();
}

class _ECMETypeSelectionState extends State<ECMETypeSelection> {
  Box? box;

  List<ECMERegionList> regionList = [];
  List<ECMERegionList> filterRegionList = [];
  List<ECMEAreaList> areaListoregion = [];
  List<ECMETerritoryList> territoryListM = [];
  DmPathDataModel? dmPathData;
  UserLoginModel? loginDataInfo;
  List<RxDcrDataModel> doctroList = [];
  List<ECMERegionList>? regionListData;
  List<String>? eCMEType;
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
  bool isLoading = false;

  @override
  void initState() {
    dmPathData = Boxes.getDmpath().get('dmPathData');
    loginDataInfo = Boxes.getLoginData().get('UserLoginData');
    regionListData = Boxes.geteCMEsetData().get("eCMESavedDataSync")!.eCMERegionList;
    eCMEType=Boxes.geteCMEsetData().get("eCMESavedDataSync")!.eCMETypeList;

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
    areaListoregion = filterRegionList.first.eCMEAreaList;
    areaNameList =
        filterRegionList.first.eCMEAreaList.map((e) => e.areaName).toList();
    if (filterRegionList.first.eCMEAreaList.isNotEmpty) {
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

    List<ECMEAreaList> areaNamewiseID =
        areaListoregion.where((element) => element.areaId == areaID1).toList();
    territoryListM = areaNamewiseID.first.eCMEterritoryList;
    for (var element in areaNamewiseID) {
      terrolist = element.eCMEterritoryList.map((e) => e.territoryName).toList();
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
        height: 480,
        child: StatefulBuilder(builder: (context, setState2) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Doctor List Area",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color:  Color.fromARGB(255, 82, 179, 98),),
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
                  child: Text("e-CME Type *"),
                ),
                const SizedBox(
                  height: 10,
                ),
                eCMEType == null
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
                                    iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                    isExpanded: true,
                                    value: initialDoctorType,
                                     hint: const Text("-------Select type -------"),
                                    iconSize: 30,
                                    items: eCMEType!.map((item) {
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
                                     iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                    hint: const Text("-------Select Region -------"),
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
                                iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                value: initialDocroeArea,
                                hint: const Text("------Select Area------"),
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
                              iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                              value: initialTerritory,
                              hint: const Text("------Select Territory ------"),
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
                                List<ECMEAreaList> areaNamewiseID = areaListoregion
                                    .where(
                                        (element) => element.areaId == areaID)
                                    .toList();
                                for (var element in areaNamewiseID) {
                                  for (var element in element.eCMEterritoryList) {
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
                isLoading != true
                    ? ConfirmButtonWidget(buttonHeight: 50, buttonName: "Get Doctor List", fontColor: Colors.white, fontSize: 16, onTapFuction: () async{
                          bool hasInternet =
                              await InternetConnectionChecker().hasConnection;
                          if (hasInternet == true) {
                            if (regionID != "") {
                              if (areaID != "") {
                                bool result = await InternetConnectionChecker()
                                    .hasConnection;
                                if (result == true) {
                                  getTerriBaesdDoctor();
                                } else {
                                  AllServices().toastMessage(interNetErrorMsg,
                                      Colors.red, Colors.white, 16);
                                }
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
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            AllServices().toastMessage(
                                interNetErrorMsg, Colors.red, Colors.white, 16);
                          }
                        },)
                  


                    : const Center(
                        child: CircularProgressIndicator(),
                      )
              ],
            ),
          );
        }),
      ),
    );
  }

  //=============================================== get Territory Based Doctor Button (Api call)================================
  getTerriBaesdDoctor() async {
    setState(() {
      isLoading = true;
    });
    box = Hive.box("eCMEDoctorList");
    box?.clear();
    Map<String, dynamic> data = await ECMERepositry()
        .getTerritoryBasedDoctor(dmPathData!.submitUrl, cid!, userId!,
            password!, regionID, areaID, terrorID, initialDoctorType!);
    if (data["res_data"]["status"] == "Success") {
      List doctorData = data["res_data"]["doctorList"];

      result = doctorData;
      setState(() {
        isLoading = false;
      });
      doctroList.clear();

      for (var disco in result) {
        box?.add(disco);
      }
   
      widget.callbackData["eCMERegion"] = initialRegion;
      widget.callbackData["eCMEArea"] = initialDocroeArea;
      widget.callbackData["eCMETerritory"] = initialTerritory;
      widget.callbackFuction(widget.callbackData);
      var pref = await SharedPreferences.getInstance();
      pref.setString("eCMERegion", regionID);
      pref.setString("eCMEArea", areaID);
      pref.setString("eCMETerritory", terrorID);
    } else {
      setState(() {
        isLoading = false;
      });
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
