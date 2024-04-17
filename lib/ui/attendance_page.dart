import 'dart:async';
import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceScreen extends StatefulWidget {
  // String startTime;
  // String endTime;
 String userPassword;
  // final Function callbackFunction;

   AttendanceScreen({Key? key,required this.userPassword}) : super(key: key);

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
  String isStartred="";
  bool sameDate =true;
   bool isLoading=true;

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  String address = "";
  bool reportAttendance = true;
  String startTime="";
  String endTime="";
 // bool isLoading=false;

  @override
  void initState() {
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
      getLatLong();
      getAttenadce();

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
  
    setState(() {
      address = "${placemarks[0].name}, "
      "${placemarks[0].street}, "
      "${placemarks[0].subLocality}, "
      "${placemarks[0].locality}, "
      "${placemarks[0].administrativeArea}, "
      "${placemarks[0].country}, "
      "${placemarks[0].postalCode}";

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
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40,horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AttenceRowClass(titleName: "Latitude", value: lat.toString()),
                      AttenceRowClass(titleName: "Longitude", value: long.toString()),
                      AttenceRowClass(titleName: "Address", value: address.toString()),
                      AttenceRowClass(titleName: "Time", value: dt),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                     startTime==""?  Expanded(
                            child: SizedBox(
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
                                   SharedPreferences prefs = await SharedPreferences.getInstance();
                                   setState(() {
                                  isLoading=true;
                                   
                                 });
                                  
                                    Map<String, dynamic> result =
                                        await Repositories().attendanceRepo(
                                            dmpathData!.syncUrl,
                                            cid,
                                            userInfo!.userId,
                                            userPassword,
                                            deviceId,
                                            lat.toString(),
                                            long.toString(),
                                            address.toString(),
                                            "START",
                                            "0");
                                            
                                    if (result["status"] == "Success") {
                                      reportAttendance = false;
                                      setState(() {
                                        isLoading=false;
                                        sameDate=true;
                                      });
                                      
                                    
                                       prefs.setString('startTime', result["start_time"].toString());
                                            AllServices().toastMessage("Day Start ${result["ret_str"]}",
                                        Colors.green,
                                        Colors.white,
                                        16.0);
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
                                    else {
                                      setState(() {
                                        isLoading=false;
                                      });
                                    AllServices().toastMessage(
                                       result["ret_str"].toString(),
                                        Colors.red,
                                        Colors.white,
                                        16.0);
                                  }
                                  // } else {
                                  //   AllServices().toastMessage(
                                  //       'Start Time has been Submitted for Today',
                                  //       Colors.red,
                                  //       Colors.white,
                                  //       16.0);
                                  // }
                                },
                                child: const Text(
                                  "Day Start",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ):SizedBox(),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.blueGrey,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15))),
                                onPressed: () async {
                                 SharedPreferences prefs = await SharedPreferences.getInstance();
                                 setState(() {
                                  isLoading=true;
                                   
                                 });
                                
                                    Map<String, dynamic> result =
                                        await Repositories().attendanceRepo(
                                            dmpathData!.syncUrl,
                                            cid,
                                            userInfo!.userId,
                                            userPassword,
                                            deviceId,
                                            lat.toString(),
                                            long.toString(),
                                            address.toString(),
                                            "END",
                                            "0");
                                            
                                    if (result["status"] == "Success") {
                                 
                                      setState(() {
                                        isLoading=false;
                                             prefs.setString('endTime', result["end_time"].toString());
                                      });
                                        AllServices().toastMessage("Day End ${result["ret_str"]}",
                                        Colors.green,
                                        Colors.white,
                                        16.0);
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
                                    else {
                                      setState(() {
                                        isLoading=false;
                                      });
                                    AllServices().toastMessage(
                                       result["ret_str"].toString(),
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
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

    String getDateTime(String givenDate){
    DateTime targetDateTime = DateTime.parse(givenDate!);
          DateTime now = DateTime.now();
          print(now);
          sameDate  = targetDateTime.year == now.year &&
          targetDateTime.month == now.month &&
          targetDateTime.day == now.day;       
          return sameDate?DateFormat.Hm().format(targetDateTime) :"00:00";
  }

  getAttenadce()async{
      SharedPreferences prefs = await SharedPreferences.getInstance();
                                     setState(() {
                                    isLoading=true;
                                     
                                   });
                                    
                                      Map<String, dynamic> result =
                                          await Repositories().attendanceGetRepo(
                                              dmpathData!.syncUrl,
                                              prefs.getString("CID")!,
                                              userInfo!.userId,
                                              widget.userPassword,
                                              );
                                              
                                      if (result["status"] == "Success") {

                                        startTime=result["start_time"].toString();
                                        endTime=result["end_time"].toString();
                                         setState(() {
                                            int space = startTime.indexOf(" ");
                                            String removeSpace =
                                                startTime.substring(space + 1, startTime.length);
                                            startTime = removeSpace.replaceAll("'", '');
                                            int space1 = endTime.indexOf(" ");
                                            String removeSpace1 = endTime.substring(space1 + 1, endTime.length);
                                            endTime = removeSpace1.replaceAll("'", '');
                                            isLoading=false;

                                          });
                                      
                                      }
                                      else {
                                        setState(() {
                                          isLoading=false;
                                        });
                                      AllServices().toastMessage(
                                         result["ret_str"].toString(),
                                          Colors.red,
                                          Colors.white,
                                          16.0);
                                    }
                                  
  }

}



 class AttenceRowClass extends StatelessWidget {
  String titleName;
  String value;
  
    AttenceRowClass({super.key,required this.titleName,required this.value });
 
   @override
   Widget build(BuildContext context) {
     return Padding(
       padding: const EdgeInsets.symmetric(vertical: 10),
       child: Column(
         children: [
           Row(
                              children: [
                                Expanded(
                            flex: 4,
                            child: Text(
                                        titleName,
                                        style:const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ), ),
                                      const     Expanded(child: Text(
                                        ":",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ), ),
                                      Expanded(
                                        flex: 4,
                                        child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ), ),

                                     
                              ],
                            ),
                           ///  Divider(thickness: 0.1,color: Colors.black,)
         ],
       ),
     );
   }
   
 }
