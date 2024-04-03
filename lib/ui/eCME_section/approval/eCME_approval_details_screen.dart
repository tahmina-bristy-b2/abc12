import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/dSR_details_model.dart';
import 'package:MREPORTING/models/e_CME/e_CME_approval_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shimmer/shimmer.dart';


class EcmeApprovalScreen extends StatefulWidget {
  const EcmeApprovalScreen(
      {super.key,
      required this.cid,
      required this.userPass,
      required this.submittedBy,
      required this.territoryId,
      required this.levelDepth,
      required this.calledBackAction});
  final String cid;
  final String userPass;
  final String submittedBy;
  final String territoryId;
  final String levelDepth;
  final Function calledBackAction;
  @override
  State<EcmeApprovalScreen> createState() => _EcmeApprovalScreenState();
}

class _EcmeApprovalScreenState extends State<EcmeApprovalScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Map<String, TextEditingController> controller = {};
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  EcmeApprovalDetailsDataModel? dsrDetails;

  String levelDepth = '1';
  bool isLoading = true;
  bool isPressed = false;
  Map<String, bool> isUpdate = {};
  bool rsmCashError = false;
  Map<String, String> dropdownValue = {};

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getDsrDetailsData();
  }

  @override
  void dispose() {
    super.dispose();
    controller.forEach((key, value) {
      value.dispose();
    });
  }

  double totalBrandSales(List<BrandList> brandList) {
    double total = 0.0;
    for (var element in brandList) {
      total = total + double.parse(element.amount);
    }

    return total;
  }

  void removeDSR(int index) {
    listKey.currentState!.removeItem(
      index,
      (context, animation) {
        return listItemView(index, animation);
      },
      duration: const Duration(seconds: 1),
    );

    Future.delayed(const Duration(seconds: 1), () {
      dsrDetails!.resData.dataList.removeAt(index);
      if (dsrDetails!.resData.dataList.isEmpty) {
        widget.calledBackAction('value');
        Navigator.pop(context);
      }
    });

  }


   void approvedOrRejectedDsr(String sl,String approvedEdsrParams, int index) async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      Map<String, dynamic> approvedResponse =
          await ECMERepositry().approvedOrRejectedDsr(
        sl,
        dmpathData!.syncUrl,
        widget.cid,
        userInfo!.userId,
        widget.userPass,
        approvedEdsrParams,
      );

      if (approvedResponse.isNotEmpty &&
          approvedResponse["status"] == "Success") {
        removeDSR(index);

        rsmCashError = false;
        setState(() {
          isPressed = false;
        });
      } else {
        setState(() {
          isPressed = false;
        });
      }
    } else {
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.yellow, Colors.black, 16);
      setState(() {
        isPressed = false;
      });
    }
  }


 String getTotal(List<EcmeBrandListDataModel> brandList){
    int totalAmount = 0;
    for (var element in brandList) {
      totalAmount = totalAmount + int.parse(element.salesQty);
    }
    print("total $totalAmount");
    return totalAmount.toString();

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.calledBackAction('');
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Approval eDSR'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: isLoading
              ? dsrDetailsLoadingView()
              : dsrDetails == null || dsrDetails!.resData.dataList.isEmpty
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
                                widget.calledBackAction('');
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Go back',
                                style: TextStyle(color: Colors.black54),
                              )),
                        )
                      ]),
                    )
                  : dsrDetailsView(),
        ),
      ),
    );
  }

  AnimatedList dsrDetailsView() {
    return AnimatedList(
      key: listKey,
      initialItemCount: dsrDetails!.resData.dataList.length,
      itemBuilder: (itemBuilder, index, animation) {
        for (var element in dsrDetails!.resData.dataList[index].brandList) {
          controller[element.rowId] =
              TextEditingController(text: element.salesQty);
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
            Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 5),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text("Doctor's Name",style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(' ${dsrDetails!.resData.dataList[index].doctorName}'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Doctor Id',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text( '  ${dsrDetails!.resData.dataList[index].doctorId}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Degree',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(' ${dsrDetails!.resData.dataList[index].degree}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Speciality',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(' ${dsrDetails!.resData.dataList[index].specialty}'),
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
                      child: Text( '  ${dsrDetails!.resData.dataList[index].ecmeType }'),
                    ),
                  ],
                ),
              ),
             dsrDetails!.resData.dataList[index].ecmeType!="RMP MEETING"?  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   const  Expanded(flex: 5, child: Text('E-CME Amount',style: TextStyle(fontWeight: FontWeight.w500),)),
                     const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(' ${dsrDetails!.resData.dataList[index].ecmeAmount}',
                          ),
                    ),
                  ],
                ),
              ):const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Meeting Date',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(
                         '  ${dsrDetails!.resData.dataList[index].meetingDate}'
                          ),
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
                      child: Text('  ${dsrDetails!.resData.dataList[index].doctorsCategory }'),
                    ),
                  ],
                ),
              ),
          dsrDetails!.resData.dataList[index].doctorsCategory=="Institution"  ?  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Institute Name',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text('  ${dsrDetails!.resData.dataList[index].institutionName}'),
                    ),
                  ],
                ),
              ) : const SizedBox(),
            dsrDetails!.resData.dataList[index].doctorsCategory=="Institution" ?  Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Department',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(
                          '  ${dsrDetails!.resData.dataList[index].department}'),
                    ),
                  ],
                ),
              ) :const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Meeting vanue',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text( '  ${dsrDetails!.resData.dataList[index].meetingVenue}'),
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
                      child: Text(" ${dsrDetails!.resData.dataList[index].meetingTopic}"
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
                    const Expanded(flex: 5, child: Text('Probable Speaker Name',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text('  ${dsrDetails!.resData.dataList[index].probableSpeakerName}'),
                    ),
                  ],
                ),
              ),
               Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Probable Speaker Department',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child:
                          Text('  ${dsrDetails!.resData.dataList[index].department}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 5, child: Text('Rx Objectives per day',style: TextStyle(fontWeight: FontWeight.w500),)),
                    const Text(':',style: TextStyle(fontWeight: FontWeight.w500),),
                    Expanded(
                      flex: 5,
                      child: Text(dsrDetails!.resData.dataList[index].rxPerDay==null
                          ? ""
                          : '  ${dsrDetails!.resData.dataList[index].rxPerDay}'),
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
                      child: Text(dsrDetails!.resData.dataList[index].step==null
                          ? ""
                          : '  ${dsrDetails!.resData.dataList[index].step}'),
                    ),
                  ],
                ),
              ),
               Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('Total Numbers of participants',style: TextStyle(fontWeight: FontWeight.w500),)),
                          const Text(':',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 5,
                            child: Text(dsrDetails!.resData.dataList[index].totalNumbersOfParticipants == null
                                ? ""
                                : ' ${dsrDetails!.resData.dataList[index].totalNumbersOfParticipants}'),
                          ),
                        ],
                      ),
                    ) ,
                    Container(
                       decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
                        ),
                        child:  Column( 
                          mainAxisAlignment: MainAxisAlignment.center, 
                          crossAxisAlignment: CrossAxisAlignment.center ,
                          children: [
                          Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8,left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('1.  Doctors',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(' ${dsrDetails!.resData.dataList[index].doctorsCount}',style: const TextStyle(fontSize: 12)),
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
                              child: Text("  ${dsrDetails!.resData.dataList[index].internDoctors}",style: const TextStyle(fontSize: 12),),
                            ),
                          ),
                        ],
                      ),
                    ),Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8,left: 15,right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('3.  DMF Doctor',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text("  ${dsrDetails!.resData.dataList[index].dmfDoctors}",style: const TextStyle(fontSize: 12),),
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
                              child: Text("  ${dsrDetails!.resData.dataList[index].nurses}",style: const TextStyle(fontSize: 12),),
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
                            child: Text("  ${dsrDetails!.resData.dataList[index].totalBudget}" 
                              ),
                          ),
                        ],
                      ),
                    ) ,
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),color:const Color.fromARGB(255, 230, 244, 243),
                        ),
                        child:Column(
                          children: [
                            Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 5,left: 15,right: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 5, child: Text('1.  Hall rent',style: TextStyle(fontSize: 12),)),
                          const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                          Expanded(
                            flex: 10, 
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text('  ৳${dsrDetails!.resData.dataList[index].hallRent}',style: const TextStyle(fontSize: 12)),
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
                                child: Text('  ৳${dsrDetails!.resData.dataList[index].foodExpense}',style: const TextStyle(fontSize: 12),),
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
                                child: Text('  ৳${dsrDetails!.resData.dataList[index].costPerDoctor}',style: const TextStyle(fontSize: 12),),
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
                            const Expanded(flex: 5, child: Text('4.  Speaker Gift or Souvenir',style: TextStyle(fontSize: 12),)),
                            const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('  ৳${dsrDetails!.resData.dataList[index].giftsSouvenirs}',style: const TextStyle(fontSize: 12),),
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
                            const Expanded(flex: 5, child: Text('5.  Stationnaires or others',style: TextStyle(fontSize: 12),)),
                            const Text('-',style: TextStyle(fontWeight: FontWeight.w500)),
                            Expanded(
                              flex: 10,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text('  ৳${dsrDetails!.resData.dataList[index].stationnaires}',style: const TextStyle(fontSize: 12),),
                              ),
                            ),
                          ],
                        ),
                      ),
                  

                          ],
                        ) ,
                    ),
                    const SizedBox(height: 10,),
                
            dsrDetails!.resData.dataList[index].ecmeType=="RMP MEETING"?     Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(flex: 3, child: Text('Brand Details',style: TextStyle(fontWeight: FontWeight.w500))),
                    Text(''),
                    Expanded(
                      flex: 8,
                      child: Text(':'),
                    ),
                  ],
                ),
              ):const SizedBox(),
             dsrDetails!.resData.dataList[index].ecmeType=="RMP MEETING"?   Padding(
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
                                         child: Text( 'Name',
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
                              dsrDetails!.resData.dataList[index].ecmeType=="RMP MEETING"?  SizedBox(
                                  height:
                                      dsrDetails!.resData.dataList[index].brandList.length * 25.0,
                                  child: ListView.builder(
                                      itemCount:
                                          dsrDetails!.resData.dataList[index].brandList.length,
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
                                         child: Text(dsrDetails!.resData.dataList[index].brandList
                                                    [index2].brandName.toString(),
                                                                               style:const TextStyle(
                                           color: Colors.black,
                                           fontSize: 12),
                                                                             ),
                                       ),
                                      Expanded(
                                        flex: 3,
                                          child: Center(
                                        child: Text(
                                         dsrDetails!.resData.dataList[index].brandList
                                                    [index2].salesQty.toString(),
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
                                     
                                     
                                      Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                           getTotal(dsrDetails!.resData.dataList[index].brandList
                                                    ),
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
                     
            
            dsrDetails!.resData.dataList[index].lastAction == 'Approved' &&
                    dsrDetails!.resData.dataList[index].step == 'RSM' &&
                    widget.levelDepth == '0'
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: isPressed
                            ? () {}
                            : () {
                                setState(() {
                                  isPressed = true;
                                });
                           
                                // String approvedEdsrParams =
                                //     "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Rejected";
                                approvedOrRejectedDsr(dsrDetails!.resData.dataList[index].sl,
                                   "Rejected", index);

                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isPressed ? Colors.grey : Colors.red,
                            fixedSize: const Size(150, 30)),
                        child: const Text('Reject',
                            style: TextStyle(color: Colors.white)),
                      ),
                      ElevatedButton(
                        onPressed: isPressed
                            ? () {}
                            : () {
                                setState(() {
                                  isPressed = true;
                                });
                                // String approvedEdsrParams =
                                //     "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Approved";
                                approvedOrRejectedDsr(dsrDetails!.resData.dataList[index].sl,
                                    "Approved", index);
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isPressed
                                ? Colors.grey
                                : const Color.fromARGB(255, 44, 114, 66),
                     
                            fixedSize: const Size(150, 30)),
                        child: const Text('Approve'),
                      ),
                    ],
                  )
                : (dsrDetails!.resData.dataList[index].lastAction ==
                                'Approved' &&
                            dsrDetails!.resData.dataList[index].step == 'FM' &&
                            widget.levelDepth == '1') ||
                        (dsrDetails!.resData.dataList[index].lastAction ==
                                'Submitted' &&
                            dsrDetails!.resData.dataList[index].step == 'MSO' &&
                            widget.levelDepth == '2')
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: isPressed
                                ? () {}
                                : () {
                                    setState(() {
                                      isPressed = true;
                                    });
                                   
                                    // String approvedEdsrParams =
                                    //     "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Rejected";
                                    approvedOrRejectedDsr(dsrDetails!.resData.dataList[index].sl,
                                        "Rejected", index);

                                  },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    isPressed ? Colors.grey : Colors.red,
                                fixedSize: const Size(150, 30)),
                            child: const Text('Reject',
                                style: TextStyle(color: Colors.white)),
                          ),
                          ElevatedButton(
                            onPressed: isPressed
                                ? () {}
                                : () {
                                    setState(() {
                                      isPressed = true;
                                    });
                                    // String approvedEdsrParams =
                                    //     "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Approved";
                                    approvedOrRejectedDsr(dsrDetails!.resData.dataList[index].sl,
                                        "Approved", index);
                                  },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: isPressed
                                    ? Colors.grey
                                    : const Color.fromARGB(255, 44, 114, 66),
                                fixedSize: const Size(150, 30)),
                            child: const Text('Approve'),
                          ),
                        ],
                      )
                    : const Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '----------- Approval pending from RSM/FM -----------',
                              style: TextStyle(color: Colors.red, fontSize: 16),
                            )),
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

  ListView dsrDetailsLoadingView() {
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

  void getDsrDetailsData() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result == true) {
      dsrDetails = await ECMERepositry().getDsrDetailsData(
          dmpathData!.syncUrl,
          widget.cid,
          userInfo!.userId,
          widget.userPass,
          widget.submittedBy,
          widget.territoryId,
          widget.levelDepth);
          print("data =$dsrDetails");

      if (dsrDetails != null) {
        for (var element in dsrDetails!.resData.dataList) {
          dropdownValue[element.sl] = "NO";
        }

        setState(() {
          isLoading = false;
        });
      } else {
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

  // void brandAmountUpdate(String brandAmountUpdateParams, int index, int index2,
  //     String rowId, setState_2) async {
  //   setState_2(() {
  //     isUpdate[rowId] = true;
  //   });
  //   Map<String, dynamic> updateResponse =
  //       await EDSRRepositories().brandAmountUpdate(
  //     dmpathData!.syncUrl,
  //     widget.cid,
  //     userInfo!.userId,
  //     widget.userPass,
  //     brandAmountUpdateParams,
  //   );

  //   if (updateResponse.isNotEmpty) {
  //     dsrDetails!.resData.dataList[index].brandList[index2].salesQty = controller[
  //             dsrDetails!.resData.dataList[index].brandList[index2].rowId]!
  //         .text;
  //     setState_2(() {
  //       isUpdate[rowId] = false;
  //     });
  //   } else {
  //     setState_2(() {
  //       isUpdate[rowId] = false;
  //     });
  //   }
  // }

 
}

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget(
      {super.key, required this.firstWidth, required this.secondWidth});

  final double firstWidth;
  final double secondWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                    width: firstWidth,
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
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.white38,
                  child: Container(
                    height: 15,
                    width: secondWidth,
                    margin: const EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox.shrink()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
