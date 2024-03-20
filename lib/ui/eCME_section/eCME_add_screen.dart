import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_row_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_textformFiled_widget.dart';
import 'package:MREPORTING/ui/eDSR_section/eDSR_add_preview_screen.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECMEAddScreen extends StatefulWidget {
  List<dynamic> docInfo;
 // String dsrType;
  int index;
  ECMEAddScreen(
      {super.key,
      required this.docInfo,
      required this.index,
    //  required this.dsrType
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
  TextEditingController meetingProbaleSpeakerController = TextEditingController();
  TextEditingController brandSelectedController = TextEditingController();
  TextEditingController rxPerDayController = TextEditingController();
  TextEditingController eCMEController = TextEditingController();
  TextEditingController probaleSpeakerController = TextEditingController();
  TextEditingController probaleSpeakerInstituteController = TextEditingController();
  TextEditingController totalNumberOfParticiController = TextEditingController();
  TextEditingController totalBudgetController = TextEditingController();
  TextEditingController hallRentController = TextEditingController();
  TextEditingController morningEveningController = TextEditingController();
  TextEditingController costperDoctorController = TextEditingController();
  TextEditingController lunchDinnerController = TextEditingController();
  TextEditingController stationnairesController = TextEditingController();
  TextEditingController giftController = TextEditingController();
  TextEditingController othersController = TextEditingController();
  ECMESavedDataModel? eCMESettingsData;
  List<String>? eBrandList = [];
  
  List<List<dynamic>> dynamicRowsListForBrand = [];
  List<List<dynamic>> finalBrandListAftrRemoveDuplication = [];
  String? initialBrand;
 

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
    eCMESettingsData = Boxes.geteCMEsetData().get("eCMESavedDataSync")!;
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
    meetingDateController.dispose();
    rxPerDayController.dispose();
    eCMEController.dispose();
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
          child: Column(
            children: [
              SizedBox(
                height: wholeHeight / 75.927,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 1,
                          color:const Color(0xff8AC995)
                        ),
                        borderRadius: BorderRadius.circular(50)
                        
                        
                        
                      ),
                      child: const Icon(Icons.person, size: 50, color: Color(0xff8AC995))),
                  ),
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
                              fontSize: 15,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${widget.docInfo[widget.index]["address"]}|$territoryid",
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromARGB(255, 64, 64, 64)),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "${widget.docInfo[widget.index]["mobile"]}",
                          style: const TextStyle(
                               fontSize: 12,
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
                                            inputFormatters: [
                                               FilteringTextInputFormatter
                                                                      .allow(
                                                                    RegExp(
                                                                        "[A-Za-z0-9]"),
                                                                  ),
                                              FilteringTextInputFormatter.deny(
                                                RegExp(r'^\d{12,}$'),
                                              ),
                                            ],
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return "Mobile Number is required";
                                              }
                                              if (value.length < 11 
                                                  ) {
                                                return "Mobile Number should be  11  digits";
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
                                                    // Navigator.pop(context);
                                                    // doctorMobileNumberController
                                                    //     .text = widget
                                                    //         .docInfo[
                                                    //     widget.index]["mobile"];
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
                                                    child:  isMobileUpdate?const Center(child:  CircularProgressIndicator()) :const Center(
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
                                                    // if (_form1Key.currentState!
                                                    //     .validate()) {
                                                    //   setState(() {
                                                    //     isMobileUpdate = true;
                                                    //   });
                                                    //   bool result =
                                                    //       await InternetConnectionChecker()
                                                    //           .hasConnection;
                                                    //   if (result == true) {
                                                    //     Map<String, dynamic>
                                                    //         responsData =
                                                    //         await EDSRRepositories().getMobileNumberUpdation(
                                                    //             dmpathData!
                                                    //                 .submitUrl,
                                                    //             cid!,
                                                    //             userInfo!
                                                    //                 .userId,
                                                    //             userPassword,
                                                    //             widget.docInfo[
                                                    //                     widget
                                                    //                         .index]
                                                    //                 ["doc_id"],
                                                    //             doctorType!,
                                                    //             doctorMobileNumberController
                                                    //                 .text,
                                                    //             widget.docInfo[
                                                    //                     widget
                                                    //                         .index]
                                                    //                 [
                                                    //                 "area_id"]);
                                                    //     if (responsData
                                                    //         .isNotEmpty) {
                                                    //       if (responsData[
                                                    //               "status"] ==
                                                    //           "Success") {
                                                    //         widget.docInfo[widget
                                                    //                     .index]
                                                    //                 ["mobile"] =
                                                    //             doctorMobileNumberController
                                                    //                 .text;
                                                    //         setState(() {
                                                    //           isMobileUpdate =
                                                    //               false;
                                                    //         });
                                                    //         AllServices()
                                                    //             .toastMessage(
                                                    //                 responsData[
                                                    //                     "ret_str"],
                                                    //                 Colors
                                                    //                     .green,
                                                    //                 Colors
                                                    //                     .white,
                                                    //                 14);

                                                    //         if (!mounted) {
                                                    //           return;
                                                    //         }
                                                    //         Navigator.pop(
                                                    //             context);
                                                    //       } else {
                                                    //         setState(() {
                                                    //           isMobileUpdate =
                                                    //               false;
                                                    //         });
                                                    //         AllServices()
                                                    //             .toastMessage(
                                                    //                 responsData[
                                                    //                     "ret_str"],
                                                    //                 Colors.red,
                                                    //                 Colors
                                                    //                     .white,
                                                    //                 14);
                                                    //       }
                                                    //     } else {
                                                    //       setState(() {
                                                    //         isMobileUpdate =
                                                    //             false;
                                                    //       });
                                                    //     }
                                                    //   } else {
                                                    //     setState(() {
                                                    //       isMobileUpdate =
                                                    //           false;
                                                    //     });
                                                    //     AllServices()
                                                    //         .toastMessage(
                                                    //             interNetErrorMsg,
                                                    //             Colors.red,
                                                    //             Colors.white,
                                                    //             16);
                                                    //   }
                                                    // }
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
                                    suffixIcon: const Icon(Icons.calendar_month_outlined,color: Color.fromARGB(255, 82, 179, 98),),
                                    textStyle: const TextStyle(fontSize: 14,color: Color.fromARGB(255, 82, 179, 98),), 
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
                            ),
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
                                    controller: meetingProbaleSpeakerController,
                                    textAlign: TextAlign.left, 
                                    textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                               
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
                                brandAddWidget(wholeHeight, wholeWidth, context)
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            dynamicRowsListForBrand.isNotEmpty
                                ? brandDetailsWidget(wholeWidth, wholeHeight)
                                : const SizedBox(),
                               const SizedBox(height: 10,),
                            const Text(
                              "Probable Speaker Name",
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
                                    controller: meetingTopicController,
                                    textAlign: TextAlign.left, 
                                    textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                
                                ),
                                const SizedBox(
                              height: 10,
                            ),
                                const Text(
                              "Probable Speaker Degree",
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
                                   hinText: '----Enter Speaker Degree----',
                                    controller: probaleSpeakerController,
                                    textAlign: TextAlign.left, 
                                    textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                ),
                                const SizedBox(
                              height: 10,
                            ),

                                const Text(
                              "Probable Speaker Institute",
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
                                     hinText: '----Enter Speaker Institute----',
                                    controller: probaleSpeakerInstituteController,
                                    textAlign: TextAlign.left, 
                                    textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                ),
                                const SizedBox(
                              height: 10,
                            ),

                            Row(
                             children: [
                                      
                                      SizedBox(
                                        width:MediaQuery.of(context).size.width /2.15 ,
                                        child:const Text("Total numbers of participants*",
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
                                      SizedBox(
                                        height: 45,
                                         width:MediaQuery.of(context).size.width / 3,
                                         child:TextFormField(
                                          controller: totalNumberOfParticiController,
                                          textAlign: TextAlign.right,
                                          style:const TextStyle(fontSize: 14),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderSide:
                                                  const BorderSide(color: Colors.white),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        )
                                   
                                       ),
                                    
                                    ],
                                  ),
                                  const SizedBox(height: 10,),
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
                                      SizedBox(
                                        height: 45,
                                         width:MediaQuery.of(context).size.width / 3,
                                         child: TextFormField(
                                            textAlign: TextAlign.right,
                                            style:const TextStyle(fontSize: 14),
                                          controller: totalBudgetController,
                                          decoration: InputDecoration(
                                            
                                            border: OutlineInputBorder(
                                              borderSide:
                                                  const BorderSide(color: Colors.white),
                                              borderRadius: BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        )
                                  
                                  ),
                                      
    
                                    ],
                                  ),

                         
                                 const SizedBox(height: 10,),

                              const  Text(
                              "Budget breakdown*",
                              style: TextStyle(
                                 fontSize: 15,
                                 color: Color.fromARGB(255, 0, 0, 0),
                                 fontWeight: FontWeight.w600),
                            ),
                            Column(
                              
                              children: [
                                BudgetBreakDownRowWidget(rowNumber: "1.", reason:"Hall rent ", controller: hallRentController,),
                                BudgetBreakDownRowWidget(rowNumber: "2.", reason:"Morning/Evening refreshment(total cost)", controller: morningEveningController,),
                                BudgetBreakDownRowWidget(rowNumber: "3.", reason:"Cost per doctor ", controller: costperDoctorController,),
                                BudgetBreakDownRowWidget(rowNumber: "4.", reason:"Lunch/Dinner(total cost) ", controller: lunchDinnerController,),
                                BudgetBreakDownRowWidget(rowNumber: "5.", reason:"Stationnaires", controller: stationnairesController,),
                                BudgetBreakDownRowWidget(rowNumber: "6.", reason:"Gift/Souvenirs ", controller: giftController,),
                                BudgetBreakDownRowWidget(rowNumber: "7.", reason:"Others ", controller: othersController,),
                          

                              ],
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
                                    // getbrandString() != ""
                                    //     ? widget.docInfo[widget.index]
                                    //                 ["area_id"] !=
                                    //             ""
                                    //         ? widget.docInfo[widget.index]
                                    //                     ["doc_id"] !=
                                    //                 ""
                                    //             ? widget.docInfo[widget.index]
                                    //                         ["doc_name"] !=
                                    //                     ""
                                    //                 ? initialCategory != null
                                    //                     ? initialCategory !=
                                    //                             null
                                    //                         ? purposeId != ""
                                    //                             ? subPurposeId !=
                                    //                                     ""
                                    //                                 ? addDescriptionController.text !=
                                    //                                         ""
                                    //                                     ? rxFromDate !=
                                    //                                             ""
                                    //                                         ? rxToDate != ""
                                    //                                             ? initialPaySchdedule != null
                                    //                                                 ? dsrFromdate != ""
                                    //                                                     ? dsrTodate != ""
                                    //                                                         ? noOfPatientController.text .toString().trim().isNotEmpty
                                    //                                                             ? initialIssueMode != null
                                    //                                                                 ? isCheck == true
                                    //                                                                     ? issueToController.text.toString().trim().isNotEmpty
                                    //                                                                         ? readyForPreviewMethod()
                                    //                                                                         : AllServices().toastMessage("Enter Issue To First", Colors.red, Colors.white, 16)
                                    //                                                                     : readyForPreviewMethod()
                                    //                                                                 : AllServices().toastMessage("Select Issue Mode First", Colors.red, Colors.white, 16)
                                    //                                                             : AllServices().toastMessage("Enter The No of Patient First", Colors.red, Colors.white, 16)
                                    //                                                         : AllServices().toastMessage("Select DSR Duration To First", Colors.red, Colors.white, 16)
                                    //                      0                               : AllServices().toastMessage("Select DSR Duration From First", Colors.red, Colors.white, 16)
                                    //                                                 : AllServices().toastMessage("Select DSR Schdule First", Colors.red, Colors.white, 16)
                                    //                                             : AllServices().toastMessage("Select Rx Duration To First", Colors.red, Colors.white, 16)
                                    //                                         : AllServices().toastMessage("Select Rx Duration From First", Colors.red, Colors.white, 16)
                                    //                                     : AllServices().toastMessage("Enter Description First", Colors.red, Colors.white, 16)
                                    //                                 : AllServices().toastMessage("Select Sub-Purpose First", Colors.red, Colors.white, 16)
                                    //                             : AllServices().toastMessage("Select Purpose First", Colors.red, Colors.white, 16)
                                    //                         : AllServices().toastMessage("Select Category First", Colors.red, Colors.white, 16)
                                    //                     : AllServices().toastMessage("Select Category First", Colors.red, Colors.white, 16)
                                    //                 : AllServices().toastMessage("Doctor Doctor ID Missing", Colors.red, Colors.white, 16)
                                    //             : AllServices().toastMessage("Doctor Name ID Missing", Colors.red, Colors.white, 16)
                                    //         : AllServices().toastMessage("Doctor Area ID Missing", Colors.red, Colors.white, 16)
                                    //     : AllServices().toastMessage("Please Select Brand First", Colors.red, Colors.white, 16);
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

  Column brandDetailsWidget(double wholeWidth, double wholeHeight) {
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
                                              width: wholeWidth / 2,
                                              height: wholeHeight / 25.309,
                                              child: const Center(
                                                child: Text(
                                                  "e-CME",
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
                                                        width: wholeWidth / 2,
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
                                                content: Container(
                                        //           decoration: BoxDecoration(
                                        //   boxShadow:const [
                                        //     BoxShadow(
                                        //       color :Colors.white ,
                                        //       spreadRadius : 2,
                                        //       blurStyle :BlurStyle.outer,
                                        //       blurRadius: 1,
                                        //     ),
                                        //   ],
                                          
                                        //  // borderRadius: BorderRadius.circular(40),
                                        //   color: Colors.white ,
                                          
                                        // ),

                                                  child: SizedBox(
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
                                                          
                                                      
                                                          const SizedBox(
                                                            height: 15,
                                                          ),
                                                          const Align(
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              "e-CME*",
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
                                                                      .allow(RegExp(
                                                                          r'[0-9]')), 
                                                                ],
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                controller:
                                                                    eCMEController,
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
                                                                      eCMEController
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
                                                
                                                                        if(eCMEController.text!=""){
                                                                             dynamicRowsListForBrand.add([
                                                                              initialBrand,
                                                                              rxPerDayController.text == "" ? "0" : rxPerDayController.text,
                                                                              eCMEController.text == "" ? "0" : eCMEController.text,
                                                                              "0",
                                                                              "0"
                                                                             
                                                                            ]);
                                                
                                                                            finalBrandListAftrRemoveDuplication =
                                                                                removeDuplicationForBrand(dynamicRowsListForBrand);
                                                
                                                                            Navigator.pop(context);
                                                                            setState(() {
                                                                              initialBrand = null;
                                                                              rxPerDayController.clear();
                                                                              eCMEController.clear();
                                                                             
                                                                            });
                                                
                                                                       }
                                                                        else {
                                                                            AllServices().toastMessage(
                                                                                "Please Enter e_CME Amount  ",
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

    Map<String, dynamic> readyForPreviewData = {
    //   "submit_url": dmpathData!.submitUrl,
    //   "cid": cid!,
    //   "userId": userInfo!.userId,
    //   "password": password,
    //   "brandString": brandString,
    //   "area_id": widget.docInfo[widget.index]["area_id"],
    //   "doc_id": widget.docInfo[widget.index]["doc_id"],
    //   "latitude": latitude.toString(),
    //   "longitude": longitude.toString(),
    //   "doc_name": widget.docInfo[widget.index]["doc_name"],
    //   "degree": widget.docInfo[widget.index]["degree"],
    //   "specialty": widget.docInfo[widget.index]["specialty"],
    //   "address": widget.docInfo[widget.index]["address"],
    //   "mobile": widget.docInfo[widget.index]["mobile"],
    //   // "Category": initialCategory,
    //   // "purposeName": initialPurpose,
    //   "purposeId": purposeId,
    //   "Sub_purpose_Name": initialSubPurpose,
    //   "Sub_purpose": subPurposeId,
    //   "Descripton": addDescriptionController.text,
    //   "RX_Duration_from_Name": initialRxDurationMonthList,
    //   "RX_Duration_from": rxFromDate,
    //   "RX_Duration_to": rxToDate,
    //   "RX_Duration_to_name": initialRxDurationMonthListTo,
    //   "DSR_Schedule": initialPaySchdedule,
    //   "DSR_Duration_from_name": initialdsrDurationMonthList,
    //   "DSR_Duration_from": dsrFromdate,
    //   "DSR_Duration_to": dsrTodate,
    //   "DSR_Duration_to_name": initialdsrDurationMonthListTo,
    // //  "Number_of_Patient": noOfPatientController.text,
    //   "Issue_Mode": initialIssueMode,
    //   "Issue_To": issueToController.text,
    //   "Brand": finalBrandListAftrRemoveDuplication,
    //   "dsr_type": doctorType
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
      initialValue(String val) {
    return TextEditingController(text: val);
  }
  pickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate:selectedExpiredDate,
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now(),
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



