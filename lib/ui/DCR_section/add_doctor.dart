// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:MREPORTING/models/doctor_edit_model.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:hive/hive.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/doc_settings_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DcotorInfoScreen extends StatefulWidget {
  final bool isEdit;
  String areaName;
  final String areaID;
  final Map? editDoctorInfo;
  final List customerList;
  final DocSettingsModel? docSettings;
  final docEditInfo;

  DcotorInfoScreen({
    Key? key,
    required this.isEdit,
    required this.areaName,
    required this.areaID,
    this.editDoctorInfo,
    this.docEditInfo,
    required this.customerList,
    this.docSettings,
  }) : super(key: key);

  @override
  State<DcotorInfoScreen> createState() => _DcotorInfoScreenState();
}

class _DcotorInfoScreenState extends State<DcotorInfoScreen> {
  Box? box;
  UserLoginModel? userLoginInfo;
  DmPathDataModel? dmPathData;
  final formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController marriageDayController = TextEditingController();
  TextEditingController dobChild1Controller = TextEditingController();
  TextEditingController dobChild2Controller = TextEditingController();
  TextEditingController patientNumController = TextEditingController();
  TextEditingController docIDController = TextEditingController();
  TextEditingController docNameController = TextEditingController();
  TextEditingController docSpecialityController = TextEditingController();
  TextEditingController docAddressController = TextEditingController();

  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List<String> category = [];
  List<String> any = ["_", "a", "b", "c"];
  List<String> dcrVisitedWithList = ["_", "a", "b", "c"];
  List<String> customerNameList = [];
  String dropdownValueforCat = "_";
  List val = [];
  String dropdownValue = "_";
  List<String> degree = [];
  List<int> degreeInt = [];
  String degreeList = " ";
  List<String> collarSizeList = [];
  List<String> dCList = [];
  List<String> brandList = [];
  String docId = "";
  String brandListString = " ";
  String categoryValue = 'A';
  String docCategoryValue = 'DCC';
  String docTypeValue = 'CHAMBER DOCTOR';
  String docSpecialityValue = 'ANESTHESIOLOGY';
  String thanaValue = '_';
  String districtValue = '_';
  String chemistId = "";
  List<int> chemistInt = [];
  List<int> brandInt = [];

  String thanaSelectedId = '';
  String districtSelectedId = '';

  String collarSize = '0';
  List<DistThanaList> getThanaWithDist = [];

  // String cateGoriesSelectedValue = 'a';

