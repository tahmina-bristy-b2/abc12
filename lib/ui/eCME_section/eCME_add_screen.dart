import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/e_CME/e_CME_submit_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/ui/eCME_section/eCME_doctor_preview.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_row_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_textformFiled_widget.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECMEAddScreen extends StatefulWidget {
  List docInfo;

  ECMEAddScreen(
      {super.key,
      required this.docInfo,
      });

  @override
  State<ECMEAddScreen> createState() => _ECMEAddScreenState();
}

class _ECMEAddScreenState extends State<ECMEAddScreen> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  final GlobalKey<FormState> _form1Key = GlobalKey();
  DateTime selectedExpiredDate=DateTime.now();
  String selectedExpiredDateString=DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController meetingDateController = TextEditingController();
  TextEditingController meetingVenueController = TextEditingController();
  TextEditingController meetingTopicController = TextEditingController();
  TextEditingController brandSelectedController = TextEditingController();
  TextEditingController rxPerDayController = TextEditingController();
  TextEditingController eCMEAmountCOntroller = TextEditingController();
  TextEditingController salesQtyController = TextEditingController();
  TextEditingController meetingProbaleSpeakerNameController = TextEditingController();
  TextEditingController probaleSpeakerInstituteController = TextEditingController();
  TextEditingController totalNumberOfParticiController = TextEditingController();
  TextEditingController totalBudgetController = TextEditingController();
  TextEditingController hallRentController = TextEditingController();
  TextEditingController foodExpansesController = TextEditingController();
  TextEditingController costperDoctorController = TextEditingController();
  TextEditingController lunchDinnerController = TextEditingController();
  TextEditingController stationnairesController = TextEditingController();
  TextEditingController giftController = TextEditingController();
  TextEditingController othersController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController rxObjectiveperDayController = TextEditingController();
  TextEditingController internDoctorController = TextEditingController();
  TextEditingController dmfDoctorController = TextEditingController();
  TextEditingController nursesController = TextEditingController();
  TextEditingController doctorParticipantCount = TextEditingController();
  TextEditingController skfAttenaceController = TextEditingController();
  TextEditingController othersParticipantsController = TextEditingController();
  TextEditingController eCMEAmountForRMPController = TextEditingController();
  TextEditingController eCMESplitAmountController = TextEditingController();
  TextEditingController probaleSpeakerDesignationController = TextEditingController();
  TextEditingController probaleSpeakerDegreeController = TextEditingController();
  ECMESavedDataModel? eCMESettingsData;
  List<String>? eBrandList = [];
  
  List<List<dynamic>> dynamicRowsListForBrand = [];
  List<List<dynamic>> finalBrandListAftrRemoveDuplication = [];
  String? initialBrand;
  String? selectedECMEType;
  String? selcetDoctorCategory;
  String? selectedDepartment;
  String? selectedPayMode;
 

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
  double splitedAmount=0.0;
  
  final RegExp phoneRegex = RegExp(r'^\d{13}$');
  bool isMobileUpdate = false;
  List<String> eCMETypeList=[];
  double totalBudget=0.0;
  int noIfparticipants=0;
  double costPerDoctor=0.0;

  @override
  void initState() {
    super.initState();
     eCMEAmountCOntroller.addListener((){
            setState(() {
                    });
        });
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    eCMESettingsData = Boxes.geteCMEsetData().get("eCMESavedDataSync")!;
    eCMETypeList = Boxes.geteCMEsetData().get("eCMESavedDataSync")!.eCMETypeList;
    allSettingsDataGet(eCMESettingsData);
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
  allSettingsDataGet(ECMESavedDataModel? eDSRsettingsData) {
    eBrandList = eDSRsettingsData!.eCMEBrandList.map((e) => e.brandName).toList();  
  }

  //=============================== get brand String ===============================
  String getbrandString() {
    brandString = '';
    for (var element1 in eCMESettingsData!.eCMEBrandList) {
      if (finalBrandListAftrRemoveDuplication.isNotEmpty) {
        for (int i = 0; i < finalBrandListAftrRemoveDuplication.length; i++) {
          if (element1.brandName == finalBrandListAftrRemoveDuplication[i][0]) {
            if (brandString == "") {
              brandString +=
                  "${element1.brandId}|${element1.brandName}|${finalBrandListAftrRemoveDuplication[i][2]}";
            } else {
              brandString +=
                  "||${element1.brandId}|${element1.brandName}|${finalBrandListAftrRemoveDuplication[i][2]}";
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

  //============================ total budget =========================
double getTotalBudget() {
  double hall = double.tryParse(hallRentController.text) ?? 0.0;
  double food = double.tryParse(foodExpansesController.text) ?? 0.0;
  double gift = double.tryParse(giftController.text) ?? 0.0;
  double others = double.tryParse(stationnairesController.text) ?? 0.0;
  totalBudget = hall + food + gift + others ;
  totalBudgetController.text = totalBudget.toStringAsFixed(2);
  getCostPerDoctor();
  return totalBudget;
}

//============================ total Numbers of participants =========================
int totalParticipants() {
  noIfparticipants = 
    (int.tryParse(doctorParticipantCount.text) ?? 0) +
    (int.tryParse(internDoctorController.text) ?? 0) +
    (int.tryParse(dmfDoctorController.text) ?? 0) +
    (int.tryParse(nursesController.text) ?? 0)+ (int.tryParse(skfAttenaceController.text) ?? 0)+ (int.tryParse(nursesController.text) ?? 0) +(int.tryParse(othersParticipantsController.text) ?? 0); 
  getCostPerDoctor();
  setState(() {
    
  });
  return noIfparticipants;
}
   //============================== Cost per doctor ======================================
   double getCostPerDoctor(){
    if(totalBudget>0.0){
      double costPerDoctor= totalBudget/noIfparticipants;
      return costPerDoctor;
    }
    else{
      return 0.0;
    }
   }

  double getECMEAmontSplit(){
    splitedAmount=0;
    int listNum= finalBrandListAftrRemoveDuplication.length;
    double? eCMEAmount= double.tryParse(eCMEAmountCOntroller.text)??0.0 ;
    splitedAmount=(eCMEAmount/listNum);
    print("splited data =$splitedAmount");
    return splitedAmount;
   }

  @override
  void dispose() {
    meetingDateController.dispose();
    rxPerDayController.dispose();
    eCMEAmountCOntroller.dispose();
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
          "e-CME Add",
        ),
      ),
      body: SingleChildScrollView(
        reverse: false,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction, 
            key:_form1Key,
            child: Column(
              children: [
                SizedBox(
                  height: wholeHeight / 75.927,
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                  padding:  EdgeInsets.only(left: 6),
                    child: Text(
                                    "Selected Doctors*",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w600),
                                  ),
                  ),
                ),
                              const SizedBox(
                                height: 6,
                              ),
                Row(
                  children: [
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          height: widget.docInfo.length*20,
                          width: 150,
                          child: ListView.builder(itemCount: widget.docInfo.length,
                            itemBuilder: (context,index){
                               return Padding(
                                 padding: const EdgeInsets.only(top: 4),
                                 child: Text( "${index+1}. ${widget.docInfo[index]["doc_name"]}|${widget.docInfo[index]["degree"]}|${widget.docInfo[index]["specialty"]}",style: const TextStyle(fontSize: 13),),
                               );
                            }),
                        
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: IconButton(
                        icon: const Icon(Icons.edit,
                            size: 20, color: Color(0xff8AC995)),
                        onPressed: () {
                          Navigator.pop(context);
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         scrollable: true,
                          //         title: Center(
                          //             child: Text(
                          //                 "${widget.docInfo["doc_name"]}")),
                          //         content: SizedBox(
                          //           height: 150,
                          //           child: Form(
                          //             key: _form1Key,
                          //             child: Column(
                          //               children: [
                          //                 const SizedBox(
                          //                   height: 15,
                          //                 ),
                          //                 const Align(
                          //                   alignment: Alignment.centerLeft,
                          //                   child: Text(
                          //                     "Mobile Number*",
                          //                     style: TextStyle(
                          //                         fontWeight: FontWeight.w500),
                          //                   ),
                          //                 ),
                          //                 const SizedBox(
                          //                   height: 5,
                          //                 ),
                          //                 SizedBox(
                          //                   width: MediaQuery.of(context)
                          //                           .size
                          //                           .width /
                          //                       1.1,
                          //                   height: 45,
                          //                   child: TextFormField(
                          //                     keyboardType: TextInputType.number,
                          //                     inputFormatters: [
                          //                        FilteringTextInputFormatter
                          //                                               .allow(
                          //                                             RegExp(
                          //                                                 "[A-Za-z0-9]"),
                          //                                           ),
                          //                       FilteringTextInputFormatter.deny(
                          //                         RegExp(r'^\d{12,}$'),
                          //                       ),
                          //                     ],
                          //                     validator: (value) {
                          //                       if (value!.isEmpty) {
                          //                         return "Mobile Number is required";
                          //                       }
                          //                       if (value.length < 11 
                          //                           ) {
                          //                         return "Mobile Number should be  11  digits";
                          //                       }
                          //                     },
                          //                   ),
                          //                 ),
                          //                 const SizedBox(
                          //                   height: 20,
                          //                 ),
                          //                 Row(
                          //                   children: [
                          //                     Expanded(
                          //                       child: InkWell(
                          //                           child: Container(
                          //                             height: 40,
                          //                             decoration: BoxDecoration(
                          //                               borderRadius:
                          //                                   BorderRadius.circular(
                          //                                       10),
                          //                               color:
                          //                                   const Color.fromARGB(
                          //                                       255,
                          //                                       170,
                          //                                       172,
                          //                                       170),
                          //                             ),
                          //                             child: const Center(
                          //                                 child: Text("Cancel",
                          //                                     style: TextStyle(
                          //                                       color: Color
                          //                                           .fromARGB(
                          //                                               255,
                          //                                               255,
                          //                                               255,
                          //                                               255),
                          //                                     ))),
                          //                           ),
                          //                           onTap: () {
                          //                             // Navigator.pop(context);
                          //                             // doctorMobileNumberController
                          //                             //     .text = widget
                          //                             //         .docInfo[
                          //                             //     widget.index]["mobile"];
                          //                           }),
                          //                     ),
                          //                     const SizedBox(
                          //                       width: 15,
                          //                     ),
                          //                     Expanded(
                          //                       child: InkWell(
                          //                           child: Container(
                          //                             height: 40,
                          //                             decoration: BoxDecoration(
                          //                               borderRadius:
                          //                                   BorderRadius.circular(
                          //                                       10),
                          //                               color:
                          //                                   const Color.fromARGB(
                          //                                       255, 44, 114, 66),
                          //                             ),
                          //                             child:  isMobileUpdate?const Center(child:  CircularProgressIndicator()) :const Center(
                          //                                 child: Text("Update",
                          //                                     style: TextStyle(
                          //                                       color: Color
                          //                                           .fromARGB(
                          //                                               255,
                          //                                               255,
                          //                                               255,
                          //                                               255),
                          //                                     ))),
                          //                           ),
                          //                           onTap: () async {
                          //                             // if (_form1Key.currentState!
                          //                             //     .validate()) {
                          //                             //   setState(() {
                          //                             //     isMobileUpdate = true;
                          //                             //   });
                          //                             //   bool result =
                          //                             //       await InternetConnectionChecker()
                          //                             //           .hasConnection;
                          //                             //   if (result == true) {
                          //                             //     Map<String, dynamic>
                          //                             //         responsData =
                          //                             //         await EDSRRepositories().getMobileNumberUpdation(
                          //                             //             dmpathData!
                          //                             //                 .submitUrl,
                          //                             //             cid!,
                          //                             //             userInfo!
                          //                             //                 .userId,
                          //                             //             userPassword,
                          //                             //             widget.docInfo[
                          //                             //                     widget
                          //                             //                         .index]
                          //                             //                 ["doc_id"],
                          //                             //             doctorType!,
                          //                             //             doctorMobileNumberController
                          //                             //                 .text,
                          //                             //             widget.docInfo[
                          //                             //                     widget
                          //                             //                         .index]
                          //                             //                 [
                          //                             //                 "area_id"]);
                          //                             //     if (responsData
                          //                             //         .isNotEmpty) {
                          //                             //       if (responsData[
                          //                             //               "status"] ==
                          //                             //           "Success") {
                          //                             //         widget.docInfo[widget
                          //                             //                     .index]
                          //                             //                 ["mobile"] =
                          //                             //             doctorMobileNumberController
                          //                             //                 .text;
                          //                             //         setState(() {
                          //                             //           isMobileUpdate =
                          //                             //               false;
                          //                             //         });
                          //                             //         AllServices()
                          //                             //             .toastMessage(
                          //                             //                 responsData[
                          //                             //                     "ret_str"],
                          //                             //                 Colors
                          //                             //                     .green,
                          //                             //                 Colors
                          //                             //                     .white,
                          //                             //                 14);
          
                          //                             //         if (!mounted) {
                          //                             //           return;
                          //                             //         }
                          //                             //         Navigator.pop(
                          //                             //             context);
                          //                             //       } else {
                          //                             //         setState(() {
                          //                             //           isMobileUpdate =
                          //                             //               false;
                          //                             //         });
                          //                             //         AllServices()
                          //                             //             .toastMessage(
                          //                             //                 responsData[
                          //                             //                     "ret_str"],
                          //                             //                 Colors.red,
                          //                             //                 Colors
                          //                             //                     .white,
                          //                             //                 14);
                          //                             //       }
                          //                             //     } else {
                          //                             //       setState(() {
                          //                             //         isMobileUpdate =
                          //                             //             false;
                          //                             //       });
                          //                             //     }
                          //                             //   } else {
                          //                             //     setState(() {
                          //                             //       isMobileUpdate =
                          //                             //           false;
                          //                             //     });
                          //                             //     AllServices()
                          //                             //         .toastMessage(
                          //                             //             interNetErrorMsg,
                          //                             //             Colors.red,
                          //                             //             Colors.white,
                          //                             //             16);
                          //                             //   }
                          //                             // }
                          //                           }),
                          //                     ),
                          //                   ],
                          //                 )
                          //               ],
                          //             ),
                          //           ),
                          //         ),
                          //       );
                          //     });
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10
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
                                "e-CME Type*",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                       width: MediaQuery.of(context).size.width / 1.1,
                                         height: 45,
                                    decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
                                    ),
                                    child:   DropdownButtonHideUnderline(
                                              child: DropdownButton2(
                                                isExpanded: true,
                                                  iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                                  hint: const Text(
                                                    '  Select e-CME Type',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  items: eCMETypeList.map((String item) {
                                                    return DropdownMenuItem(
                                                      value: item, 
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: Text(
                                                          item,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: selectedECMEType,
                                                  onChanged: (value) {
                                                    eCMEAmountCOntroller.clear();
                                                    setState(() {
                                                      selectedECMEType = value; 
                                                      finalBrandListAftrRemoveDuplication.clear();
                                                      eCMEAmountCOntroller.clear();
                                                      dynamicRowsListForBrand.clear();
                                                    });
                                                  },
                                                  
                                                 
                                                  
                                                buttonHeight: 50,
                                                buttonWidth: MediaQuery.of(context).size.width / 1.5,
                                                itemHeight: 40,
                                                dropdownMaxHeight: 252,
                                                searchController: brandSelectedController,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextFormField(
                                                    expands: true,
                                                    maxLines: null,
                                                    controller: brandSelectedController,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.transparent,
                                                      filled: true,
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 8,
                                                      ),
                                                      hintText: '  Search e-CME Type...',
                                                      hintStyle: const TextStyle(fontSize: 14),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn: (item, searchValue) {
                                                  return (item.value.toString().toUpperCase().startsWith(searchValue.toUpperCase()));
                                                },
                                                onMenuStateChange: (isOpen) {
                                                  if (!isOpen) {
                                                    brandSelectedController.clear();
                                                  }
                                                },
                                                
                                              ),
                                            )
                                                                                    
                                
                                ),
                                  const SizedBox(
                                height: 10,
                              ),
                               const Text(
                                "Meeting Date*",
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
                                  child: CustomtextFormFiledWidget(
                                      controller: initialValue(selectedExpiredDateString), 
                                      textAlign: TextAlign.left, 
                                      keyboardType: TextInputType.text,
                                      suffixIcon: const Icon(Icons.calendar_month_outlined,color: Color.fromARGB(255, 82, 179, 98),),
                                      textStyle: const TextStyle(fontSize: 14,color: Color.fromARGB(255, 41, 90, 50),), 
                                      onChanged: (String value) {
                                        setState(() {});
                                        selectedExpiredDateString  = value;

                                      },
          
                                      onTap: () {
                                         pickDate();
                                        },
                                      focusNode: AlwaysDisabledFocusNode(), 
                                      hinText: "",
                                    ),
                                  ),
                                  const SizedBox(
                                height: 10,
                                  ) ,
                             const Text(
                                "Doctor Category*",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                       width: MediaQuery.of(context).size.width / 1.1,
                                         height: 45,
                                    decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
                                    ),
                                    child:   DropdownButtonHideUnderline(
                                              child: DropdownButton2(
                                                isExpanded: true,
                                                  iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                                  hint: const Text(
                                                    ' Select Doctor Category',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  items: ["Institution","KOL Hub or GP Area","Society"].map((String item) {
                                                    return DropdownMenuItem(
                                                      value: item, 
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: Text(
                                                          item,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: selcetDoctorCategory,
                                                  onChanged: (value) {
                                                    if(value!="Institution"){
                                                      institutionController.clear();
                                                      departmentController.clear();

                                                    }
                                                    setState(() {
                                                      selcetDoctorCategory = value; 
                                                    });
                                                  },
                                                buttonHeight: 50,
                                                buttonWidth: MediaQuery.of(context).size.width / 1.5,
                                                itemHeight: 40,
                                                dropdownMaxHeight: 252,
                                                searchController: brandSelectedController,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextFormField(
                                                    expands: true,
                                                    maxLines: null,
                                                    controller: brandSelectedController,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.transparent,
                                                      filled: true,
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 8,
                                                      ),
                                                      hintText: '  Search e-CME Type...',
                                                      hintStyle: const TextStyle(fontSize: 14),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn: (item, searchValue) {
                                                  return (item.value.toString().toUpperCase().startsWith(searchValue.toUpperCase()));
                                                },
                                                onMenuStateChange: (isOpen) {
                                                  if (!isOpen) {
                                                    brandSelectedController.clear();
                                                  }
                                                },
                                                
                                              ),
                                            )
                                                                                    
                                
                               ),
                               selcetDoctorCategory=="Institution"? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const SizedBox(height: 10,),
                                  const Text(
                                "Institution Name*",
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
                                  child: CustomtextFormFiledWidget(
                                             hinText: '----Enter Institution Name----',
                                              controller: institutionController,
                                              textAlign: TextAlign.left, 
                                              keyboardType: TextInputType.text,
                                              textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                              focusNode: AlwaysDisabledFocusNode(),
                                            ),
                                 
                                  ),
                                  const SizedBox(
                                height: 10,
                              ),
                                  const Text(
                                "Department*",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                       width: MediaQuery.of(context).size.width / 1.1,
                                         height: 45,
                                    decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
                                    ),
                                    child:   DropdownButtonHideUnderline(
                                              child: DropdownButton2(
                                                isExpanded: true,
                                                  iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                                  hint: const Text(
                                                    '  ----Select Department Name---- ',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  items: ["A","B","C","D","E"].map((String item) {
                                                    return DropdownMenuItem(
                                                      value: item, 
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: Text(
                                                          item,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: selectedDepartment,
                                                  onChanged: (value) {
                                                    selectedDepartment=value;
                                                    setState(() {
                                                      
                                                    });
                                                    // if(value!="Institution"){
                                                    //   institutionController.clear();
                                                    //   departmentController.clear();

                                                    // }
                                                    // setState(() {
                                                    //   selcetDoctorCategory = value; 
                                                    // });
                                                  },
                                                buttonHeight: 50,
                                                buttonWidth: MediaQuery.of(context).size.width / 1.5,
                                                itemHeight: 40,
                                                dropdownMaxHeight: 252,
                                                searchController: departmentController,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextFormField(
                                                    expands: true,
                                                    maxLines: null,
                                                    controller: departmentController,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.transparent,
                                                      filled: true,
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 8,
                                                      ),
                                                      hintText: '  Search Department Name...',
                                                      hintStyle: const TextStyle(fontSize: 14),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn: (item, searchValue) {
                                                  return (item.value.toString().toUpperCase().startsWith(searchValue.toUpperCase()));
                                                },
                                                onMenuStateChange: (isOpen) {
                                                  if (!isOpen) {
                                                    departmentController.clear();
                                                  }
                                                },
                                                
                                              ),
                                            )
                                                                                    
                                
                               ),
                              // SizedBox(
                              //     width: MediaQuery.of(context).size.width / 1.1,
                              //     height: 45,
                              //     child: CustomtextFormFiledWidget(
                              //         hinText: '----Enter Department---',
                              //         controller: departmentController,
                              //         textAlign: TextAlign.left, 
                              //         keyboardType: TextInputType.text,
                              //         textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                              //         focusNode: AlwaysDisabledFocusNode(),
                              //       ),
                                 
                              //   ),
                                ],
                               ): const SizedBox(),
                               const SizedBox(height: 10,),
                                const Text(
                                "Meeting venue*",
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
                                  child: CustomtextFormFiledWidget(
                                              hinText: '----Enter Meeting Venue----',
                                              controller: meetingVenueController,
                                              textAlign: TextAlign.left, 
                                              keyboardType: TextInputType.text,
                                              textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                              focusNode: AlwaysDisabledFocusNode(),
                                            ),
                                 
                                  ),
                                  const SizedBox(
                                height: 10,
                              ),
                                  const Text(
                                "Meeting Topic*",
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
                                  child: CustomtextFormFiledWidget(
                                      hinText: '----Enter Meeting Topic----',
                                      controller: meetingTopicController,
                                      textAlign: TextAlign.left, 
                                      keyboardType: TextInputType.text,
                                      textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                      focusNode: AlwaysDisabledFocusNode(),
                                    ),
                                 
                                ),
                              SizedBox(
                                height: wholeHeight / 75.927,
                              ),
                            
                                  const Text(
                                "Probable Speaker Name & Designation*",
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
                                  child: CustomtextFormFiledWidget(
                                     hinText: '----Enter Speaker Name----',
                                      controller: meetingProbaleSpeakerNameController,
                                      textAlign: TextAlign.left, 
                                      keyboardType: TextInputType.text,
                                      textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                      focusNode: AlwaysDisabledFocusNode(),
                                    ),
                                  ),
                              const SizedBox(
                                height:  10,
                              ),


                               
                            const SizedBox(
                                height: 6,
                              ),
                                const Text(
                                  "e_CME Amount *" ,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w600),
                                  ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                     hinText: '----Enter e-CME Amount ----',
                                      controller: eCMEAmountCOntroller,
                                      textAlign: TextAlign.left, 
                                      textStyle: const TextStyle(fontSize: 14,color:Color.fromARGB(255, 71, 60, 60),), 
                                      focusNode: AlwaysDisabledFocusNode(),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ) ,
                                  const SizedBox(
                                height: 10,
                              ),
                        eCMEAmountCOntroller.text.isNotEmpty?     Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const  Text(
                                    "Brand*",
                                    style:  TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width:  wholeWidth / 1.45,
                                  ),
                                  brandAddWidget( wholeHeight, wholeWidth, context)
                                ],
                              ):const SizedBox(),
                              const SizedBox(
                                height: 10,
                              ),
                             (dynamicRowsListForBrand.isNotEmpty && eCMEAmountCOntroller.text.isNotEmpty)
                                  ? brandDetailsWidget(wholeWidth, wholeHeight)
                                  : const SizedBox(),
                                 const SizedBox(height: 10,),
                            
                            (dynamicRowsListForBrand.isNotEmpty)
                                  ?    const SizedBox(
                                height: 10,
                              ) :const SizedBox(),
          
                                 Row(
                                     children: [ 
                                        SizedBox(
                                          width:MediaQuery.of(context).size.width /2.15 ,
                                          child:const Text("Total numbers of participants",
                                                style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.w600)
                                                      ),
                                          
                                        ),
                                         SizedBox(
                                          width:MediaQuery.of(context).size.width / 9 ,
                                          child:const Text(":"),
                                          
                                        ),
                                         Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            width:MediaQuery.of(context).size.width / 3 ,
                                            child: Text(totalParticipants().toString(),style:const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),))
                                          ),
                                      
                                      
                                      ],
                                    ),
                                    
                         Column(
                                children: [
                                  BudgetBreakDownRowWidget(rowNumber: "1.", reason:"Doctors*", controller: doctorParticipantCount,
                                        onChanged: (value ) {  
                                           totalParticipants();
                                            setState(() {
                                            });
                                        },
                                         validator: null,
                                          routingName: 'participants',
                                        ),
                                  BudgetBreakDownRowWidget(routingName: 'participants',
                                    rowNumber: "2.", reason:"Intern Doctors*", controller: internDoctorController, 
                                           onChanged: (value ) {  
                                            totalParticipants();
                                            setState(() {
                                            });
                                            },
                                            validator: null,
                                          ),
                                  BudgetBreakDownRowWidget(routingName: 'participants',
                                    rowNumber: "3.", reason:"DMF/RMP doctors* ", controller: dmfDoctorController, 
                                         onChanged: (value ) {  
                                            totalParticipants();
                                            setState(() { 
                                            });
                                          },
                                           validator: null,
                                     
                                        ),
                                  BudgetBreakDownRowWidget(routingName: 'participants',
                                    rowNumber: "4.", reason:"Nurses/Staff* ", controller: nursesController, 
                                      onChanged: (value ) {  
                                           totalParticipants();
                                            setState(() {
                                            });
          
                                           },
                                            validator: null,
                                       
                                      ),
                                  BudgetBreakDownRowWidget(routingName: 'participants',
                                        rowNumber: "5.", reason:"SKF Attendance*", controller: skfAttenaceController, 
                                          onChanged: (value ) {  
                                              totalParticipants();
                                                setState(() {
                                                });
              
                                              },
                                                validator: null,
                                          
                                          ),
                                BudgetBreakDownRowWidget(routingName: 'participants',
                                        rowNumber: "6.", reason:"Others", controller: othersParticipantsController, 
                                          onChanged: (value ) {  
                                              totalParticipants();
                                                setState(() {
                                                });
              
                                              },
                                                validator: null,
                                          
                                          ),
                                 
                                 
                                ],
                              ) ,
                              
                              const SizedBox(
                                height: 10,
                              ),

                              const SizedBox(
                                height: 10,
                              ),
                                  
                              ( totalParticipants()>0 )? 
                              Row(
                                    children: [
                                        
                                        SizedBox(
                                          width:MediaQuery.of(context).size.width /2.15 ,
                                          child:const Text("Total budget*",
                                                style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.w600)
                                                      ),
                                          
                                        ),
                                         SizedBox(
                                          width:MediaQuery.of(context).size.width / 9 ,
                                          child:const Text(":"),
                                          
                                        ),
                                         Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            width:MediaQuery.of(context).size.width / 3 ,
                                            child: Text("৳${totalBudget.toStringAsFixed(2)}",style:const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),))
                                          ),
                                      
                                      
                                      ],
                                    ) 
                              
                                    :const SizedBox(),
                                    const SizedBox(height: 10,),
                                ( totalParticipants()>0 )?   Row(
                                    children: [
                                        
                                        SizedBox(
                                          width:MediaQuery.of(context).size.width /2.15 ,
                                          child:const Text("Cost per doctor",
                                                style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(255, 0, 0, 0),
                                                fontWeight: FontWeight.w600)
                                                      ),
                                          
                                        ),
                                         SizedBox(
                                          width:MediaQuery.of(context).size.width / 9 ,
                                          child:const Text(":"),
                                          
                                        ),
                                         Align(
                                          alignment: Alignment.centerRight,
                                          child: SizedBox(
                                            width:MediaQuery.of(context).size.width / 3 ,
                                            child: Text("৳${getCostPerDoctor().toStringAsFixed(2)}",style:const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),))
                                          ),
                                      
                                      
                                      ],
                                    )
                                    :const SizedBox(),
          
                           
                                    SizedBox(height:(  totalParticipants()>0 )? 10:0),
          
                            ( totalParticipants()>0 )? const Text(
                                "Budget breakdown*",
                                style: TextStyle(
                                   fontSize: 15,
                                   color: Color.fromARGB(255, 0, 0, 0),
                                   fontWeight: FontWeight.w600),
                              ) :const SizedBox(),
                            (   totalParticipants()>0 )?  Column(
                                children: [
                                  BudgetBreakDownRowWidget(
                                    routingName: 'budget',
                                    rowNumber: "1.", reason:"Hall rent*", controller: hallRentController,
                                        onChanged: (value ) {  
                                            getTotalBudget();
                                            setState(() {
                                            });
                                        },
                                         validator: null,
                                       
                                        ),
                                  BudgetBreakDownRowWidget(
                                       routingName: 'budget',
                                    rowNumber: "2.", reason:"Food Expense*", controller: foodExpansesController, 
                                           onChanged: (value ) {  
                                            getTotalBudget();
                                            setState(() {
                                            });
                                            },
                                             validator: null,
                                       
                                          ),
                                  BudgetBreakDownRowWidget(
                                       routingName: 'budget',
                                    rowNumber: "3.", reason:"Speaker Gift or Souvenir*", controller: giftController, 
                                      onChanged: (value ) {  
                                            getTotalBudget();
                                            setState(() {
                                            });
          
                                           },
                                           validator: null,
                                      
                                      ),
                                  BudgetBreakDownRowWidget(
                                       routingName: 'budget',
                                    rowNumber: "4.", reason:"Stationnaires or Others*", controller: stationnairesController, 
                                       onChanged: (value ) {  
                                            getTotalBudget();
                                            setState(() {
                                            });
                                        },
                                         validator: null,
                                        
                                      ),
                                 
                                ],
                              ) :const SizedBox(),
                              
                               const SizedBox(
                                height: 10 ,
                              ),
                              const Text(
                                  "Pay Mode *" ,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(
                                height: 6 ,
                              ),
                              Container(
                                       width: MediaQuery.of(context).size.width / 1.1,
                                         height: 45,
                                    decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
                                    ),
                                    child:   DropdownButtonHideUnderline(
                                              child: DropdownButton2(
                                                isExpanded: true,
                                                  iconEnabledColor: const Color.fromARGB(255, 82, 179, 98),
                                                  hint: const Text(
                                                    '  Select Pay Mode',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  items: ['Bill','Bill b'].map((String item) {
                                                    return DropdownMenuItem(
                                                      value: item, 
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 8),
                                                        child: Text(
                                                          item,
                                                          style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  value: selectedPayMode,
                                                  onChanged: (value) {
                                                  
                                                    setState(() {
                                                      selectedPayMode=value;
                                                    });
                                                  },
                                                  
                                                 
                                                  
                                                buttonHeight: 50,
                                                buttonWidth: MediaQuery.of(context).size.width / 1.5,
                                                itemHeight: 40,
                                                dropdownMaxHeight: 252,
                                                searchController: brandSelectedController,
                                                searchInnerWidgetHeight: 50,
                                                searchInnerWidget: Container(
                                                  height: 50,
                                                  padding: const EdgeInsets.only(
                                                    top: 8,
                                                    bottom: 4,
                                                    right: 8,
                                                    left: 8,
                                                  ),
                                                  child: TextFormField(
                                                    expands: true,
                                                    maxLines: null,
                                                    controller: brandSelectedController,
                                                    decoration: InputDecoration(
                                                      fillColor: Colors.transparent,
                                                      filled: true,
                                                      isDense: true,
                                                      contentPadding: const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 8,
                                                      ),
                                                      hintText: '  Search e-CME Type...',
                                                      hintStyle: const TextStyle(fontSize: 14),
                                                      border: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                searchMatchFn: (item, searchValue) {
                                                  return (item.value.toString().toUpperCase().startsWith(searchValue.toUpperCase()));
                                                },
                                                onMenuStateChange: (isOpen) {
                                                  if (!isOpen) {
                                                    brandSelectedController.clear();
                                                  }
                                                },
                                                
                                              ),
                                            )
                                                                                    
                                
                                ),
                                  const SizedBox(
                                height: 10,
                              ),
                              
                              
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
                                          if(selectedECMEType!=null){
                                            if(finalBrandListAftrRemoveDuplication.isNotEmpty){
                                             if(selectedExpiredDateString!=""){
                                              if(selcetDoctorCategory!=null){
                                                    if(meetingVenueController.text!=""){
                                                      if(meetingTopicController.text!=""){
                                                        if(meetingProbaleSpeakerNameController.text!=""){
                                                                 if(eCMEAmountCOntroller.text!=""){
                                                                  if(doctorParticipantCount.text!=""){
                                                                   if(hallRentController.text!=""){
                                                                    if(foodExpansesController.text!=""){
                                                                      if(giftController.text!=""){
                                                                        
                                                                        // if(stationnairesController.text!=""){
                                                                        //   if(selcetDoctorCategory=="Institution"){
                                                                        //     if(institutionController.text !=""){
                                                                        //      if(institutionController.text !=""){
                                                                        //        readyForPreviewMethod();
                                                                        //       }
                                                                        //       else{
                                                                        //         AllServices().toastMessage("Please add department ", Colors.red, Colors.white, 16);
                                                                        //       }
                                                                        //     }
                                                                        //     else{
                                                                        //       AllServices().toastMessage("Please add Institution Name ", Colors.red, Colors.white, 16);
                                                                        //     }

                                                                        //   }
                                                                        //   else{
                                                                         
                                                                        //       readyForPreviewMethod();
                                                                        //   }
                                                                        // }
                                                                        // else{
                                                                        //   AllServices().toastMessage("Please add speaker stationaries expense  ", Colors.red, Colors.white, 16);
                                                                        // }

                                                                      }
                                                                      else{
                                                                        AllServices().toastMessage("Please add sepeaker gift expense  ", Colors.red, Colors.white, 16);
                                                                      }
                                                                    }
                                                                    else{
                                                                      AllServices().toastMessage("Please add food expense amount  ", Colors.red, Colors.white, 16);
                                                                    }

                                                                    }
                                                                    else{
                                                                      AllServices().toastMessage("Please add hall rent amount  ", Colors.red, Colors.white, 16);
                                                                    }
                                                                }
                                                                else{
                                                                  AllServices().toastMessage("Please add participating doctor ", Colors.red, Colors.white, 16);

                                                                }

                                                                 }
                                                                 else{
                                                                  AllServices().toastMessage("Please enter e-CME anmount", Colors.red, Colors.white, 16);
                                                                 }

                                                          }
                                                        else{
                                                          AllServices().toastMessage("Please Enter probable speaker Name ", Colors.red, Colors.white, 16);
                                                        }
                                                      }
                                                      else{
                                                        AllServices().toastMessage("Please Enter meeting topic ", Colors.red, Colors.white, 16);
                                                      }
                                                  }
                                                  else{
                                                    AllServices().toastMessage("Please Enter meeting vanue ", Colors.red, Colors.white, 16);
                                                  }
                                            }
                                            else{
                                              AllServices().toastMessage("Please Select Doctor Category ", Colors.red, Colors.white, 16);
                                            }

                                        }
                                        else{
                                          AllServices().toastMessage("Please Select Meeting Date ", Colors.red, Colors.white, 16);
                                        }

                                       }
                                       else{
                                         AllServices().toastMessage("Please Select Brand ", Colors.red, Colors.white, 16);
                                      }
                                      }
                                      else{
                                         AllServices().toastMessage("Please Select eCME Type First", Colors.red, Colors.white, 16);
                                      }
                                        
                                  
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
      ),
    );
  }

  Column brandDetailsWidget( double wholeWidth, double wholeHeight) {
    return Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color:
                                      const Color.fromARGB(255, 98, 158, 219),
                                ),
                                   
                                      width: wholeWidth / 1.073,
                                     
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: wholeWidth / 5,
                                            height: 40,
                                            
                                            child: const Center(
                                              child: Text(
                                                "Name",
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ),
                                         
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: SizedBox(
                                              width: wholeWidth / 4,
                                              height: wholeHeight / 25.309,
                                              child: const Center(
                                                child: Text(
                                                  "e_CME Amount",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 5,
                                            ),
                                            child: SizedBox(
                                              width: wholeWidth / 4,
                                              height: wholeHeight / 25.309,
                                              child:  Center(
                                                child: Text(
                                                selectedECMEType=="RMP Meeting"?   "Sales Qty":"Rx objective per day",
                                                  style:const TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      ),
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
                                                      color: Colors.white,
                                                      ),
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
                                              30,
                                      width: wholeWidth / 1.073,
                                      
                                      child: ListView.builder(
                                          itemCount:
                                              finalBrandListAftrRemoveDuplication
                                                  .length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(left: 4,right: 4),
                                              child: Container(
                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: index % 2 != 0
                                                ? Colors.grey[300]
                                                : Colors.transparent,),
                                                height: 30,
                                                
                                                                                    
                                                
                                                child: Row(
                                                  children: [
                                                    SizedBox(
                                                      width: wholeWidth / 5,
                                                      height:
                                                          wholeHeight / 25.309,
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(left: 2),
                                                        child: Center(
                                                          child: Text(
                                                            finalBrandListAftrRemoveDuplication[
                                                                index][0],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
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
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 5,
                                                      ),
                                                      child: SizedBox(
                                                        width: wholeWidth / 4,
                                                        height: wholeHeight /
                                                            25.309,
                                                        child: Center(
                                                          child: Text(
                                                            getECMEAmontSplit().toStringAsFixed(2),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 12,
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
                                                        width: wholeWidth / 4,
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
                                                              fontSize: 12,
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
                                                            
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(bottom: 10,top: 0),
                                                          child: Center(
                                                            child: IconButton(
                                                              icon: const Icon(
                                                                Icons
                                                                    .delete_forever,
                                                                color: Colors.red,
                                                                size: 20,
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                );
  }

  Container brandAddWidget(double wholeHeight, double wholeWidth, BuildContext context) {
    return Container(
                                height: wholeHeight / 18.98,
                                width: wholeWidth / 9.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: const Color(0xff8AC995),
                                ),
                                child: Center(
                                  child: IconButton(
                                      onPressed: () {
                                       // getECMEAmontSplit();
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0),
                                                        ),
                                                                                                //  shape: ,
                                                
                                                scrollable: true,
                                                title: const Text(
                                                    "Brand Details"),
                                                content: SizedBox(
                                                  height: 220,
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
                                                        // const SizedBox(
                                                        //   // 
                                                        //   height: 15,
                                                        // ),
                                                        
                                                        // const  Align(
                                                        //   alignment: Alignment
                                                        //       .centerLeft,
                                                        //   child: Text(
                                                        //     "Amount",
                                                        //     style:  TextStyle(
                                                        //         fontWeight:
                                                        //             FontWeight
                                                        //                 .w600),
                                                        //   ),
                                                        // ) ,
                                                        // const SizedBox(
                                                        //   height: 5,
                                                        // ),
                                                        // SizedBox(
                                                        //     width: MediaQuery.of(
                                                        //                 context)
                                                        //             .size
                                                        //             .width /
                                                        //         1.1,
                                                        //     height: 45,
                                                        //     child:
                                                        //         TextFormField(
                                                        //       inputFormatters: [
                                                        //         FilteringTextInputFormatter
                                                        //             .allow(RegExp(
                                                        //                 r'[0-9]')), 
                                                        //       ],
                                                        //       keyboardType:
                                                        //           TextInputType
                                                        //               .number,
                                                        //       controller:
                                                        //         eCMESplitAmountController,
                                                        //       decoration:
                                                        //           InputDecoration(
                                                        //         border:
                                                        //             OutlineInputBorder(
                                                        //           borderSide:
                                                        //               const BorderSide(
                                                        //                   color:
                                                        //                       Colors.white),
                                                        //           borderRadius:
                                                        //               BorderRadius.circular(
                                                        //                   5.0),
                                                        //         ),
                                                        //       ),
                                                        //     )),
                                                        
                                                    
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        
                                                          Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                           selectedECMEType=="RMP Meeting"? "Sales Qty*" :"Rx objective per day",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ) ,
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
                                                                    .allow(RegExp(
                                                                        r'[0-9]')), 
                                                              ],
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              controller:
                                                                selectedECMEType=="RMP Meeting"?  salesQtyController : rxPerDayController,
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
                                                                    salesQtyController
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
                                                                        null)    
                                                                    {
                                                                      if( selectedECMEType=="RMP Meeting"? salesQtyController.text!="": rxPerDayController.text!=""){
                                                                           dynamicRowsListForBrand.add([
                                                                            initialBrand,
                                                                           eCMEAmountCOntroller.text==""?"0": eCMEAmountCOntroller.text,
                                                                            selectedECMEType=="RMP Meeting"? (salesQtyController.text == "" ? "0" : salesQtyController.text) :(rxPerDayController.text == "" ? "0" : rxPerDayController.text),
                                                                            "0",
                                                                            "0"
                                                                           
                                                                          ]);
                                                                          finalBrandListAftrRemoveDuplication =
                                                                              removeDuplicationForBrand(dynamicRowsListForBrand);
                                                                          Navigator.pop(context);
                                                                          setState(() {
                                                                            initialBrand = null;
                                                                            rxPerDayController.clear();
                                                                            salesQtyController.clear();
                                                                            eCMESplitAmountController.clear();
                                                                          });
                                                
                                                                     }
                                                                      else {
                                                                          AllServices().toastMessage(
                                                                            selectedECMEType=="RMP Meeting"?  "Please Enter e_CME Amount  " :"Please Enter Rx objective per day",
                                                                              Colors.red,
                                                                              Colors.white,
                                                                              16);
                                                                           }    
                                                                         
                                                                   } 
                                                                     else {
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
                              );
  }

  readyForPreviewMethod() {
    setState(() {
      isLoading = true;
    });
    final ECMESubmitDataModel ecmeSubmitDataModel = ECMESubmitDataModel(
              cid: cid!,
              userId:userInfo!.userId,
              password: password!,  
              // address:  widget.docInfo["address"], 
              // areaId:  widget.docInfo["area_id"], 
              brandList: finalBrandListAftrRemoveDuplication, 
              brandString: getbrandString(), 
              costPerDoctor: getCostPerDoctor().toStringAsFixed(2), 
              // degree: widget.docInfo["degree"],  
              // docId: widget.docInfo["doc_id"], 
              docListString: "" ,
              giftcose: giftController.text,
              hallRentAmount: hallRentController.text,
              foodExpense: foodExpansesController.text, 
              lattitute: latitude.toString(), 
              longitude: longitude.toString(),
              meetingDate: selectedExpiredDateString,
              meetingTopic: meetingTopicController.text, 
              meetingVanue: meetingVenueController.text, 
              // mobile:widget.docInfo["mobile"]??"", 
              eCMEType: selectedECMEType!,
              doctorCategory: selcetDoctorCategory!, 
              institureName: institutionController.text,
              departament: departmentController.text, 
              eCMEAmount: eCMEAmountCOntroller.text, 
              rxPerDay: rxObjectiveperDayController.text,
              doctorsCount: doctorParticipantCount.text, 
              internDoctor: internDoctorController.text, 
              dMFDoctors: dmfDoctorController.text, 
              nurses: nursesController.text, 
              numberOfParticipant: noIfparticipants.toString(), 
              speakerInstitute: probaleSpeakerInstituteController.text,
              others: '',
              speakerName: meetingProbaleSpeakerNameController.text, 
              speakerDesignation: probaleSpeakerDesignationController.text, 
              // speciality: widget.docInfo["specialty"], 
              stationaries: stationnairesController.text, 
              totalBudget: totalBudget.toStringAsFixed(2) 
              
            );

    if (ecmeSubmitDataModel!=null) {
      setState(() {
        isLoading = false;
      });
      //==================== will work
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (_) => ECMEDoctorPreviewScreen(
      //      eCMESubmitDataModel: ecmeSubmitDataModel,
            
      //     ),
      //   ),
      // );
    }
  }
      initialValue(String val) {
    return TextEditingController(text: val);
  }
  pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate:selectedExpiredDate,
      firstDate: DateTime.now(),
      lastDate:  DateTime(DateTime.now().year + 100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.white,
            colorScheme: const ColorScheme.light(primary: Colors.teal),
            canvasColor: Colors.teal,
          ),
          child: child!,
        );
      },
    );

    if (newDate == null) return;
    selectedExpiredDate = newDate;
    selectedExpiredDateString = DateFormat('yyyy-MM-dd').format(selectedExpiredDate);
    setState(() => selectedExpiredDate = newDate);
  
  }
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}



