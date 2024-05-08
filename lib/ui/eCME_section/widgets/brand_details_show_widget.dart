
import 'package:flutter/material.dart';
import 'package:MREPORTING/models/e_CME/e_CME_submit_data_model.dart';

class BrandDetailsShowWidget extends StatelessWidget {
  final double paddingTopValue;
  final double paddingbottomValue;
  final double containerHeight;
  final String eCMeTYpe;
  final ECMESubmitDataModel eCMESubmitDataModel;
  final String eCMEAmount;
  final String totalAmount;


  const BrandDetailsShowWidget({
    Key? key,
    required this.paddingTopValue,
    required this.paddingbottomValue,
    required this.containerHeight,
    required this.eCMeTYpe,
    required this.eCMESubmitDataModel,
    required this.totalAmount,
    required this.eCMEAmount
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child:  Padding(
                                    padding: const EdgeInsets.only(left: 0),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: containerHeight,
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
                                                child: Text( 'Name',
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
                                                child: Text(eCMESubmitDataModel.eCMEType=="RMP Meeting"? 
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
                                              eCMESubmitDataModel.brandList.length * 25.0,
                                          child: ListView.builder(
                                              itemCount:
                                                  eCMESubmitDataModel.brandList.length,
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
                                                child: Text(eCMESubmitDataModel.brandList
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
                                                eCMESubmitDataModel.splitdECMEAmount,style: const TextStyle(fontSize: 12),
                                                ),
                                              )),
                                              Expanded(
                                                flex: 3,
                                                  child: Center(
                                                child: Text(
                                                eCMESubmitDataModel.brandList
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
                                                    eCMEAmount.toString(),
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
                                  ),
                            ),
                          ],
                        ),
                      );
  }
}