  String cid = '';
  // String userId = '';
  String userPassword = '';
  //=========================================proper way of initializing screenhight and screeWidth=====================================================
  // / static double
  // / static const double
  // /// Get the proportionate height as per screen size.
  // double getProportionateScreenHeight(double inputHeight) =>
  //     (inputHeight / layoutHeight) * size.height;
  //=========================================proper way of initializing screenhight and screeWidth=====================================================

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID")!;
        userPassword = prefs.getString("PASSWORD")!;
      });
    });

    if (widget.isEdit) {
      print(widget.docSettings);
      print(widget.docEditInfo["docRecords"]);

      print("edit theke");
      for (int i = 0; i < widget.docEditInfo["docRecords"].length; i++) {
        print(widget.docEditInfo["docRecords"][i]["area_id"]);
        nameController.text = widget.docEditInfo["docRecords"][i]["doc_name"];
        print(widget.docEditInfo["docRecords"][i]["doc_id"]);
        widget.areaName = widget.docEditInfo["docRecords"][i]["area_id"];
        chemistId = widget.docEditInfo["docRecords"][i]["arround_chemist_id"];
        brandListString = widget.docEditInfo["docRecords"][i]["brand"];
        degreeList = widget.docEditInfo["docRecords"][i]["degree"];
        docId = widget.docEditInfo["docRecords"][i]["doc_id"];
        dobController.text = widget.docEditInfo["docRecords"][i]["dob"];
        dobChild1Controller.text =
            widget.docEditInfo["docRecords"][i]["dob_child1"];
        dobChild2Controller.text =
            widget.docEditInfo["docRecords"][i]["dob_child2"];
        marriageDayController.text =
            widget.docEditInfo["docRecords"][i]["mar_day"];

        categoryValue = widget.docEditInfo["docRecords"][i]["d_category"];

        docCategoryValue =
            widget.docEditInfo["docRecords"][i]["doctors_category"];
        adressController.text = widget.docEditInfo["docRecords"][i]["address"];
        print(docCategoryValue);
        docSpecialityValue = widget.docEditInfo["docRecords"][i]["specialty"];
        patientNumController.text =
            widget.docEditInfo["docRecords"][i]["nop"].toString();
        mobileController.text =
            widget.docEditInfo["docRecords"][i]["mobile"].toString();
        docTypeValue = widget.docEditInfo["docRecords"][i]["address_type"];

        thanaValue = widget.docEditInfo["docRecords"][i]["thana"];

        districtValue = widget.docEditInfo["docRecords"][i]["district"];
        docIDController.text =
            widget.docEditInfo["docRecords"][i]["third_party_id"];
        docNameController.text =
            widget.docEditInfo["docRecords"][i]["fourP_doc_name"];

        docAddressController.text =
            widget.docEditInfo["docRecords"][i]["fourP_doc_address"];
        docSpecialityController.text =
            widget.docEditInfo["docRecords"][i]["fourP_doc_specialty"];

        collarSize = widget.docEditInfo["docRecords"][i]["collar_size"];
        widget.docSettings!.resData.dCategoryList
            .forEach((element) => dCList.add(element));
        getThanaWithDist =
            widget.docSettings!.resData.distThanaList.where((element) {
          return element.districtName == districtValue;
        }).toList();
      }
      // nameController.text = widget.editDoctorInfo!['doc_name'].toString();
      // categoryValue =
      //     widget.docEditInfo!.docRecords.first.dCategory.toUpperCase();
      // docCategoryValue =
      //     widget.docEditInfo!.docRecords.first.doctorsCategory.toUpperCase();
      // docTypeValue = widget.docEditInfo!.docRecords.first.addressType
      //     .toUpperCase(); //addresstype = doctortype
      // docSpecialityValue = widget.docEditInfo!.docRecords.first.specialty;
      // print(widget.docEditInfo!.docRecords.first.district);
      // if (widget.docEditInfo!.docRecords.first.district == '') {
      //   districtValue =
      //       widget.docSettings!.resData.distThanaList.first.districtName;
      //   getThanaWithDist = widget.docSettings!.resData.distThanaList
      //       .where((element) => element.districtName == districtValue)
      //       .toList();

      //   thanaValue = getThanaWithDist.first.thanaList.first.thanaName;

      //   thanaSelectedId = getThanaWithDist.first.thanaList.first.thanaId;
      // } else {
      //   districtValue = widget.docEditInfo!.docRecords.first.district;
      //   thanaValue = widget.docEditInfo!.docRecords.first.thana;
      //   widget.docSettings!.resData.distThanaList.forEach((element) {
      //     // print(element.districtName);
      //     if (element.districtName ==
      //         widget.docEditInfo!.docRecords.first.district) {
      //       districtSelectedId = element.districtId;

      //       element.thanaList.forEach((element2) {
      //         if (element2.thanaName ==
      //             widget.docEditInfo!.docRecords.first.thana) {
      //           thanaSelectedId = element2.thanaName;
      //         }
      //       });
      //     }
      //   });

      //   // thanaSelectedId = widget.docEditInfo!.docRecords.first.thana;
      //   // districtSelectedId = widget.docEditInfo!.docRecords.first.district;
      // }
      // widget.docSettings!.resData.distThanaList.forEach((element) {
      //   print(element.districtName);
      //   if (element.districtId ==
      //       widget.docEditInfo!.docRecords.first.district) {
      //     districtValue = element.districtName;
      //     print(element.districtName);

      //     element.thanaList.forEach((element2) {
      //       if (element2.thanaId ==
      //           widget.docEditInfo!.docRecords.first.thana) {
      //         thanaValue = element2.thanaName;
      //       }
      //     });
      //   }
      // });

      // thanaSelectedId = widget.docEditInfo!.docRecords.first.thana;
      // districtSelectedId = widget.docEditInfo!.docRecords.first.district;

      // degree = widget.docSettings!.resData.docDegreeList;
      // for (var element in widget.docSettings!.resData.brandList) {
      //   brandList.add(element.brandName);
      // }
    } else {
      categoryValue = widget.docSettings!.resData.dCategoryList.first;
      docCategoryValue = widget.docSettings!.resData.docCategoryList.first;
      docTypeValue = widget.docSettings!.resData.docTypeList.first;
      docSpecialityValue = widget.docSettings!.resData.docSpecialtyList.first;
      districtValue =
          widget.docSettings!.resData.distThanaList.first.districtName;
      getThanaWithDist = widget.docSettings!.resData.distThanaList
          .where((element) => element.districtName == districtValue)
          .toList();

      thanaValue = getThanaWithDist.first.thanaList.first.thanaName;

      thanaSelectedId = getThanaWithDist.first.thanaList.first.thanaId;
      districtSelectedId =
          widget.docSettings!.resData.distThanaList.first.districtId;
    }
    userLoginInfo = Boxes.getLoginData().get('userInfo');
    dmPathData = Boxes.getDmpath().get('dmPathData');
    //widget.docName != "" ? nameController.text = widget.docName.toString() : "";
    //category = widget.docSettings.resData.dCategoryList;

    // widget.docName != "" ? nameController.text = widget.docName.toString() : "";
    // category = widget.docSettings.resData.dCategoryList;
    // degree = widget.docSettings.resData.docDegreeList;
    // collarSizeList = widget.docSettings.resData.docDegreeList;
    // print("object=$collarSizeList");
    degree = widget.docSettings!.resData.docDegreeList; //[name]
    List degreeTempList = degreeList.split("|");

    for (int i = 0; i < degree.length; i++) {
      for (var e in degreeTempList) {
        if (degree[i] == e) {
          degreeInt.add(i);
        }
      }
    }

