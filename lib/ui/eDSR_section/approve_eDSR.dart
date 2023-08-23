import 'dart:ui';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/dSR_details_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:flutter/material.dart';

class ApproveEDSR extends StatefulWidget {
  const ApproveEDSR(
      {super.key,
      required this.cid,
      required this.userPass,
      required this.submittedBy,
      required this.territoryId});
  final String cid;
  final String userPass;
  final String submittedBy;
  final String territoryId;
  @override
  State<ApproveEDSR> createState() => _ApproveEDSRState();
}

class _ApproveEDSRState extends State<ApproveEDSR> {
  Map<String, TextEditingController> controller = {};
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  DsrDetailsModel? dsrDetails;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getDsrDetailsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Approve eDSR'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : dsrDetails!.resData.dataList.isEmpty
              ? const Center(
                  child: Text("No Data Found!"),
                )
              : SafeArea(
                  child: ListView.builder(
                      itemCount: dsrDetails!.resData.dataList.length,
                      itemBuilder: (itemBuilder, index) {
                        dsrDetails!.resData.dataList[index].brandList
                            .forEach((element) {
                          controller[element.rowId] =
                              TextEditingController(text: element.amount);
                        });
                        return Container(
                          constraints:
                              const BoxConstraints(maxHeight: double.infinity),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    const Expanded(flex: 3, child: Text('Ref')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          '  ${dsrDetails!.resData.dataList[index].refId}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Date')),
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(flex: 3, child: Text('DCC')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          '  ${dsrDetails!.resData.dataList[index].doctorName}|${dsrDetails!.resData.dataList[index].doctorId}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Brand Details')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Colors.blue[700],
                                              ),
                                              child: Row(
                                                children: const [
                                                  Expanded(
                                                      child: Text(
                                                    'Name',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                                  Expanded(
                                                      child: Text(
                                                    'Sales Objectives',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                                  Expanded(
                                                      child: Text(
                                                    'Monthly Avg. Sales',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                                  Expanded(
                                                      child: Text(
                                                    'Action',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            SizedBox(
                                              height: dsrDetails!
                                                      .resData
                                                      .dataList[index]
                                                      .brandList
                                                      .length *
                                                  40,
                                              child: ListView.builder(
                                                  itemCount: dsrDetails!
                                                      .resData
                                                      .dataList[index]
                                                      .brandList
                                                      .length,
                                                  itemBuilder:
                                                      (itemBuilder, index2) {
                                                    return Container(
                                                      height: 40,
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 5,
                                                              bottom: 5,
                                                              left: 5),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: index2 % 2 == 0
                                                            ? Colors.grey[300]
                                                            : Colors.white,
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                              child: Text(
                                                            dsrDetails!
                                                                .resData
                                                                .dataList[index]
                                                                .brandList[
                                                                    index2]
                                                                .brandName,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          )),
                                                          Expanded(
                                                              child: Text(
                                                            dsrDetails!
                                                                .resData
                                                                .dataList[index]
                                                                .brandList[
                                                                    index2]
                                                                .rxPerDay,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12),
                                                          )),
                                                          Expanded(
                                                              child:
                                                                  TextFormField(
                                                            controller: controller[
                                                                dsrDetails!
                                                                    .resData
                                                                    .dataList[
                                                                        index]
                                                                    .brandList[
                                                                        index2]
                                                                    .rowId],
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            // decoration: const InputDecoration(
                                                            // border:
                                                            //     OutlineInputBorder(
                                                            //         gapPadding:
                                                            //             0.0)
                                                            // ),
                                                          )
                                                              //  Text(
                                                              //   '500.00',
                                                              //   style: TextStyle(
                                                              //       fontSize: 12),
                                                              // ),
                                                              ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.blue[700],
                                                                      ),
                                                                      onPressed:
                                                                          () {},
                                                                      child:
                                                                          const FittedBox(
                                                                        child: Text(
                                                                            'Update'),
                                                                      ))),
                                                        ],
                                                      ),
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
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Purpose')),
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Purpose Sub')),
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Description')),
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Rx Duration')),
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('No. of Patient')),
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('DSR Duration')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          '  ${dsrDetails!.resData.dataList[index].payFromFirstDate} To ${dsrDetails!.resData.dataList[index].payToFirstDate}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('DSR Schedule')),
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
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('No. of Month')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          '  ${dsrDetails!.resData.dataList[index].payNOfMonth}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Mode')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          '  ${dsrDetails!.resData.dataList[index].payMode}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('RSM Cash')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          '  ${dsrDetails!.resData.dataList[index].rsmCash}'),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, bottom: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                        flex: 3, child: Text('Status')),
                                    const Text(':'),
                                    Expanded(
                                      flex: 8,
                                      child: Text(
                                          '  ${dsrDetails!.resData.dataList[index].lastAction}'),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        fixedSize: const Size(150, 30)),
                                    child: const Text('Reject',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue[700],
                                        fixedSize: const Size(150, 30)),
                                    child: const Text('Approve'),
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
                        );
                      }),
                ),
    );
  }

  getDsrDetailsData() async {
    dsrDetails = await eDSRRepository().getDsrDetailsData(
        "",
        widget.cid,
        userInfo!.userId,
        widget.userPass,
        widget.submittedBy,
        widget.territoryId);

    if (dsrDetails != null) {
      setState(() {
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }
}
