import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/apiCall.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:MREPORTING/ui/Appraisal/appraisal_screen.dart';
import 'package:MREPORTING/ui/Appraisal/appraisal_employee_page.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_list_page.dart';
import 'package:MREPORTING/ui/Widgets/common_in_app_web_view.dart';
import 'package:MREPORTING/ui/eDSR_section/approval_eDSR_FM_list.dart';
import 'package:MREPORTING/ui/eDSR_section/eDCR_screen.dart';
import 'package:MREPORTING/ui/promo_page.dart';
import 'package:MREPORTING/ui/stock_page.dart';
import 'package:MREPORTING/ui/target_achievemet.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:MREPORTING/ui/DCR_section/draft_dcr_page.dart';
import 'package:MREPORTING/ui/Expense/expense_section.dart';
import 'package:MREPORTING/ui/areaPage.dart';
import 'package:MREPORTING/ui/attendance_page.dart';
import 'package:MREPORTING/ui/order_sections/customerListPage.dart';
import 'package:MREPORTING/ui/order_sections/draft_order_page.dart';
import 'package:MREPORTING/ui/loginPage.dart';
import 'package:MREPORTING/ui/Rx/rxDraftPage.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_report.dart';
import 'package:MREPORTING/ui/order_sections/order_report_page.dart';
import 'package:MREPORTING/ui/Rx/rx_report_page.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:url_launcher/link.dart';
import 'package:MREPORTING/ui/reset_password.dart';
import 'package:MREPORTING/ui/syncDataTabPaga.dart';
import 'package:MREPORTING/ui/Rx/rxPage.dart';
import 'package:MREPORTING/ui/Widgets/custombutton.dart';
import 'package:shared_preferences/shared_preferences.dart';

// double? lat;
// double? long;
// String? address;

class MyHomePage extends StatefulWidget {
  final String userName;
  final String userId;
  final String userPassword;

