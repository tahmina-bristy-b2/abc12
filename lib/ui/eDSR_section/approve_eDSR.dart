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

  String? dropdownValue = "NO";

  bool isLoading = true;
  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    getDsrDetailsData();
  }

  double totalBrandSales(List<BrandList> brandList) {
    double total = 0.0;
    for (var element in brandList) {
      total = total + double.parse(element.amount);
    }

    return total;
  }

  void removeDSR(int index) {
    dsrDetails!.resData.dataList.removeAt(index);
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
                        for (var element
                            in dsrDetails!.resData.dataList[index].brandList) {
                          controller[element.rowId] =
                              TextEditingController(text: element.amount);
                        }

                        dropdownValue =
                            dsrDetails!.resData.dataList[index].rsmCash;

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
                                                color: Color.fromARGB(
                                                    255, 138, 201, 149),
                                                // color: Colors.blue[700],
                                              ),
                                              child: Row(
                                                children: const [
                                                  Expanded(
                                                      child: Text(
                                                    'Name',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  )),
                                                  Expanded(
                                                      child: Center(
                                                    child: Text(
                                                      'Sales Objectives',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                  )),
                                                  Expanded(
                                                      child: Center(
                                                    child: Text(
                                                      'Monthly Avg. Sales',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
                                                  )),
                                                  Expanded(
                                                      child: Center(
                                                    child: Text(
                                                      'Action',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12),
                                                    ),
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
                                                              child: Center(
                                                            child: Text(
                                                              dsrDetails!
                                                                  .resData
                                                                  .dataList[
                                                                      index]
                                                                  .brandList[
                                                                      index2]
                                                                  .rxPerDay,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          12),
                                                            ),
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: const TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                              textInputAction:
                                                                  TextInputAction
                                                                      .done,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          Expanded(
                                                            child:
                                                                StatefulBuilder(
                                                              builder: (context,
                                                                  setState_2) {
                                                                return isUpdate
                                                                    ? Center(
                                                                        child:
                                                                            SizedBox(
                                                                          height:
                                                                              20,
                                                                          width:
                                                                              20,
                                                                          child:
                                                                              CircularProgressIndicator(
                                                                            color:
                                                                                Colors.blue[700],
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : ElevatedButton(
                                                                        style: ElevatedButton.styleFrom(
                                                                            backgroundColor:
                                                                                Colors.blue[700]),
                                                                        onPressed:
                                                                            () {
                                                                          String
                                                                              brandAmountUpdateParams =
                                                                              "row_id=${dsrDetails!.resData.dataList[index].brandList[index2].rowId}&sl=${dsrDetails!.resData.dataList[index].sl}&brand_id=${dsrDetails!.resData.dataList[index].brandList[index2].brandId}&brand_name=${dsrDetails!.resData.dataList[index].brandList[index2].brandName}&rx_per_day=${dsrDetails!.resData.dataList[index].brandList[index2].rxPerDay}&new_amount=${controller[dsrDetails!.resData.dataList[index].brandList[index2].rowId]!.text}&old_amount=${dsrDetails!.resData.dataList[index].brandList[index2].amount}";

                                                                          brandAmountUpdate(
                                                                              brandAmountUpdateParams,
                                                                              setState_2);
                                                                        },
                                                                        child:
                                                                            const FittedBox(
                                                                          child:
                                                                              Text('Update'),
                                                                        ),
                                                                      );
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: Color.fromARGB(
                                                    255, 138, 201, 149),
                                                // color: Colors.blue[500],
                                              ),
                                              child: Row(
                                                children: [
                                                  const Expanded(
                                                      child: Text(
                                                    'Total',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                  )),
                                                  const Expanded(
                                                      child: Text(
                                                    '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                                  Expanded(
                                                      child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      totalBrandSales(
                                                              dsrDetails!
                                                                  .resData
                                                                  .dataList[
                                                                      index]
                                                                  .brandList)
                                                          .toStringAsFixed(2),
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 13),
                                                    ),
                                                  )),
                                                  const Expanded(
                                                      child: Text(
                                                    '',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12),
                                                  )),
                                                ],
                                              ),
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
                                        child: StatefulBuilder(
                                          builder: (context, setState_2) {
                                            return Row(
                                              children: [
                                                DropdownButton(
                                                  value: dropdownValue,
                                                  iconEnabledColor:
                                                      Colors.blue[900],
                                                  iconDisabledColor: Colors.red,
                                                  items: <String>["YES", "NO"]
                                                      .map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                    return DropdownMenuItem<
                                                            String>(
                                                        value: value,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10,
                                                                  right: 10),
                                                          child: Text(value),
                                                        ));
                                                  }).toList(),
                                                  underline: null,
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState_2(() {
                                                      dropdownValue = newValue;
                                                    });
                                                  },
                                                ),
                                                const SizedBox.shrink()
                                              ],
                                            );
                                          },
                                        )

                                        // Text(
                                        //     '  ${dsrDetails!.resData.dataList[index].rsmCash}'),
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
                                    onPressed: () {
                                      String approvedEdsrParams =
                                          "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=$dropdownValue&status=REJECTED";
                                      approvedOrRejectedDsr(
                                          approvedEdsrParams, index);
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        fixedSize: const Size(150, 30)),
                                    child: const Text('Reject',
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      String approvedEdsrParams =
                                          "sl=${dsrDetails!.resData.dataList[index].sl}&rsm_cash=$dropdownValue&status=APPROVED";
                                      approvedOrRejectedDsr(
                                          approvedEdsrParams, index);
                                    },
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

  void getDsrDetailsData() async {
    dsrDetails = await EDSRRepositories().getDsrDetailsData(
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

  void brandAmountUpdate(String brandAmountUpdateParams, setState_2) async {
    setState_2(() {
      isUpdate = true;
    });
    Map<String, dynamic> updateResponse =
        await EDSRRepositories().brandAmountUpdate(
      "",
      widget.cid,
      userInfo!.userId,
      widget.userPass,
      brandAmountUpdateParams,
    );

    if (updateResponse.isNotEmpty) {
      setState_2(() {
        isUpdate = false;
      });
    } else {
      setState_2(() {
        isUpdate = false;
      });
    }
  }

  void approvedOrRejectedDsr(String approvedEdsrParams, int index) async {
    setState(() {
      isLoading = true;
    });
    Map<String, dynamic> approvedResponse =
        await EDSRRepositories().approvedOrRejectedDsr(
      "",
      widget.cid,
      userInfo!.userId,
      widget.userPass,
      approvedEdsrParams,
    );

    if (approvedResponse.isNotEmpty &&
        approvedResponse["res_data"]["status"] == "Success") {
      removeDSR(index);
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
