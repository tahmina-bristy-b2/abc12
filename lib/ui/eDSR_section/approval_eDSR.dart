import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/dSR_details_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shimmer/shimmer.dart';

// enum ApprovalStatus { APPROVED, REJECTED }

class ApproveEDSR extends StatefulWidget {
  const ApproveEDSR(
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
  State<ApproveEDSR> createState() => _ApproveEDSRState();
}

class _ApproveEDSRState extends State<ApproveEDSR> {
  /// Will used to access the Animated list
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Map<String, TextEditingController> controller = {};
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  DsrDetailsModel? dsrDetails;

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

    // if (index == dsrDetails!.resData.dataList.length - 1) {
    //   return;
    // } else {
    //   dsrDetails!.resData.dataList.removeAt(index);
    // }
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
    // print('main length:${dsrDetails!.resData.dataList.length}');
    return AnimatedList(
      key: listKey,
      initialItemCount: dsrDetails!.resData.dataList.length,
      itemBuilder: (itemBuilder, index, animation) {
        for (var element in dsrDetails!.resData.dataList[index].brandList) {
          controller[element.rowId] =
              TextEditingController(text: element.amount);
          isUpdate[element.rowId] = false;
        }

        // dropdownValue =
        //     dsrDetails!.resData.dataList[index].rsmCash;

        return listItemView(index, animation);
      },
    );
  }

