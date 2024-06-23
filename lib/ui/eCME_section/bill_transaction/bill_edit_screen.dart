import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING/ui/eCME_section/bill_transaction/approval_print_screen.dart';
import 'package:MREPORTING/ui/eCME_section/print/pdf/bill_feedback.dart';
import 'package:MREPORTING/ui/eCME_section/print/pdf/proposal_bill_pdf.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/add_title_row_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_row_widget.dart';
import 'package:MREPORTING/ui/eCME_section/widgets/custom_textformFiled_widget.dart';

class BillEditScreen extends StatefulWidget {
  final ApprovedPrintDataModel wholeData;
  final DataListPrint previousDataModel;
  final List<DoctorListPrint> docInfo;
  final String eCMEType;
  final Function calledBackAction;

  const BillEditScreen(
      {Key? key,
      required this.wholeData,
      required this.previousDataModel,
      required this.docInfo,
      required this.eCMEType,
      required this.calledBackAction})
      : super(key: key);

  @override
  State<BillEditScreen> createState() => _BillEditScreenState();
}

class _BillEditScreenState extends State<BillEditScreen> {
  final GlobalKey<FormState> _form1Key = GlobalKey();
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  bool isPreviewLoading = false;
  DateTime selectedExpiredDate = DateTime.now();
  String selectedExpiredDateString =
      DateFormat('yyyy-MM-dd').format(DateTime.now());
  TextEditingController meetingVenueController = TextEditingController();
  TextEditingController meetingTopicController = TextEditingController();
  TextEditingController brandSelectedController = TextEditingController();
  TextEditingController rxPerDayController = TextEditingController();
  TextEditingController eCMEAmountCOntroller = TextEditingController();
  TextEditingController salesQtyController = TextEditingController();
  TextEditingController meetingProbaleSpeakerNameController =
      TextEditingController();
  TextEditingController probaleSpeakerInstituteController =
      TextEditingController();
  TextEditingController totalNumberOfParticiController =
      TextEditingController();
  TextEditingController totalBudgetController = TextEditingController();
  TextEditingController hallRentController = TextEditingController();
  TextEditingController foodExpansesController = TextEditingController();
  TextEditingController costperDoctorController = TextEditingController();
  TextEditingController lunchDinnerController = TextEditingController();
  TextEditingController stationnairesController = TextEditingController();
  TextEditingController giftController = TextEditingController();
  TextEditingController othersController = TextEditingController();
  TextEditingController institutionController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController rxObjectiveperDayController = TextEditingController();
  TextEditingController internDoctorController = TextEditingController();
  TextEditingController dmfDoctorController = TextEditingController();
  TextEditingController nursesController = TextEditingController();
  TextEditingController doctorParticipantCount = TextEditingController();
  TextEditingController skfAttenaceController = TextEditingController();
  TextEditingController othersParticipantsController = TextEditingController();
  TextEditingController eCMEAmountForRMPController = TextEditingController();
  TextEditingController eCMESplitAmountController = TextEditingController();
  TextEditingController probaleSpeakerDesignationController =
      TextEditingController();
  TextEditingController probaleSpeakerDegreeController =
      TextEditingController();
  TextEditingController payToController = TextEditingController();

  TextEditingController hallrentPreController = TextEditingController();
  TextEditingController foodPreController = TextEditingController();
  TextEditingController giftPrevController = TextEditingController();
  TextEditingController stationariesPrevController = TextEditingController();
  TextEditingController eCMEPrevController = TextEditingController();
  TextEditingController doctorPrevController = TextEditingController();
  TextEditingController internPrevController = TextEditingController();
  TextEditingController skfAttenancePrevController = TextEditingController();
  TextEditingController othersPrevController = TextEditingController();
  TextEditingController nursesPrevController = TextEditingController();
  TextEditingController dmfdoctorPrevController = TextEditingController();

