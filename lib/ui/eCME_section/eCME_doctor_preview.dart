import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/e_CME_submit_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCME_services.dart';
import 'package:MREPORTING/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/brand_details_show_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/button_row_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/preview_row_widget.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ECMEDoctorPreviewScreen extends StatefulWidget {
  ECMESubmitDataModel eCMESubmitDataModel;
  ECMEDoctorPreviewScreen({
     super.key,
     required this.eCMESubmitDataModel,
   });

  @override
  State<ECMEDoctorPreviewScreen> createState() => _ECMEDoctorPreviewScreenState();
}

class _ECMEDoctorPreviewScreenState extends State<ECMEDoctorPreviewScreen> {
  DmPathDataModel? dmpathData;
  bool isPreviewLoading = false;
  int totalAmount = 0;
  double totalECMEAmout=0.0;
  String eCMEAmount="";

  
  
  @override
  void initState() { 
    super.initState();
    dmpathData = Boxes.getDmpath().get('dmPathData');
    dynamicTotalCalculation();
  }
  
   dynamicTotalCalculation() {
    totalAmount =ECMEServices().dynamicTotalCalculation(widget.eCMESubmitDataModel)["total_amount"];
    eCMEAmount =ECMEServices().dynamicTotalCalculation(widget.eCMESubmitDataModel)["eCME_amount"];
    setState(() {
      
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eCME Preview'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
              child: Column(
                    children: [
                    ((widget.eCMESubmitDataModel.eCMEType== "Intern Reception")|| (widget.eCMESubmitDataModel.eCMEType== "Society") )? const SizedBox() :const RowForCMEPreview(title: 'Selected Doctors', value: "",isBold: false,),
                    ((widget.eCMESubmitDataModel.eCMEType== "Intern Reception")|| (widget.eCMESubmitDataModel.eCMEType== "Society") )?const SizedBox()  :  
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 5),
                        child:  Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  height: widget.eCMESubmitDataModel.docList.length*20,
                                  width: 150,
                                  child: ListView.builder(itemCount: widget.eCMESubmitDataModel.docList.length,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text( "${index+1}. ${widget.eCMESubmitDataModel.docList[index].docName}|${widget.eCMESubmitDataModel.docList[index].degree}|${widget.eCMESubmitDataModel.docList[index].specialty}",style: const TextStyle(fontSize: 13),),
                                      );
                                    }),
                                
                                ),
                              ),
                            ),
                            
                          ],
                        ),
                      ),
                      RowForCMEPreview(title: 'E-CME Type', value: widget.eCMESubmitDataModel.eCMEType, isBold: true,),
                      RowForCMEPreview(title: 'Meeting Date', value: widget.eCMESubmitDataModel.meetingDate,isBold: false,),
                      RowForCMEPreview(title: 'Doctor Category', value: widget.eCMESubmitDataModel.doctorCategory,isBold: false,), 
                      widget.eCMESubmitDataModel.doctorCategory=="Institution"  ? RowForCMEPreview(title: 'Institute Name', value: widget.eCMESubmitDataModel.institutionName,isBold: false,) : const SizedBox(),
                      widget.eCMESubmitDataModel.doctorCategory=="Institution" ?RowForCMEPreview(title: 'Department', value: widget.eCMESubmitDataModel.departament,isBold: false,):const SizedBox(),
                      RowForCMEPreview(title: 'Meeting Venue', value: widget.eCMESubmitDataModel.meetingVanue,isBold: false,),
                      RowForCMEPreview(title: 'Meeting Topic', value: widget.eCMESubmitDataModel.meetingTopic,isBold: false,), 
                      RowForCMEPreview(title: 'Probable Speaker Name & Designation', value: widget.eCMESubmitDataModel.speakerName,isBold: false,), 
                      RowForCMEPreview(title: 'Pay Mode', value: widget.eCMESubmitDataModel.payMode,isBold: false, ),
                      RowForCMEPreview(title: 'Pay to', value: widget.eCMESubmitDataModel.payTo,isBold: false,),
                      RowForCMEPreview(title: 'Total Numbers of participants', value: widget.eCMESubmitDataModel.numberOfParticipant,isBold: false,),
                     
                    Container(
                       decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 237, 246, 246),
                        ),
                        child:  Column( 
                          mainAxisAlignment: MainAxisAlignment.center, 
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                            PreviewBreakdownRowWidget(title:'1.  Doctors' ,value:widget.eCMESubmitDataModel.doctorsCount ,),
                            PreviewBreakdownRowWidget(title:'2.  Intern Doctors' ,value:widget.eCMESubmitDataModel.internDoctor ,),
                            PreviewBreakdownRowWidget(title:'3.  DMF Doctor' ,value:widget.eCMESubmitDataModel.dMFDoctors ,),
                            PreviewBreakdownRowWidget(title:'3.  Nurses' ,value:widget.eCMESubmitDataModel.nurses ,),
                            PreviewBreakdownRowWidget(title:'4.  SKF Attendance' ,value:widget.eCMESubmitDataModel.skfAttendance ,),
                            PreviewBreakdownRowWidget(title:'6.  Others' ,value:widget.eCMESubmitDataModel.othersParticipants ,),
                          ],),
                     ),

                    RowForCMEPreview(title: 'Total Budget', value: widget.eCMESubmitDataModel.totalBudget,isBold: true,),
                    RowForCMEPreview(title: 'Cost Per doctor', value: widget.eCMESubmitDataModel.costPerDoctor,isBold: true,),
                    const RowForCMEPreview(title: 'Budget Breakdown', value: '',isBold: true,),

                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 237, 246, 246),
                        ),
                        child:Column(
                          children: [
                             PreviewBreakdownRowWidget(title:'1.  Hall rent' ,value:widget.eCMESubmitDataModel.hallRentAmount ,),
                             PreviewBreakdownRowWidget(title:'2.  Food Expense' ,value:widget.eCMESubmitDataModel.foodExpense ,),
                             PreviewBreakdownRowWidget(title:'3.  Speaker Gift or Souvenir' ,value:widget.eCMESubmitDataModel.giftCost ,),
                             PreviewBreakdownRowWidget(title:'4.  Stationnaires or others' ,value:widget.eCMESubmitDataModel.stationaries ,),

                          ],
                        ) ,
                    ),

                     RowForCMEPreview(title: 'e_CME Amount', value: eCMEAmount,isBold: true,),
                     const RowForCMEPreview(title: 'Brand Details', value: '',isBold: false,),
                     BrandDetailsShowWidget(
                              routeName:"Preview" ,
                              paddingTopValue: 5, 
                              paddingbottomValue: 5, 
                              containerHeight: 35, 
                              eCMeTYpe: widget.eCMESubmitDataModel.eCMEType, 
                              eCMESubmitDataModel: widget.eCMESubmitDataModel.brandList, 
                              eCMEAmount: eCMEAmount, 
                              totalAmount: totalAmount.toString(), 
                              rxOrSalesTile:widget.eCMESubmitDataModel.eCMEType=="RMP Meeting"? 
                                                  "Sales Qty":"Rx Objective Per Day", 
                              splitedECMEamount: widget.eCMESubmitDataModel.splitdECMEAmount,
                           ),
                      const SizedBox(
                        height: 25,
                      ),
                      
                      ButtonRowWidget(
                            buttonheight: 40, 
                          buttonwidth: 140, 
                          firstButtonTitle: "Edit", 
                          firstButtonColor: const Color(0xffD9873D),
                          firstButtonAction: () {
                              Navigator.pop(context);
                            },
                          secondButtonTitle: "Submit", 
                          secondButtonColor: const Color.fromARGB(255, 44, 114, 66), 
                          secondButtonAction: () async {
                                    setState(() {
                                      isPreviewLoading = true;
                                    });
                                    bool result =
                                        await InternetConnectionChecker().hasConnection;
                                    if (result == true) {
                                      eDsrSubmit();
                                    } else {
                                      setState(() {
                                        isPreviewLoading = true;
                                      });
                                      AllServices().toastMessage(interNetErrorMsg,
                                          Colors.red, Colors.white, 16);
                                    }
                                  }, 
                          isRowShow: isPreviewLoading
                        )
            ],
          ),
        ),
      )),
    );
  }

  //=============================================== get Territory Based Doctor Button (Api call)================================
  eDsrSubmit() async {
    ECMESubmitDataModel ecmeSubmitDataModel= widget.eCMESubmitDataModel;
    String submitUrl= "${dmpathData!.submitUrl}api_eCME_submit/data_submit?cid=${ecmeSubmitDataModel.cid}&userId=${ecmeSubmitDataModel.userId}&password=${ecmeSubmitDataModel.password}&synccode=123&brandString=${ecmeSubmitDataModel.brandString}0&areaId=${ecmeSubmitDataModel.areaId}&doctor_category=${ecmeSubmitDataModel.doctorCategory}&latitude=${ecmeSubmitDataModel.lattitute}&longitude=${ecmeSubmitDataModel.longitude}&eCMEType=${ecmeSubmitDataModel.eCMEType}&meetingDate=${ecmeSubmitDataModel.meetingDate}&meetingVanue=${ecmeSubmitDataModel.meetingVanue}&meetingTopic=${ecmeSubmitDataModel.meetingTopic}&speakerName=${ecmeSubmitDataModel.speakerName}&speakerInstitute=${ecmeSubmitDataModel.institutionName}&totalNumbeParticiapnts=${ecmeSubmitDataModel.numberOfParticipant}&totalBudget=${ecmeSubmitDataModel.totalBudget}&hallRentAmount=${ecmeSubmitDataModel.hallRentAmount}&costPerDoctor=${ecmeSubmitDataModel.costPerDoctor}&stationaries=${ecmeSubmitDataModel.stationaries}&giftcose=${ecmeSubmitDataModel.giftCost}&others=${ecmeSubmitDataModel.othersParticipants}&doctorsCount=${ecmeSubmitDataModel.doctorsCount}&internDoctor=${ecmeSubmitDataModel.internDoctor}&dMFDoctors=${ecmeSubmitDataModel.dMFDoctors}&nurses=${ecmeSubmitDataModel.nurses}&eCMEAmount=${ecmeSubmitDataModel.eCMEAmount}&doctor_str=${ecmeSubmitDataModel.docListString}&pay_mode=${ecmeSubmitDataModel.payMode}&skf_attendance=${ecmeSubmitDataModel.skfAttendance}&others_participants=${ecmeSubmitDataModel.othersParticipants}&food_expense=${ecmeSubmitDataModel.foodExpense}&departament=${ecmeSubmitDataModel.departament}&pay_to=${ecmeSubmitDataModel.payTo}&institutionName=${ecmeSubmitDataModel.institutionName}";
    // String submitUrl= "http://10.168.27.183:8000/skf_api/api_eCME_submit/data_submit?cid=${ecmeSubmitDataModel.cid}&userId=${ecmeSubmitDataModel.userId}&password=${ecmeSubmitDataModel.password}&synccode=123&brandString=${ecmeSubmitDataModel.eCMEType== "RMP Meeting" ? ecmeSubmitDataModel.brandString:""}&areaId=${ecmeSubmitDataModel.areaId}&docId=${ecmeSubmitDataModel.docId}&doctor_name=${ecmeSubmitDataModel.docName}&doctor_category=${ecmeSubmitDataModel.doctorCategory}&latitude=${ecmeSubmitDataModel.lattitute}&longitude=${ecmeSubmitDataModel.longitude}&eCMEType=${ecmeSubmitDataModel.eCMEType}&meetingDate=${ecmeSubmitDataModel.meetingDate}&meetingVanue=${ecmeSubmitDataModel.meetingVanue}&meetingTopic=${ecmeSubmitDataModel.meetingTopic}&speakerName=${ecmeSubmitDataModel.speakerName}&speakerdegree=${ecmeSubmitDataModel.degree}&speakerInstitute=${ecmeSubmitDataModel.institureName}&probable_speaker_designation=${ecmeSubmitDataModel.speakerDesignation}&totalNumbeParticiapnts=${ecmeSubmitDataModel.numberOfParticipant}&totalBudget=${ecmeSubmitDataModel.totalBudget}&hallRentAmount=${ecmeSubmitDataModel.hallRentAmount}&costPerDoctor=${ecmeSubmitDataModel.costPerDoctor}&foodexpenses=${ecmeSubmitDataModel.foodExpense}&stationaries=${ecmeSubmitDataModel.stationaries}&giftcose=${ecmeSubmitDataModel.giftcose}&doctorsCount=${ecmeSubmitDataModel.doctorsCount}&internDoctor=${ecmeSubmitDataModel.internDoctor}&dMFDoctors=${ecmeSubmitDataModel.dMFDoctors}&nurses=${ecmeSubmitDataModel.nurses}&rxPerDay=${ecmeSubmitDataModel.rxPerDay}&eCMEAmount=${ecmeSubmitDataModel.eCMEAmount}&institutionName=${ecmeSubmitDataModel.institureName}&departament=${ecmeSubmitDataModel.departament}";
   print("submt =$submitUrl");
    Map<String, dynamic> data = await ECMERepositry().eCMESubmitURL(submitUrl);
    if (data["status"] == "Success") {
      setState(() {
        isPreviewLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.green, Colors.white, 16);
         if ((widget.eCMESubmitDataModel.eCMEType== "Intern Reception")|| (widget.eCMESubmitDataModel.eCMEType== "Society") ){
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
         }
         else{
          if (!mounted) return;
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);

         } 
      
    } else {
      setState(() {
        isPreviewLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.red, Colors.white, 16);
    }
  }
}