  SizeTransition listItemView(int index, Animation<double> animation) {
    // print('index: $index');
    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        constraints: const BoxConstraints(maxHeight: double.infinity),
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                children: [
                  const Expanded(flex: 3, child: Text('Trans. ID')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text('  ${dsrDetails!.resData.dataList[index].sl}'),
                  ),
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 5, bottom: 5),
            //   child: Row(
            //     children: [
            //       const Expanded(flex: 3, child: Text('Ref')),
            //       const Text(':'),
            //       Expanded(
            //         flex: 8,
            //         child: Text(
            //             '  ${dsrDetails!.resData.dataList[index].refId}'),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Date')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].submitDate}'),
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
                      flex: 3,
                      child: Text(dsrDetails!.resData.dataList[index].dsrType ==
                              'DOCTOR'
                          ? 'Doctor ID'
                          : 'Client ID')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Text(dsrDetails!.resData.dataList[index].doctorId),
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
                  Expanded(
                      flex: 3,
                      child: Text(dsrDetails!.resData.dataList[index].dsrType ==
                              'DOCTOR'
                          ? 'Doctor Name'
                          : 'Client Name')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child:
                          Text(dsrDetails!.resData.dataList[index].doctorName),
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
                  const Expanded(flex: 3, child: Text('Degree')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(dsrDetails!.resData.dataList[index].dsrType ==
                            'DOCTOR'
                        ? '  ${dsrDetails!.resData.dataList[index].degree}'
                        : '  ${dsrDetails!.resData.dataList[index].dsrType}'),
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
                      flex: 3,
                      child: Text(dsrDetails!.resData.dataList[index].dsrType ==
                              'DOCTOR'
                          ? 'Dr. Category'
                          : 'Category')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(dsrDetails!.resData.dataList[index].dsrType ==
                            'DOCTOR'
                        ? '  ${dsrDetails!.resData.dataList[index].doctorsCategory}'
                        : '  ${dsrDetails!.resData.dataList[index].dsrType}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Speciality')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(dsrDetails!.resData.dataList[index].dsrType ==
                            'DOCTOR'
                        ? '  ${dsrDetails!.resData.dataList[index].specialty}'
                        : '  ${dsrDetails!.resData.dataList[index].dsrType}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Mobile')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child:
                        Text('  ${dsrDetails!.resData.dataList[index].mobile}'),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Purpose')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].purpose}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Purpose Sub')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].purposeSub}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Dsr Type')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].dsrType}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Description')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].purposeDes}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Rx Duration')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].purposeDurationFrom} To ${dsrDetails!.resData.dataList[index].purposeDurationTo}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('No. of Patient')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].noOfPatient}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('DSR Schedule')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].scheduleType}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('DSR Duration')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].payFromFirstDate} To ${dsrDetails!.resData.dataList[index].payToFirstDate}'),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.only(top: 5, bottom: 5),
            //   child: Row(
            //     mainAxisAlignment:
            //         MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Expanded(
            //           flex: 3, child: Text('No. of Month')),
            //       const Text(':'),
            //       Expanded(
            //         flex: 8,
            //         child: Text(
            //             '  ${dsrDetails!.resData.dataList[index].payNOfMonth}'),
            //       ),
            //     ],
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Issue Mode')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].payMode}'),
                  ),
                ],
              ),
            ),
            dsrDetails!.resData.dataList[index].payMode == 'APC' ||
                    dsrDetails!.resData.dataList[index].payMode == 'CT' ||
                    dsrDetails!.resData.dataList[index].payMode == 'CC'
                ? Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(flex: 3, child: Text('CT')),
                        const Text(':'),
                        Expanded(
                          flex: 8,
                          child: Text(
                              '  ${dsrDetails!.resData.dataList[index].ct}'),
                        ),
                      ],
                    ),
                  )
                : Container(),
            // Padding(
            //   padding: const EdgeInsets.only(top: 5, bottom: 5),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       const Expanded(flex: 3, child: Text('RSM Cash')),
            //       const Text(':'),
            //       Expanded(
            //         flex: 8,
            //         child:
            //             // StatefulBuilder(
            //             //   builder: (context, setState_2) {
            //             //     return Row(
            //             //       children: [
            //             //         DropdownButton(
            //             //           value: dropdownValue[
            //             //               dsrDetails!.resData
            //             //                   .dataList[index].sl],
            //             //           hint: const Padding(
            //             //             padding:
            //             //                 EdgeInsets.all(8.0),
            //             //             child: Text('Select',
            //             //                 style: TextStyle(
            //             //                     fontSize: 12)),
            //             //           ),
            //             //           iconEnabledColor:
            //             //               Colors.blue[900],
            //             //           iconDisabledColor: Colors.red,
            //             //           items: <String>["YES", "NO"]
            //             //               .map<
            //             //                       DropdownMenuItem<
            //             //                           String>>(
            //             //                   (String value) {
            //             //             return DropdownMenuItem<
            //             //                     String>(
            //             //                 value: value,
            //             //                 child: Padding(
            //             //                   padding:
            //             //                       const EdgeInsets
            //             //                               .only(
            //             //                           left: 10,
            //             //                           right: 10),
            //             //                   child: Text(value),
            //             //                 ));
            //             //           }).toList(),
            //             //           underline: null,
            //             //           onChanged:
            //             //               (String? newValue) {
            //             //             setState_2(() {
            //             //               dropdownValue[dsrDetails!
            //             //                       .resData
            //             //                       .dataList[index]
            //             //                       .sl] =
            //             //                   newValue ?? "NO";
            //             //             });
            //             //           },
            //             //         ),
            //             //         const SizedBox.shrink()
            //             //       ],
            //             //     );
            //             //   },
            //             // )

            //             Text(
            //                 '  ${dsrDetails!.resData.dataList[index].rsmCash}'),
            //       ),
            //     ],
            //   ),
            // ),
            // rsmCashError
            //     ? Padding(
            //         padding: const EdgeInsets.only(top: 5, bottom: 5),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             const Expanded(flex: 3, child: Text('')),
            //             const Text(''),
            //             Expanded(
            //                 flex: 8,
            //                 child: StatefulBuilder(
            //                   builder: (context, setState_2) {
            //                     return Row(
            //                       children: const [
            //                         Text('RSM Cash is Resqired.',
            //                             style: TextStyle(
            //                                 color: Colors.red, fontSize: 12)),
            //                         SizedBox.shrink()
            //                       ],
            //                     );
            //                   },
            //                 )

            //                 // Text(
            //                 //     '  ${dsrDetails!.resData.dataList[index].rsmCash}'),
            //                 ),
            //           ],
            //         ),
            //       )
            //     : Container(),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Status')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].lastAction}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(flex: 3, child: Text('Brand Details')),
                  const Text(':'),
                  Expanded(
                    flex: 8,
                    child: Container(),
                  ),
                ],
              ),
            ),
            brandDetails(index),
            const SizedBox(
              height: 10,
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
                                // if (dropdownValue != null) {
                                String approvedEdsrParams =
                                    "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Rejected";
                                approvedOrRejectedDsr(
                                    approvedEdsrParams, index);

                                // } else {
                                //   rsmCashError = true;
                                //   setState(() {});
                                // }
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
                                String approvedEdsrParams =
                                    "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Approved";
                                approvedOrRejectedDsr(
                                    approvedEdsrParams, index);
                              },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: isPressed
                                ? Colors.grey
                                : const Color.fromARGB(255, 44, 114, 66),
                            // backgroundColor: Colors.blue[700],
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
                                    // if (dropdownValue != null) {
                                    String approvedEdsrParams =
                                        "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Rejected";
                                    approvedOrRejectedDsr(
                                        approvedEdsrParams, index);

                                    // } else {
                                    //   rsmCashError = true;
                                    //   setState(() {});
                                    // }
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
                                    String approvedEdsrParams =
                                        "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=${dropdownValue[dsrDetails!.resData.dataList[index].sl]}&status=Approved";
                                    approvedOrRejectedDsr(
                                        approvedEdsrParams, index);
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

  Padding brandDetails(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 8,
            child: StatefulBuilder(
              builder: (context, setState_2) {
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 98, 158, 219),
                        // color: const Color.fromARGB(255, 138, 201, 149),
                        // color: Colors.blue[700],
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Name',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          Expanded(
                            flex: 3,
                              child: Center(
                            child: Text(
                              // dsrDetails!.resData.dataList[index].dsrType ==
                              //         'DCC'
                              //     ? 'Monthly Avg. Sales'
                              //     : 'Rx/Day',


                             dsrDetails!.resData.dataList[index].dsrType ==   "DOCTOR"
                                                                  ? "Seen RX Objective/Per Day*"
                                                                  : "Business Objective Per Month(Qty)*",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          )),
                          // const Expanded(
                          //     child: Center(
                          //   child: Text(
                          //     'EMRX',
                          //     style:
                          //         TextStyle(color: Colors.white, fontSize: 12),
                          //   ),
                          // )),
                          // const Expanded(
                          //     child: Center(
                          //   child: Text(
                          //     '4P RX',
                          //     style:
                          //         TextStyle(color: Colors.white, fontSize: 12),
                          //   ),
                          // )),
                          const Expanded(
                              child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "DSR",
                              // dsrDetails!.resData.dataList[index].dsrType ==
                              //         'DCC'
                              //     ? 'Monthly Avg. Sales'
                              //     : 'Amount',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          )),
                          // const Expanded(
                          //   child: Center(
                          //     child: Text(
                          //       'Action',
                          //       style: TextStyle(
                          //           color: Colors
                          //               .black,
                          //           fontSize: 12),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      height:
                          dsrDetails!.resData.dataList[index].brandList.length *
                              25,
                      child: ListView.builder(
                          itemCount: dsrDetails!
                              .resData.dataList[index].brandList.length,
                          itemBuilder: (itemBuilder, index2) {
                            return Container(
                              height: 25,
                              padding: const EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: index2 % 2 == 0
                                    ? Colors.grey[300]
                                    : Colors.white,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    dsrDetails!.resData.dataList[index]
                                        .brandList[index2].brandName,
                                    style: const TextStyle(fontSize: 12),
                                  )),
                                  Expanded(
                                    flex: 3,
                                      child: Center(
                                    child: Text(
                                      dsrDetails!.resData.dataList[index]
                                          .brandList[index2].rxPerDay,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )),
                                  // Expanded(
                                  //     child: Center(
                                  //   child: Text(
                                  //     dsrDetails!.resData.dataList[index]
                                  //         .brandList[index2].emrx,
                                  //     style: const TextStyle(fontSize: 12),
                                  //   ),
                                  // )),
                                  // Expanded(
                                  //     child: Center(
                                  //   child: Text(
                                  //     dsrDetails!.resData.dataList[index]
                                  //         .brandList[index2].fourPRx,
                                  //     style: const TextStyle(fontSize: 12),
                                  //   ),
                                  // )),
                                  Expanded(
                                      child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      dsrDetails!.resData.dataList[index]
                                          .brandList[index2].amount,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  )),
                                  // Expanded(
                                  //   child: TextFormField(
                                  //     readOnly: true,
                                  //     controller: controller[dsrDetails!
                                  //         .resData
                                  //         .dataList[index]
                                  //         .brandList[index2]
                                  //         .rowId],
                                  //     decoration: const InputDecoration(
                                  //         border: InputBorder.none),
                                  //     textAlign: TextAlign.end,
                                  //     style: const TextStyle(
                                  //         fontSize: 13, color: Colors.black),
                                  //     keyboardType: TextInputType.number,
                                  //     textInputAction: TextInputAction.done,
                                  //   ),
                                  // ),
                                  const SizedBox(width: 5),
                                  // Expanded(
                                  //   child: isUpdate[dsrDetails!
                                  //           .resData
                                  //           .dataList[
                                  //               index]
                                  //           .brandList[
                                  //               index2]
                                  //           .rowId]!
                                  //       ? Center(
                                  //           child:
                                  //               SizedBox(
                                  //             height:
                                  //                 20,
                                  //             width:
                                  //                 20,
                                  //             child:
                                  //                 CircularProgressIndicator(
                                  //               color:
                                  //                   Colors.blue[700],
                                  //             ),
                                  //           ),
                                  //         )
                                  //       : ElevatedButton(
                                  //           style: ElevatedButton.styleFrom(
                                  //               backgroundColor:
                                  //                   Colors.blue[700]),
                                  //           onPressed:
                                  //               () {
                                  //             String
                                  //                 brandAmountUpdateParams =
                                  //                 "row_id=${dsrDetails!.resData.dataList[index].brandList[index2].rowId}&sl=${dsrDetails!.resData.dataList[index].sl}&brand_id=${dsrDetails!.resData.dataList[index].brandList[index2].brandId}&brand_name=${dsrDetails!.resData.dataList[index].brandList[index2].brandName}&rx_per_day=${dsrDetails!.resData.dataList[index].brandList[index2].rxPerDay}&new_amount=${controller[dsrDetails!.resData.dataList[index].brandList[index2].rowId]!.text}&old_amount=${dsrDetails!.resData.dataList[index].brandList[index2].amount}";

                                  //             brandAmountUpdate(
                                  //                 brandAmountUpdateParams,
                                  //                 index,
                                  //                 index2,
                                  //                 dsrDetails!.resData.dataList[index].brandList[index2].rowId,
                                  //                 setState_2);
                                  //           },
                                  //           child:
                                  //               const FittedBox(
                                  //             child:
                                  //                 Text('Update'),
                                  //           ),
                                  //         ),
                                  // ),
                                ],
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromARGB(255, 98, 158, 219),
                        // color: const Color.fromARGB(255, 138, 201, 149),
                        // color: Colors.blue[500],
                      ),
                      child: Row(
                        children: [
                          const Expanded(
                              child: Text(
                            'Total',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          const Expanded(
                              child: Text(
                            '',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          const Expanded(
                              child: Text(
                            '',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          const Expanded(
                              child: Text(
                            '',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )),
                          Expanded(
                              child: Align(
                            alignment: const Alignment(0.9, 0.0),
                            child: Text(
                              totalBrandSales(dsrDetails!
                                      .resData.dataList[index].brandList)
                                  .toStringAsFixed(0),
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13),
                            ),
                          )),
                          // const Expanded(
                          //   child: Text(
                          //     '',
                          //     style: TextStyle(
                          //         color:
                          //             Colors.white,
                          //         fontSize: 12),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
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
      dsrDetails = await EDSRRepositories().getDsrDetailsData(
          dmpathData!.syncUrl,
          widget.cid,
          userInfo!.userId,
          widget.userPass,
          widget.submittedBy,
          widget.territoryId,
          widget.levelDepth);

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

  void brandAmountUpdate(String brandAmountUpdateParams, int index, int index2,
      String rowId, setState_2) async {
    setState_2(() {
      isUpdate[rowId] = true;
    });
    Map<String, dynamic> updateResponse =
        await EDSRRepositories().brandAmountUpdate(
      dmpathData!.syncUrl,
      widget.cid,
      userInfo!.userId,
      widget.userPass,
      brandAmountUpdateParams,
    );

    if (updateResponse.isNotEmpty) {
      dsrDetails!.resData.dataList[index].brandList[index2].amount = controller[
              dsrDetails!.resData.dataList[index].brandList[index2].rowId]!
          .text;
      setState_2(() {
        isUpdate[rowId] = false;
      });
    } else {
      setState_2(() {
        isUpdate[rowId] = false;
      });
    }
  }

  void approvedOrRejectedDsr(String approvedEdsrParams, int index) async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      Map<String, dynamic> approvedResponse =
          await EDSRRepositories().approvedOrRejectedDsr(
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
