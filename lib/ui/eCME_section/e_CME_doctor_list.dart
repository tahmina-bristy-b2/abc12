import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/e_CME/e_CME_doctor_list.dart';
import 'package:MREPORTING_OFFLINE/models/e_CME/e_cme_category_List_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/eCME/eCME_services.dart';
import 'package:MREPORTING_OFFLINE/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING_OFFLINE/ui/Expired_dated_section/widget/cancel-button.dart';
import 'package:MREPORTING_OFFLINE/ui/Expired_dated_section/widget/confirm_widget.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/eCME_add_screen.dart';
import 'package:MREPORTING_OFFLINE/utils/constant.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECMEClientScreen extends StatefulWidget {
  List<DocListECMEModel> docList;
  List eCMEType;
  ECMEClientScreen({super.key, required this.docList, required this.eCMEType});

  @override
  State<ECMEClientScreen> createState() => _ECMEClientScreenState();
}

class _ECMEClientScreenState extends State<ECMEClientScreen> {
  Box? box;
  List<RegionList>? regionListData;

  TextEditingController searchController = TextEditingController();
  TextEditingController doctorCategoryController = TextEditingController();
  String? seletedDoctorCategory;
  List foundUsers = [];
  List<DocListECMEModel> result = [];
  List<DocListECMEModel> duplicateList = [];
  String? cid;
  String? userId;
  String? password;
  String? region;
  String? territory;
  String? area;
  String dSRType = "";
  Map<String, bool> doctorSelectionMap = {};
  List<DocListECMEModel> doctInfo = [];
  bool isConfirm = false;
  bool isDocListShow = false;
  String eCmeType = "";
  DmPathDataModel? dmpathData;
  DoctorCategoryRestData? doctorCategoryListFromSync;
  EcmeTerritoryRestDoctorModel? eCMEDoctorListData;

  @override
  void initState() {
    // print("ei jeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee ");
    super.initState();
    dmpathData = Boxes.getDmpath().get('dmPathData');
    doctorCategoryListFromSync =
        Boxes.getECMECategoryData().get("eCMEDOctorCategory");
    eCMEDoctorListData = Boxes.getEcmeDoctorList().get("eCMEDoctorList");

    for (var eachType in widget.eCMEType) {
      doctorSelectionMap[eachType] = false;
    }
    addShowDialogForVeryFirstTime(widget.eCMEType, context);

    if (eCMEDoctorListData != null) {
      if (eCMEDoctorListData!.docList != null) {
        result = eCMEDoctorListData!.docList;
        print("doctor list ======================$result");
        for (var element in result) {
          doctorSelectionMap[element.docId] = false;
        }
      }
    }

    // if (widget.docList != null) {
    //   result = widget.docList;
    // }
    // if (result.isNotEmpty) {
    //   for (var element in result) {
    //     doctorSelectionMap[element.docId] = false;
    //   }
    // }

    SharedPreferences.getInstance().then((prefs) {
      cid = prefs.getString("CID")!;
      userId = prefs.getString("USER_ID");
      password = prefs.getString("PASSWORD");
      region = prefs.getString("Region") ?? "";
      area = prefs.getString("Area") ?? "";
      territory = prefs.getString("Territory") ?? "";
      setState(() {});
    });
  }