  TextEditingController categoryController = TextEditingController();
  TextEditingController payModeController = TextEditingController();
  TextEditingController departmentControllerNew = TextEditingController();

  ECMESavedDataModel? eCMESettingsData;
  List<String>? eBrandList = [];
  List<List<dynamic>> dynamicRowsListForBrand = [];
  List<List<dynamic>> finalBrandListAftrRemoveDuplication = [];
  Map<String, dynamic> proposalBill = {};
  String? initialBrand;
  List<String> docCategoryList = [];
  List<String> docDepartmentList = [];
  String? selcetDoctorCategory;
  String? selectedDepartment;
  List<String> payModeList = [];
  String? selectedPayMode;
  String brandString = '';
  String? cid;
  String? password;
  double latitude = 0.0;
  double longitude = 0.0;
  bool isLoading = false;
  double splitedAmount = 0.0;
  String areaId = "";

  final RegExp phoneRegex = RegExp(r'^\d{13}$');
  bool isMobileUpdate = false;
  List<String> eCMETypeList = [];
  double totalBudget = 0.0;
  int noIfparticipants = 0;
  double costPerDoctor = 0.0;

  bool isPrint = false;

  @override
  void initState() {
    super.initState();
    eCMEAmountCOntroller.addListener(() {
      setState(() {});
    });
    autoDatatoController();

    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    // eCMESettingsData = Boxes.geteCMEsetData().get("eCMESavedDataSync")!;
    // allSettingsDataGet(eCMESettingsData);
    SharedPreferences.getInstance().then((prefs) {
      password = prefs.getString("PASSWORD") ?? '';
      cid = prefs.getString("CID") ?? '';
      latitude = prefs.getDouble("latitude") ?? 0.0;
      longitude = prefs.getDouble("longitude") ?? 0.0;
    });
  }

  autoDatatoController() {
    meetingVenueController =
        TextEditingController(text: widget.previousDataModel.meetingVenue);
    meetingTopicController =
        TextEditingController(text: widget.previousDataModel.meetingTopic);
    meetingProbaleSpeakerNameController = TextEditingController(
        text: widget.previousDataModel.probableSpeakerName);
    probaleSpeakerInstituteController =
        TextEditingController(text: widget.previousDataModel.institutionName);
    totalNumberOfParticiController = TextEditingController(
        text: widget.previousDataModel.totalNumbersOfParticipants);
    totalBudgetController =
        TextEditingController(text: widget.previousDataModel.meetingVenue);

    hallrentPreController =
        TextEditingController(text: widget.previousDataModel.hallRent);
    foodPreController =
        TextEditingController(text: widget.previousDataModel.foodExpense);
    costperDoctorController =
        TextEditingController(text: widget.previousDataModel.costPerDoctor);
    stationariesPrevController =
        TextEditingController(text: widget.previousDataModel.stationnaires);
    giftPrevController =
        TextEditingController(text: widget.previousDataModel.giftsSouvenirs);
    dmfdoctorPrevController =
        TextEditingController(text: widget.previousDataModel.dmfDoctors);
    internPrevController =
        TextEditingController(text: widget.previousDataModel.internDoctors);
    nursesPrevController =
        TextEditingController(text: widget.previousDataModel.nurses);
    doctorPrevController =
        TextEditingController(text: widget.previousDataModel.doctorsCount);
    skfAttenancePrevController =
        TextEditingController(text: widget.previousDataModel.skfAttendance);
    othersPrevController = TextEditingController(
        text: widget.previousDataModel.othersParticipants);
    eCMEPrevController =
        TextEditingController(text: widget.previousDataModel.ecmeAmount);

    selectedDepartment = widget.previousDataModel.department;
    payToController =
        TextEditingController(text: widget.previousDataModel.payTo);
    selectedPayMode = widget.previousDataModel.payMode;
    selcetDoctorCategory = widget.previousDataModel.ecmeDoctorCategory;

    categoryController = TextEditingController(
        text: widget.previousDataModel.ecmeDoctorCategory);
    if (selcetDoctorCategory == "Institution") {
      departmentControllerNew =
          TextEditingController(text: widget.previousDataModel.department);
      institutionController =
          TextEditingController(text: widget.previousDataModel.institutionName);
    }
    payModeController =
        TextEditingController(text: widget.previousDataModel.payMode);

    //============================== auto data put ==================================
    hallRentController =
        TextEditingController(text: widget.previousDataModel.hallRent);
    foodExpansesController =
        TextEditingController(text: widget.previousDataModel.foodExpense);
    stationnairesController =
        TextEditingController(text: widget.previousDataModel.stationnaires);
    giftController =
        TextEditingController(text: widget.previousDataModel.giftsSouvenirs);
    dmfDoctorController =
        TextEditingController(text: widget.previousDataModel.dmfDoctors);
    internDoctorController =
        TextEditingController(text: widget.previousDataModel.internDoctors);
    nursesController =
        TextEditingController(text: widget.previousDataModel.nurses);
    doctorParticipantCount =
        TextEditingController(text: widget.previousDataModel.doctorsCount);
    skfAttenaceController =
        TextEditingController(text: widget.previousDataModel.skfAttendance);
    othersParticipantsController = TextEditingController(
        text: widget.previousDataModel.othersParticipants);
    eCMEAmountCOntroller =
        TextEditingController(text: widget.previousDataModel.ecmeAmount);
    totalParticipants();
    getTotalBudget();
  }

