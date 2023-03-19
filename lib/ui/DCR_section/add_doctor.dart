// ignore_for_file: public_member_api_docs, sort_constructors_first
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
  final String areaName;
  final String areaID;
  final Map? editDoctorInfo;
  final List customerList;
  final DocSettingsModel docSettings;

  const DcotorInfoScreen({
    Key? key,
    required this.isEdit,
    required this.areaName,
    required this.areaID,
    this.editDoctorInfo,
    required this.customerList,
    required this.docSettings,
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
  String dropdownValue = "_";
  List<String> degree = [];
  String degreeList = " ";
  List<String> collarSizeList = [];
  List<String> brandList = [];

  String brandListString = " ";
  String dCgSelectedValue = '_';
  String docCtSelectedValue = '_';
  String docTypeSelectedValue = '_';
  String docSpSelectedValue = '_';
  String thanaSelectedValue = '_';
  String districtSelectedValue = '_';
  String collarSize = '';
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
        // userId = prefs.getString("USER_ID")!;
        // areaPageUrl = prefs.getString('user_area_url')!;
        userPassword = prefs.getString("PASSWORD")!;
        // syncUrl = prefs.getString("sync_url")!;
      });
    });

    if (widget.isEdit) {
      nameController.text = widget.editDoctorInfo!['doc_name'].toString();
      dCgSelectedValue = widget.docSettings.resData.dCategoryList.first;
      docCtSelectedValue = widget.docSettings.resData.docCategoryList.first;
      docTypeSelectedValue = widget.docSettings.resData.docTypeList.first;
      docSpSelectedValue = widget.docSettings.resData.docSpecialtyList.first;
      districtSelectedValue =
          widget.docSettings.resData.distThanaList.first.districtName;
      getThanaWithDist = widget.docSettings.resData.distThanaList
          .where((element) => element.districtName == districtSelectedValue)
          .toList();

      thanaSelectedValue = getThanaWithDist.first.thanaList.first.thanaName;
      degree = widget.docSettings.resData.docDegreeList;
      for (var element in widget.docSettings.resData.brandList) {
        brandList.add(element.brandName);
      }
    } else {
      dCgSelectedValue = widget.docSettings.resData.dCategoryList.first;
      docCtSelectedValue = widget.docSettings.resData.docCategoryList.first;
      docTypeSelectedValue = widget.docSettings.resData.docTypeList.first;
      docSpSelectedValue = widget.docSettings.resData.docSpecialtyList.first;
      districtSelectedValue =
          widget.docSettings.resData.distThanaList.first.districtName;
      getThanaWithDist = widget.docSettings.resData.distThanaList
          .where((element) => element.districtName == districtSelectedValue)
          .toList();

      thanaSelectedValue = getThanaWithDist.first.thanaList.first.thanaName;
      degree = widget.docSettings.resData.docDegreeList;
      for (var element in widget.docSettings.resData.brandList) {
        brandList.add(element.brandName);
      }
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

    for (var element in widget.customerList) {
      customerNameList.add(element["client_name"]);
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
        title: const Text("Add Doctor"),
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
                  Text("Territory : ${widget.areaName}"),
                  const Text("Name : "),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                    height: screenHeight / 7.5,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Category"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? value) {
                                    setState(() {
                                      dCgSelectedValue = value!;
                                      // print(dCgSelectedValue);
                                    });
                                  },
                                  value: dCgSelectedValue,
                                  items: widget.docSettings.resData
                                          .dCategoryList.isNotEmpty
                                      ? widget.docSettings.resData.dCategoryList
                                          .map<DropdownMenuItem<String>>(
                                              (String e) => DropdownMenuItem(
                                                  value: e, child: Text(e)))
                                          .toList()
                                      : any.map<DropdownMenuItem<String>>(
                                          (String e) {
                                            //print(e);
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e.toString()),
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
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Doctor Category"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      docCtSelectedValue = newValue!;
                                    });
                                  },
                                  // value: dropdownValue,
                                  value: docCtSelectedValue,
                                  items: widget.docSettings.resData
                                          .docCategoryList.isNotEmpty
                                      ? widget
                                          .docSettings.resData.docCategoryList
                                          .map<DropdownMenuItem<String>>(
                                              (String e) => DropdownMenuItem(
                                                  value: e, child: Text(e)))
                                          .toList()
                                      : any.map<DropdownMenuItem<String>>(
                                          (String e) {
                                            //print(e);
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e.toString()),
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
                            const Text("Doctor Type"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      docTypeSelectedValue = newValue!;
                                    });
                                  },
                                  // value: dropdownValue,
                                  value: docTypeSelectedValue,
                                  items: widget.docSettings.resData.docTypeList
                                          .isNotEmpty
                                      ? widget.docSettings.resData.docTypeList
                                          .map<DropdownMenuItem<String>>(
                                              (String e) => DropdownMenuItem(
                                                  value: e, child: Text(e)))
                                          .toList()
                                      : any.map<DropdownMenuItem<String>>(
                                          (String e) {
                                            //print(e);
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e.toString()),
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
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Speciality"),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: screenWidth / 2.3,
                                child: DropdownButtonFormField(
                                  decoration:
                                      const InputDecoration(enabled: false),
                                  isExpanded: true,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      docSpSelectedValue = newValue!;
                                    });
                                  },
                                  value: docSpSelectedValue,
                                  items: widget.docSettings.resData
                                          .docSpecialtyList.isNotEmpty
                                      ? widget
                                          .docSettings.resData.docSpecialtyList
                                          .map<DropdownMenuItem<String>>(
                                              (String e) => DropdownMenuItem(
                                                  value: e, child: Text(e)))
                                          .toList()
                                      : any.map<DropdownMenuItem<String>>(
                                          (String e) {
                                            //print(e);
                                            return DropdownMenuItem(
                                              value: e,
                                              child: Text(e.toString()),
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  //==========================================================Degree Row===============================================================

                  const Text(" Degree"),
                  GFMultiSelect(
                    //initialSelectedItemsIndex: [0],
                    items: widget.docSettings.resData.docDegreeList.isNotEmpty
                        ? widget.docSettings.resData.docDegreeList
                        : degree,
                    onSelect: (value) {
                      degreeList = " ";
                      if (value.isNotEmpty) {
                        for (var e in value) {
                          if (degreeList == " ") {
                            degreeList =
                                widget.docSettings.resData.docDegreeList[e];
                          } else {
                            degreeList += '|' +
                                widget.docSettings.resData.docDegreeList[e];
                          }
                          // degreeList
                          //     .add(widget.docSettings.resData.docDegreeList[e]);
                          print("degree= $degreeList");
                        }
                      }
                      // dcrString = '';
                      // if (value.isNotEmpty) {
                      //   for (var e in value) {
                      //     if (dcrString == '') {
                      //       dcrString =
                      //           dcr_visitedWithList[e];
                      //     } else {
                      //       dcrString +=
                      //           '|' + dcr_visitedWithList[e];
                      //     }
                      //   }
                      // }

                      //print('selected $value ');
                      // //print(dcrString);
                    },
                    cancelButton: cancalButton(),
                    dropdownTitleTileText: '',
                    dropdownTitleTileColor: Colors.grey[200],
                    dropdownTitleTileMargin:
                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    dropdownTitleTilePadding:
                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                    // dropdownTitleTileTextStyle: const TextStyle(
                    //     fontSize: 14, color: Colors.black54),
                    padding: EdgeInsets.zero,
                    margin: const EdgeInsets.all(0),
                    type: GFCheckboxType.basic,
                    activeBgColor: Colors.green.withOpacity(0.5),
                    inactiveBorderColor: Colors.grey,
                  ),

                  //==========================================================Chemist Row===============================================================

                  const Text("Chemist ID "),
                  GFMultiSelect(
                    items: customerNameList,
                    onSelect: (value) {
                      // dcrString = '';
                      // if (value.isNotEmpty) {
                      //   for (var e in value) {
                      //     if (dcrString == '') {
                      //       dcrString =
                      //           dcr_visitedWithList[e];
                      //     } else {
                      //       dcrString +=
                      //           '|' + dcr_visitedWithList[e];
                      //     }
                      //   }
                      // }
                      degreeController.text = value.toString();
                      //print('selected $value ');
                      // //print(dcrString);
                    },
                    cancelButton: cancalButton(),
                    dropdownTitleTileText: '',
                    dropdownTitleTileColor: Colors.grey[200],
                    dropdownTitleTileMargin:
                        const EdgeInsets.fromLTRB(0, 10, 0, 10),

                    dropdownTitleTilePadding:
                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                    // dropdownTitleTileTextStyle: const TextStyle(
                    //     fontSize: 14, color: Colors.black54),
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    type: GFCheckboxType.basic,
                    activeBgColor: Colors.green.withOpacity(0.5),
                    inactiveBorderColor: Colors.grey,
                  ),
                  //==========================================================Address row===============================================================
                  const Text("Address"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Thana"),
                          SizedBox(
                            width: screenWidth / 2.1,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              isExpanded: true,
                              onChanged: (value) {},
                              value: thanaSelectedValue,
                              items: getThanaWithDist.first.thanaList.isNotEmpty
                                  ? getThanaWithDist.first.thanaList
                                      .map((e) => DropdownMenuItem(
                                          value: e.thanaName,
                                          child: Text(e.thanaName)))
                                      .toList()
                                  : any.map<DropdownMenuItem<String>>(
                                      (String e) {
                                        //print(e);
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e.toString()),
                                        );
                                      },
                                    ).toList(),
                              style: const TextStyle(
                                color: Colors.black,
                                // fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("District"),
                          SizedBox(
                            width: screenWidth / 2.1,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                districtSelectedValue = newValue!;
                                getThanaWithDist = widget
                                    .docSettings.resData.distThanaList
                                    .where((element) =>
                                        element.districtName == newValue)
                                    .toList();

                                thanaSelectedValue =
                                    getThanaWithDist.first.thanaList.isNotEmpty
                                        ? getThanaWithDist
                                            .first.thanaList.first.thanaName
                                        : '_';
                                setState(() {});
                                // getThana.first.thanaList.forEach((element) {
                                //   print(element.thanaName);
                                // });
                              },
                              value: districtSelectedValue,
                              items: widget.docSettings.resData.distThanaList
                                      .isNotEmpty
                                  ? widget.docSettings.resData.distThanaList
                                      .map((e) => DropdownMenuItem(
                                          value: e.districtName,
                                          child: Text(e.districtName)))
                                      .toList()
                                  : any.map<DropdownMenuItem<String>>(
                                      (String e) {
                                        //print(e);
                                        return DropdownMenuItem(
                                          value: e,
                                          child: Text(e.toString()),
                                        );
                                      },
                                    ).toList(),
                              style: const TextStyle(
                                color: Colors.black,
                                // fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  //==========================================================Mobile Number row===============================================================
                  const Text("Mobile Number"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("DOB"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("Marriage Day"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("Collar Size"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                        value: widget.docSettings.resData.collarSizeList.first,
                        items:
                            widget.docSettings.resData.collarSizeList.isNotEmpty
                                ? widget.docSettings.resData.collarSizeList.map(
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
                  const Text("DOB of CHild 1 "),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("DOB of CHild 2 "),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("No of patient per day"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("4p Doctor ID"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("4p Doctor Name"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("4p Doctor Speciality"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("4p Doctor Address"),
                  Padding(
                    // padding: const EdgeInsets.all(6.0),
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),

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
                  const Text("Brand"),

                  GFMultiSelect(
                    items: brandList,
                    onSelect: (value) {
                      brandListString = " ";
                      if (value.isNotEmpty) {
                        //print("data========$brandListString");

                        for (var e in value) {
                          if (brandListString == " ") {
                            brandListString =
                                widget.docSettings.resData.brandList[e].brandId;
                          } else {
                            brandListString +=
                                '|${widget.docSettings.resData.brandList[e].brandId}';
                          }
                        }
                        print("data========$brandListString");
                      }
                      // dcrString = '';
                      // if (value.isNotEmpty) {
                      //   for (var e in value) {
                      //     if (dcrString == '') {
                      //       dcrString =
                      //           dcr_visitedWithList[e];
                      //     } else {
                      //       dcrString +=
                      //           '|' + dcr_visitedWithList[e];
                      //     }
                      //   }
                      // }

                      // //print('selected $value ');
                      // //print(dcrString);
                    },
                    cancelButton: cancalButton(),
                    dropdownTitleTileText: '',
                    dropdownTitleTileColor: Colors.grey[200],
                    dropdownTitleTileMargin:
                        const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    dropdownTitleTilePadding:
                        const EdgeInsets.fromLTRB(5, 10, 5, 10),
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
                    // dropdownTitleTileTextStyle: const TextStyle(
                    //     fontSize: 14, color: Colors.black54),
                    padding: const EdgeInsets.all(0),
                    margin: const EdgeInsets.all(0),
                    type: GFCheckboxType.basic,
                    activeBgColor: Colors.green.withOpacity(0.5),
                    inactiveBorderColor: Colors.grey,
                  ),

                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        ///hashbo na kadbo

                        var a = await DcrRepositories().addDoctorR(
                            dmPathData!.doctorAddUrl,
                            cid,
                            userLoginInfo!.userId,
                            userPassword,
                            widget.areaID,
                            widget.areaName,
                            nameController.text.toString(),
                            dCgSelectedValue,
                            docCtSelectedValue,
                            docTypeSelectedValue,
                            docSpSelectedValue,
                            degreeList,
                            "pharmacy|pharmacy",
                            adressController.text.toString(),
                            thanaSelectedValue,
                            districtSelectedValue,
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
                        print("object=====================$a");

                        ///code beyadobi kore
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(screenWidth / 1.2, screenHeight * 0.06),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor:
                              const Color.fromARGB(255, 4, 60, 105)),
                      child: const Text("Submit"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  cancalButton() {
    //print("cancelled");
  }
}
