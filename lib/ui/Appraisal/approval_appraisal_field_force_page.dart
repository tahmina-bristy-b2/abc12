import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/appraisal/appraisal_field_Force_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_repository.dart';
import 'package:MREPORTING/services/appraisal/services.dart';
import 'package:MREPORTING/ui/Appraisal/appraisal_approval_details.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ApprovalAppraisalFieldForce extends StatefulWidget {
  const ApprovalAppraisalFieldForce(
      {super.key,
      required this.pageState,
      required this.cid,
      required this.userPass});
  final String pageState;
  final String cid;
  final String userPass;

  @override
  State<ApprovalAppraisalFieldForce> createState() =>
      _ApprovalAppraisalFieldForceState();
}

class _ApprovalAppraisalFieldForceState
    extends State<ApprovalAppraisalFieldForce> {
  final TextEditingController _searchController = TextEditingController();
  // final TabController _tabController = TabController(length: 6, vsync: this.vsync);
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  AppraisalFfDataModel? appraisalFfData;
  List<DataList> userFflistAll = [];
  List<DataList> userFflistNew = [];
  List<DataList> userFflistDraft = [];
  List<DataList> userFflistApproved = [];
  List<DataList> userFflistReleaseHr = [];
  List<DataList> userFflistReleasedSup = [];
  List<DataList> userFflistRejected = [];
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
    getAppraisalFFdata(); //FF means field Force
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      initialIndex: 0,
      child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              appraisalFfData != null
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          _searchExpand = !_searchExpand;
                          _color = true;

                          if (height == 0.0) {
                            height = 40.0;
                          } else {
                            _searchController.clear();
                            userFflistAll = appraisalFfData!.resData.dataList;
                            height = 0.0;
                          }
                        });
                      },
                      icon: const Icon(Icons.search_outlined))
                  : Container()
            ],
            bottom: TabBar(
              onTap: (value) {
                _searchController.clear();
                _searchExpand = false;
                height = 0;
                _color = false;
                userFflistAll = appraisalFfData!.resData.dataList;
                userFflistDraft = userFflistAll
                    .where((element) => element.appActionStatus == "DRAFT_SUP")
                    .toList();
                userFflistApproved = userFflistAll
                    .where((element) => element.appActionStatus == "APPROVED")
                    .toList();
                userFflistReleaseHr = userFflistAll
                    .where(
                        (element) => element.appActionStatus == "RELEASED_HR")
                    .toList();
                userFflistReleasedSup = userFflistAll
                    .where(
                        (element) => element.appActionStatus == "RELEASED_SUP")
                    .toList();
                userFflistRejected = userFflistAll
                    .where((element) => element.appActionStatus == "REJECTED")
                    .toList();
                userFflistNew = userFflistAll
                    .where((element) => element.appActionStatus == "")
                    .toList();
                setState(() {});
              },
              isScrollable: true,
              tabs: const [
                Tab(
                  text: 'ALL',
                ),
                Tab(
                  text: 'NEW',
                ),
                Tab(
                  text: 'DRAFT',
                ),
                Tab(
                  text: 'APPROVED',
                ),
                Tab(
                  text: 'RELEASED HR',
                ),
                Tab(
                  text: 'RELEASED SUP',
                ),
                Tab(
                  text: 'REJECTED',
                ),
              ],
            ), // TabBar
          ), // AppBar
          body: TabBarView(
            children: [
              isLoading
                  ? dataLoadingView()
                  : appraisalFfData == null ||
                          appraisalFfData!.resData.dataList.isEmpty
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
                      : Column(
                          children: [
                            AnimatedContainer(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  border: Border.all(
                                      color: _color
                                          ? const Color.fromARGB(
                                              255, 138, 201, 149)
                                          : Colors.black)),
                              height: height,
                              child: _searchExpand
                                  ? TextFormField(
                                      autofocus: false,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.done,
                                      controller: _searchController,
                                      decoration: const InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            bottom: 0, left: 10, top: 5),
                                        hintText: 'FF name/Territory id',
                                        border: InputBorder.none,
                                        prefixIcon: Icon(Icons.search),
                                      ),
                                      onChanged: (value) {
                                        setState(() {
                                          userFflistAll = AppraisalServices()
                                              .searchFf(
                                                  value,
                                                  appraisalFfData!
                                                      .resData.dataList);
                                        });
                                      },
                                    )
                                  : Container(),
                            ),
                            appraisalFFView(context, 'ALL', userFflistAll),
                          ],
                        ),

              //------------------for New-----------------

              appraisalFfData == null ||
                      appraisalFfData!.resData.dataList.isEmpty
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
                  : Column(
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0, left: 10, top: 5),
                                    hintText: 'FF name/Territory id',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      userFflistAll = AppraisalServices()
                                          .searchFf(
                                              value,
                                              appraisalFfData!
                                                  .resData.dataList);

                                      userFflistNew = userFflistAll
                                          .where((element) =>
                                              element.appActionStatus == "")
                                          .toList();
                                    });
                                  },
                                )
                              : Container(),
                        ),
                        appraisalFFView(context, 'NEW', userFflistNew),
                      ],
                    ),

              //-----------------for Draft------------------------
              appraisalFfData == null ||
                      appraisalFfData!.resData.dataList.isEmpty
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
                  : Column(
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0, left: 10, top: 5),
                                    hintText: 'FF name/Territory id',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      userFflistAll = AppraisalServices()
                                          .searchFf(
                                              value,
                                              appraisalFfData!
                                                  .resData.dataList);
                                      userFflistDraft = userFflistAll
                                          .where((element) =>
                                              element.appActionStatus ==
                                              "DRAFT_SUP")
                                          .toList();
                                    });
                                  },
                                )
                              : Container(),
                        ),
                        appraisalFFView(context, 'DRAFT', userFflistDraft),
                      ],
                    ),

              //--------------------------for Approved ----------------------

              appraisalFfData == null ||
                      appraisalFfData!.resData.dataList.isEmpty
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
                  : Column(
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0, left: 10, top: 5),
                                    hintText: 'FF name/Territory id',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      userFflistAll = AppraisalServices()
                                          .searchFf(
                                              value,
                                              appraisalFfData!
                                                  .resData.dataList);

                                      userFflistApproved = userFflistAll
                                          .where((element) =>
                                              element.appActionStatus ==
                                              "APPROVED")
                                          .toList();
                                    });
                                  },
                                )
                              : Container(),
                        ),
                        appraisalFFView(
                            context, 'APPROVED', userFflistApproved),
                      ],
                    ),

              //------------------------- for Released hr ----------------------
              appraisalFfData == null ||
                      appraisalFfData!.resData.dataList.isEmpty
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
                  : Column(
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0, left: 10, top: 5),
                                    hintText: 'FF name/Territory id',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      userFflistAll = AppraisalServices()
                                          .searchFf(
                                              value,
                                              appraisalFfData!
                                                  .resData.dataList);

                                      userFflistReleaseHr = userFflistAll
                                          .where((element) =>
                                              element.appActionStatus ==
                                              "RELEASED_HR")
                                          .toList();
                                    });
                                  },
                                )
                              : Container(),
                        ),
                        appraisalFFView(
                            context, 'RELEASED_HR', userFflistReleaseHr),
                      ],
                    ),

              //--------------------------- for Released SUP ---------------
              appraisalFfData == null ||
                      appraisalFfData!.resData.dataList.isEmpty
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
                  : Column(
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0, left: 10, top: 5),
                                    hintText: 'FF name/Territory id',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      userFflistAll = AppraisalServices()
                                          .searchFf(
                                              value,
                                              appraisalFfData!
                                                  .resData.dataList);

                                      userFflistReleasedSup = userFflistAll
                                          .where((element) =>
                                              element.appActionStatus ==
                                              "RELEASED_SUP")
                                          .toList();
                                    });
                                  },
                                )
                              : Container(),
                        ),
                        appraisalFFView(
                            context, 'RELEASED_SUP', userFflistReleasedSup),
                      ],
                    ),

              //------------------ for Rejected --------------------------
              appraisalFfData == null ||
                      appraisalFfData!.resData.dataList.isEmpty
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
                  : Column(
                      children: [
                        AnimatedContainer(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
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
                                    contentPadding: EdgeInsets.only(
                                        bottom: 0, left: 10, top: 5),
                                    hintText: 'FF name/Territory id',
                                    border: InputBorder.none,
                                    prefixIcon: Icon(Icons.search),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      userFflistAll = AppraisalServices()
                                          .searchFf(
                                              value,
                                              appraisalFfData!
                                                  .resData.dataList);

                                      userFflistRejected = userFflistAll
                                          .where((element) =>
                                              element.appActionStatus ==
                                              "REJECTED")
                                          .toList();
                                    });
                                  },
                                )
                              : Container(),
                        ),
                        appraisalFFView(
                            context, 'REJECTED', userFflistRejected),
                      ],
                    ),
            ],
          )),
    ); //
  }

  Expanded appraisalFFView(
      BuildContext context, tabTitle, List<DataList> userFflist) {
    return Expanded(
      child: ListView.builder(
          itemCount: userFflist.length,
          itemBuilder: (itemBuilder, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  if (widget.pageState == 'Approval') {
                    String restParams =
                        "submit_by=${userFflist[index].submitId}&employee_id=${userFflist[index].employeeId}&level_depth_no=${appraisalFfData!.resData.levelDepthNo}";

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppraisalApprovalDetails(
                            cid: widget.cid,
                            userPass: widget.userPass,
                            restParams: restParams,
                            appraisalStatus: userFflist[index].appActionStatus,
                            callBackFuntion: (value) {
                              _searchController.clear();
                              userFflist = appraisalFfData!.resData.dataList;
                              height = 0.0;
                              _searchExpand = false;
                              _color = false;
                              getAppraisalFFdata();
                              setState(() {});
                            }),
                      ),
                    );
                  }
                },
                leading: Container(
                  decoration: const ShapeDecoration(
                    shape: CircleBorder(),
                    color: Color.fromARGB(255, 138, 201, 149),
                  ),
                  height: 55,
                  width: 55,
                  child: Center(
                      child:
                          Text(userFflist[index].employeeName.substring(0, 2))),
                ),
                title: Text(
                    '${userFflist[index].employeeName} || ${userFflist[index].employeeId}'),
                subtitle:
                    // Text(
                    //     'Submitted by: ${userFflist[index].submitName} || ${userFflist[index].submitId}'),
                    Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Submitted by:  ${userFflist[index].submitId}'),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: Text(
                        userFflist[index].appActionStatus.split('_').first ==
                                'RELEASED'
                            ? userFflist[index]
                                .appActionStatus
                                .replaceAll('_', ' ')
                            : userFflist[index]
                                .appActionStatus
                                .split('_')
                                .first,

                        // userFflist[index].appActionStatus == 'DRAFT_SUP'
                        // ? userFflist[index].appActionStatus.split('_').first
                        // : userFflist[index].appActionStatus,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                userFflist[index].appActionStatus == 'DRAFT_SUP'
                                    ? Colors.orange
                                    : userFflist[index]
                                                .appActionStatus
                                                .split('_')
                                                .first ==
                                            'RELEASED'
                                        ? const Color.fromARGB(255, 44, 211, 50)
                                        : Colors.teal),
                      ),
                    ),
                  ],
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios_outlined,
                  color: Color.fromARGB(255, 138, 201, 149),
                ),
              ),
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

  getAppraisalFFdata() async {
    bool result = await InternetConnectionChecker().hasConnection;
    if (result) {
      appraisalFfData = await AppraisalRepository().getAppraisalFFData(
          dmpathData!.syncUrl, widget.cid, userInfo!.userId, widget.userPass);

      if (appraisalFfData != null) {
        if (!mounted) return;
        title = appraisalFfData!.resData.levelDepthNo == '1'
            ? 'MSO'
            : appraisalFfData!.resData.levelDepthNo == '0'
                ? 'FM'
                : appraisalFfData!.resData.levelDepthNo == '2'
                    ? 'MSO'
                    : 'Employee';
        userFflistAll = appraisalFfData!.resData.dataList;
        userFflistDraft = userFflistAll
            .where((element) => element.appActionStatus == "DRAFT_SUP")
            .toList();
        userFflistApproved = userFflistAll
            .where((element) => element.appActionStatus == "APPROVED")
            .toList();
        userFflistReleaseHr = userFflistAll
            .where((element) => element.appActionStatus == "RELEASED_HR")
            .toList();
        userFflistReleasedSup = userFflistAll
            .where((element) => element.appActionStatus == "RELEASED_SUP")
            .toList();
        userFflistRejected = userFflistAll
            .where((element) => element.appActionStatus == "REJECTED")
            .toList();
        userFflistNew = userFflistAll
            .where((element) => element.appActionStatus == "")
            .toList();

        setState(() {
          isLoading = false;
        });
      } else {
        if (!mounted) return;
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
