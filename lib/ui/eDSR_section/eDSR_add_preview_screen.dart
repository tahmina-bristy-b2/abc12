import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSr_repository.dart';
import 'package:MREPORTING/ui/eDSR_section/eDCR_screen.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PreviewEDSRADDScreen extends StatefulWidget {
  Map<String, dynamic> previewData;
  PreviewEDSRADDScreen({super.key, required this.previewData});

  @override
  State<PreviewEDSRADDScreen> createState() => _PreviewEDSRADDScreenState();
}

class _PreviewEDSRADDScreenState extends State<PreviewEDSRADDScreen> {
  bool isLoading = false;
  int totalRxperDay = 0;
  int totalEmrX = 0;
  int total4pRX = 0;
  int totalAmount = 0;

  @override
  void initState() {
    super.initState();
    totalAmount = dynamicTotalCalculation(
      totalAmount,
      2,
    );
    totalRxperDay = dynamicTotalCalculation(
      totalRxperDay,
      1,
    );
    totalEmrX = dynamicTotalCalculation(
      totalEmrX,
      3,
    );
    total4pRX = dynamicTotalCalculation(
      total4pRX,
      4,
    );
  }

  //=======================

  int dynamicTotalCalculation(int purposeTotal, int index) {
    purposeTotal = 0;
    widget.previewData["Brand"].forEach((element) {
      purposeTotal = purposeTotal + int.parse(element[index]);
    });
    return purposeTotal;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eDSR Preview'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 3, child: Text('Doctor')),
                    const Text(':'),
                    Expanded(
                      flex: 8,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Text(' ${widget.previewData["doc_name"]}'),
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
                    const Expanded(flex: 3, child: Text('Doctor Id')),
                    const Text(':'),
                    Expanded(
                      flex: 8,
                      child: Text(widget.previewData["doc_id"] == null
                          ? ""
                          : '  ${widget.previewData["doc_id"]}'),
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
                      child: Text(widget.previewData["degree"] == null
                          ? ""
                          : ' ${widget.previewData["degree"]}'),
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
                      child: Text(widget.previewData["specialty"] == null
                          ? ""
                          : ' ${widget.previewData["specialty"]}'),
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
                      child: Text(widget.previewData["mobile"] == null
                          ? "0"
                          : '  ${widget.previewData["mobile"]}'),
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
                      child: Text(widget.previewData["purposeName"] == null
                          ? ""
                          : '  ${widget.previewData["purposeName"]}'),
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
                      child: Text(widget.previewData["Sub_purpose_Name"] == null
                          ? ""
                          : '  ${widget.previewData["Sub_purpose_Name"]}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 3, child: Text('Doctor Type')),
                    const Text(':'),
                    Expanded(
                      flex: 8,
                      child: Text('  ${widget.previewData["dsr_type"]}'),
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
                      child: Text('  ${widget.previewData["Descripton"]}'),
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
                          '  ${widget.previewData["RX_Duration_from_Name"]}  To  ${widget.previewData["RX_Duration_to_name"]}'),
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
                      child: Text(widget.previewData["DSR_Schedule"] == null
                          ? ""
                          : '  ${widget.previewData["DSR_Schedule"]}'),
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
                          ' ${widget.previewData["DSR_Duration_from_name"]}  To  ${widget.previewData["DSR_Duration_to_name"]}'),
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
                      child:
                          Text('  ${widget.previewData["Number_of_Patient"]}'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(flex: 3, child: Text('Mode')),
                    const Text(':'),
                    Expanded(
                      flex: 8,
                      child: Text(widget.previewData["Issue_Mode"] == null
                          ? ""
                          : '  ${widget.previewData["Issue_Mode"]}'),
                    ),
                  ],
                ),
              ),
              (widget.previewData["Issue_Mode"] == "APC" ||
                      widget.previewData["Issue_Mode"] == "CT")
                  ? Padding(
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(flex: 3, child: Text('Issue To')),
                          const Text(':'),
                          Expanded(
                            flex: 8,
                            child: Text(widget.previewData["Issue_To"] == null
                                ? ""
                                : ' ${widget.previewData["Issue_To"]}'),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Expanded(flex: 3, child: Text('Brand Details')),
                    Text(':'),
                    Expanded(
                      flex: 8,
                      child: Text(' '),
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
                                      const Expanded(
                                          child: Text(
                                        'Name',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 253, 253, 253),
                                            fontSize: 12),
                                      )),
                                      Expanded(
                                          child: Center(
                                        child: Text(
                                          widget.previewData["dsr_type"] !=
                                                  'DOCTOR'
                                              ? 'Monthly Avg. Sales'
                                              : 'Rx/Day',
                                          style: const TextStyle(
                                              color: Color.fromARGB(
                                                  255, 253, 253, 253),
                                              fontSize: 12),
                                        ),
                                      )),
                                      const Expanded(
                                          child: Center(
                                        child: Text(
                                          "EMR RX",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 253, 253, 253),
                                              fontSize: 12),
                                        ),
                                      )),
                                      const Expanded(
                                          child: Center(
                                        child: Text(
                                          "4P RX",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 253, 253, 253),
                                              fontSize: 12),
                                        ),
                                      )),
                                      const Expanded(
                                          child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "DSR",
                                          style: TextStyle(
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
                                      widget.previewData["Brand"].length * 25.0,
                                  child: ListView.builder(
                                      itemCount:
                                          widget.previewData["Brand"].length,
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
                                                  child: Text(
                                                widget.previewData["Brand"]
                                                    [index2][0],
                                                style: const TextStyle(
                                                    fontSize: 12),
                                              )),
                                              Expanded(
                                                  child: Center(
                                                child: Text(
                                                  widget.previewData["Brand"]
                                                      [index2][1],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              )),
                                              Expanded(
                                                  child: Center(
                                                child: Text(
                                                  widget.previewData["Brand"]
                                                      [index2][3],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              )),
                                              Expanded(
                                                  child: Center(
                                                child: Text(
                                                  widget.previewData["Brand"]
                                                      [index2][4],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              )),
                                              Expanded(
                                                  child: Align(
                                                alignment: Alignment.topRight,
                                                child: Text(
                                                  widget.previewData["Brand"]
                                                      [index2][2],
                                                  style: const TextStyle(
                                                      fontSize: 12),
                                                ),
                                              )),
                                              const SizedBox(width: 5),
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
                                          child: Text(
                                        "Total",
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 12),
                                      )),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "$totalRxperDay",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 254, 254, 254),
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "$totalEmrX",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 254, 254, 254),
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Center(
                                          child: Text(
                                            "$total4pRX",
                                            style: const TextStyle(
                                                color: Color.fromARGB(
                                                    255, 254, 254, 254),
                                                fontSize: 13),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            "$totalAmount",
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
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      bool result =
                          await InternetConnectionChecker().hasConnection;
                      if (result == true) {
                        eDsrSubmit();
                      } else {
                        setState(() {
                          isLoading = true;
                        });
                        AllServices().toastMessage(
                            interNetErrorMsg, Colors.red, Colors.white, 16);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 44, 114, 66),
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
                                color: Color.fromARGB(255, 241, 240, 240))),
                      ],
                    ),
                  ),
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
    Map<String, dynamic> data = await EDSRRepositories().submitEDSR(
      widget.previewData["submit_url"],
      widget.previewData["cid"],
      widget.previewData["userId"],
      widget.previewData["password"],
      "123",
      widget.previewData["brandString"],
      widget.previewData["area_id"],
      widget.previewData["doc_id"],
      widget.previewData["doc_name"],
      "",
      widget.previewData["latitude"],
      widget.previewData["longitude"],
      widget.previewData["dsr_type"],
      widget.previewData["Category"],
      widget.previewData["purposeId"],
      widget.previewData["Sub_purpose"],
      widget.previewData["Descripton"],
      widget.previewData["RX_Duration_from"],
      widget.previewData["RX_Duration_to"],
      widget.previewData["Number_of_Patient"],
      widget.previewData["DSR_Duration_from"],
      widget.previewData["DSR_Duration_to"],
      widget.previewData["DSR_Schedule"],
      "0",
      widget.previewData["Issue_Mode"],
      "",
      "0",
      widget.previewData["Issue_To"],
    );
    if (data["status"] == "Success") {
      setState(() {
        isLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.green, Colors.white, 16);
      if (!mounted) return;
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      setState(() {
        isLoading = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.red, Colors.white, 16);
    }
  }
}
