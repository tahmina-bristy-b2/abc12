import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_employee_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:MREPORTING/services/appraisal/services.dart';
import 'package:MREPORTING/ui/Appraisal/appraisal_approval_details.dart';
import 'package:MREPORTING/ui/Appraisal/appraisal_screen.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ApprovalAppraisal extends StatefulWidget {
  const ApprovalAppraisal(
      {super.key,
      required this.pageState,
      required this.cid,
      required this.userPass});
  final String pageState;
  final String cid;
  final String userPass;

  @override
  State<ApprovalAppraisal> createState() => _ApprovalAppraisalState();
}

class _ApprovalAppraisalState extends State<ApprovalAppraisal> {
  final TextEditingController _searchController = TextEditingController();
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  AppraisalEmployee? appraisalEmployee;
  List<FfList> employeeList = [];
  bool isLoading = true;
  bool _searchExpand = false;
  bool _color = false;
  double height = 0.0;
  String title = "Employee";
  @override
  initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    internetCheckForEmployeeDetails();
  }

  //====================================== Internet check for Employee List Api ============================================
  internetCheckForEmployeeDetails() async {
    bool hasInternet = await InternetConnectionChecker().hasConnection;
    if (hasInternet == true) {
      getAppraisalEmployee();
    } else {
      AllServices()
          .toastMessage(interNetErrorMsg, Colors.red, Colors.white, 16);
    }
  }

  //========================================= Employee List Api Call====================================================
  getAppraisalEmployee() async {
    appraisalEmployee = await AppraisalRepository().getEployeeListOfData(
        dmpathData!.syncUrl, widget.cid, userInfo!.userId, widget.userPass);

    if (appraisalEmployee != null) {
      if (!mounted) return;
      title = appraisalEmployee!.resData.supLevelDepthNo == '1'
          ? 'FM List'
          : appraisalEmployee!.resData.supLevelDepthNo == '0'
              ? 'RSM List'
              : appraisalEmployee!.resData.supLevelDepthNo == '2'
                  ? 'MSO List'
                  : 'Employee List';
      employeeList = appraisalEmployee!.resData.ffList;
      setState(() {
        isLoading = false;
      });
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          appraisalEmployee != null
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      _searchExpand = !_searchExpand;
                      _color = true;
                      if (height == 0.0) {
                        height = 40.0;
                      } else {
                        height = 0.0;
                      }
                    });

                    if (_searchExpand == false) {
                      _searchController.clear();
                      employeeList = appraisalEmployee!.resData.ffList;
                      setState(() {});
                    }
                  },
                  icon: const Icon(Icons.search_outlined))
              : Container()
        ],
      ),
      body: SafeArea(
          child: Column(
        children: [
          AnimatedContainer(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: _color
                        ? const Color.fromARGB(255, 138, 201, 149)
                        : Colors.black)),
            height: height,
            child: _searchExpand
                ? TextFormField(
                    autofocus: false,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.done,
                    controller: _searchController,
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.only(bottom: 0, left: 10, top: 5),
                      hintText: 'Search Employeee here.....',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.search,
                          color: Color.fromARGB(255, 138, 201, 149)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        employeeList = AppraisalServices().searchEmployee(
                            value, appraisalEmployee!.resData.ffList);
                        print("searc Data==$employeeList");
                      });
                    },
                  )
                : Container(),
          ),
          isLoading
              ? Expanded(child: dataLoadingView())
              : appraisalEmployee == null ||
                      appraisalEmployee!.resData.ffList.isEmpty
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
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Go back',
                                style: TextStyle(color: Colors.black54),
                              )),
                        )
                      ]),
                    )
                  : appraisalEmployeeView(context),
        ],
      )),
    );
  }

  Expanded appraisalEmployeeView(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: employeeList.length,
          itemBuilder: (itemBuilder, index) {
            return Card(
              child: ListTile(
                  leading: Container(
                    decoration: const ShapeDecoration(
                      shape: CircleBorder(),
                      color: Color.fromARGB(255, 138, 201, 149),
                    ),
                    height: 50,
                    width: 50,
                    child: Center(
                        child:
                            Text(employeeList[index].empName.substring(0, 2))),
                  ),
                  title: Text(employeeList[index].empName),
                  subtitle:
                      Text('Employee id: ${employeeList[index].employeeId}'),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ApprisalScreen(
                                      cid: widget.cid,
                                      levelDepth: appraisalEmployee!
                                          .resData.supLevelDepthNo,
                                      userId: userInfo!.userId,
                                      userPass: widget.userPass,
                                      employeeId:
                                          employeeList[index].employeeId,
                                    )));
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color.fromARGB(255, 138, 201, 149),
                      ))),
            );
          }),
    );
  }

  Padding dataLoadingView() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: 15,
          itemBuilder: (itemBuilder, index) {
            return Card(
              child: ListTile(
                leading: Container(
                  decoration: ShapeDecoration(
                    shape: const CircleBorder(),
                    color: Colors.grey[300],
                  ),
                  height: 50,
                  width: 50,
                ),
                title: Container(
                  margin: const EdgeInsets.only(right: 50),
                  height: 15,
                  constraints: const BoxConstraints(maxHeight: double.infinity),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey[300],
                  ),
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(right: 150),
                  height: 12,
                  constraints: const BoxConstraints(
                    maxHeight: double.infinity,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.grey[300],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
