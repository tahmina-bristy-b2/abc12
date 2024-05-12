import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING/ui/eCME_section/print/pdf/pdf_page.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_textformFiled_widget.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'eCME_approval_details_screen.dart';

class ApprovedPrintScreen extends StatefulWidget {
  String cid;
  String userPass;

  ApprovedPrintScreen({super.key, required this.cid,required this.userPass});

  

  @override
  _ApprovedPrintScreenState createState() => _ApprovedPrintScreenState(); 
}

class _ApprovedPrintScreenState extends State<ApprovedPrintScreen> {
   final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Map<String, TextEditingController> controller = {};
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  ApprovedPrintDataModel? approvedPrintDetails;
  DateTime selectedStartDate=DateTime.now();
  DateTime selectedEndDate=DateTime.now();
  String startDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
  String endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  Map<String, bool> isUpdate = {};
    String levelDepth = '1';
  bool isLoading = true;
  bool isPressed = false;

  
  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getDsrDetailsData() ;
    
  }
  
  startPickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate:selectedStartDate,
      firstDate: DateTime(DateTime.now().year -1),
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
    selectedStartDate = newDate;
    startDate = DateFormat('yyyy-MM-dd').format(selectedStartDate);
    setState(() => selectedStartDate = newDate);
  
  }
   endPickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate:selectedEndDate,
      firstDate: DateTime(DateTime.now().year - 1),
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
    selectedEndDate = newDate;
    endDate = DateFormat('yyyy-MM-dd').format(selectedEndDate);
    setState(() => selectedEndDate = newDate);
  
  }
  

  double getTotalSalesQty(List<BrandListPrint> brandList){
    double totalQty=0.0;
    for (var element in brandList) {
        totalQty += double.parse(element.qty);
    }
   return totalQty;
  }

  getDouble(String eCMEAmount){
    return double.parse(eCMEAmount).toStringAsFixed(2);

  }
  @override
  void dispose() {
    super.dispose();
    controller.forEach((key, value) {
      value.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Approved e-CME'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 5),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                 const  Text("FROM :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                 Expanded(
                  flex: 2,
                   child: CustomtextFormFiledWidget(
                                          controller: initialValue(startDate), 
                                          textAlign: TextAlign.left, 
                                          keyboardType: TextInputType.text,
                                          textStyle: const TextStyle(fontSize: 14,color: Color.fromARGB(255, 41, 90, 50),), 
                                          onChanged: (String value) {
                                            setState(() {});
                                            startDate  = value;
                                          },
                           
                                          onTap: () {
                                             startPickDate();
                                            },
                                          focusNode: AlwaysDisabledFocusNode(), 
                                          hinText: "",
                                        ),
                 ),
                 const  Text("  TO :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                 Expanded(
                  flex: 2,
                   child: CustomtextFormFiledWidget(
                                          controller: initialValue(endDate), 
                                          textAlign: TextAlign.left, 
                                          keyboardType: TextInputType.text,
                                          
                                          textStyle: const TextStyle(fontSize: 14,color: Color.fromARGB(255, 41, 90, 50),), 
                                          onChanged: (String value) {
                                            setState(() {});
                                            endDate  = value;
                 
                                          },
                           
                                          onTap: () {
                                             endPickDate();
                                            },
                                          focusNode: AlwaysDisabledFocusNode(), 
                                          hinText: "",
                                        ),
                 ),
                 const SizedBox(width: 10,),
                 Expanded( child: InkWell( 
                  onTap: (){
                    getDsrDetailsData();
                  },
                   child: Container(
                                      height: 45,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: const Color.fromARGB(
                                              255, 44, 114, 66),
                                        ),
                                        child: const Center(
                                            child: Text("Filter",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255),
                                                ))),
                                      ),
                 ),)
                ],
              ),
            ),
          ),
          
          Expanded(
            child: isLoading
              ? approvedPrintDetailsLoadingView()
              : approvedPrintDetails == null || approvedPrintDetails!.resData.dataListPrint.isEmpty
                  ? Center(
                      child: Stack(children: [
                        Image.asset(
                          'assets/images/no_data_found.png',
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          left: MediaQuery.of(context).size.width / 2.5,
                          bottom: MediaQuery.of(context).size.height * .005,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffF0F0F0),
                              ),
                              onPressed: () {
                                // widget.calledBackAction('');
                                // Navigator.pop(context);
                              },
                              child: const Text(
                                'Go back',
                                style: TextStyle(color: Colors.black54),
                              )),
                        )
                      ]),
                    )
                  : approvedPrintDetailsView(),
          ),
        ],
      ),
    );
  }
  initialValue(String val) {
    return TextEditingController(text: val);
  }

  void getDsrDetailsData() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
    ApprovedPrintDataModel? approvedPrintDetailsData = await ECMERepositry().getECMEPrintDetails(
          dmpathData!.syncUrl,
          widget.cid,
          userInfo!.userId,
          widget.userPass,
          startDate,
          endDate
          );

      if (approvedPrintDetailsData != null) {
        approvedPrintDetails=approvedPrintDetailsData;
        setState(() {
          isLoading = false;
        });
      } else {
        approvedPrintDetails=null;

        setState(() {
          isLoading = false;
        });
      }
    } else {
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.yellow, Colors.black, 16);
      setState(() {
        isLoading = false;
      });
    }
  }



   AnimatedList approvedPrintDetailsView() {
    return AnimatedList(
      key: listKey,
      initialItemCount: approvedPrintDetails!.resData.dataListPrint.length,
      itemBuilder: (itemBuilder, index, animation) {
        
        for (var element in approvedPrintDetails!.resData.dataListPrint[index].brandList) {
          controller[element.rowId] =
              TextEditingController(text: element.qty);
          isUpdate[element.rowId] = false;
        }

        return listItemView(index, animation);
      },
    );
  }

  SizeTransition listItemView(int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        constraints: const BoxConstraints(maxHeight: double.infinity),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [

           ((approvedPrintDetails!.resData.dataListPrint[index].ecmeType== "Intern Reception")|| (approvedPrintDetails!.resData.dataListPrint[index].ecmeType== "Society") )?const SizedBox():  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                     Expanded(flex: 5, child: Text('Selected Doctors',style: TextStyle(fontWeight: FontWeight.w500),)),
                     Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text(''),
                    ),
                  ],
                ),
              ),

             ((approvedPrintDetails!.resData.dataListPrint[index].ecmeType== "Intern Reception")|| (approvedPrintDetails!.resData.dataListPrint[index].ecmeType== "Society") )?const SizedBox():  Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 10),
                 child:  Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: SizedBox(
                          height: approvedPrintDetails!.resData.dataListPrint[index].doctorList.length*20,
                          width: 150,
                          child: ListView.builder(itemCount: approvedPrintDetails!.resData.dataListPrint[index].doctorList.length,
                            itemBuilder: (context,index2){
                             
                               return Padding(
                                 padding: const EdgeInsets.only(top: 4),
                                 child: Text( "${index2+1}. ${approvedPrintDetails!.resData.dataListPrint[index].doctorList[index2].doctorName}|${approvedPrintDetails!.resData.dataListPrint[index].doctorList[index2].doctorId}",style: const TextStyle(fontSize: 13),),
                               );
                            }),
                        
                        ),
                      ),
                    ),
                   
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('SL No',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(approvedPrintDetails!.resData.dataListPrint[index].sl == null
                          ? ""
                          : '  ${approvedPrintDetails!.resData.dataListPrint[index].sl}',style: const TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
             
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('E-CME Type',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(approvedPrintDetails!.resData.dataListPrint[index].ecmeType == null
                          ? ""
                          : '  ${approvedPrintDetails!.resData.dataListPrint[index].ecmeType}'),
                    ),
                  ],
                ),
              ),
            
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Meeting Date',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(approvedPrintDetails!.resData.dataListPrint[index].meetingDate == null
                          ? ""
                          : '  ${approvedPrintDetails!.resData.dataListPrint[index].meetingDate}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Doctor Category',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text('  ${approvedPrintDetails!.resData.dataListPrint[index].ecmeDoctorCategory }'),
                    ),
                  ],
                ),
              ),
         approvedPrintDetails!.resData.dataListPrint[index].ecmeDoctorCategory=="Institution"  ?  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Institute Name',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text('  ${approvedPrintDetails!.resData.dataListPrint[index].institutionName}'),
                    ),
                  ],
                ),
              ) : const SizedBox(),
            approvedPrintDetails!.resData.dataListPrint[index].ecmeDoctorCategory=="Institution" ?  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Department',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(
                          '  ${approvedPrintDetails!.resData.dataListPrint[index].department}'),
                    ),
                  ],
                ),
              ) :const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Meeting Venue',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(approvedPrintDetails!.resData.dataListPrint[index].meetingVenue==null
                          ? ""
                          : '  ${approvedPrintDetails!.resData.dataListPrint[index].meetingVenue}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Meeting Topic',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':'),
                    Expanded(
                      flex: 5,
                      child: Text(" ${approvedPrintDetails!.resData.dataListPrint[index].meetingTopic}"
                         ,),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Probable Speaker Name & Designation',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text('  ${approvedPrintDetails!.resData.dataListPrint[index].probableSpeakerName}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Pay Mode',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text('  ${approvedPrintDetails!.resData.dataListPrint[index].payMode}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Pay To',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text('  ${approvedPrintDetails!.resData.dataListPrint[index].payTo}'),
                    ),
                  ],
                ),
              ),
                Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Status',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(approvedPrintDetails!.resData.dataListPrint[index].step==null
                          ? ""
                          : '   ${approvedPrintDetails!.resData.dataListPrint[index].step}',style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ), 
               Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Last Action',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(approvedPrintDetails!.resData.dataListPrint[index].lastAction==null
                          ? ""
                          : '   ${approvedPrintDetails!.resData.dataListPrint[index].lastAction}',style: const TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ),
              Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('Total Numbers of participants',style: TextStyle(fontWeight: FontWeight.w500),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 5,
                            child: Text(approvedPrintDetails!.resData.dataListPrint[index].totalNumbersOfParticipants == null
                                ? ""
                                : '   ${approvedPrintDetails!.resData.dataListPrint[index].totalNumbersOfParticipants}',style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ) ,
                    Container(
                       decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 237, 246, 246),
                        ),
                        child:  Column( 
                          mainAxisAlignment: MainAxisAlignment.center, 
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                          Padding(
                      padding: const EdgeInsets.only(top: 1, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('1.  Doctors',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].doctorsCount,style: const TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('2.  Intern Doctors',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                           flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].internDoctors,style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('3.  DMF Doctor',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].dmfDoctors,style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('3.  Nurses',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].nurses,style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('4.  SKF Attendance',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].skfAttendance,style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('6.  Others',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].othersParticipants,style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),

                        ],),
                     ),
                 
                     Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('Total Budget',style: TextStyle(fontWeight: FontWeight.w500),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 5,
                            child: Text(approvedPrintDetails!.resData.dataListPrint[index].totalBudget == null
                                ? ""
                                : '   ৳${approvedPrintDetails!.resData.dataListPrint[index].totalBudget}',style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ) ,
                    Padding(
                    padding: const EdgeInsets.only(top: 6, bottom:5 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('Cost Per doctor',style: TextStyle(fontWeight: FontWeight.w500),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 5,
                            child: Text( '   ৳${approvedPrintDetails!.resData.dataListPrint[index].costPerDoctor}',style: const TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ) ,
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:const [
                           Expanded(flex: 5, child: Text('Budget Breakdown',style: TextStyle(fontWeight: FontWeight.w500),)),
                           Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 5,
                            child: Text('',style:  TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                    ) ,

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 237, 246, 246),
                        ),
                        child:Column(
                          children: [
                            Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('1.  Hall rent',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10, 
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].hallRent==""?"৳00":' ৳${approvedPrintDetails!.resData.dataListPrint[index].hallRent}',style: const TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('2.  Food Expense',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].foodExpense==""?"৳00":' ৳${approvedPrintDetails!.resData.dataListPrint[index].foodExpense}',style: TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),
                   
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('3.  Speaker Gift or Souvenir',style: TextStyle(fontSize: 12),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].giftsSouvenirs==""?"৳00": ' ৳${approvedPrintDetails!.resData.dataListPrint[index].giftsSouvenirs}',style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 10, child: Text('4.  Stationnaires or others',style: TextStyle(fontSize: 12),)),
                          const Text(' :',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(approvedPrintDetails!.resData.dataListPrint[index].stationnaires==""?"৳00": ' ৳${approvedPrintDetails!.resData.dataListPrint[index].stationnaires}',style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),
                

                          ],
                        ) ,
                    ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('e_CME Amount',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text(' ${getDouble(approvedPrintDetails!.resData.dataListPrint[index].ecmeAmount)}'),
                    ),
                  ],
                ),
              ),
                
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(flex: 5, child: Text('Brand Details',style: TextStyle(fontWeight: FontWeight.bold),)),
                    Text('',),
                    Expanded(
                      flex: 5,
                      child: Text(':'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState_2) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 0),
                            child: Column(
                              children: [
                                Container(
                                  height: 35,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        const Color.fromARGB(255, 98, 158, 219),
                                  ),
                                  child: Row(
                                    children: [
                                     const  Expanded(
                                         flex: 2,
                                         child: Text(
                                                                               'Name',
                                                                               style: TextStyle(
                                           color: Color.fromARGB(
                                               255, 253, 253, 253),
                                           fontSize: 12),
                                                                             ),
                                       ),
                                     const  Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text("e_CME Amount",
                                          style:  TextStyle(
                                              color: Color.fromARGB(
                                                  255, 253, 253, 253),
                                              fontSize: 12),
                                        ),
                                      )),
                                      Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text(approvedPrintDetails!.resData.dataListPrint[index].ecmeType=="RMP Meeting"? 
                                          "Sales Qty":"Rx Objective Per Day",
                                          style:const  TextStyle(
                                              color: Color.fromARGB(
                                                  255, 253, 253, 253),
                                              fontSize: 12),
                                        ),
                                      )),
                                      
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 5),
                           SizedBox(
                                  height:
                                      approvedPrintDetails!.resData.dataListPrint[index].brandList.length * 25.0,
                                  child: ListView.builder(
                                      itemCount:
                                          approvedPrintDetails!.resData.dataListPrint[index].brandList.length,
                                      itemBuilder: (itemBuilder, index2) {
                                        return Container(
                                          height: 25,
                                          padding: const EdgeInsets.only(
                                              top: 5, bottom: 5, left: 5),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: index2 % 2 == 0
                                                ? Colors.grey[300]
                                                : Colors.white,
                                          ),
                                        
                                          child: Row(
                                    children: [
                                       Expanded(
                                         flex: 2,
                                         child: Text(approvedPrintDetails!.resData.dataListPrint[index].brandList
                                                    [index2].brandName,
                                                                               style:const TextStyle(
                                           color: Colors.black,
                                           fontSize: 12),
                                                                             ),
                                       ),
                                       Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text(
                                         approvedPrintDetails!.resData.dataListPrint[index].brandList[index2].amount,style: const TextStyle(fontSize: 12),
                                        ),
                                      )),
                                      Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text(
                                         approvedPrintDetails!.resData.dataListPrint[index].brandList[index2].qty,style: const TextStyle(fontSize: 12),
                                        ),
                                      )),
                                      
                                    ],
                                  ),
                                        );
                                      }),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      color: const Color.fromARGB(
                                          255, 98, 158, 219)),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 2,
                                          child: Text(
                                        "Total",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 13,),
                                      )),
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            approvedPrintDetails!.resData.dataListPrint[index].ecmeAmount,
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 254, 254, 254),
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                     
                                     
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "${getTotalSalesQty(approvedPrintDetails!.resData.dataListPrint[index].brandList)}",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 254, 254, 254),
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ), 


                   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        
                          ElevatedButton(
                            onPressed: (){
                              Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (_) =>  PdfPage(
                                                                wholeData: approvedPrintDetails!,
                                                                dataListPrint: approvedPrintDetails!.resData.dataListPrint[index], )
                                                            ),
                                                          );
                                    
                                  },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: isPressed
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 44, 114, 66),
                                 fixedSize: const Size(350, 40)
                                 ),
                            child: const Text('Print/PDF'),
                          ),
                        ],
                      ),
                   
                   
            const SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.blue[700],
            )
          ],
        ),
      ),
    );
  }

  ListView approvedPrintDetailsLoadingView() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (itemBuilder, index) {
        return Container(
          constraints: const BoxConstraints(maxHeight: double.infinity),
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              const ShimmerWidget(
                firstWidth: 70,
                secondWidth: 250,
              ),
              const ShimmerWidget(
                firstWidth: 60,
                secondWidth: 150,
              ),
              const ShimmerWidget(
                firstWidth: 60,
                secondWidth: 150,
              ),
              const ShimmerWidget(
                firstWidth: 65,
                secondWidth: 180,
              ),
              const ShimmerWidget(
                firstWidth: 55,
                secondWidth: 140,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Shimmer.fromColors(
                            baseColor: Colors.grey.shade300,
                            highlightColor: Colors.white38,
                            child: Container(
                              height: 15,
                              width: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                              ),
                            ),
                          ),
                          const SizedBox.shrink()
                        ],
                      ),
                    ),
                    const Text(':'),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          children: [
                            Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.white38,
                              child: Container(
                                height: 20,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              height: 3 * 20,
                              child: ListView.builder(
                                  itemCount: 3,
                                  itemBuilder: (itemBuilder, index2) {
                                    return Column(
                                      children: [
                                        Shimmer.fromColors(
                                          baseColor: Colors.grey.shade300,
                                          highlightColor: Colors.white38,
                                          child: Container(
                                            height: 20,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const ShimmerWidget(
                firstWidth: 50,
                secondWidth: 140,
              ),
              const ShimmerWidget(
                firstWidth: 70,
                secondWidth: 180,
              ),
              const ShimmerWidget(
                firstWidth: 60,
                secondWidth: 200,
              ),
              const ShimmerWidget(
                firstWidth: 70,
                secondWidth: 220,
              ),
              const SizedBox(
                height: 10,
              ),
              Divider(
                color: Colors.blue[700],
              )
            ],
          ),
        );
      },
    );
  }



  
}
class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

  