  const MyHomePage({
    Key? key,
    required this.userPassword,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  String? startTime;

  String deviceId = "";

  String? endTime;
  var prefix;
  var prefix2;

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    AllServices().getLatLong();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferences.getInstance().then((prefs) {
        setState(() {
          cid = prefs.getString("CID")!;
          userId = prefs.getString("USER_ID") ?? widget.userId;
          userPassword = prefs.getString("PASSWORD") ?? widget.userPassword;
          startTime = prefs.getString("startTime") ?? '';
          endTime = prefs.getString("endTime") ?? '';

          timer_track_url = prefs.getString("timer_track_url") ?? '';

          deviceId = prefs.getString("deviceId") ?? '';

          var parts = startTime?.split(' ');
          prefix = parts![0].trim();
          String dt = DateTime.now().toString();
          var parts2 = dt.split(' ');
          prefix2 = parts2[0].trim();
        });

        setState(() {
          int space = startTime!.indexOf(" ");
          String removeSpace =
              startTime!.substring(space + 1, startTime!.length);
          startTime = removeSpace.replaceAll("'", '');
          int space1 = endTime!.indexOf(" ");
          String removeSpace1 = endTime!.substring(space1 + 1, endTime!.length);
          endTime = removeSpace1.replaceAll("'", '');
        });
      });
    });
  }

  // getLoc() {
  //   String location = "";
  //   Timer.periodic(const Duration(minutes: 3), (timer) {
  //     getLatLong();
  //     if (lat != 0.0 && long != 0.0) {
  //       if (location == "") {
  //         location = "$lat|$long";
  //       } else {
  //         location = "$location||$lat|$long";
  //       }
  //     }
  //   });
  // }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }
  //   return await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high);
  // }

  // getLatLong() {
  //   Future<Position> data = _determinePosition();
  //   data.then((value) {
  //     setState(() {
  //       lat = value.latitude;
  //       long = value.longitude;
  //     });
  //     getAddress(value.latitude, value.longitude);
  //   }).catchError((error) {});
  // }

  // getAddress(lat, long) async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
  //   setState(() {
  //     address = "${placemarks[0].street!} ${placemarks[0].country!}";
  //   });
  //   for (int i = 0; i < placemarks.length; i++) {}
  // }

  int _currentSelected = 0;
  _onItemTapped(int index) async {
    if (index == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => RxPage(
                    isRxEdit: false,
                  )));
      setState(() {
        _currentSelected = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _drawerKey,
      endDrawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll,
        // through the options in the drawer if there isn't enough vertical,
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 138, 201, 149)),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Image.asset(
                  'assets/images/logo-black.png',
                ),
              ),
            ),
            ListTile(
              leading:
                  const Icon(Icons.sync_outlined, color: Colors.blueAccent),
              title: const Text(
                'Sync Data',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 15, 53, 85)),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SyncDataTabScreen(
                              cid: cid,
                              userId: userId,
                              userPassword: userPassword,
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.fact_check_outlined,
                  color: Colors.blueAccent),
              title: const Text(
                'Achievement',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 15, 53, 85)),
              ),
              onTap: () async {
                List tarAchievementList = await Repositories().targetAchRepo(
                    dmpathData!.userSalesCollAchUrl,
                    cid,
                    userId,
                    userPassword,
                    deviceId);

                if (tarAchievementList.isNotEmpty) {
                  if (!mounted) return;

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => TargetAchievement(
                                tarAchievementList: tarAchievementList,
                              )));
                } else {
                  AllServices().toastMessage(
                      "No Target Achievement ", Colors.red, Colors.white, 16.0);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_offer, color: Colors.blueAccent),
              title: const Text(
                'Promo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 15, 53, 85),
                ),
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => PromoPage(
                            cid: cid,
                            userPassword: userPassword,
                          ))),
            ),
            ListTile(
              leading:
                  const Icon(Icons.dataset_sharp, color: Colors.blueAccent),
              title: const Text(
                'Stock',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 15, 53, 85),
                ),
              ),
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => StockPage(
                            cid: cid,
                            userPassword: userPassword,
                          ))),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.vpn_key, color: Colors.blueAccent),
              title: const Text(
                'Change password',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 15, 53, 85)),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ResetPasswordScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.blueAccent),
              title: const Text(
                'Logout',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 15, 53, 85)),
              ),
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('PASSWORD', '');
                await prefs.setString("Region", '');
                await prefs.setString("Area", '');
                await prefs.setString("Territory", '');
                Hive.box("doctorList").clear();
                final eDsrSettingBox = Boxes.geteDSRsetData();
                eDsrSettingBox.clear();
                if (!mounted) return;
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
            ),
            const SizedBox(height: 100),
            Row(
              children: [
                const Spacer(),
                SizedBox(
                  width: screenWidth / 2.7,
                  // height: screenHeight / 10,
                  child: Text(
                    loginPageVersionName,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black.withOpacity(.5),
                      // color: Color.fromARGB(255, 129, 188, 236),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text('MREPORTING $appVersion'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: userInfo!.rxFlag == true
          ? BottomNavigationBar(
              // type: BottomNavigationBarType.fixed,
              onTap: _onItemTapped,
              currentIndex: _currentSelected,
              // showUnselectedLabels: true,
              unselectedItemColor: Colors.grey[800],
              selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  label: 'Home',
                  icon: Icon(Icons.home),
                ),
                // rxFlag == false
                //     ?
                BottomNavigationBarItem(
                  label: 'Camera',
                  icon: Icon(
                    Icons.photo_camera_outlined,
                    color: Colors.black87,
                  ),
                )
                // : const BottomNavigationBarItem(
                //     label: '',
                //     icon: Icon(
                //       Icons.photo_camera_outlined,
                //       color: Colors.white,
                //     ),
                //   )
              ],
            )
          : Container(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ///*****************************************************  User information Section***********************************************///

                Container(
                  height: 75,
                  // height: screenHeight / 9.3,
                  width: MediaQuery.of(context).size.width,
                  color: const Color.fromARGB(255, 222, 237, 250),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  child: Text(
                                    widget.userName,

                                    // ' $userName',
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 15, 53, 85),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                FittedBox(
                                  child: Text(
                                    'ID: ${widget.userId}\n${userInfo!.mobileNo}',
                                    // ' $userName',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 15, 53, 85),
                                      fontSize: 18,
                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      userInfo!.othersFlag
                          ? Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: (() {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AttendanceScreen()));
                                      }),
                                      child: FittedBox(
                                        child: prefix != prefix2
                                            ? const Text(
                                                '[Attendance]'
                                                '\n'
                                                'Start: '
                                                " "
                                                '\n'
                                                "End: "
                                                " ",
                                                style: TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 15, 53, 85),
                                                  fontSize: 18,
                                                ),
                                              )
                                            : Text(
                                                '[Attendance]' '\n' 'Start: ' +
                                                    startTime.toString() +
                                                    '\n' +
                                                    "End: " +
                                                    endTime.toString(),
                                                style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 15, 53, 85),
                                                  fontSize: 18,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const Text(""),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),

                ///************************************************ Order area Field *********************************************///

                userInfo!.orderFlag
                    ? Container(
                        color: const Color(0xFFE2EFDA),
                        height: screenHeight / 3.4,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomBuildButton(
                                    icon: Icons.add,
                                    onClick: () async {
                                      List orderList = await AllServices()
                                          .getSyncSavedData('data');

                                      if (userInfo!.areaPage == false) {
                                        if (!mounted) return;

                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    CustomerListScreen(
                                                      data: orderList,
                                                    )));
                                      } else {
                                        if (!mounted) return;

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => AreaPage(
                                                    screenName: 'order',
                                                  )),
                                        );
                                      }

                                      //  print(areaPage);
                                    },
                                    title: 'New Order',
                                    sizeWidth: screenWidth,
                                    inputColor:
                                        const Color(0xff70BA85).withOpacity(.3),
                                  ),
                                ),
                              ],
                            ),
                            // const SizedBox(
                            //   height: 5,
                            // ),
                            Row(
                              children: [
                                Expanded(
                                  child: CustomBuildButton(
                                    icon: Icons.drafts_sharp,
                                    onClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const DraftOrderPage(),
                                        ),
                                      );
                                    },
                                    title: 'Draft Order',
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: CustomBuildButton(
                                    icon: Icons.insert_drive_file,
                                    onClick: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderReportWebViewScreen(
                                            report_url:
                                                dmpathData!.reportSalesUrl,
                                            cid: cid,
                                            userId: userId,
                                            userPassword: userPassword,
                                          ),
                                        ),
                                      );
                                    },
                                    title: 'Report',
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                userInfo!.orderFlag
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox.shrink(),

                ///******************************************** DCR Section ********************************************///

                userInfo!.dcrFlag
                    ? Container(
                        height: screenHeight / 3.4,
                        width: MediaQuery.of(context).size.width,
                        color: const Color(0xFFDDEBF7),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.add,
                                        onClick: () async {
                                          List dcrList = await AllServices()
                                              .getSyncSavedData('dcrListData');

                                          if (userInfo!.areaPage) {
                                            if (!mounted) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => AreaPage(
                                                        screenName: 'dcr',
                                                      )),
                                            );
                                          } else if (dcrList.isNotEmpty) {
                                            if (!mounted) return;
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => DcrListPage(
                                                    dcrDataList: dcrList),
                                              ),
                                            );
                                          } else {
                                            AllServices().toastMessage(
                                                'Doctor List Empty!',
                                                Colors.red,
                                                Colors.white,
                                                16);
                                          }
                                        },
                                        title: 'New DCR',
                                        sizeWidth: screenWidth,
                                        inputColor: const Color(0xff56CCF2)
                                            .withOpacity(.3),
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.drafts_sharp,
                                        onClick: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const DraftDCRScreen()));
                                        },
                                        title: 'Draft DCR',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.insert_drive_file,
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DcrReportWebView(
                                                reportUrl:
                                                    dmpathData!.reportDcrUrl,
                                                cid: cid,
                                                userId: userId,
                                                userPassword: userPassword,
                                                deviceId: deviceId,
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'DCR Report',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                userInfo!.dcrFlag
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox.shrink(),
                // Container(
                //   height: screenHeight / 7.4,
                //   width: MediaQuery.of(context).size.width,
                //   child: Row(
                //     children: [
                //       CustomBuildButton(
                //         icon: Icons.add,
                //         onClick: () {
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const EDcrScreen()),
                //           );
                //         },
                //         title: '   eDSR',
                //         sizeWidth: screenWidth,
                //         inputColor: const Color(0xff56CCF2).withOpacity(.3),
                //       ),
                //     ],
                //   ),
                // ),

                ///********************************************* New Rx section **************************************///

                userInfo!.rxFlag
                    ? Container(
                        color: const Color(0xFFE2EFDA),
                        height: screenHeight / 3.4,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.camera_alt_sharp,
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RxPage(
                                                isRxEdit: false,
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'RX Capture',
                                        sizeWidth: screenWidth,
                                        inputColor: const Color(0xff70BA85)
                                            .withOpacity(.3),
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(
                                //   height: 5,
                                // ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.drafts_rounded,
                                        onClick: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const RxDraftPage()));
                                        },
                                        title: 'Draft RX',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.insert_drive_file,
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  RxReportPageWebView(
                                                cid: cid,
                                                userId: userId,
                                                userPassword: userPassword,
                                                reportUrl:
                                                    dmpathData!.reportRxUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'RX Report',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                userInfo!.rxFlag
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox.shrink(),

                ///*******************************************Expense and Attendance  section ***********************************///
                userInfo!.othersFlag
                    ? Container(
                        color: const Color(0xFFE2EFDA),
                        height: screenHeight / 6.80,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: CustomBuildButton(
                                    icon: Icons.add,
                                    onClick: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ExpensePage()));
                                    },
                                    title: 'Expense',
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 5,
                                // ),
                                Expanded(
                                  child: CustomBuildButton(
                                    onClick: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const AttendanceScreen()));
                                    },
                                    icon: Icons.assignment_turned_in_sharp,
                                    title: 'Attendance',
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                userInfo!.othersFlag
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox.shrink(),

                ///******************************************* Leave Request and Leave Report **********************************///
                userInfo!.leaveFlag
                    ? Container(
                        color: const Color(0xFFE2EFDA),
                        height: screenHeight / 6.8,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Link(
                                    uri: Uri.parse(
                                        '${dmpathData!.leaveRequestUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                    target: LinkTarget.blank,
                                    builder: (BuildContext ctx,
                                        FollowLink? openLink) {
                                      return Card(
                                        elevation: 5,
                                        child: Container(
                                          color: Colors.white,
                                          width: screenWidth,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextButton.icon(
                                              onPressed: openLink,
                                              label: const Text(
                                                'Leave Request',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 29, 67, 78),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              icon: const Icon(
                                                Icons
                                                    .leave_bags_at_home_rounded,
                                                color: Color.fromARGB(
                                                    255, 27, 56, 34),
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // const SizedBox(
                                //   width: 5,
                                // ),
                                Expanded(
                                  child: Link(
                                    uri: Uri.parse(
                                        '${dmpathData!.leaveReportUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                    target: LinkTarget.blank,
                                    builder: (BuildContext ctx,
                                        FollowLink? openLink) {
                                      return Card(
                                        elevation: 5,
                                        child: Container(
                                          color: Colors.white,
                                          width: screenWidth,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              8,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: TextButton.icon(
                                              onPressed: openLink,
                                              label: const Text(
                                                'Leave Report',
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 29, 67, 78),
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              icon: const Icon(
                                                Icons.insert_drive_file,
                                                color: Color.fromARGB(
                                                    255, 27, 56, 34),
                                                size: 28,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                userInfo!.othersFlag
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox.shrink(),

                ///******************************************  Tour Plan *********************************************///
                userInfo!.visitPlanFlag
                    ? Container(
                        color: const Color(0xFFDDEBF7),
                        height: screenHeight / 7,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Link(
                                        uri: Uri.parse(
                                            '${dmpathData!.tourPlanUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                        target: LinkTarget.blank,
                                        builder: (BuildContext ctx,
                                            FollowLink? openLink) {
                                          return Card(
                                            elevation: 5,
                                            child: Container(
                                              color: const Color.fromARGB(
                                                  255, 217, 224, 250),
                                              width: screenWidth,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: TextButton.icon(
                                                  onPressed: openLink,
                                                  label: const Text(
                                                    'Tour Plan',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 29, 67, 78),
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.tour_sharp,
                                                    color: Color.fromARGB(
                                                        255, 27, 56, 34),
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: Link(
                                        uri: Uri.parse(
                                            '${dmpathData!.tourComplianceUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                        target: LinkTarget.blank,
                                        builder: (BuildContext ctx,
                                            FollowLink? openLink) {
                                          return Card(
                                            elevation: 5,
                                            child: Container(
                                              color: const Color.fromARGB(
                                                  255, 217, 224, 250),
                                              width: screenWidth,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  8,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: TextButton.icon(
                                                  onPressed: openLink,
                                                  label: const Text(
                                                    'Approval & Compliance',
                                                    style: TextStyle(
                                                        color: Color.fromARGB(
                                                            255, 29, 67, 78),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                  icon: const Icon(
                                                    Icons.tour_outlined,
                                                    color: Color.fromARGB(
                                                        255, 27, 56, 34),
                                                    size: 28,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                userInfo!.visitPlanFlag
                    ? const SizedBox(
                        height: 5,
                      )
                    : const SizedBox.shrink(),

                ///***********************************  Plugg-in & Reports *************************************************///
                userInfo!.plaginFlag
                    ? Container(
                        color: const Color(0xFFDDEBF7),
                        height: screenHeight / 6.8,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.insert_drive_file,
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CommonInAppWebView(
                                                title: 'Plugin',
                                                cid: cid,
                                                userId: userInfo!.userId,
                                                userPassword: userPassword,
                                                url: dmpathData!.pluginUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'Plugg-in & Reports',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                      child: CustomBuildButton(
                                        icon: Icons.local_activity_rounded,
                                        onClick: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  CommonInAppWebView(
                                                title: 'Activity',
                                                cid: cid,
                                                userId: userInfo!.userId,
                                                userPassword: userPassword,
                                                url: dmpathData!.activityLogUrl,
                                              ),
                                            ),
                                          );
                                        },
                                        title: 'Activity Log',
                                        sizeWidth: screenWidth,
                                        inputColor: Colors.white,
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Link(
                                    //     uri: Uri.parse(
                                    //         '${dmpathData!.pluginUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                    //     target: LinkTarget.blank,
                                    //     builder: (BuildContext ctx,
                                    //         FollowLink? openLink) {
                                    //       return Card(
                                    //         elevation: 5,
                                    //         child: Container(
                                    //           color: Colors.white,
                                    //           width: screenWidth,
                                    //           height: MediaQuery.of(context)
                                    //                   .size
                                    //                   .height /
                                    //               8,
                                    //           child: Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(10.0),
                                    //             child: TextButton.icon(
                                    //               onPressed: openLink,
                                    //               label: const Text(
                                    //                 'Plugg-in & Reports',
                                    //                 style: TextStyle(
                                    //                     color: Color.fromARGB(
                                    //                         255, 29, 67, 78),
                                    //                     fontSize: 16,
                                    //                     fontWeight:
                                    //                         FontWeight.w500),
                                    //               ),
                                    //               icon: const Icon(
                                    //                 Icons.insert_drive_file,
                                    //                 color: Color.fromARGB(
                                    //                     255, 27, 56, 34),
                                    //                 size: 28,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),

                                    // const SizedBox(
                                    //   width: 5,
                                    // ),

                                    // Expanded(
                                    //   child: Link(
                                    //     uri: Uri.parse(
                                    //         '${dmpathData!.activityLogUrl}?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
                                    //     target: LinkTarget.blank,
                                    //     builder: (BuildContext ctx,
                                    //         FollowLink? openLink) {
                                    //       // print(
                                    //       //     '$activity_log_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword');
                                    //       return Card(
                                    //         elevation: 5,
                                    //         child: Container(
                                    //           color: Colors.white,
                                    //           width: screenWidth,
                                    //           height: MediaQuery.of(context)
                                    //                   .size
                                    //                   .height /
                                    //               8,
                                    //           child: Padding(
                                    //             padding:
                                    //                 const EdgeInsets.all(10.0),
                                    //             child: TextButton.icon(
                                    //               onPressed: openLink,
                                    //               label: const Text(
                                    //                 'Activity Log',
                                    //                 style: TextStyle(
                                    //                     color: Color.fromARGB(
                                    //                         255, 29, 67, 78),
                                    //                     fontSize: 16,
                                    //                     fontWeight:
                                    //                         FontWeight.w500),
                                    //               ),
                                    //               icon: const Icon(
                                    //                 Icons
                                    //                     .local_activity_rounded,
                                    //                 color: Color.fromARGB(
                                    //                     255, 27, 56, 34),
                                    //                 size: 28,
                                    //               ),
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
                userInfo!.plaginFlag
                    ? const SizedBox(
                        height: 10,
                      )
                    : const SizedBox.shrink(),

                ///****************************************** Sync Data************************************************///
                Container(
                  color: const Color(0xFFE2EFDA),
                  height: screenHeight / 6.8,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //==========================================================Notice flag +Notice url will be here====================================
                          userInfo!.noteFlag
                              ? Expanded(
                                  child: CustomBuildButton(
                                    icon: Icons.note_alt,
                                    onClick: () async {
                                      // var noticeBody = await noticeEvent();
                                      // print("list ${noticeBody}");

                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) => NoticeScreen(
                                      //               noticelist: noticeBody,
                                      //             )));
                                    },
                                    title: 'Notice',
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                )
                              : const SizedBox(
                                  width: 5,
                                ),

                          Expanded(
                            child: CustomBuildButton(
                              icon: Icons.sync,
                              onClick: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SyncDataTabScreen(
                                              cid: cid,
                                              userId: userId,
                                              userPassword: userPassword,
                                            )));
                              },
                              title: 'Sync Data',
                              sizeWidth: screenWidth,
                              inputColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                ///****************************************** Sync Data************************************************///
                Container(
                  color: const Color(0xFFDDEBF7),
                  height: screenHeight / 6.8,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //==========================================================Notice flag +Notice url will be here====================================
                          userInfo!.noteFlag
                              ? Expanded(
                                  child: CustomBuildButton(
                                    icon: Icons.add,
                                    onClick: () async {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const EDcrScreen()));
                                    },
                                    title: 'Add eDSR',
                                    sizeWidth: screenWidth,
                                    inputColor: Colors.white,
                                  ),
                                )
                              : const SizedBox(
                                  width: 5,
                                ),

                          Expanded(
                            child: CustomBuildButton(
                              icon: Icons.note_alt,
                              onClick: () async {
                                bool result = await InternetConnectionChecker()
                                    .hasConnection;
                                if (result == true) {
                                  if (!mounted) return;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => EdsrFmList(
                                        cid: cid,
                                        userPass: userPassword,
                                      ),
                                    ),
                                  );
                                } else {
                                  AllServices().toastMessage(interNetErrorMsg,
                                      Colors.yellow, Colors.black, 16);
                                }
                              },
                              title: 'eDSR Approve',
                              sizeWidth: screenWidth,
                              inputColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //============================================================ Appraisal Scetion======================================
                Container(
                  color: const Color(0xFFE2EFDA),
                  height: screenHeight / 6.8,
                  width: screenWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //==========================================================Notice flag +Notice url will be here====================================
                          Expanded(
                            child: CustomBuildButton(
                              icon: Icons.note_alt,
                              onClick: () async {
                                // var noticeBody = await noticeEvent();
                                // print("list ${noticeBody}");

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const ApprisalScreen()));
                              },
                              title: ' Appraisal',
                              sizeWidth: screenWidth,
                              inputColor: Colors.white,
                            ),
                          ),

                          Expanded(
                            child: CustomBuildButton(
                              icon: Icons.sync,
                              onClick: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const ApprovalAppraisal(
                                            pageState: 'Approvaal')));
                              },
                              title: 'Appraisal Approval',
                              sizeWidth: screenWidth,
                              inputColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // // Draft Item order section.......................

  // Future orderOpenBox() async {
  //   var dir = await getApplicationDocumentsDirectory();
  //   Hive.init(dir.path);
  //   box = await Hive.openBox('DraftOrderList');
  // }
  // Future timetrack() async {
  //   final response = await http.post(
  //     Uri.parse("$timer_track_url"),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       "cid": cid,
  //       "user_id": userId,
  //       "user_pass": widget.userPassword,
  //       'device_id': deviceId!,

  //       // "locations": Location,

  //     }),
  //   );
  //   Map<String, dynamic> data = json.decode(response.body);
  //   // status = data['status'];
  //   final startTime = data['start_time'];
  //   final endTime = data['end_time'];
  //   final prefs = await SharedPreferences.getInstance();

  //   // if (status == "Success") {
  //   //   await prefs.setString('startTime', startTime);
  //   //   await prefs.setString('endTime', endTime);
  //   //   print('hello');

  //   //   Navigator.pushReplacement(
  //   //       context,
  //   //       MaterialPageRoute(
  //   //           builder: (context) => MyHomePage(
  //   //                 userName: userName,
  //   //                 user_id: user_id,
  //   //                 userPassword: userPass!,
  //   //               )));

  //   //   Fluttertoast.showToast(msg: "Attendance $submitType Successfully");
  //   // } else {
  //   //   return "Failed";
  //   // }
  //   return "Null";
  // }
}
