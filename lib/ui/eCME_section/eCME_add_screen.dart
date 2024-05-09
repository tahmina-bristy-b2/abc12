import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/e_CME/e_CME_submit_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCME_services.dart';
import 'package:MREPORTING/ui/Appraisal/apparaisal_self_assesment_history.dart';
import 'package:MREPORTING/ui/eCME_section/eCME_doctor_preview.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/add_title_row_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_dropdown_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_row_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_textformFiled_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECMEAddScreen extends StatefulWidget {
 final List<DocListECMEModel> docInfo;
 final String eCMEType;

 const ECMEAddScreen(
      {super.key,
      required this.docInfo,
      required this.eCMEType
      });

  @override
  State<ECMEAddScreen> createState() => _ECMEAddScreenState();
}

class _ECMEAddScreenState extends State<ECMEAddScreen> {
  final GlobalKey<FormState> _form1Key = GlobalKey();
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
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
  TextEditingController payToController = TextEditingController();

  ECMESavedDataModel? eCMESettingsData;
  List<String>? eBrandList = [];
  List<List<dynamic>> dynamicRowsListForBrand = [];
  List<List<dynamic>> finalBrandListAftrRemoveDuplication = [];
  String? initialBrand;
  List<String> docCategoryList=[];
   List<String>  docDepartmentList=[];
  String? selcetDoctorCategory;
  String? selectedDepartment;
  List<String> payModeList=[];
  String? selectedPayMode;
  String brandString='';
  String? cid;
  String? password;
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLoading = false;
  double splitedAmount=0.0;
  String areaId="";
  
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
      setState(() {});
    });
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    eCMESettingsData = Boxes.geteCMEsetData().get("eCMESavedDataSync")!;
    allSettingsDataGet(eCMESettingsData);
    SharedPreferences.getInstance().then((prefs) {
      password = prefs.getString("PASSWORD") ?? '';
      cid = prefs.getString("CID") ?? '';
      latitude = prefs.getDouble("latitude") ?? 0.0;
      longitude = prefs.getDouble("longitude") ?? 0.0;
    });
  }

  //===============================All Settings Data get Method============================
  allSettingsDataGet(ECMESavedDataModel? eDSRsettingsData) {
    eBrandList = eDSRsettingsData!.eCMEBrandList.map((e) => e.brandName).toList();  
    eCMETypeList = Boxes.geteCMEsetData().get("eCMESavedDataSync")!.eCMETypeList;
    payModeList = Boxes.geteCMEsetData().get("eCMESavedDataSync")!.payModeList;
    docCategoryList = Boxes.geteCMEsetData().get("eCMESavedDataSync")!.docCategoryList;
    docDepartmentList=Boxes.geteCMEsetData().get("eCMESavedDataSync")!.departmentList;
    areaId=Boxes.geteCMEsetData().get("eCMESavedDataSync")!.supAreaId ;
  }

  //============================ total budget =========================
double getTotalBudget() {
  double hall = double.tryParse(hallRentController.text) ?? 0.0;
  double food = double.tryParse(foodExpansesController.text) ?? 0.0;
  double gift = double.tryParse(giftController.text) ?? 0.0;
  double others = double.tryParse(stationnairesController.text) ?? 0.0;
  totalBudget = hall + food + gift + others ;
  totalBudgetController.text = totalBudget.toStringAsFixed(2);
  totalBudget = hall + food + gift + others ;
  eCMEAmountCOntroller.text=totalBudget.toString();
  getCostPerDoctor();
  return totalBudget;
}