//========================================================================================================================================================
//=============================================================brand for GFMULTISELECT==========================================================================
//========================================================================================================================================================
    for (int i = 0; i < widget.docSettings!.resData.brandList.length; i++) {
      if (brandListString != " ") {
        List brandTempList = brandListString.split("|");
        for (var e in brandTempList) {
          if (e == widget.docSettings!.resData.brandList[i].brandId) {
            brandInt.add(i);
          }
        }
      }
      brandList.add(widget.docSettings!.resData.brandList[i].brandName);
    }
//========================================================================================================================================================
//=============================================================chemistID for GFMULTISELECT==========================================================================
//========================================================================================================================================================
    for (int i = 0; i < widget.customerList.length; i++) {
      if (chemistId != " ") {
        List chemistList = chemistId.split("|");
        for (var e in chemistList) {
          if (e == widget.customerList[i]["client_id"]) {
            chemistInt.add(i);
          }
        }
      }
      customerNameList.add(widget.customerList[i]["client_name"]);
    }
    // dropdownValueforCat = widget.docSettings.resData.dCategoryList.first;
    // customerNameList.add(widget.customerList["client_name"])
    setState(() {});
  }

  @override
  void dispose() {
    nameController.dispose();
    degreeController.dispose();
    adressController.dispose();
    mobileController.dispose();
    dobController.dispose();
    dobChild1Controller.dispose();
    dobChild2Controller.dispose();
    patientNumController.dispose();
    docIDController.dispose();
    docNameController.dispose();
    docSpecialityController.dispose();
    docAddressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: widget.isEdit
            ? const Text("Doctor Update")
            : const Text("Add Doctor"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Territory : ${widget.areaName}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    "Name  ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  //==========================================================1st Dropdown/Second row===============================================================
                  SizedBox(
                    width: screenWidth,
                    height: screenHeight / 6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Category",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Container(child: Text(categoryValue)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? value) {
                                    setState(() {
                                      categoryValue = value!;
                                    });
                                  },
                                  // value: categoryValue,
                                  items: widget
                                      .docSettings!.resData.dCategoryList
                                      .map<DropdownMenuItem<String>>(
                                          (String e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                      .toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Doctor Category",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            SizedBox(height: 20, child: Text(docCategoryValue)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      docCategoryValue = newValue!;
                                    });
                                  },
                                  // value: dropdownValue,
                                  // value: docCategoryValue,
                                  items: widget
                                      .docSettings!.resData.docCategoryList
                                      .map<DropdownMenuItem<String>>(
                                          (String e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                      .toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //==========================================================Expanded/ responsive Row for example===============================================================

                  // Expanded(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                  //     children: [
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text("Doctor Type"),
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: DropdownButtonFormField(
                  //                 decoration: const InputDecoration(enabled: false),
                  //                 isExpanded: true,
                  //                 onChanged: (value) {},
                  //                 value: dropdownValue,
                  //                 items: any.map(
                  //                   (String e) {
                  //                     //print(e);
                  //                     return DropdownMenuItem(
                  //                       value: e,
                  //                       child: Text(e),
                  //                     );
                  //                   },
                  //                 ).toList(),
                  //                 style: const TextStyle(
                  //                   color: Colors.black,
                  //                   // fontSize: 16,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           children: [
                  //             Text("Speciality"),
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: DropdownButtonFormField(
                  //                 decoration: const InputDecoration(enabled: false),
                  //                 isExpanded: true,
                  //                 onChanged: (value) {},
                  //                 value: dropdownValue,
                  //                 items: any.map(
                  //                   (String e) {
                  //                     //print(e);
                  //                     return DropdownMenuItem(
                  //                       value: e,
                  //                       child: Text(e),
                  //                     );
                  //                   },
                  //                 ).toList(),
                  //                 style: const TextStyle(
                  //                   color: Colors.black,
                  //                   // fontSize: 16,
                  //                 ),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  //==========================================================2nd Dropdown/Third row===============================================================

                  SizedBox(
                    width: screenWidth,
                    height: screenHeight / 7.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Doctor Type",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Container(height: 20, child: Text(docTypeValue)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      docTypeValue = newValue!;
                                    });
                                  },
                                  // value: dropdownValue,
                                  // value: docTypeValue,
                                  items: widget.docSettings!.resData.docTypeList
                                      .map<DropdownMenuItem<String>>(
                                          (String e) {
                                    return DropdownMenuItem(
                                        value: e, child: Text(e));
                                  }).toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Speciality",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "*",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                            Container(
                                height: 20, child: Text(docSpecialityValue)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 6, 8, 10),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      docSpecialityValue = newValue!;
                                    });
                                  },
                                  // value: docSpecialityValue,
                                  items: widget
                                      .docSettings!.resData.docSpecialtyList
                                      .map<DropdownMenuItem<String>>(
                                          (String e) => DropdownMenuItem(
                                              value: e, child: Text(e)))
                                      .toList(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //==========================================================Degree Row===============================================================

                  const Text(
                    " Degree",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GFMultiSelect(
                    initialSelectedItemsIndex: degreeInt,
                    items: degree,

                    onSelect: (val) {
                      degreeList = " ";
                      if (val.isNotEmpty) {
                        for (var e in val) {
                          if (degreeList == " ") {
                            degreeList =
                                widget.docSettings!.resData.docDegreeList[e];
                          } else {
                            degreeList +=
                                '|${widget.docSettings!.resData.docDegreeList[e]}';
                          }
                          // degreeList
                          //     .add(widget.docSettings.resData.docDegreeList[e]);
                          //print("degree= $degreeList");
                        }
                      }
                    },
                    cancelButton: cancalButton(),
                    dropdownTitleTileText: '',
                    dropdownTitleTileColor: Colors.grey[200],
                    dropdownTitleTileMargin:
                        const EdgeInsets.fromLTRB(0, 6, 0, 10),
                    dropdownTitleTilePadding:
                        const EdgeInsets.fromLTRB(5, 6, 5, 10),
                    dropdownUnderlineBorder:
                        const BorderSide(color: Colors.transparent, width: 2),
                    dropdownTitleTileBorder:
                        Border.all(color: Colors.grey, width: 1),
                    dropdownTitleTileBorderRadius: BorderRadius.circular(10),
                    expandedIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),

                    // const Icon(
                    //   Icons.keyboard_arrow_up,
                    //   color: Colors.black54,
                    // ),
                    collapsedIcon: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black54,
                    ),
                    // submitButton: Text('OK'),
                    // dropdownTitleTileTextStyle: const TextStyle(
                    //     fontSize: 14, color: Colors.black54),
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.all(0),
                    type: GFCheckboxType.basic,
                    activeBgColor: Colors.green.withOpacity(0.5),
                    inactiveBorderColor: Colors.grey,
                  ),

                  //==========================================================Chemist Row===============================================================

                  const Text(
                    "Chemist ID ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  GFMultiSelect(
                    initialSelectedItemsIndex: chemistInt,
                    items: customerNameList,
                    onSelect: (value) {
                      chemistId = "";
                      if (value.isNotEmpty) {
                        for (var ele in value) {
                          for (var e in widget.customerList) {
                            if (e["client_name"] == customerNameList[ele]) {
                              if (chemistId == "") {
                                chemistId = e["client_id"];
                              } else {
                                chemistId += "|" + e["client_id"];
                              }
                            }
                          }
                        }
                      }
                      degreeController.text = value.toString();
                    },
                    cancelButton: cancalButton(),
                    dropdownTitleTileText: '',
                    dropdownTitleTileColor: Colors.grey[200],
                    dropdownTitleTileMargin:
                        const EdgeInsets.fromLTRB(0, 6, 0, 10),
                    dropdownTitleTilePadding:
                        const EdgeInsets.fromLTRB(5, 6, 5, 10),
                    dropdownUnderlineBorder:
                        const BorderSide(color: Colors.transparent, width: 2),
                    dropdownTitleTileBorder:
                        Border.all(color: Colors.grey, width: 1),
                    dropdownTitleTileBorderRadius: BorderRadius.circular(10),
                    expandedIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                    collapsedIcon: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black54,
                    ),
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    type: GFCheckboxType.basic,
                    activeBgColor: Colors.green.withOpacity(0.5),
                    inactiveBorderColor: Colors.grey,
                  ),
                  //==========================================================Address row===============================================================
                  Row(
                    children: const [
                      Text(
                        "Address",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                    child: TextField(
                      controller: adressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  //==========================================================Thana row===============================================================

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Row(
                  //           children: const [
                  //             Text(
                  //               "District",
                  //               style: TextStyle(fontWeight: FontWeight.bold),
                  //             ),
                  //             Text(
                  //               "*",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.red),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(
                  //           width: screenWidth / 2.1,
                  //           child: Padding(
                  //             padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                  //             child: DropdownButtonFormField(
                  //               decoration: InputDecoration(
                  //                 border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                 ),
                  //               ),
                  //               isExpanded: true,
                  //               onChanged: (String? newValue) {
                  //                 districtValue = newValue!;
                  //                 getThanaWithDist = widget
                  //                     .docSettings!.resData.distThanaList
                  //                     .where((element) =>
                  //                         element.districtName == districtValue)
                  //                     .toList();

                  //                 thanaValue = getThanaWithDist
                  //                         .first.thanaList.isNotEmpty
                  //                     ? getThanaWithDist
                  //                         .first.thanaList.first.thanaName
                  //                     : '_';

                  //                 setState(() {});
                  //               },
                  //               // value: districtValue,
                  //               items: widget.docSettings!.resData.distThanaList
                  //                   .map((e) => DropdownMenuItem(
                  //                       value: e.districtName,
                  //                       child: Text(e.districtName)))
                  //                   .toList(),
                  //               style: const TextStyle(
                  //                 color: Colors.black,
                  //                 // fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //     Column(
                  //       crossAxisAlignment: CrossAxisAlignment.start,
                  //       children: [
                  //         Row(
                  //           children: const [
                  //             Text(
                  //               "Thana",
                  //               style: TextStyle(fontWeight: FontWeight.bold),
                  //             ),
                  //             Text(
                  //               "*",
                  //               style: TextStyle(
                  //                   fontWeight: FontWeight.bold,
                  //                   color: Colors.red),
                  //             ),
                  //           ],
                  //         ),
                  //         SizedBox(
                  //           width: screenWidth / 2.1,
                  //           child: Padding(
                  //             padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),
                  //             child: DropdownButtonFormField(
                  //               decoration: InputDecoration(
                  //                 border: OutlineInputBorder(
                  //                   borderRadius: BorderRadius.circular(15),
                  //                 ),
                  //               ),
                  //               isExpanded: true,
                  //               onChanged: (String? newValue) {
                  //                 thanaValue = newValue!;

                  //                 setState(() {});
                  //               },
                  //               // value: thanaValue,
                  //               items:
                  //                   getThanaWithDist.first.thanaList.isNotEmpty
                  //                       ? getThanaWithDist.first.thanaList
                  //                           .map((e) => DropdownMenuItem(
                  //                               value: e.thanaName,
                  //                               child: Text(e.thanaName)))
                  //                           .toList()
                  //                       : any.map<DropdownMenuItem<String>>(
                  //                           (String e) {
                  //                             //print(e);
                  //                             return DropdownMenuItem(
                  //                               value: e,
                  //                               child: Text(e.toString()),
                  //                             );
                  //                           },
                  //                         ).toList(),
                  //               style: const TextStyle(
                  //                 color: Colors.black,
                  //                 // fontSize: 16,
                  //               ),
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ],
                  // ),

                  //==========================================================Mobile Number row===============================================================
                  Row(
                    children: const [
                      Text(
                        "Mobile Number*",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: mobileController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  //==========================================================DOB row===============================================================
                  const Text(
                    "DOB",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: dobController,
                      decoration: InputDecoration(
                        hintText: dobController.text == ""
                            ? "Select Date Of Birth"
                            : dobController.text,
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date =
                            await AllServices().pickDate(context, dateTime);
                        if (date == null) {
                          return;
                        } else {
                          setState(
                            () {
                              // dateTime = date;
                              List<String> splittedDate =
                                  date.toString().split(' ');
                              dobController.text = splittedDate[0].toString();
                              print(dobController.text);
                              // DateFormat.yMd().format(date);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  //==========================================================Marriage Day row===============================================================
                  const Text(
                    "Marriage Day",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: marriageDayController,
                      decoration: InputDecoration(
                        hintText: marriageDayController.text == ""
                            ? "Select Marriage Date"
                            : marriageDayController.text,
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date =
                            await AllServices().pickDate(context, dateTime);
                        if (date == null) {
                          return;
                        } else {
                          setState(
                            () {
                              // dateTime = date;
                              List<String> splittedDate =
                                  date.toString().split(' ');
                              marriageDayController.text =
                                  splittedDate[0].toString();
                              print(marriageDayController.text);
                              // DateFormat.yMd().format(date);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  //==========================================================Collar Size row===============================================================
                  const Text(
                    "Collar Size",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Container(child: Text(collarSize)),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: SizedBox(
                      width: screenWidth,
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        isExpanded: true,
                        onChanged: (value) {
                          collarSize = value!;
                        },
                        // value: collarSize,
                        items: widget
                                .docSettings!.resData.collarSizeList.isNotEmpty
                            ? widget.docSettings!.resData.collarSizeList.map(
                                (String e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                },
                              ).toList()
                            : collarSizeList.map(
                                (String e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                },
                              ).toList(),
                        style: const TextStyle(
                          color: Colors.black,
                          // fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  //==========================================================DOB of CHild 1 row===============================================================
                  const Text(
                    "DOB of CHild 1 ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: dobChild1Controller,
                      decoration: InputDecoration(
                        hintText: dobChild1Controller.text == ""
                            ? "Select DOB of Child 1"
                            : dobChild1Controller.text,
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date =
                            await AllServices().pickDate(context, dateTime);
                        if (date == null) {
                          return;
                        } else {
                          setState(
                            () {
                              // dateTime = date;
                              List<String> splittedDate =
                                  date.toString().split(' ');
                              dobChild1Controller.text =
                                  splittedDate[0].toString();
                              // DateFormat.yMd().format(date);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  //==========================================================DOB of CHild 2 row===============================================================
                  const Text(
                    "DOB of CHild 2 ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: dobChild2Controller,
                      decoration: InputDecoration(
                        hintText: dobChild2Controller.text == ""
                            ? "Select DOB of Child 1"
                            : dobChild2Controller.text,
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.teal),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onTap: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final date =
                            await AllServices().pickDate(context, dateTime);
                        if (date == null) {
                          return;
                        } else {
                          setState(
                            () {
                              // dateTime = date;
                              List<String> splittedDate =
                                  date.toString().split(' ');
                              dobChild2Controller.text =
                                  splittedDate[0].toString();
                              // DateFormat.yMd().format(date);
                            },
                          );
                        }
                      },
                    ),
                  ),
                  //==========================================================No of patient per day  row===============================================================
                  Row(
                    children: const [
                      Text(
                        "No of patient per day",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: patientNumController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  //==========================================================4p Doctor ID row===============================================================
                  const Text(
                    "4p Doctor ID",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: docIDController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      // onTap: () {
                      //   showDialog(
                      //       context: context,
                      //       builder: (BuildContext context) {
                      //         return AlertDialog(
                      //           content: Container(
                      //             height: screenHeight / 3,
                      //             width: screenWidth / 1,
                      //             decoration: BoxDecoration(
                      //                 borderRadius:
                      //                     BorderRadius.circular(15)),
                      //             child: Column(
                      //               children: [],
                      //             ),
                      //           ),
                      //         );
                      //       });
                      // }
                    ),
                  ),
                  //==========================================================4p Doctor Name row===============================================================
                  const Text(
                    "4p Doctor Name",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: docNameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  //==========================================================4p Doctor Speciality row===============================================================
                  const Text(
                    "4p Doctor Speciality",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: docSpecialityController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  //==========================================================4p Doctor Address row===============================================================
                  const Text(
                    "4p Doctor Address",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 6, 0, 10),

                    child: TextField(
                      controller: docAddressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),

                  //==========================================================Brand===============================================================
                  Row(
                    children: const [
                      Text(
                        "Brand",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "*",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                    ],
                  ),

                  GFMultiSelect(
                    initialSelectedItemsIndex: brandInt,
                    items: brandList,
                    onSelect: (value) {
                      brandListString = " ";
                      if (value.isNotEmpty) {
                        //print("data========$brandListString");

                        for (var e in value) {
                          if (brandListString == " ") {
                            brandListString = widget
                                .docSettings!.resData.brandList[e].brandId;
                          } else {
                            brandListString +=
                                '|${widget.docSettings!.resData.brandList[e].brandId}';
                          }
                        }
                        //print("data========$brandListString");
                      }
                    },
                    cancelButton: cancalButton(),
                    dropdownTitleTileText: '',
                    dropdownTitleTileColor: Colors.grey[200],
                    dropdownTitleTileMargin:
                        const EdgeInsets.fromLTRB(0, 6, 0, 10),
                    dropdownTitleTilePadding:
                        const EdgeInsets.fromLTRB(5, 6, 5, 10),
                    dropdownUnderlineBorder:
                        const BorderSide(color: Colors.transparent, width: 2),
                    dropdownTitleTileBorder:
                        Border.all(color: Colors.grey, width: 1),
                    dropdownTitleTileBorderRadius: BorderRadius.circular(10),
                    expandedIcon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black54,
                    ),
                    collapsedIcon: const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.black54,
                    ),
                    // submitButton: Text('OK'),
                    // dropdownTitleTileTextStyle: const Text   Style(
                    //     fontSize: 14, color: Colors.black54),
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    type: GFCheckboxType.basic,
                    activeBgColor: Colors.green.withOpacity(0.5),
                    inactiveBorderColor: Colors.grey,
                  ),

                  widget.isEdit
                      ? editsubmitButton(context)
                      : submitButton(context)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Center submitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (cid != "") {
            if (userPassword != "") {
              if (categoryValue.isNotEmpty) {
                if (categoryValue.isNotEmpty) {
                  if (adressController.text.isNotEmpty) {
                    if (mobileController.text.isNotEmpty) {
                      if (thanaSelectedId != "") {
                        if (districtSelectedId != "") {
                          if (patientNumController.text.isNotEmpty) {
                            if (brandListString != " ") {
                              readyForData();

                              Map<String, dynamic> a = await DcrRepositories()
                                  .addDoctorR(
                                      dmPathData!.doctorAddUrl,
                                      cid,
                                      userLoginInfo!.userId,
                                      userPassword,
                                      widget.areaID,
                                      widget.areaName,
                                      nameController.text.toString(),
                                      categoryValue,
                                      docCategoryValue,
                                      docTypeValue,
                                      docSpecialityValue,
                                      degreeList,
                                      chemistId,
                                      adressController.text.toString(),
                                      thanaSelectedId,
                                      districtSelectedId,
                                      mobileController.text.toString(),
                                      marriageDayController.text.toString(),
                                      dobChild1Controller.text.toString(),
                                      dobChild2Controller.text.toString(),
                                      collarSize,
                                      patientNumController.text.toString(),
                                      docIDController.text.toString(),
                                      docNameController.text.toString(),
                                      docSpecialityController.text.toString(),
                                      docAddressController.text.toString(),
                                      brandListString,
                                      dobController.text.toString());

                              String status = a['status'];

                              if (status == "Success") {
                                AllServices().toastMessage(
                                    "Doctor Added Successfully Done",
                                    Colors.green,
                                    Colors.white,
                                    14);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                String resString = a['ret_str'] ?? "";

                                AllServices().toastMessage(
                                    "$status for $resString",
                                    Colors.red,
                                    Colors.white,
                                    14);
                              }
                            } else {
                              AllServices().toastMessage(
                                  "Please select brand Day",
                                  Colors.red,
                                  Colors.white,
                                  14);
                            }
                          } else {
                            AllServices().toastMessage(
                                "Please fill up your patient per Day",
                                Colors.red,
                                Colors.white,
                                14);
                          }
                        } else {
                          AllServices().toastMessage(
                              "Please select up your District",
                              Colors.red,
                              Colors.white,
                              14);
                        }
                      } else {
                        AllServices().toastMessage(
                            "Please select up your Thana",
                            Colors.red,
                            Colors.white,
                            14);
                      }
                    } else {
                      AllServices().toastMessage(
                          "Please fill up your mobile number",
                          Colors.red,
                          Colors.white,
                          14);
                    }
                  } else {
                    AllServices().toastMessage("Please fill up your address",
                        Colors.red, Colors.white, 14);
                  }
                } else {
                  AllServices().toastMessage("Please select up your Category",
                      Colors.red, Colors.white, 14);
                }
              } else {
                AllServices().toastMessage(
                    "Please select your Doctor Category first",
                    Colors.red,
                    Colors.white,
                    14);
              }
            } else {
              AllServices().toastMessage(
                  "Password did not Found", Colors.red, Colors.white, 14);
            }
          } else {
            AllServices()
                .toastMessage("CID Missing", Colors.red, Colors.white, 14);
          }

          ///code beyadobi kore
        },
        style: ElevatedButton.styleFrom(
            fixedSize: Size(screenWidth / 1.2, screenHeight * 0.06),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: const Color.fromARGB(255, 4, 60, 105)),
        child: const Text("Submit"),
      ),
    );
  }

  Center editsubmitButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          if (cid != "") {
            if (userPassword != "") {
              if (categoryValue.isNotEmpty) {
                if (categoryValue.isNotEmpty) {
                  if (adressController.text.isNotEmpty) {
                    if (mobileController.text.isNotEmpty) {
                      if (patientNumController.text.isNotEmpty) {
                        if (brandListString != " ") {
                          //readyForData();

                          Map<String, dynamic> a = await DcrRepositories()
                              .editDoctorR(
                                  dmPathData!.doctorEditSubmitUrl,
                                  cid,
                                  userLoginInfo!.userId,
                                  userPassword,
                                  widget.areaID,
                                  widget.areaName,
                                  docId,
                                  nameController.text.toString(),
                                  categoryValue,
                                  docCategoryValue,
                                  docTypeValue,
                                  docSpecialityValue,
                                  degreeList,
                                  chemistId,
                                  adressController.text.toString(),
                                  thanaSelectedId,
                                  districtSelectedId,
                                  mobileController.text.toString(),
                                  marriageDayController.text.toString(),
                                  dobChild1Controller.text.toString(),
                                  dobChild2Controller.text.toString(),
                                  collarSize,
                                  patientNumController.text.toString(),
                                  docIDController.text.toString(),
                                  docNameController.text.toString(),
                                  docSpecialityController.text.toString(),
                                  docAddressController.text.toString(),
                                  brandListString,
                                  dobController.text.toString());

                          String status = a['status'];

                          if (status == "Success") {
                            AllServices().toastMessage(
                                "Doctor Edited Successfully Done",
                                Colors.green,
                                Colors.white,
                                14);
                            Navigator.pop(context);
                          } else {
                            String resString = a['ret_str'] ?? "";

                            AllServices().toastMessage("$status for $resString",
                                Colors.red, Colors.white, 14);
                          }
                        } else {
                          AllServices().toastMessage("Please select brand",
                              Colors.red, Colors.white, 14);
                        }
                      } else {
                        AllServices().toastMessage(
                            "Please fill up your patient per Day",
                            Colors.red,
                            Colors.white,
                            14);
                      }
                    } else {
                      AllServices().toastMessage(
                          "Please fill up your mobile number",
                          Colors.red,
                          Colors.white,
                          14);
                    }
                  } else {
                    AllServices().toastMessage("Please fill up your address",
                        Colors.red, Colors.white, 14);
                  }
                } else {
                  AllServices().toastMessage("Please select up your Category",
                      Colors.red, Colors.white, 14);
                }
              } else {
                AllServices().toastMessage(
                    "Please select your Doctor Category first",
                    Colors.red,
                    Colors.white,
                    14);
              }
            } else {
              AllServices().toastMessage(
                  "Password did not Found", Colors.red, Colors.white, 14);
            }
          } else {
            AllServices()
                .toastMessage("CID Missing", Colors.red, Colors.white, 14);
          }

          ///code beyadobi kore
        },
        style: ElevatedButton.styleFrom(
            fixedSize: Size(screenWidth / 1.2, screenHeight * 0.06),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: const Color.fromARGB(255, 4, 60, 105)),
        child: const Text("Submit"),
      ),
    );
  }

  cancalButton() {}
  readyForData() {
    districtSelectedId = getThanaWithDist.first.districtId;
    for (var element in getThanaWithDist.first.thanaList) {
      if (element.thanaName == thanaValue) {
        thanaSelectedId = element.thanaId;
      }
    }

    setState(() {});
  }
}
