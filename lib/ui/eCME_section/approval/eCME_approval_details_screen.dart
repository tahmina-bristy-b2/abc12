import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/e_CME/e_CME_approval_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING_OFFLINE/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shimmer/shimmer.dart';

class EcmeApprovalScreen extends StatefulWidget {
  const EcmeApprovalScreen(
      {super.key,
      required this.cid,
      required this.userPass,
      required this.submittedBy,
      required this.areaId,
      required this.levelDepth,
      required this.calledBackAction});
  final String cid;
  final String userPass;
  final String submittedBy;
  final String areaId;
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
  ECMESavedDataModel? ecmeSavedDataModel;

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

  double getTotalSalesQty(List<EcmeBrandListDataModel> brandList) {
    double totalQty = 0.0;
    for (var element in brandList) {
      totalQty += double.parse(element.salesQty);
    }
    return totalQty;
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

  void approvedOrRejectedECME(
      String sl, String approvedEdsrParams, int index) async {
    bool result = await InternetConnectionChecker().hasConnection;

    if (result) {
      Map<String, dynamic> approvedResponse =
          await ECMERepositry().approvedOrRejectedECME(
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

  getDouble(String eCMEAmount) {
    return double.parse(eCMEAmount).toStringAsFixed(2);
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
          title: const Text('Approval CME'),
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
            ((dsrDetails!.resData.dataList[index].ecmeType ==
                        "Intern Reception") ||
                    (dsrDetails!.resData.dataList[index].ecmeType == "Society"))
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
            ((dsrDetails!.resData.dataList[index].ecmeType ==
                        "Intern Reception") ||
                    (dsrDetails!.resData.dataList[index].ecmeType == "Society"))
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 5),
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SizedBox(
                              height: dsrDetails!.resData.dataList[index]
                                      .doctorList.length *
                                  19.5,
                              width: 150,
                              child: ListView.builder(
                                  //physics: const NeverScrollableScrollPhysics(),
                                  primary: false,
                                  itemCount: dsrDetails!.resData.dataList[index]
                                      .doctorList.length,
                                  itemBuilder: (context, index2) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        "${index2 + 1}. ${dsrDetails!.resData.dataList[index].doctorList[index2].doctorName}|${dsrDetails!.resData.dataList[index].doctorList[index2].doctorId}",
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
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'SL No',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(dsrDetails!.resData.dataList[index].sl == null
                        ? ""
                        : '  ${dsrDetails!.resData.dataList[index].sl}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'CME Type',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(dsrDetails!.resData.dataList[index].ecmeType ==
                            null
                        ? ""
                        : '  ${dsrDetails!.resData.dataList[index].ecmeType}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Meeting Date',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(dsrDetails!
                                .resData.dataList[index].meetingDate ==
                            null
                        ? ""
                        : '  ${dsrDetails!.resData.dataList[index].meetingDate}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Doctor Category',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].ecmeDoctorCategory}'),
                  ),
                ],
              ),
            ),
            dsrDetails!.resData.dataList[index].ecmeDoctorCategory ==
                    "Institution"
                ? Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 5,
                            child: Text(
                              'Institute Name',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                        const Text(
                          ':',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                              '  ${dsrDetails!.resData.dataList[index].institutionName}'),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            dsrDetails!.resData.dataList[index].ecmeDoctorCategory ==
                    "Institution"
                ? Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 5,
                            child: Text(
                              'Department',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            )),
                        const Text(
                          ':',
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                              '  ${dsrDetails!.resData.dataList[index].department}'),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Meeting Venue',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(dsrDetails!
                                .resData.dataList[index].meetingVenue ==
                            null
                        ? ""
                        : '  ${dsrDetails!.resData.dataList[index].meetingVenue}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Meeting Topic',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(':'),
                  Expanded(
                    flex: 5,
                    child: Text(
                      " ${dsrDetails!.resData.dataList[index].meetingTopic}",
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
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Probable Speaker Name & Designation',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].probableSpeakerName}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Pay Mode',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                        '  ${dsrDetails!.resData.dataList[index].payMode}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Pay To',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child:
                        Text('  ${dsrDetails!.resData.dataList[index].payTo}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Status',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      dsrDetails!.resData.dataList[index].step == null
                          ? ""
                          : '   ${dsrDetails!.resData.dataList[index].step}',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
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
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Last Action',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                      dsrDetails!.resData.dataList[index].lastAction == null
                          ? ""
                          : '   ${dsrDetails!.resData.dataList[index].lastAction}',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Total Numbers of participants',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(':',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Expanded(
                    flex: 5,
                    child: Text(
                      dsrDetails!.resData.dataList[index]
                                  .totalNumbersOfParticipants ==
                              null
                          ? ""
                          : '   ${dsrDetails!.resData.dataList[index].totalNumbersOfParticipants}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 1, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '1.  Doctors (MBBS & Above)',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                dsrDetails!
                                    .resData.dataList[index].doctorsCount,
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '2.  Intern Doctors',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!.resData.dataList[index].internDoctors,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '3.  DMF / RMP Doctors',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!.resData.dataList[index].dmfDoctors,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '3.  Nurses',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!.resData.dataList[index].nurses,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '4.  SKF Attendees',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!.resData.dataList[index].skfAttendance,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '6.  Others',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!
                                  .resData.dataList[index].othersParticipants,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
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
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Total Budget',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(':',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Expanded(
                    flex: 5,
                    child: Text(
                      dsrDetails!.resData.dataList[index].totalBudget == null
                          ? ""
                          : '   ৳${dsrDetails!.resData.dataList[index].totalBudget}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'Cost Per doctor',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(':',
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  Expanded(
                    flex: 5,
                    child: Text(
                      '   ৳${dsrDetails!.resData.dataList[index].costPerDoctor}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                      flex: 5,
                      child: Text(
                        'Budget Breakdown',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  Text(':', style: TextStyle(fontWeight: FontWeight.w500)),
                  Expanded(
                    flex: 5,
                    child: Text(
                      '',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(255, 237, 246, 246),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '1.  Hall rent',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                                dsrDetails!.resData.dataList[index].hallRent ==
                                        ""
                                    ? "৳00"
                                    : ' ৳${dsrDetails!.resData.dataList[index].hallRent}',
                                style: const TextStyle(fontSize: 12)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '2.  Food Expense',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!.resData.dataList[index].foodExpense ==
                                      ""
                                  ? "৳00"
                                  : ' ৳${dsrDetails!.resData.dataList[index].foodExpense}',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '3.   Gift / Souvenir',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(':',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!.resData.dataList[index]
                                          .giftsSouvenirs ==
                                      ""
                                  ? "৳00"
                                  : ' ৳${dsrDetails!.resData.dataList[index].giftsSouvenirs}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8, bottom: 5, left: 15, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 10,
                            child: Text(
                              '4.  Stationaires and others',
                              style: TextStyle(fontSize: 12),
                            )),
                        const Text(' :',
                            style: TextStyle(fontWeight: FontWeight.w500)),
                        Expanded(
                          flex: 10,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              dsrDetails!.resData.dataList[index]
                                          .stationnaires ==
                                      ""
                                  ? "৳00"
                                  : ' ৳${dsrDetails!.resData.dataList[index].stationnaires}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ],
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
                  const Expanded(
                      flex: 5,
                      child: Text(
                        'CME Amount',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  const Text(
                    ':',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Expanded(
                    flex: 5,
                    child: Text(
                        ' ${getDouble(dsrDetails!.resData.dataList[index].ecmeAmount)}'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                      flex: 5,
                      child: Text(
                        'Brand Details',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  Text(
                    '',
                  ),
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
                                    const Expanded(
                                      flex: 2,
                                      child: Text(
                                        'Name',
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 253, 253, 253),
                                            fontSize: 12),
                                      ),
                                    ),
                                    const Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            "CME Amount",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 253, 253, 253),
                                                fontSize: 12),
                                          ),
                                        )),
                                    Expanded(
                                        flex: 3,
                                        child: Center(
                                          child: Text(
                                            dsrDetails!.resData.dataList[index]
                                                        .ecmeType ==
                                                    "RMP Meeting"
                                                ? "Sales Qty"
                                                : "Rx Objective / Day",
                                            style: const TextStyle(
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
                                height: dsrDetails!.resData.dataList[index]
                                        .brandList.length *
                                    25.0,
                                child: ListView.builder(
                                    itemCount: dsrDetails!.resData
                                        .dataList[index].brandList.length,
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
                                              child: Text(
                                                dsrDetails!
                                                    .resData
                                                    .dataList[index]
                                                    .brandList[index2]
                                                    .brandName,
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: Text(
                                                    dsrDetails!
                                                        .resData
                                                        .dataList[index]
                                                        .brandList[index2]
                                                        .amount,
                                                    style: const TextStyle(
                                                        fontSize: 12),
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: Text(
                                                    dsrDetails!
                                                        .resData
                                                        .dataList[index]
                                                        .brandList[index2]
                                                        .salesQty,
                                                    style: const TextStyle(
                                                        fontSize: 12),
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
                                            fontSize: 13,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Text(
                                          dsrDetails!.resData.dataList[index]
                                              .ecmeAmount,
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
                                          "${getTotalSalesQty(dsrDetails!.resData.dataList[index].brandList)}",
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

                                approvedOrRejectedECME(
                                    dsrDetails!.resData.dataList[index].sl,
                                    "Rejected",
                                    index);
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

                                approvedOrRejectedECME(
                                    dsrDetails!.resData.dataList[index].sl,
                                    "Approved",
                                    index);
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
                            'Submitted' &&
                        dsrDetails!.resData.dataList[index].step == 'FM' &&
                        widget.levelDepth == '1')
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
                                    approvedOrRejectedECME(
                                        dsrDetails!.resData.dataList[index].sl,
                                        "Rejected",
                                        index);
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

                                    approvedOrRejectedECME(
                                        dsrDetails!.resData.dataList[index].sl,
                                        "Approved",
                                        index);
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
                              '-----------------------------------------',
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
          widget.areaId,
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
