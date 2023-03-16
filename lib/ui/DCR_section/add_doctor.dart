import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/components/dropdown/gf_multiselect.dart';
import 'package:getwidget/types/gf_checkbox_type.dart';
import 'package:intl/intl.dart';

import 'package:MREPORTING/services/all_services.dart';

class DcotorInfoScreen extends StatefulWidget {
  String areaName;
  String docName;
  String docID;
  List customerList;
  DcotorInfoScreen({
    Key? key,
    required this.areaName,
    required this.docName,
    required this.docID,
    required this.customerList,
  }) : super(key: key);

  @override
  State<DcotorInfoScreen> createState() => _DcotorInfoScreenState();
}

class _DcotorInfoScreenState extends State<DcotorInfoScreen> {
  final formKey = GlobalKey<FormState>();
  DateTime dateTime = DateTime.now();

  TextEditingController nameController = TextEditingController();
  TextEditingController degreeController = TextEditingController();
  TextEditingController chemistIDController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController thanaController = TextEditingController();
  TextEditingController districtController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController marriageDayController = TextEditingController();
  TextEditingController collarSizeController = TextEditingController();
  TextEditingController dobChild1Controller = TextEditingController();
  TextEditingController dobChild2Controller = TextEditingController();
  TextEditingController patientNumController = TextEditingController();
  TextEditingController docIDController = TextEditingController();
  TextEditingController docNameController = TextEditingController();
  TextEditingController docSpecialityController = TextEditingController();
  TextEditingController docAddressController = TextEditingController();
  // TextEditingController nameController = TextEditingController();
  var screenHeight;
  var screenWidth;
  List<String> any = ["a", "b", "c"];
  List<String> dcrVisitedWithList = ["a", "b", "c"];
  List<String> customerNameList = [];
  String dropdownValue = "a";
  //=========================================proper way of initializing screenhight and screeWidth=====================================================
  // / static double
  // / static const double
  // /// Get the proportionate height as per screen size.
  // double getProportionateScreenHeight(double inputHeight) =>
  //     (inputHeight / layoutHeight) * size.height;
  //=========================================proper way of initializing screenhight and screeWidth=====================================================

  @override
  void initState() {
    widget.docName != "" ? nameController.text = widget.docName.toString() : "";
    widget.customerList.forEach((element) {
      customerNameList.add(element["client_name"]);
    });
    // customerNameList.add(widget.customerList["client_name"])
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Doctor"),
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
                                  onChanged: (value) {},
                                  value: dropdownValue,
                                  items: any.map(
                                    (String e) {
                                      //print(e);
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
                                  onChanged: (value) {},
                                  value: dropdownValue,
                                  items: any.map(
                                    (String e) {
                                      //print(e);
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
                                  onChanged: (value) {},
                                  value: dropdownValue,
                                  items: any.map(
                                    (String e) {
                                      //print(e);
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
                                  onChanged: (value) {},
                                  value: dropdownValue,
                                  items: any.map(
                                    (String e) {
                                      //print(e);
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  //==========================================================Degree Row===============================================================

                  const Text(" Degree"),
                  GFMultiSelect(
                    items: dcrVisitedWithList,
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
                              value: dropdownValue,
                              items: any.map(
                                (String e) {
                                  //print(e);
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
                              onChanged: (value) {},
                              value: dropdownValue,
                              items: any.map(
                                (String e) {
                                  //print(e);
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
                        onChanged: (value) {},
                        value: dropdownValue,
                        items: any.map(
                          (String e) {
                            //print(e);
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
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Container(
                                    height: screenHeight / 3,
                                    width: screenWidth / 1,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Column(
                                      children: [],
                                    ),
                                  ),
                                );
                              });
                        }),
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
                    items: dcrVisitedWithList,
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
                      onPressed: () {
                        var a = DcrRepositories().addDoctorR();
                        print("object=====================$a");
                      },
                      style: ElevatedButton.styleFrom(
                          fixedSize:
                              Size(screenWidth / 1.2, screenHeight * 0.06),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          backgroundColor: Color.fromARGB(255, 4, 60, 105)),
                      child: Text("Submit"),
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
