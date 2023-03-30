import 'dart:async';
import 'dart:convert';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  TextEditingController mtrReading = TextEditingController();
  late AnimationController controller;
  var dt = DateFormat('HH:mm a').format(DateTime.now());

  String? cid;
  double? lat;
  double? long;
  String? syncUrl;
  String userName = '';
  String userId = '';
  String? userPass;
  String deviceId = '';

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  String address = "";
  bool reportAttendance = true;

  @override
  void initState() {
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    getLatLong();

    SharedPreferences.getInstance().then((prefs) {
      if ((prefs.getString("CID") == null) ||
          (prefs.getString("USER_ID") == null) ||
          prefs.getString("PASSWORD") == null) {
        return;
      } else {
        cid = prefs.getString("CID");
        userPass = prefs.getString("PASSWORD");
        deviceId = prefs.getString("deviceId") ?? " ";
      }
    });

    super.initState();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      getAddress(value.latitude, value.longitude);
    }).catchError((error) {});
  }

  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    print(placemarks);
    setState(() {
      address = "${placemarks[0].street!} ${placemarks[0].country!}";
    });
    for (int i = 0; i < placemarks.length; i++) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text("Attendance"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
        child: (lat == null && long == null)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DataTable(
                      dataRowHeight: 70,
                      columns: const [
                        DataColumn(label: Text("")),
                        DataColumn(label: Text(""))
                      ],
                      rows: [
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Latitude",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                lat.toString(),
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Longitude",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                "$long",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Address",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                address,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: [
                            const DataCell(
                              Text(
                                "Time",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                dt,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        DataRow(
                          color: MaterialStateProperty.all(
                              const Color.fromARGB(255, 230, 179, 192)),
                          cells: [
                            const DataCell(
                              Text(
                                "Meter Reading",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400),
                              ),
                            ),
                            DataCell(
                              TextField(
                                controller: mtrReading,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.teal.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            onPressed: () async {
                              if (reportAttendance == true) {
                                Map<String, dynamic> result =
                                    await Repositories().attendanceRepo(
                                        dmpathData!.syncUrl,
                                        cid,
                                        userId,
                                        userPass,
                                        deviceId,
                                        lat.toString(),
                                        long.toString(),
                                        address.toString(),
                                        "START",
                                        mtrReading.text);

                                if (result["status"] == "Success") {
                                  reportAttendance = false;
                                  if (!mounted) return;

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(
                                                userName: userInfo!.userName,
                                                userId: userInfo!.userId,
                                                userPassword: userPass!,
                                              )));
                                }
                              } else {
                                AllServices().toastMessage(
                                    'Start Time has been Submitted for Today',
                                    Colors.red,
                                    Colors.white,
                                    16.0);
                              }
                            },
                            child: const Text(
                              "Day Start",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blueGrey,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15))),
                            onPressed: () async {
                              if (reportAttendance == true) {
                                Map<String, dynamic> result =
                                    await Repositories().attendanceRepo(
                                        dmpathData!.syncUrl,
                                        cid,
                                        userId,
                                        userPass,
                                        deviceId,
                                        lat.toString(),
                                        long.toString(),
                                        address.toString(),
                                        "END",
                                        mtrReading.text);

                                if (result["status"] == "Success") {
                                  reportAttendance = false;
                                  if (!mounted) return;

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyHomePage(
                                                userName: userInfo!.userName,
                                                userId: userInfo!.userId,
                                                userPassword: userPass!,
                                              )));
                                }
                              } else {
                                AllServices().toastMessage(
                                    'End Time has been Submitted for Today',
                                    Colors.red,
                                    Colors.white,
                                    16.0);
                              }
                            },
                            child: const Text(
                              "Day End",
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