  void refreshData() {
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isConfirm = doctorSelectionMap.containsValue(true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text("CME Doctor List"),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Doctor Search Section
            isDocListShow == true
                ? Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        (result.isNotEmpty)
                            ? Expanded(
                                flex: 5,
                                child: SizedBox(
                                  height: 50,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          height: 45,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: const Color.fromARGB(
                                                255, 240, 246, 246),
                                            border: Border.all(
                                              color: const Color.fromARGB(
                                                  255, 138, 201, 149),
                                            ),
                                          ),
                                          child: TextFormField(
                                            onChanged: (value) {
                                              result =
                                                  ECMEServices().doctorSearch(
                                                value,
                                                duplicateList,
                                              );

                                              // print(
                                              //     "filter data =================================${result}");
                                              setState(() {});
                                            },
                                            controller: searchController,
                                            decoration: InputDecoration(
                                              hintText: " Search Doctor .....",
                                              hintStyle:
                                                  const TextStyle(fontSize: 14),
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              border: InputBorder.none,
                                              suffixIcon:
                                                  searchController.text.isEmpty
                                                      ? const Icon(
                                                          Icons.search,
                                                          color: Colors.grey,
                                                        )
                                                      : IconButton(
                                                          onPressed: () {
                                                            searchController
                                                                .clear();
                                                            setState(() {
                                                              result =
                                                                  ECMEServices()
                                                                      .doctorSearch(
                                                                '',
                                                                duplicateList,
                                                              );
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.clear,
                                                            color: Colors.teal,
                                                          ),
                                                        ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(width: 5),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              bool isPreviewLoading = false;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState2) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        backgroundColor: Colors.white,
                                        child: Container(
                                          padding: const EdgeInsets.all(20),
                                          height: seletedDoctorCategory != null
                                              ? 180
                                              : 110,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              DropdownButtonHideUnderline(
                                                child: DropdownButton2(
                                                  isExpanded: true,
                                                  iconEnabledColor:
                                                      const Color.fromARGB(
                                                          255, 82, 179, 98),
                                                  hint: const Text(
                                                    "Select Doctor Category",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  items:
                                                      doctorCategoryListFromSync!
                                                          .docSpecialtyList
                                                          .map((String item) {
                                                    return DropdownMenuItem(
                                                      value: item,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 8),
                                                        child: Text(
                                                          item,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: seletedDoctorCategory,
                                                  onChanged: (value) {
                                                    setState2(() {
                                                      seletedDoctorCategory =
                                                          value;

                                                      searchController.clear();
                                                    });
                                                  },
                                                  buttonHeight: 50,
                                                  buttonWidth:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width /
                                                          1.1,
                                                  itemHeight: 40,
                                                  dropdownMaxHeight: 200,
                                                  searchController:
                                                      doctorCategoryController,
                                                  searchInnerWidgetHeight: 50,
                                                  searchInnerWidget: Container(
                                                    height: 50,
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: TextFormField(
                                                      expands: true,
                                                      maxLines: null,
                                                      controller:
                                                          doctorCategoryController,
                                                      decoration:
                                                          InputDecoration(
                                                        fillColor:
                                                            Colors.transparent,
                                                        filled: true,
                                                        isDense: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 8,
                                                          vertical: 8,
                                                        ),
                                                        hintText:
                                                            "Search Doctor Category",
                                                        hintStyle:
                                                            const TextStyle(
                                                                fontSize: 16),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  searchMatchFn:
                                                      (item, searchValue) {
                                                    return item.value
                                                        .toString()
                                                        .toUpperCase()
                                                        .startsWith(searchValue
                                                            .toUpperCase());
                                                  },
                                                  dropdownDecoration:
                                                      BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              seletedDoctorCategory != null
                                                  ? isPreviewLoading == false
                                                      ? ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            primary: const Color
                                                                    .fromARGB(
                                                                255,
                                                                82,
                                                                179,
                                                                98),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            minimumSize: Size(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width /
                                                                  1.1,
                                                              45,
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            setState2(() {
                                                              isPreviewLoading =
                                                                  true;
                                                            });
                                                            bool result2 =
                                                                await InternetConnectionChecker()
                                                                    .hasConnection;
                                                            if (result2 ==
                                                                true) {
                                                              EcmeTerritoryWiseDoctorModel?
                                                                  responseData =
                                                                  await ECMERepositry().getECMEDoctorData(
                                                                      dmpathData!
                                                                          .syncUrl,
                                                                      cid!,
                                                                      userId!,
                                                                      password!,
                                                                      seletedDoctorCategory!);
                                                              if (responseData !=
                                                                  null) {
                                                                result =
                                                                    responseData
                                                                        .resData
                                                                        .docList;

                                                                duplicateList =
                                                                    responseData
                                                                        .resData
                                                                        .docList;

                                                                if (result
                                                                    .isNotEmpty) {
                                                                  for (var element
                                                                      in result) {
                                                                    doctorSelectionMap[
                                                                            element.docId] =
                                                                        false;
                                                                  }
                                                                }
                                                              } else {
                                                                setState2(() {
                                                                  isPreviewLoading =
                                                                      false;
                                                                });
                                                                AllServices()
                                                                    .toastMessage(
                                                                        "No data found, Sync First",
                                                                        Colors
                                                                            .red,
                                                                        Colors
                                                                            .white,
                                                                        16);
                                                              }
                                                              if (context
                                                                  .mounted) {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {});
                                                              }
                                                            } else {
                                                              setState2(() {
                                                                isPreviewLoading =
                                                                    false;
                                                              });
                                                              AllServices()
                                                                  .toastMessage(
                                                                      interNetErrorMsg,
                                                                      Colors
                                                                          .red,
                                                                      Colors
                                                                          .white,
                                                                      16);
                                                            }
                                                          },
                                                          child: const Text(
                                                            "Get Doctor List",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      : const CircularProgressIndicator(
                                                          color: Color.fromARGB(
                                                              255, 82, 179, 98),
                                                        )
                                                  : const SizedBox(),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 1.1,
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    result.isEmpty
                                        ? const Text(
                                            "Select Category",
                                            style: TextStyle(fontSize: 15),
                                          )
                                        : const SizedBox(),
                                    SizedBox(
                                      width: result.isEmpty ? 10 : 0,
                                    ),
                                    Image.asset(
                                      "assets/icons/icons8-dropdown.gif",
                                      height: result.isEmpty ? 40 : 35,
                                    ),
                                  ],
                                ),
                              ),
                              // child: const Icon(
                              //   Icons.add,
                              //   size: 32,
                              //   color: Color.fromARGB(255, 82, 179, 98),
                              // ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                : SizedBox(),
            // Doctor List Section
            (result.isNotEmpty && isDocListShow == true)
                ? Expanded(
                    child: ListView.builder(
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 6, right: 6, top: 6),
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:
                                    doctorSelectionMap[result[index].docId] ==
                                            true
                                        ? const Color.fromARGB(
                                            255, 243, 251, 245)
                                        : Colors.white,
                              ),
                              child: Theme(
                                data: ThemeData(
                                    unselectedWidgetColor: Colors.grey),
                                child: CheckboxListTile(
                                  checkboxShape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  activeColor:
                                      const Color.fromARGB(255, 138, 201, 149),
                                  title: Container(
                                    color: Colors.transparent,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(2, 2, 4, 2),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              result[index].docName,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Flexible(
                                            child: Text(
                                              "${result[index].areaName}  (${result[index].areaId}) , ${result[index].specialty}",
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black54),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  value:
                                      doctorSelectionMap[result[index].docId] ??
                                          false,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      doctorSelectionMap[result[index].docId] =
                                          value ?? false;
                                      doctInfo.removeWhere((element) =>
                                          element.docId == result[index].docId);
                                      if (value == true) {
                                        doctInfo.add(result[index]);
                                      } else {
                                        doctInfo.removeWhere((element) =>
                                            element.docId ==
                                            result[index].docId);
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        }),
                  )
                : const SizedBox(),
          ],
        ),
        //================================ Confirm Button =======================================
        bottomNavigationBar: isConfirm
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    // doctInfo = [];
                    // doctorSelectionMap.forEach((key1, value1) {
                    //   if (value1 == true) {
                    //     for (var element2 in result) {
                    //       if (key1 == element2.docId) {
                    //         doctInfo.add(element2);
                    //       }
                    //     }
                    //   }
                    // });
                    doctInfo.toSet().toList().forEach((element) {
                      print("docto name   ${element.docName} ${element.docId}");
                    });

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ECMEAddScreen(
                                  docInfo: doctInfo.toSet().toList(),
                                  eCMEType: eCmeType,
                                )));
                  },
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 1),
                          blurRadius: 0.8,
                          color: Colors.black.withOpacity(0.3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 139, 214, 152),
                    ),
                    child: const Center(
                        child: Text(
                      "Confirm",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    )),
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }

//============================= Bottom Modal sheet for Selecting eCME Type ========================================
  void addShowDialogForVeryFirstTime(
      List doctorType, BuildContext context) async {
    Map<String, bool> doctorSelectionMap = {};
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        isScrollControlled: true,
        clipBehavior: Clip.antiAlias,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        isDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState2) {
              return SizedBox(
                height: (doctorType.length * 50) +
                    105, //==this Size contains with Text+ eCME type +button height. if any changes needed, then change everywhere
                child: Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        "Select CME Type",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                      ),
                      height: doctorType.length * 50,
                      child: ListView.builder(
                        itemCount: doctorType.length,
                        itemBuilder: (context, index) {
                          doctorSelectionMap.putIfAbsent(
                              doctorType[index],
                              () =>
                                  false); //== as per user requirement .//only one option can be seleted by user
                          return Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.grey),
                            child: SizedBox(
                              height: 45,
                              child: CheckboxListTile(
                                checkboxShape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                activeColor:
                                    const Color.fromARGB(255, 138, 201, 149),
                                title: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(2, 2, 4, 2),
                                  child: ListTile(
                                    title: Text(
                                      doctorType[index],
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ),
                                value: doctorSelectionMap[doctorType[index]],
                                onChanged: (bool? value) {
                                  setState2(() {
                                    for (var key in doctorSelectionMap.keys) {
                                      doctorSelectionMap[key] = false;
                                    }
                                    doctorSelectionMap[doctorType[index]] =
                                        true;
                                    if (doctorSelectionMap[doctorType[index]] ==
                                        true) {
                                      eCmeType = doctorType[index];
                                    }
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 4),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: CancelButtonWidget(
                                buttonHeight: 50,
                                fontColor:
                                    const Color.fromARGB(255, 82, 179, 98),
                                buttonName: "Cancel",
                                fontSize: 16,
                                onTapFuction: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                borderColor:
                                    const Color.fromARGB(255, 82, 179, 98),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ConfirmButtonWidget(
                                buttonHeight: 50,
                                fontColor: Colors.white,
                                buttonName: "OK",
                                fontSize: 16,
                                onTapFuction: () {
                                  if ((doctorSelectionMap["Intern Reception"] ==
                                          true) ||
                                      (doctorSelectionMap["Society"] == true)) {
                                    //== no doctor needed ,if EME type these
                                    doctInfo = [];
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => ECMEAddScreen(
                                                  docInfo: doctInfo,
                                                  eCMEType: eCmeType,
                                                )));
                                  } else {
                                    setState(() {
                                      isDocListShow =
                                          true; //== it used for doctor List show //== be carefull
                                    });

                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ).then((value) {
        setState(() {});
      });
    });
  }
}
