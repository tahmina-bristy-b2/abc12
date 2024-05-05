import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/e_CME_submit_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ECMEDoctorPreviewScreen extends StatefulWidget {
  ECMESubmitDataModel eCMESubmitDataModel;
  ECMEDoctorPreviewScreen({super.key,
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
  
  int dynamicTotalCalculation() {
    totalAmount = 0;
    eCMEAmount = double.parse(widget.eCMESubmitDataModel.eCMEAmount).toStringAsFixed(2);
    for (var element in widget.eCMESubmitDataModel.brandList) {
      totalAmount = totalAmount + int.parse(element[2]);
    }
    return totalAmount;
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
                
        ((widget.eCMESubmitDataModel.eCMEType== "Intern Reception")|| (widget.eCMESubmitDataModel.eCMEType== "Society") )?const SizedBox()  :Padding(
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

           ( (widget.eCMESubmitDataModel.eCMEType== "Intern Reception")|| (widget.eCMESubmitDataModel.eCMEType== "Society") )?const SizedBox()  :   Padding(
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
                    // Padding(
                    //   padding: const EdgeInsets.only(right: 10),
                    //   child: IconButton(
                    //     icon: const Icon(Icons.edit,
                    //         size: 20, color: Color(0xff8AC995)),
                    //     onPressed: () {
                    //       Navigator.pop(context);
                        
                    //     },
                    //   ),
                    // )
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
                      child: Text(widget.eCMESubmitDataModel.eCMEType == null
                          ? ""
                          : '  ${widget.eCMESubmitDataModel.eCMEType}'),
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
                      child: Text(widget.eCMESubmitDataModel.meetingDate == null
                          ? ""
                          : '  ${widget.eCMESubmitDataModel.meetingDate}'),
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
                      child: Text('  ${widget.eCMESubmitDataModel.doctorCategory }'),
                    ),
                  ],
                ),
              ),
          widget.eCMESubmitDataModel.doctorCategory=="Institution"  ?  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Institute Name',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text('  ${widget.eCMESubmitDataModel.institutionName}'),
                    ),
                  ],
                ),
              ) : const SizedBox(),
            widget.eCMESubmitDataModel.doctorCategory=="Institution" ?  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Department',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(
                          '  ${widget.eCMESubmitDataModel.departament}'),
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
                      child: Text(widget.eCMESubmitDataModel.meetingVanue==null
                          ? ""
                          : '  ${widget.eCMESubmitDataModel.meetingVanue}'),
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
                      child: Text(" ${widget.eCMESubmitDataModel.meetingTopic}"
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
                          Text('  ${widget.eCMESubmitDataModel.speakerName}'),
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
                          Text('  ${widget.eCMESubmitDataModel.payMode}'),
                    ),
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Pay to',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text('  ${widget.eCMESubmitDataModel.payTo}'),
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
                            child: Text(widget.eCMESubmitDataModel.numberOfParticipant == null
                                ? ""
                                : '   ${widget.eCMESubmitDataModel.numberOfParticipant}',style: const TextStyle(fontWeight: FontWeight.bold),),
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
                              child: Text(widget.eCMESubmitDataModel.doctorsCount,style: const TextStyle(fontSize: 12)),
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
                              child: Text(widget.eCMESubmitDataModel.internDoctor,style: const TextStyle(fontSize: 12),),
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
                              child: Text(widget.eCMESubmitDataModel.dMFDoctors,style: const TextStyle(fontSize: 12),),
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
                              child: Text(widget.eCMESubmitDataModel.nurses,style: const TextStyle(fontSize: 12),),
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
                              child: Text(widget.eCMESubmitDataModel.skfAttendance,style: const TextStyle(fontSize: 12),),
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
                              child: Text(widget.eCMESubmitDataModel.othersParticipants,style: const TextStyle(fontSize: 12),),
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
                            child: Text(widget.eCMESubmitDataModel.totalBudget == null
                                ? ""
                                : '   ৳${widget.eCMESubmitDataModel.totalBudget}',style: const TextStyle(fontWeight: FontWeight.bold),),
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
                            child: Text( '   ৳${widget.eCMESubmitDataModel.costPerDoctor}',style: const TextStyle(fontWeight: FontWeight.bold),),
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
                              child: Text(widget.eCMESubmitDataModel.hallRentAmount==""?"৳00":' ৳${widget.eCMESubmitDataModel.hallRentAmount}',style: const TextStyle(fontSize: 12)),
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
                              child: Text(widget.eCMESubmitDataModel.foodExpense==""?"৳00":' ৳${widget.eCMESubmitDataModel.foodExpense}',style: TextStyle(fontSize: 12),),
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
                              child: Text(widget.eCMESubmitDataModel.giftCost==""?"৳00": ' ৳${widget.eCMESubmitDataModel.giftCost}',style: const TextStyle(fontSize: 12),),
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
                              child: Text(widget.eCMESubmitDataModel.stationaries==""?"৳00": ' ৳${widget.eCMESubmitDataModel.stationaries}',style: TextStyle(fontSize: 12),),
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
                          Text('  $eCMEAmount'),
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
                                        child: Text(widget.eCMESubmitDataModel.eCMEType=="RMP Meeting"? 
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
                                      widget.eCMESubmitDataModel.brandList.length * 25.0,
                                  child: ListView.builder(
                                      itemCount:
                                          widget.eCMESubmitDataModel.brandList.length,
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
                                         child: Text(widget.eCMESubmitDataModel.brandList
                                                    [index2][0],
                                                                               style:const TextStyle(
                                           color: Colors.black,
                                           fontSize: 12),
                                                                             ),
                                       ),
                                       Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text(
                                         widget.eCMESubmitDataModel.splitdECMEAmount,style: const TextStyle(fontSize: 12),
                                        ),
                                      )),
                                      Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text(
                                         widget.eCMESubmitDataModel.brandList
                                                         [index2][2],style: const TextStyle(fontSize: 12),
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
                                            eCMEAmount,
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
                                            totalAmount.toString(),
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
                height: 25,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffD9873D),
                        fixedSize: const Size(160, 40)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.edit, size: 18),
                        SizedBox(
                          width: 8,
                        ),
                        Text('Edit',
                            style: TextStyle(
                                color: Color.fromARGB(255, 241, 240, 240))),
                      ],
                    ),
                  ),
                  isPreviewLoading == false
                      ? ElevatedButton(
                          onPressed: () async {
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
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 44, 114, 66),
                              fixedSize: const Size(160, 40)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.cloud_done, size: 18),
                              SizedBox(
                                width: 8,
                              ),
                              Text('Submit',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 241, 240, 240))),
                            ],
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }

  //=============================================== get Territory Based Doctor Button (Api call)================================
  eDsrSubmit() async {
    ECMESubmitDataModel ecmeSubmitDataModel= widget.eCMESubmitDataModel;
   // print("submt =${ecmeSubmitDataModel.areaId}");
    String submitUrl= "${dmpathData!.submitUrl}api_eCME_submit/data_submit?cid=${ecmeSubmitDataModel.cid}&userId=${ecmeSubmitDataModel.userId}&password=${ecmeSubmitDataModel.password}&synccode=123&brandString=${ecmeSubmitDataModel.brandString}0&areaId=${ecmeSubmitDataModel.areaId}&doctor_category=${ecmeSubmitDataModel.doctorCategory}&latitude=${ecmeSubmitDataModel.lattitute}&longitude=${ecmeSubmitDataModel.longitude}&eCMEType=${ecmeSubmitDataModel.eCMEType}&meetingDate=${ecmeSubmitDataModel.meetingDate}&meetingVanue=${ecmeSubmitDataModel.meetingVanue}&meetingTopic=${ecmeSubmitDataModel.meetingTopic}&speakerName=${ecmeSubmitDataModel.speakerName}&speakerInstitute=${ecmeSubmitDataModel.institutionName}&totalNumbeParticiapnts=${ecmeSubmitDataModel.numberOfParticipant}&totalBudget=${ecmeSubmitDataModel.totalBudget}&hallRentAmount=${ecmeSubmitDataModel.hallRentAmount}&costPerDoctor=${ecmeSubmitDataModel.costPerDoctor}&stationaries=${ecmeSubmitDataModel.stationaries}&giftcose=${ecmeSubmitDataModel.giftCost}&others=${ecmeSubmitDataModel.othersParticipants}&doctorsCount=${ecmeSubmitDataModel.doctorsCount}&internDoctor=${ecmeSubmitDataModel.internDoctor}&dMFDoctors=${ecmeSubmitDataModel.dMFDoctors}&nurses=${ecmeSubmitDataModel.nurses}&eCMEAmount=${ecmeSubmitDataModel.eCMEAmount}&doctor_str=${ecmeSubmitDataModel.docListString}&pay_mode=${ecmeSubmitDataModel.payMode}&skf_attendance=${ecmeSubmitDataModel.skfAttendance}&others_participants=${ecmeSubmitDataModel.othersParticipants}&food_expense=${ecmeSubmitDataModel.foodExpense}&departament=${ecmeSubmitDataModel.departament}&pay_to=${ecmeSubmitDataModel.payTo}";
    // String submitUrl= "http://10.168.27.183:8000/skf_api/api_eCME_submit/data_submit?cid=${ecmeSubmitDataModel.cid}&userId=${ecmeSubmitDataModel.userId}&password=${ecmeSubmitDataModel.password}&synccode=123&brandString=${ecmeSubmitDataModel.eCMEType== "RMP Meeting" ? ecmeSubmitDataModel.brandString:""}&areaId=${ecmeSubmitDataModel.areaId}&docId=${ecmeSubmitDataModel.docId}&doctor_name=${ecmeSubmitDataModel.docName}&doctor_category=${ecmeSubmitDataModel.doctorCategory}&latitude=${ecmeSubmitDataModel.lattitute}&longitude=${ecmeSubmitDataModel.longitude}&eCMEType=${ecmeSubmitDataModel.eCMEType}&meetingDate=${ecmeSubmitDataModel.meetingDate}&meetingVanue=${ecmeSubmitDataModel.meetingVanue}&meetingTopic=${ecmeSubmitDataModel.meetingTopic}&speakerName=${ecmeSubmitDataModel.speakerName}&speakerdegree=${ecmeSubmitDataModel.degree}&speakerInstitute=${ecmeSubmitDataModel.institureName}&probable_speaker_designation=${ecmeSubmitDataModel.speakerDesignation}&totalNumbeParticiapnts=${ecmeSubmitDataModel.numberOfParticipant}&totalBudget=${ecmeSubmitDataModel.totalBudget}&hallRentAmount=${ecmeSubmitDataModel.hallRentAmount}&costPerDoctor=${ecmeSubmitDataModel.costPerDoctor}&foodexpenses=${ecmeSubmitDataModel.foodExpense}&stationaries=${ecmeSubmitDataModel.stationaries}&giftcose=${ecmeSubmitDataModel.giftcose}&doctorsCount=${ecmeSubmitDataModel.doctorsCount}&internDoctor=${ecmeSubmitDataModel.internDoctor}&dMFDoctors=${ecmeSubmitDataModel.dMFDoctors}&nurses=${ecmeSubmitDataModel.nurses}&rxPerDay=${ecmeSubmitDataModel.rxPerDay}&eCMEAmount=${ecmeSubmitDataModel.eCMEAmount}&institutionName=${ecmeSubmitDataModel.institureName}&departament=${ecmeSubmitDataModel.departament}";
   // print("submt =$submitUrl");
    Map<String, dynamic> data = await ECMERepositry().eCMESubmitURL(submitUrl);
    if (data["status"] == "Success") {
      setState(() {
        isPreviewLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.green, Colors.white, 16);
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      
      
    } else {
      setState(() {
        isPreviewLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.red, Colors.white, 16);
    }
  }
}