  //============================ total budget =========================
  double getTotalBudget() {
    double hall = double.tryParse(hallRentController.text) ?? 0.0;
    double food = double.tryParse(foodExpansesController.text) ?? 0.0;
    double gift = double.tryParse(giftController.text) ?? 0.0;
    double others = double.tryParse(stationnairesController.text) ?? 0.0;
    totalBudget = hall + food + gift + others;
    totalBudgetController.text = totalBudget.toStringAsFixed(2);
    totalBudget = hall + food + gift + others;
    eCMEAmountCOntroller.text = totalBudget.toString();
    getCostPerDoctor();
    return totalBudget;
  }

//============================ total Numbers of participants =========================
  int totalParticipants() {
    noIfparticipants = (int.tryParse(doctorParticipantCount.text) ?? 0) +
        (int.tryParse(internDoctorController.text) ?? 0) +
        (int.tryParse(dmfDoctorController.text) ?? 0) +
        (int.tryParse(skfAttenaceController.text) ?? 0) +
        (int.tryParse(nursesController.text) ?? 0) +
        (int.tryParse(othersParticipantsController.text) ?? 0);
    costPerDoctor = getCostPerDoctor();
    setState(() {});
    return noIfparticipants;
  }

  //============================== Cost per doctor ======================================
  double getCostPerDoctor() {
    if (totalBudget > 0.0) {
      double costPerDoctor = totalBudget / noIfparticipants;
      return costPerDoctor;
    } else {
      return 0.0;
    }
  }

  double getECMEAmontSplit() {
    splitedAmount = 0;
    int listNum = widget.previousDataModel.brandList.length;
    double? eCMEAmount = double.tryParse(eCMEAmountCOntroller.text) ?? 0.0;
    splitedAmount = (eCMEAmount / listNum);
    return splitedAmount;
  }