//============================ total Numbers of participants =========================
int totalParticipants() {
  noIfparticipants = 
    (int.tryParse(doctorParticipantCount.text) ?? 0) +
    (int.tryParse(internDoctorController.text) ?? 0) +
    (int.tryParse(dmfDoctorController.text) ?? 0) +
    (int.tryParse(skfAttenaceController.text) ?? 0)+ (int.tryParse(nursesController.text) ?? 0) +(int.tryParse(othersParticipantsController.text) ?? 0); 
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
    return splitedAmount;
   }


  @override
  void dispose() {
    payToController.dispose();
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
               (widget.eCMEType=="Intern Reception")||(widget.eCMEType=="Society")?const SizedBox():  Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                  padding: const EdgeInsets.only(left: 6),
                    child: AddTitleRowWidget(context: context, title: "Selected Doctors*"),
                  ),
                ),
              
             (widget.eCMEType=="Intern Reception")||(widget.eCMEType=="Society")?const SizedBox() :  Row(
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
                                 child: Text( "${index+1}. ${widget.docInfo[index].docName}|${widget.docInfo[index].degree}|${widget.docInfo[index].specialty}",style: const TextStyle(fontSize: 13),),
                               );
                            }),
                        
                        ),
                      ),
                    ),
                 
                    
                  ],
                ),
                 SizedBox(
                  height:(widget.eCMEType=="Intern Reception")||(widget.eCMEType=="Society")? 10:0
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
                                  const SizedBox(
                                height: 10,
                              ),
                     //=============================== Meeting Date ====================================
                              AddTitleRowWidget(context: context, title: "Meeting Date*"),
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
                     //=============================== Doctor Category ====================================
                               AddTitleRowWidget(context: context, title: "Doctor Category*"),
                               CustomDropdownWidget(
                                context: context,
                                dropdownHint:  ' Select Doctor Category',
                                dropdownList: docCategoryList, 
                                dropdownController: brandSelectedController, 
                                dropdownOnchanged: (value) { 
                                                  if(value!="Institution"){
                                                      institutionController.clear();
                                                      departmentController.clear();
                                                      selectedDepartment=null;

                                                    }
                                                    setState(() {
                                                      selcetDoctorCategory = value; 
                                                    });
                                                },
                                selectedValue: selcetDoctorCategory, 
                                textformFiledHint:  ' Select Doctor Category',
                                onMenuStateChangeforClear: (isOpen) {
                                                if (!isOpen) {
                                                  departmentController.clear();
                                                }
                                              },
                                ),
                     //================================== Institution ===========================
                               selcetDoctorCategory=="Institution"? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const SizedBox(height: 10,),
                                 AddTitleRowWidget(context: context, title: "Institution Name*"),
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
                    //================================== Department ===========================
                              AddTitleRowWidget(context: context, title: "Department*"),
                              CustomDropdownWidget(
                                context: context,
                                dropdownHint:  '  ----Select Department Name---- ',
                                dropdownList: docDepartmentList, 
                                dropdownController: departmentController, 
                                dropdownOnchanged: (value) { 
                                                  setState(() {
                                                    selectedDepartment=value;
                                                  });
                                                },
                                selectedValue: selectedDepartment, 
                                textformFiledHint: '  Search Department Name...',
                                onMenuStateChangeforClear: (isOpen) {
                                                if (!isOpen) {
                                                  departmentController.clear();
                                                }
                                              },
                                ),
                                ],
                               ): const SizedBox(),
                               const SizedBox(height: 10,),
                     //================================== Meeting Venue ===========================
                              AddTitleRowWidget(context: context, title: "Meeting venue*"),
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
                    //================================== Meeting Topic ===========================
                              AddTitleRowWidget(context: context, title: "Meeting Topic*"),
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
                     //================================== Probable Speaker Name & Designation ===========================
                             AddTitleRowWidget(context: context, title: "Probable Speaker Name & Designation*"),
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
                             
                    //================================== Participats Section ===========================
                             titleRowWidget(context ,"Total numbers of participants",totalParticipants().toString()),
                             participatingBreakdownWidget() , 
                             const SizedBox(
                                height: 20,
                              ),
                    //================================== Budget Section ===========================
                                  
                              ( totalParticipants()>0 )? 
                               titleRowWidget(context,"Total budget*","৳${totalBudget.toStringAsFixed(2)}") 
                                    :const SizedBox(),
                                ( totalParticipants()>0  )? titleRowWidget(context,"Cost per doctor","৳${getCostPerDoctor().toStringAsFixed(2)}") 
                                   :const SizedBox(),   
          
                            ( totalParticipants()>0 )? AddTitleRowWidget(context: context, title: "Budget breakdown*")
                              :const SizedBox(),
                            (   totalParticipants()>0)?  budgetBreakdownWidget() :const SizedBox(),
                            const SizedBox(
                                height: 15,
                              ),
                    //=================================== eCME Amount================================
                              widget.eCMEType!=null? AddTitleRowWidget(context: context, title: "e_CME Amount *"):const SizedBox(),
                                widget.eCMEType!=null? SizedBox(
                                  width: MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                     hinText: '----Enter e-CME Amount ----',  // if you change it,you have to change it in inputformatter+readOnly too.
                                      controller: eCMEAmountCOntroller,
                                      textAlign: TextAlign.left, 
                                      textStyle: const TextStyle(fontSize: 14,color:Color.fromARGB(255, 71, 60, 60),), 
                                      focusNode: AlwaysDisabledFocusNode(),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ) : const SizedBox(),

                                  SizedBox(
                                      height:  widget.eCMEType!=null? 10:0,
                                  ),
                    //====================================== Brand section ===================================
                                  (widget.eCMEType!=null )? Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                           AddTitleRowWidget(context: context, title:  "Brand*",) ,
                                           SizedBox(
                                              width:  wholeWidth / 1.45,
                                            ),
                                           brandAddWidget( wholeHeight, wholeWidth, context)
                                          ],
                                        ):const SizedBox(),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      (dynamicRowsListForBrand.isNotEmpty )
                                            ? brandDetailsWidget(wholeWidth, wholeHeight)
                                            : const SizedBox(),
                                          const SizedBox(height: 10,),
                                      
                                      (dynamicRowsListForBrand.isNotEmpty)
                                            ?    const SizedBox(
                                          height: 10,
                                        ) :const SizedBox(),

                    //================================= Pay Mode ==================================
                                  AddTitleRowWidget(context: context, title: "Pay Mode *"),
                                  CustomDropdownWidget(
                                    context: context,
                                    dropdownHint:  '  Select Pay Mode',
                                    dropdownList: payModeList, 
                                    dropdownController: brandSelectedController, 
                                    dropdownOnchanged: (value) { 
                                                      setState(() {
                                                        selectedPayMode=value;
                                                      });
                                                    },
                                    selectedValue: selectedPayMode, 
                                    textformFiledHint: '  Search e-CME Type...', 
                                    onMenuStateChangeforClear: (isOpen) {
                                                    if (!isOpen) {
                                                      brandSelectedController.clear();
                                                    }
                                                  },
                                    ),
                                   SizedBox(
                                      height: wholeHeight / 75.927,
                                    ),
                    //============================== Pay to ===================================
                                    AddTitleRowWidget(context: context, title: "Pay to*",),
                                    SizedBox(
                                        width: MediaQuery.of(context).size.width / 1.1,
                                        height: 45,
                                        child: CustomtextFormFiledWidget(
                                          hinText: '----Enter pay reciever name----',
                                            controller: payToController,
                                            textAlign: TextAlign.left, 
                                            keyboardType: TextInputType.text,
                                            textStyle: const TextStyle(fontSize: 14,color:Colors.black,), 
                                            focusNode: AlwaysDisabledFocusNode(),
                                          ),
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
                    ? buttonRowWidget(context)
                    : const CircularProgressIndicator()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding titleRowWidget(BuildContext context ,String title,String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row( 
        children: [
           SizedBox(
               width:MediaQuery.of(context).size.width /2.15 ,
                 child: Text(title,
                 style:const TextStyle(
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
                 child: Text(value,style:const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),))
              ),
            ],
        ),
    );
  }
