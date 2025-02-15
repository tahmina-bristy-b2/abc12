import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/approval/eCME_approval_details_screen.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/bill_transaction/bill_edit_screen.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/print/pdf/bill_feedback.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/print/pdf/doctor_list_pdf.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/print/pdf/pdf_page.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/print/pdf/proposal_bill_pdf.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/widgets/brand_details_show_widget.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/widgets/custom_textformFiled_widget.dart';
import 'package:MREPORTING_OFFLINE/ui/eCME_section/widgets/preview_row_widget.dart';
import 'package:MREPORTING_OFFLINE/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ApprovedPrintScreen extends StatefulWidget {
  String cid;
  String userPass;

  ApprovedPrintScreen({super.key, required this.cid, required this.userPass});

  @override
  _ApprovedPrintScreenState createState() => _ApprovedPrintScreenState();
}

class _ApprovedPrintScreenState extends State<ApprovedPrintScreen> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  Map<String, TextEditingController> controller = {};
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  ApprovedPrintDataModel? approvedPrintDetails;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();
  String startDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
    getDsrDetailsData();
  }

  startPickDate() async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: selectedStartDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 100),
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
      initialDate: selectedEndDate,
      firstDate: DateTime(DateTime.now().year - 1),
      lastDate: DateTime(DateTime.now().year + 100),
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

  double getTotalSalesQty(List<BrandListPrint> brandList) {
    double totalQty = 0.0;
    for (var element in brandList) {
      totalQty += double.parse(element.qty);
    }
    return totalQty;
  }

  getDouble(String eCMEAmount) {
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
        title: const Text('Approved CME'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            child: SizedBox(
              height: 60,
              child: Row(
                children: [
                  const Text(
                    "FROM :  ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomtextFormFiledWidget(
                      controller: initialValue(startDate),
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 41, 90, 50),
                      ),
                      onChanged: (String value) {
                        setState(() {});
                        startDate = value;
                      },
                      onTap: () {
                        startPickDate();
                      },
                      focusNode: AlwaysDisabledFocusNode(),
                      hinText: "",
                    ),
                  ),
                  const Text(
                    "  TO :  ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    flex: 2,
                    child: CustomtextFormFiledWidget(
                      controller: initialValue(endDate),
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      textStyle: const TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 41, 90, 50),
                      ),
                      onChanged: (String value) {
                        setState(() {});
                        endDate = value;
                      },
                      onTap: () {
                        endPickDate();
                      },
                      focusNode: AlwaysDisabledFocusNode(),
                      hinText: "",
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        getDsrDetailsData();
                      },
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(255, 44, 114, 66),
                        ),
                        child: const Center(
                            child: Text("Filter",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? approvedPrintDetailsLoadingView()
                : approvedPrintDetails == null ||
                        approvedPrintDetails!.resData.dataListPrint.isEmpty
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
      ApprovedPrintDataModel? approvedPrintDetailsData = await ECMERepositry()
          .getECMEPrintDetails(dmpathData!.syncUrl, widget.cid,
              userInfo!.userId, widget.userPass, startDate, endDate);

      if (approvedPrintDetailsData != null) {
        approvedPrintDetails = approvedPrintDetailsData;
        setState(() {
          isLoading = false;
        });
      } else {
        approvedPrintDetails = null;

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
        print(
            "$index ${approvedPrintDetails!.resData.dataListPrint[index].submitBy.toString()}");

        for (var element
            in approvedPrintDetails!.resData.dataListPrint[index].brandList) {
          controller[element.rowId] = TextEditingController(text: element.qty);
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
            ((approvedPrintDetails!.resData.dataListPrint[index].ecmeType ==
                        "Intern Reception") ||
                    (approvedPrintDetails!
                            .resData.dataListPrint[index].ecmeType ==
                        "Society"))
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Expanded(
                            flex: 5,
                            child: Text(
                              'Selected Doctors',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                        Text(
                          ':',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(''),
                        ),
                      ],
                    ),
                  ),
            ((approvedPrintDetails!.resData.dataListPrint[index].ecmeType ==
                        "Intern Reception") ||
                    (approvedPrintDetails!
                            .resData.dataListPrint[index].ecmeType ==
                        "Society"))
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SizedBox(
                              height: approvedPrintDetails!.resData
                                      .dataListPrint[index].doctorList.length *
                                  19,
                              width: 150,
                              child: ListView.builder(
                                  primary: false,
                                  itemCount: approvedPrintDetails!.resData
                                      .dataListPrint[index].doctorList.length,
                                  itemBuilder: (context, index2) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        "${index2 + 1}. ${approvedPrintDetails!.resData.dataListPrint[index].doctorList[index2].doctorName}|${approvedPrintDetails!.resData.dataListPrint[index].doctorList[index2].doctorId}",
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            RowForCMEPreview(
              title: 'SL No',
              value: approvedPrintDetails!.resData.dataListPrint[index].sl,
              isBold: true,
            ),
            RowForCMEPreview(
              title: 'CME Type',
              value:
                  approvedPrintDetails!.resData.dataListPrint[index].ecmeType,
              isBold: false,
            ),
            RowForCMEPreview(
              title: 'Meeting Date',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].meetingDate,
              isBold: false,
            ),
            RowForCMEPreview(
              title: 'Doctor Category',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].ecmeDoctorCategory,
              isBold: false,
            ),
            approvedPrintDetails!
                        .resData.dataListPrint[index].ecmeDoctorCategory ==
                    "Institution"
                ? RowForCMEPreview(
                    title: 'Institute Name',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].institutionName,
                    isBold: false,
                  )
                : const SizedBox(),
            approvedPrintDetails!
                        .resData.dataListPrint[index].ecmeDoctorCategory ==
                    "Institution"
                ? RowForCMEPreview(
                    title: "Department",
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].department,
                    isBold: false,
                  )
                : const SizedBox(),
            RowForCMEPreview(
              title: 'Meeting Venue',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].meetingVenue,
              isBold: false,
            ),
            RowForCMEPreview(
              title: 'Meeting Topic',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].meetingTopic,
              isBold: false,
            ),
            RowForCMEPreview(
              title: 'Probable Speaker Name & Designation',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].probableSpeakerName,
              isBold: false,
            ),
            RowForCMEPreview(
              title: 'Pay Mode',
              value: approvedPrintDetails!.resData.dataListPrint[index].payMode,
              isBold: false,
            ),
            RowForCMEPreview(
              title: 'Pay To',
              value: approvedPrintDetails!.resData.dataListPrint[index].payTo,
              isBold: false,
            ),
            RowForCMEPreview(
              title: 'Submit by',
              value:
                  approvedPrintDetails!.resData.dataListPrint[index].submitBy,
              isBold: true,
              fontColor: Colors.green,
            ),
            RowForCMEPreview(
              title: 'Status',
              value: approvedPrintDetails!.resData.dataListPrint[index].step,
              isBold: true,
              fontColor: Colors.green,
            ),
            RowForCMEPreview(
              title: 'Last Action',
              value:
                  approvedPrintDetails!.resData.dataListPrint[index].lastAction,
              isBold: true,
              fontColor: Colors.green,
            ),
            RowForCMEPreview(
              title: 'Total Numbers of participants',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].totalNumbersOfParticipants,
              isBold: true,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 237, 246, 246),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PreviewBreakdownRowWidget(
                    title: '1.  Doctors (MBBS & Above)',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].doctorsCount,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '2.  Intern Doctors',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].internDoctors,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '3.  DMF / RMP Doctors',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].dmfDoctors,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '3.  Nurses / Staffs',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].nurses,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '4.  SKF Attendees',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].skfAttendance,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '6.  Others',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].othersParticipants,
                  ),
                ],
              ),
            ),
            RowForCMEPreview(
              title: 'Total Budget',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].totalBudget,
              isBold: true,
            ),
            RowForCMEPreview(
              title: 'Cost Per doctor',
              value: approvedPrintDetails!
                  .resData.dataListPrint[index].costPerDoctor,
              isBold: true,
            ),
            const RowForCMEPreview(
              title: 'Budget Breakdown',
              value: '',
              isBold: true,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 237, 246, 246),
              ),
              child: Column(
                children: [
                  PreviewBreakdownRowWidget(
                    title: '1.  Hall rent',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].hallRent,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '2.  Food Expense',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].foodExpense,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '3.  Gift / Souvenir',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].giftsSouvenirs,
                  ),
                  PreviewBreakdownRowWidget(
                    title: '4.  Stationnaires and others',
                    value: approvedPrintDetails!
                        .resData.dataListPrint[index].stationnaires,
                  ),
                ],
              ),
            ),
            RowForCMEPreview(
              title: 'CME Amount',
              value:
                  approvedPrintDetails!.resData.dataListPrint[index].ecmeAmount,
              isBold: true,
            ),
            const RowForCMEPreview(
              title: 'Brand Details',
              value: '',
              isBold: false,
            ),
            BrandDetailsShowWidget(
              routeName: "Print",
              paddingTopValue: 5,
              paddingbottomValue: 5,
              containerHeight: 35,
              eCMeTYpe:
                  approvedPrintDetails!.resData.dataListPrint[index].ecmeType,
              eCMESubmitDataModel:
                  approvedPrintDetails!.resData.dataListPrint[index].brandList,
              eCMEAmount:
                  approvedPrintDetails!.resData.dataListPrint[index].ecmeAmount,
              splitedECMEamount: approvedPrintDetails!
                  .resData.dataListPrint[index].brandList.first.amount,
              totalAmount:
                  "${getTotalSalesQty(approvedPrintDetails!.resData.dataListPrint[index].brandList)}",
              rxOrSalesTile:
                  approvedPrintDetails!.resData.dataListPrint[index].ecmeType ==
                          "RMP Meeting"
                      ? "Sales Qty"
                      : "Rx Objective / Day",
            ),
            const SizedBox(
              height: 6,
            ),
            Center(
              child: Column(
                children: [
                  Row(
                    children: [
                      approvedPrintDetails!
                                  .resData.dataListPrint[index].isBillEdit ==
                              true
                          ? Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => BillEditScreen(
                                                  previousDataModel:
                                                      approvedPrintDetails!
                                                          .resData
                                                          .dataListPrint[index],
                                                  docInfo: approvedPrintDetails!
                                                      .resData
                                                      .dataListPrint[index]
                                                      .doctorList,
                                                  eCMEType:
                                                      approvedPrintDetails!
                                                          .resData
                                                          .dataListPrint[index]
                                                          .ecmeType,
                                                  wholeData:
                                                      approvedPrintDetails!,
                                                  calledBackAction: (value) {
                                                    getDsrDetailsData();
                                                  },
                                                )),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffD9873D),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Edit ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 241, 240, 240))),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      approvedPrintDetails!
                                  .resData.dataListPrint[index].isBillButton ==
                              true
                          ? Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (context.mounted) {
                                      if (context.mounted) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => PdfPage(
                                                    wholeData:
                                                        approvedPrintDetails!,
                                                    dataListPrint:
                                                        approvedPrintDetails!
                                                                .resData
                                                                .dataListPrint[
                                                            index],
                                                  )),
                                        );
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 7, 93, 34),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Print\nBilling ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Color.fromARGB(
                                                  255, 241, 240, 240))),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      approvedPrintDetails!.resData.dataListPrint[index]
                                  .isProposalButtonHide ==
                              true
                          ? Expanded(
                              flex: 1,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 2, right: 2),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (context.mounted) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                ProposalBillPdfScreen(
                                                  wholeData:
                                                      approvedPrintDetails!,
                                                  dataListPrint:
                                                      approvedPrintDetails!
                                                          .resData
                                                          .dataListPrint[index],
                                                )),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xff11009e)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text("Print\nProposal ",
                                          style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(
                                                  255, 241, 240, 240))),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ],
                  ),
                  (approvedPrintDetails!.resData.dataListPrint[index]
                                  .isProposalButtonHide ==
                              true ||
                          approvedPrintDetails!
                                  .resData.dataListPrint[index].isBillButton ==
                              true)
                      ? Row(
                          children: [
                            approvedPrintDetails!.resData.dataListPrint[index]
                                        .isProposalButtonHide ==
                                    true
                                ? Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 2),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (context.mounted) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      DoctorListPdfScreen(
                                                        wholeData:
                                                            approvedPrintDetails!,
                                                        dataListPrint:
                                                            approvedPrintDetails!
                                                                    .resData
                                                                    .dataListPrint[
                                                                index],
                                                      )),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xff1c658c)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            Text("Print\nDoctors",
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 241, 240, 240))),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            approvedPrintDetails!.resData.dataListPrint[index]
                                        .isBillButton ==
                                    true
                                ? Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 2, right: 2),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (context.mounted) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => BillfeedbackPrint(
                                                      wholeData:
                                                          approvedPrintDetails!,
                                                      dataListPrint:
                                                          approvedPrintDetails!
                                                                  .resData
                                                                  .dataListPrint[
                                                              index],
                                                      editedData: {})),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 87, 57, 92)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: const [
                                            FittedBox(
                                              child: Text("Print \nFeedback",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 13,
                                                      color: Color.fromARGB(
                                                          255, 241, 240, 240))),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        )
                      : const SizedBox()
                ],
              ),
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
