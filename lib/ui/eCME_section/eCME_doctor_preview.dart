import 'package:MREPORTING/models/e_CME/e_CME_submit_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
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
  bool isPreviewLoading = false;
  int totalRxperDay = 0;
  int totalEmrX = 0;
  int total4pRX = 0;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();

    // totalAmount = dynamicTotalCalculation(
    //   totalAmount,
    //   2,
    // );
    // totalRxperDay = dynamicCalculation(
    //   totalRxperDay,
    //   1,
    // );
    // totalEmrX = dynamicCalculation(
    //   totalEmrX,
    //   3,
    // );
    // total4pRX = dynamicCalculation(
    //   total4pRX,
    //   4,
    // );
  }

  // //=======================
  // int dynamicCalculation(int purposeTotal, int index) {
  //   purposeTotal = 0;
  //   widget.previewData["Brand"].forEach((element) {
  //     purposeTotal = purposeTotal + double.parse(element[index]).toInt();
  //   });
  //   return purposeTotal;
  // }

  // double dynamicTotalCalculation(double purposeTotal, int index) {
  //   purposeTotal = 0;
  //   widget.previewData["Brand"].forEach((element) {
  //     purposeTotal = purposeTotal + double.parse(element[index]);
  //   });
  //   return purposeTotal;
  // }

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
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Doctor',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(' ${widget.eCMESubmitDataModel.docName}'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Doctor Id',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(widget.eCMESubmitDataModel.docId == null
                          ? ""
                          : '  ${widget.eCMESubmitDataModel.docId}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Degree',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(widget.eCMESubmitDataModel.degree== null
                          ? ""
                          : ' ${widget.eCMESubmitDataModel.degree}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Speciality',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(widget.eCMESubmitDataModel.speciality== null
                          ? ""
                          : ' ${widget.eCMESubmitDataModel.speciality}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Mobile',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(widget.eCMESubmitDataModel.mobile== null
                          ? "0"
                          : '  ${widget.eCMESubmitDataModel.mobile}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('E-CME Type',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(widget.eCMESubmitDataModel.mobile == null
                          ? ""
                          : '  ${widget.eCMESubmitDataModel.eCMEType}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
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
                padding: const EdgeInsets.only(top: 8, bottom: 5),
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
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Institute Name',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text('  ${widget.eCMESubmitDataModel.institureName}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
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
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Meeting vanue',style: TextStyle(fontWeight: FontWeight.w500),)),
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
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Meeting Topic')),
                    const Text(':'),
                    Expanded(
                      flex: 5,
                      child: Text(" ${widget.eCMESubmitDataModel.meetingTopic}"
                         ,style: const TextStyle(fontWeight: FontWeight.w500),),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Probable Speaker Name',style: TextStyle(fontWeight: FontWeight.w500),)),
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
                padding: const EdgeInsets.only(top: 8, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Rx Objectives per day',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(widget.eCMESubmitDataModel.rxPerDay==null
                          ? ""
                          : '  ${widget.eCMESubmitDataModel.rxPerDay}'),
                    ),
                  ],
                ),
              ),
               Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('Total Numbers of participants',style: TextStyle(fontWeight: FontWeight.w500),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 5,
                            child: Text(widget.eCMESubmitDataModel.numberOfParticipant == null
                                ? ""
                                : ' ${widget.eCMESubmitDataModel.numberOfParticipant}'),
                          ),
                        ],
                      ),
                    ) ,
                Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('1.  Doctors',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(widget.eCMESubmitDataModel.doctorsCount,style: TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('2.  Intern Doctors',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                           flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(widget.eCMESubmitDataModel.internDoctor,style: TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('3.  DMF Doctor',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(widget.eCMESubmitDataModel.dMFDoctors,style: TextStyle(fontSize: 12),),
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
                          const Expanded(flex: 5, child: Text('3.  Nurses',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(widget.eCMESubmitDataModel.nurses,style: TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
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
                            child: Text(widget.eCMESubmitDataModel.numberOfParticipant == null
                                ? ""
                                : ' ${widget.eCMESubmitDataModel.numberOfParticipant}'),
                          ),
                        ],
                      ),
                    ) ,
                Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('1.  Hall rent',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10, 
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(widget.eCMESubmitDataModel.hallRentAmount,style: const TextStyle(fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('2.  Food Expense',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(widget.eCMESubmitDataModel.internDoctor,style: TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('3.  Cost per Doctor',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
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
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('3.  Nurses',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(widget.eCMESubmitDataModel.nurses,style: TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),
                
            widget.eCMESubmitDataModel.eCMEType=="RMP Meeting"?     Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(flex: 3, child: Text('Brand Details')),
                    Text(''),
                    Expanded(
                      flex: 8,
                      child: Text(':'),
                    ),
                  ],
                ),
              ):const SizedBox(),
             widget.eCMESubmitDataModel.eCMEType=="RMP Meeting"?   Padding(
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
                                    children:const [
                                       Expanded(
                                         flex: 2,
                                         child: Text(
                                                                               'Name',
                                                                               style: TextStyle(
                                           color: Color.fromARGB(
                                               255, 253, 253, 253),
                                           fontSize: 12),
                                                                             ),
                                       ),
                                      Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text(
                                          "Sales Qty",
                                          style:  TextStyle(
                                              color: Color.fromARGB(
                                                  255, 253, 253, 253),
                                              fontSize: 12),
                                        ),
                                      )),
                                      
                                    ],
                                  ),
                                ),
                              const SizedBox(height: 5),
                              widget.eCMESubmitDataModel.eCMEType=="RMP Meeting"?  SizedBox(
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
                                         widget.eCMESubmitDataModel.brandList
                                                         [index2][1],
                                        ),
                                      )),
                                      
                                    ],
                                  ),
                                        );
                                      }),
                                ):const SizedBox(),
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
                                            fontSize: 12),
                                      )),
                                      // Expanded(
                                      //   flex: 3,
                                      //   child: Text(
                                      //     totalRxperDay.toString(),
                                      //     style: const TextStyle(
                                      //         color: Color.fromARGB(
                                      //             255, 254, 254, 254),
                                      //         fontSize: 13),
                                      //   ),
                                      // ),
                                     
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            totalAmount.toString(),
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 254, 254, 254),
                                                fontSize: 13),
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
              ): const SizedBox(),
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
                             // eDsrSubmit();
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
  // eDsrSubmit() async {
  //   Map<String, dynamic> data = await EDSRRepositories().submitEDSR(
  //     widget.previewData["submit_url"],
  //     widget.previewData["cid"],
  //     widget.previewData["userId"],
  //     widget.previewData["password"],
  //     "123",
  //     widget.previewData["brandString"],
  //     widget.previewData["area_id"],
  //     widget.previewData["doc_id"],
  //     widget.previewData["doc_name"],
  //     "",
  //     widget.previewData["latitude"],
  //     widget.previewData["longitude"],
  //     widget.previewData["dsr_type"],
  //     widget.previewData["Category"],
  //     widget.previewData["purposeId"],
  //     widget.previewData["Sub_purpose"],
  //     widget.previewData["Descripton"],
  //     widget.previewData["RX_Duration_from"],
  //     widget.previewData["RX_Duration_to"],
  //     widget.previewData["Number_of_Patient"],
  //     widget.previewData["DSR_Duration_from"],
  //     widget.previewData["DSR_Duration_to"],
  //     widget.previewData["DSR_Schedule"],
  //     "0",
  //     widget.previewData["Issue_Mode"],
  //     "",
  //     "0",
  //     widget.previewData["Issue_To"],
  //   );
  //   if (data["status"] == "Success") {
  //     setState(() {
  //       isPreviewLoading = false;
  //     });
  //     AllServices()
  //         .toastMessage("${data["ret_str"]}", Colors.green, Colors.white, 16);
  //     if (!mounted) return;
  //     Navigator.pop(context);
  //     Navigator.pop(context);
  //   } else {
  //     setState(() {
  //       isPreviewLoading = false;
  //     });
  //     AllServices()
  //         .toastMessage("${data["ret_str"]}", Colors.red, Colors.white, 16);
  //   }
  // }
}