//========================================== Budget =================================
  Column budgetBreakdownWidget() {
             return Column(
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
                            );
  }
 //============================================================== Participates =======================================
  Column participatingBreakdownWidget() {
               return Column(
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
                            );
  }

 
 //============================================================== Buttons widget =======================================
  SizedBox buttonRowWidget(BuildContext context) {
    return SizedBox(
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
                                    double eCME= double.tryParse(eCMEAmountCOntroller.text)??0.0;
                                     if (selectedExpiredDateString == "") {
                                            AllServices().toastMessage("Please Select Meeting Date ", Colors.red, Colors.white, 16);
                                          } else if (selcetDoctorCategory == null) {
                                            AllServices().toastMessage("Please Select Doctor Category ", Colors.red, Colors.white, 16);
                                          } else if (meetingVenueController.text == "") {
                                            AllServices().toastMessage("Please Enter meeting venue ", Colors.red, Colors.white, 16);
                                          } else if (meetingTopicController.text == "") {
                                            AllServices().toastMessage("Please Enter meeting topic ", Colors.red, Colors.white, 16);
                                          } else if (meetingProbaleSpeakerNameController.text == "") {
                                            AllServices().toastMessage("Please Enter probable speaker Name ", Colors.red, Colors.white, 16);
                                          } else if (eCMEAmountCOntroller.text == "") {
                                            AllServices().toastMessage("Please enter e-CME amount", Colors.red, Colors.white, 16);
                                          } else if (finalBrandListAftrRemoveDuplication.isEmpty) {
                                            AllServices().toastMessage("Please add brand", Colors.red, Colors.white, 16);
                                          } else if (doctorParticipantCount.text == "") {
                                            AllServices().toastMessage("Please add participating doctor ", Colors.red, Colors.white, 16);
                                          } else if (internDoctorController.text.isEmpty) {
                                            AllServices().toastMessage("Please add number of intern doctor", Colors.red, Colors.white, 16);
                                          } else if (dmfDoctorController.text.isEmpty) {
                                            AllServices().toastMessage("Please add number of DMF/RMP doctor", Colors.red, Colors.white, 16);
                                          } else if (nursesController.text.isEmpty) {
                                            AllServices().toastMessage("Please add number of Nurses/Staff ", Colors.red, Colors.white, 16);
                                          } else if (skfAttenaceController.text.isEmpty) {
                                            AllServices().toastMessage("Please add number of SKF Attendance ", Colors.red, Colors.white, 16);
                                          } else if (hallRentController.text == "") {
                                            AllServices().toastMessage("Please add hall rent amount  ", Colors.red, Colors.white, 16);
                                          } else if (foodExpansesController.text == "") {
                                            AllServices().toastMessage("Please add food expense amount  ", Colors.red, Colors.white, 16);
                                          } else if (giftController.text == "") {
                                            AllServices().toastMessage("Please add speaker gift expense  ", Colors.red, Colors.white, 16);
                                          } else if (stationnairesController.text == "") {
                                            AllServices().toastMessage("Please add speaker stationaries expense  ", Colors.red, Colors.white, 16);
                                          } else if (selectedPayMode == null) {
                                            AllServices().toastMessage("Please select payment mode ", Colors.red, Colors.white, 16);
                                          } else if (payToController.text == "") {
                                            AllServices().toastMessage("Please enter pay reciever name ", Colors.red, Colors.white, 16);
                                          }else if (selcetDoctorCategory == "Institution" && institutionController.text == "") {
                                            AllServices().toastMessage("Please add Institution Name ", Colors.red, Colors.white, 16);
                                          }else if (selcetDoctorCategory == "Institution" && selectedDepartment==null) {
                                            AllServices().toastMessage("Please select department ", Colors.red, Colors.white, 16);
                                          }else if (totalBudget>eCME) {
                                            AllServices().toastMessage("Please reduce your budget ", Colors.red, Colors.white, 16);
                                          }
                                           else {
                                            readyForPreviewMethod();
                                          }
                                
                                  }),
                            ),
                          ],
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
                                                widget.eCMEType=="RMP Meeting"?   "Sales Qty":"Rx objective per day",
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
                                                      
                                                    
                                                        const SizedBox(
                                                          height: 15,
                                                        ),
                                                        
                                                          Align(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          child: Text(
                                                           widget.eCMEType=="RMP Meeting"? "Sales Qty*" :"Rx objective per day",
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
                                                                widget.eCMEType=="RMP Meeting"?  salesQtyController : rxPerDayController,
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
                                                                      if( widget.eCMEType=="RMP Meeting"? salesQtyController.text!="": rxPerDayController.text!=""){
                                                                           dynamicRowsListForBrand.add([
                                                                            initialBrand,
                                                                           eCMEAmountCOntroller.text==""?"0": eCMEAmountCOntroller.text,
                                                                            widget.eCMEType=="RMP Meeting"? (salesQtyController.text == "" ? "0" : salesQtyController.text) :(rxPerDayController.text == "" ? "0" : rxPerDayController.text),
                                                                            "0",
                                                                            "0"
                                                                           
                                                                          ]);
                                                                          finalBrandListAftrRemoveDuplication =
                                                                            ECMEServices().removeDuplicationForBrand(dynamicRowsListForBrand);
                                                                            print("unique brand List  ====$finalBrandListAftrRemoveDuplication");
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
                                                                            widget.eCMEType=="RMP Meeting"?  "Please Enter e_CME Amount  " :"Please Enter Rx objective per day",
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
              lattitute: latitude.toString(), 
              longitude: longitude.toString(),
              docList: widget.docInfo, 
              docListString:ECMEServices().getDoctString(widget.docInfo) , 
              brandList: finalBrandListAftrRemoveDuplication, 
              brandString:ECMEServices().getbrandString(eCMESettingsData!,finalBrandListAftrRemoveDuplication,splitedAmount), 
              areaId: areaId,
              costPerDoctor: getCostPerDoctor().toStringAsFixed(2), 
              meetingDate: selectedExpiredDateString,
              meetingTopic: meetingTopicController.text, 
              meetingVanue: meetingVenueController.text, 
              eCMEType: widget.eCMEType,
              doctorCategory: selcetDoctorCategory!,
              institutionName:selcetDoctorCategory=="Institution"? institutionController.text:"", 
              departament:selcetDoctorCategory=="Institution"? selectedDepartment!:"", 
              eCMEAmount: eCMEAmountCOntroller.text, 
              splitdECMEAmount: splitedAmount.toStringAsFixed(2),
              doctorsCount: doctorParticipantCount.text, 
              internDoctor: internDoctorController.text, 
              dMFDoctors: dmfDoctorController.text, 
              nurses: nursesController.text, 
              skfAttendance: skfAttenaceController.text,
              othersParticipants: othersParticipantsController.text,
              numberOfParticipant: noIfparticipants.toString(), 
              speakerName: meetingProbaleSpeakerNameController.text,
              stationaries: stationnairesController.text, 
              hallRentAmount: hallRentController.text,
              foodExpense: foodExpansesController.text,
              giftCost: giftController.text,
              payMode: selectedPayMode!,
              payTo:  payToController.text,
              totalBudget: totalBudget.toStringAsFixed(2) 
            );

    if (ecmeSubmitDataModel!=null) {
      setState(() {
        isLoading = false;
      });
     
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ECMEDoctorPreviewScreen(
           eCMESubmitDataModel: ecmeSubmitDataModel, 
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