  @override
  void dispose() {
    payToController.dispose();
    rxPerDayController.dispose();
    eCMEAmountCOntroller.dispose();
    brandSelectedController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double wholeHeight = MediaQuery.of(context).size.height;
    double wholeWidth = MediaQuery.of(context).size.width;
    TextEditingController meetingDateController = TextEditingController(
        text: widget.previousDataModel.meetingDate.toString());

    return WillPopScope(
      onWillPop: () async {
        widget.calledBackAction("data");
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xff8AC995),
          title: const Text(
            "Bill Edit  ",
          ),
        ),
        body: SingleChildScrollView(
          reverse: false,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _form1Key,
              child: Column(
                children: [
                  SizedBox(
                    height: wholeHeight / 95.927,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 6),
                      child: AddTitleRowWidget(
                          context: context,
                          title: "SL : ${widget.previousDataModel.sl}"),
                    ),
                  ),
                  const SizedBox(height: 10),
                  (widget.eCMEType == "Intern Reception") ||
                          (widget.eCMEType == "Society")
                      ? const SizedBox()
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: AddTitleRowWidget(
                                context: context, title: "Selected Doctors*"),
                          ),
                        ),
                  (widget.eCMEType == "Intern Reception") ||
                          (widget.eCMEType == "Society")
                      ? const SizedBox()
                      : Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: SizedBox(
                                  height: widget.docInfo.length * 19.5,
                                  width: 150,
                                  child: ListView.builder(
                                      primary: false,
                                      itemCount: widget.docInfo.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Text(
                                            "${index + 1}. ${widget.docInfo[index].doctorName}|${widget.docInfo[index].doctorId}",
                                            style:
                                                const TextStyle(fontSize: 13),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                            ),
                          ],
                        ),
                  SizedBox(
                      height: (widget.eCMEType == "Intern Reception") ||
                              (widget.eCMEType == "Society")
                          ? 10
                          : 0),
                  SizedBox(
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                //=============================== Meeting Date ====================================
                                AddTitleRowWidget(
                                    context: context, title: "Meeting Date*"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                    readonly: true, // for edit screen
                                    controller: meetingDateController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    suffixIcon: const Icon(
                                      Icons.calendar_month_outlined,
                                      color: Color.fromARGB(255, 82, 179, 98),
                                    ),
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 41, 90, 50),
                                    ),
                                    onChanged: null,
                                    focusNode: AlwaysDisabledFocusNode(),
                                    hinText: "",
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //=============================== Doctor Category ====================================
                                AddTitleRowWidget(
                                    context: context,
                                    title: "Doctor Category*"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                    readonly: true, // for edit screen
                                    controller: categoryController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    // suffixIcon: const Icon(Icons.calendar_month_outlined,color: Color.fromARGB(255, 82, 179, 98),),
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 41, 90, 50),
                                    ),
                                    onChanged: null,
                                    focusNode: AlwaysDisabledFocusNode(),
                                    hinText: "",
                                  ),
                                ),

                                //================================== Institution ===========================
                                selcetDoctorCategory == "Institution"
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          AddTitleRowWidget(
                                              context: context,
                                              title: "Institution Name*"),
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            height: 45,
                                            child: CustomtextFormFiledWidget(
                                              readonly: true,
                                              hinText:
                                                  '----Enter Institution Name----',
                                              controller: institutionController,
                                              textAlign: TextAlign.left,
                                              keyboardType: TextInputType.text,
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              focusNode:
                                                  AlwaysDisabledFocusNode(),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          //================================== Department ===========================
                                          AddTitleRowWidget(
                                              context: context,
                                              title: "Department*"),
                                          //++++++++++++++++++++++++++++++++++++++++++++
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            height: 45,
                                            child: CustomtextFormFiledWidget(
                                              readonly: true,
                                              hinText:
                                                  '  ----Select Department Name---- ',
                                              controller:
                                                  departmentControllerNew,
                                              textAlign: TextAlign.left,
                                              keyboardType: TextInputType.text,
                                              textStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.black,
                                              ),
                                              focusNode:
                                                  AlwaysDisabledFocusNode(),
                                            ),
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 10,
                                ),
                                //================================== Meeting Venue ===========================
                                AddTitleRowWidget(
                                    context: context, title: "Meeting venue*"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                    readonly: true, // for edit screen
                                    hinText: '----Enter Meeting Venue----',
                                    controller: meetingVenueController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                //================================== Meeting Topic ===========================
                                AddTitleRowWidget(
                                    context: context, title: "Meeting Topic*"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                    readonly: true, // for edit screen
                                    hinText: '----Enter Meeting Topic----',
                                    controller: meetingTopicController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                ),
                                SizedBox(
                                  height: wholeHeight / 75.927,
                                ),
                                //================================== Probable Speaker Name & Designation ===========================
                                AddTitleRowWidget(
                                    context: context,
                                    title:
                                        "Probable Speaker Name & Designation*"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                    readonly: true, // for edit screen
                                    hinText: '----Enter Speaker Name----',
                                    controller:
                                        meetingProbaleSpeakerNameController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //================================== Participats Section ===========================
                                titleRowWidget(
                                    context,
                                    "Total numbers of participants",
                                    widget.previousDataModel
                                        .totalNumbersOfParticipants
                                        .toString(),
                                    totalParticipants().toString()),
                                titleBarWidget(context),
                                Column(
                                  children: [
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit:
                                          doctorPrevController,
                                      isBillEdit: true, // for edit screen
                                      rowNumber: "1.",
                                      reason: "Doctors (MBBS & Above)*",
                                      controller: doctorParticipantCount,
                                      onChanged: (value) {
                                        totalParticipants();
                                        setState(() {});
                                      },
                                      validator: null,
                                      routingName: 'participants',
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      isBillEdit: true, // for edit screen
                                      controllerForBillEdit:
                                          internPrevController,
                                      routingName: 'participants',
                                      rowNumber: "2.",
                                      reason: "Intern Doctors*",
                                      controller: internDoctorController,
                                      onChanged: (value) {
                                        totalParticipants();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit:
                                          dmfdoctorPrevController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'participants',
                                      rowNumber: "3.",
                                      reason: "DMF / RMP Doctors* ",
                                      controller: dmfDoctorController,
                                      onChanged: (value) {
                                        totalParticipants();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit:
                                          nursesPrevController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'participants',
                                      rowNumber: "4.",
                                      reason: "Nurses / Staffs* ",
                                      controller: nursesController,
                                      onChanged: (value) {
                                        totalParticipants();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit:
                                          skfAttenancePrevController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'participants',
                                      rowNumber: "5.",
                                      reason: "SKF Attendees*",
                                      controller: skfAttenaceController,
                                      onChanged: (value) {
                                        totalParticipants();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit:
                                          othersPrevController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'participants',
                                      rowNumber: "6.",
                                      reason: "Others",
                                      controller: othersParticipantsController,
                                      onChanged: (value) {
                                        totalParticipants();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                //================================== Budget Section ===========================
                                titleRowWidget(
                                    context,
                                    "Total budget*",
                                    "৳${widget.previousDataModel.totalBudget}",
                                    "৳${totalBudget.toStringAsFixed(2)}"),
                                titleRowWidget(
                                    context,
                                    "Cost per doctor",
                                    "৳${widget.previousDataModel.costPerDoctor}",
                                    "৳${costPerDoctor.toStringAsFixed(2)}"),
                                AddTitleRowWidget(
                                    context: context,
                                    title: "Budget breakdown*"),
                                titleBarWidget(context),
                                Column(
                                  children: [
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit:
                                          hallrentPreController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'budget',
                                      rowNumber: "1.",
                                      reason: "Hall rent*",
                                      controller: hallRentController,
                                      onChanged: (value) {
                                        getTotalBudget();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit: foodPreController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'budget',
                                      rowNumber: "2.",
                                      reason: "Food Expense*",
                                      controller: foodExpansesController,
                                      onChanged: (value) {
                                        getTotalBudget();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit: giftPrevController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'budget',
                                      rowNumber: "3.",
                                      reason: "Gift / Souvenir*",
                                      controller: giftController,
                                      onChanged: (value) {
                                        getTotalBudget();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                    BudgetBreakDownRowWidget(
                                      isprint: isPrint,
                                      controllerForBillEdit:
                                          stationariesPrevController,
                                      isBillEdit: true, // for edit screen
                                      routingName: 'budget',
                                      rowNumber: "4.",
                                      reason:
                                          "Stationaires and Others (Pen, Photocopies etc)*",
                                      controller: stationnairesController,
                                      onChanged: (value) {
                                        getTotalBudget();
                                        setState(() {});
                                      },
                                      validator: null,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                //=================================== eCME Amount================================
                                widget.eCMEType != null
                                    ? AddTitleRowWidget(
                                        context: context, title: "CME Amount *")
                                    : const SizedBox(),
                                widget.eCMEType != null
                                    ? SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.1,
                                        child: Row(
                                          children: [
                                            const Text(
                                              "Prev :  ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  3,
                                              height: 45,
                                              child: CustomtextFormFiledWidget(
                                                hinText:
                                                    "----Enter CME Amount ----",
                                                // if you change it,you have to change it in inputformatter+readOnly too.
                                                controller: eCMEPrevController,
                                                textAlign: TextAlign.left,
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 71, 60, 60),
                                                ),
                                                focusNode:
                                                    AlwaysDisabledFocusNode(),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            ),
                                            const Text(
                                              "  Edit :  ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromARGB(
                                                      255, 241, 184, 13)),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.8,
                                              height: 45,
                                              child: CustomtextFormFiledWidget(
                                                hinText:
                                                    "----Enter CME Amount ----",
                                                // if you change it,you have to change it in inputformatter+readOnly too.
                                                controller:
                                                    eCMEAmountCOntroller,
                                                textAlign: TextAlign.left,
                                                textStyle: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 71, 60, 60),
                                                ),
                                                focusNode:
                                                    AlwaysDisabledFocusNode(),
                                                keyboardType:
                                                    TextInputType.number,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),

                                SizedBox(
                                  height: widget.eCMEType != null ? 10 : 0,
                                ),
                                //====================================== Brand section ===================================
                                (widget.eCMEType != null)
                                    ? Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AddTitleRowWidget(
                                            context: context,
                                            title: "Brand*",
                                          ),
                                          SizedBox(
                                            width: wholeWidth / 1.45,
                                          ),
                                        ],
                                      )
                                    : const SizedBox(),
                                const SizedBox(
                                  height: 10,
                                ),
                                brandDetailsWidget(wholeWidth, wholeHeight),
                                const SizedBox(
                                  height: 10,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),

                                //================================= Pay Mode ==================================
                                AddTitleRowWidget(
                                    context: context, title: "Pay Mode *"),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                    readonly: true, // for edit screen
                                    hinText: '  Select Pay Mode',
                                    controller: payModeController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                ),

                                SizedBox(
                                  height: wholeHeight / 75.927,
                                ),
                                //============================== Pay to ===================================
                                AddTitleRowWidget(
                                  context: context,
                                  title: "Pay to*",
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 1.1,
                                  height: 45,
                                  child: CustomtextFormFiledWidget(
                                    readonly: true, // for edit screen
                                    hinText: '----Enter pay receiver name----',
                                    controller: payToController,
                                    textAlign: TextAlign.left,
                                    keyboardType: TextInputType.text,
                                    textStyle: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    focusNode: AlwaysDisabledFocusNode(),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  isLoading == false
                      ? buttonRowWidget(context)
                      : const CircularProgressIndicator()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding titleBarWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, left: 10, right: 10),
      child: SizedBox(
        height: 20,
        child: Row(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 11,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.7,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 11,
              child: const Text(""),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.1,
              child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Prev",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  )),
            ),
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Edit",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 241, 184, 13)),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Padding titleRowWidget(
      BuildContext context, String title, String prevValue, String editValue) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            child: Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 11,
            child: const Text(":"),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    prevValue,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ))),
          SizedBox(
              width: MediaQuery.of(context).size.width / 4,
              child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    editValue,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ))),
        ],
      ),
    );
  }

  Column brandDetailsWidget(double wholeWidth, double wholeHeight) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 98, 158, 219),
          ),
          width: wholeWidth / 1.073,
          child: Row(
            children: [
              SizedBox(
                width: wholeWidth / 5,
                height: 40,
                child: const Center(
                  child: Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                child: SizedBox(
                  width: wholeWidth / 4,
                  height: wholeHeight / 25.309,
                  child: const Center(
                    child: Text(
                      "CME (Prev)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                child: SizedBox(
                  width: wholeWidth / 4,
                  height: wholeHeight / 25.309,
                  child: const Center(
                    child: Text(
                      "CME (Edit)",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 5,
                ),
                child: SizedBox(
                  width: wholeWidth / 7,
                  height: wholeHeight / 25.309,
                  child: Center(
                    child: Text(
                      widget.eCMEType == "RMP Meeting"
                          ? "Sales Qty"
                          : "Rx Objective / Day",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: widget.previousDataModel.brandList.length * 30,
          width: wholeWidth / 1.073,
          child: ListView.builder(
              itemCount: widget.previousDataModel.brandList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: index % 2 != 0
                          ? Colors.grey[300]
                          : Colors.transparent,
                    ),
                    height: 30,
                    child: Row(
                      children: [
                        SizedBox(
                          width: wholeWidth / 5,
                          height: wholeHeight / 25.309,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 2),
                            child: Center(
                              child: Text(
                                widget.previousDataModel.brandList[index]
                                    .brandName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: SizedBox(
                            width: wholeWidth / 4,
                            height: wholeHeight / 25.309,
                            child: Center(
                              child: Text(
                                widget
                                    .previousDataModel.brandList[index].amount,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: SizedBox(
                            width: wholeWidth / 4,
                            height: wholeHeight / 25.309,
                            child: Center(
                              child: Text(
                                getECMEAmontSplit().toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                          ),
                          child: SizedBox(
                            width: wholeWidth / 7,
                            height: wholeHeight / 25.309,
                            child: Center(
                              child: Text(
                                widget.previousDataModel.brandList[index].qty,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }

  //============================================================== Buttons widget =======================================
  SizedBox buttonRowWidget(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: const Border(
                        top: BorderSide(
                          color: Color.fromARGB(255, 44, 114, 66),
                          width: 2,
                        ),
                        bottom: BorderSide(
                          color: Color.fromARGB(255, 44, 114, 66),
                          width: 2,
                        ),
                        left: BorderSide(
                          color: Color.fromARGB(255, 44, 114, 66),
                          width: 2,
                        ),
                        right: BorderSide(
                          color: Color.fromARGB(255, 44, 114, 66),
                          width: 2,
                        ),
                      )),
                  child: const Center(
                      child: Text("Cancel",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 44, 114, 66),
                          ))),
                ),
                onTap: () {
                  if (isPreviewLoading = false) {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: InkWell(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 44, 114, 66),
                    ),
                    child: isPreviewLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Center(
                            child: Text("Update",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))),
                  ),
                  onTap: () async {
                    if (doctorParticipantCount.text == "") {
                      AllServices().toastMessage(
                          "Please add participating doctor ",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (internDoctorController.text.isEmpty) {
                      AllServices().toastMessage(
                          "Please add number of intern doctor",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (dmfDoctorController.text.isEmpty) {
                      AllServices().toastMessage(
                          "Please add number of DMF / RMP doctor",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (nursesController.text.isEmpty) {
                      AllServices().toastMessage(
                          "Please add number of Nurses / Staffs ",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (skfAttenaceController.text.isEmpty) {
                      AllServices().toastMessage(
                          "Please add number of SKF Attendees ",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (hallRentController.text == "") {
                      AllServices().toastMessage(
                          "Please add hall rent amount  ",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (foodExpansesController.text == "") {
                      AllServices().toastMessage(
                          "Please add food expense amount  ",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (giftController.text == "") {
                      AllServices().toastMessage(
                          "Please add speaker Gift or Souvenir expense  ",
                          Colors.red,
                          Colors.white,
                          16);
                    } else if (stationnairesController.text == "") {
                      AllServices().toastMessage(
                          "Please add  Stationaries and others  ",
                          Colors.red,
                          Colors.white,
                          16);
                    } else {
                      setState(() {
                        isPreviewLoading = true;
                      });
                      eCMEBillUpdate();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  //============================================================== Buttons widget =======================================
  SizedBox printButton(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: InkWell(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 44, 114, 66),
                    ),
                    child: isPreviewLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Center(
                            child: Text("Feedback Letter Print/PDF",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))),
                  ),
                  onTap: () {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => BillfeedbackPrint(
                                wholeData: widget.wholeData,
                                dataListPrint: widget.previousDataModel,
                                editedData: proposalBill)),
                      );
                    }
                  }),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: InkWell(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 44, 114, 66),
                    ),
                    child: isPreviewLoading == true
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Center(
                            child: Text("Proposal Bill PDF/Print",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ))),
                  ),
                  onTap: () {
                    if (context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProposalBillPdfScreen(
                                  wholeData: widget.wholeData,
                                  dataListPrint: widget.previousDataModel,
                                )),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  initialValue(String val) {
    return TextEditingController(text: val);
  }

  eCMEBillUpdate() async {
    // String updateUrlString ="http://10.168.27.183:8000/skf_api/api_ecme_update/data_update?cid=${cid}&userId=${userId}&password=${password}&sl=${widget.previousDataModel.sl.toString()}&hallRent=${hallRentController.text.toString()}&foodExpense=${foodExpansesController.text.toString()}&giftsSouvenirs=${giftController.text.toString()}&stationnaires=${stationnairesController.text.toString()}&doctorsCount=${doctorParticipantCount.text.toString()}&internDoctors=${internDoctorController.text.toString()}&dmfDoctors=${dmfDoctorController.text.toString()}&nurses=${nursesController.text.toString()}&skfAttendance=${skfAttenaceController.text.toString()}&othersParticipants=${othersParticipantsController.text.toString()}&totalBudget=${totalBudget.toStringAsFixed(2)}&brand_split_amount=${splitedAmount.toStringAsFixed(2)}&total_numbers_of_participants=${noIfparticipants}&cost_per_doctor=${costPerDoctor.toStringAsFixed(2)}";
    String updateUrlString =
        "${dmpathData!.submitUrl}api_ecme_update/data_update?cid=$cid&userId=$userId&password=$password&sl=${widget.previousDataModel.sl.toString()}&hallRent=${hallRentController.text.toString()}&foodExpense=${foodExpansesController.text.toString()}&giftsSouvenirs=${giftController.text.toString()}&stationnaires=${stationnairesController.text.toString()}&doctorsCount=${doctorParticipantCount.text.toString()}&internDoctors=${internDoctorController.text.toString()}&dmfDoctors=${dmfDoctorController.text.toString()}&nurses=${nursesController.text.toString()}&skfAttendance=${skfAttenaceController.text.toString()}&othersParticipants=${othersParticipantsController.text.toString()}&totalBudget=${totalBudget.toStringAsFixed(2)}&brand_split_amount=${splitedAmount.toStringAsFixed(2)}&total_numbers_of_participants=$noIfparticipants&cost_per_doctor=${costPerDoctor.toStringAsFixed(2)}";
    Map<String, dynamic> data =
        await ECMERepositry().eCMEBillUpdate(updateUrlString);
    if (data["status"] == "Success") {
      setState(() {
        isPreviewLoading = false;
        isPrint = true;
      });
      if (context.mounted) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ApprovedPrintScreen(
                      cid: cid!,
                      userPass: userPassword,
                    )));
      }

      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.green, Colors.white, 16);
    } else {
      setState(() {
        isPreviewLoading = false;
        isPrint = false;
      });
      AllServices()
          .toastMessage("${data["ret_str"]}", Colors.red, Colors.white, 16);
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
