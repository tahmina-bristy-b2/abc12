import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mrap7/Pages/loginPage.dart';
import 'package:mrap7/Pages/splash_screen.dart';
import 'package:mrap7/service/apiCall.dart';
import 'package:mrap7/service/hive_adapter.dart';

import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart';
import 'package:mrap7/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

double lat = 0.0;
double long = 0.0;
String location = "";
String address = "";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  await HiveAdapter().HiveAdapterbox();
  await Hive.openBox("draftForExpense");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  timer_flag = prefs.getBool("timer_flag");
  Location location = Location();
  // location.enableBackgroundMode();
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }

  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

//------------------------------------------------------

  // print("timer_flag ashbe${timer_flag}");

  if (_serviceEnabled &&
      _permissionGranted == PermissionStatus.granted &&
      timer_flag == true) {
    // await initializeService();
    BGservice.serviceOn();
    print('Starting Background Service...');
  }
  runApp(const MyApp());
}

class BGservice {
  static Future<void> serviceOn() async {
    await initializeService();
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      // this will executed when app is in foreground or background in separated isolate
      onStart: onStart,

      // auto start service
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      // auto start service
      autoStart: true,

      // this will executed when app is in foreground in separated isolate
      onForeground: onStart,

      // you have to enable background fetch capability on xcode project
      onBackground: onIosBackground,
    ),
  );
}

void onIosBackground() {
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() {
  WidgetsFlutterBinding.ensureInitialized();

  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }

    if (event["action"] == "startService") {
      service.start();
    }
  });
  // final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  // bring to foreground
  service.setForegroundMode(true);

  //********************Loop start********************
  Timer.periodic(const Duration(minutes: 3), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();

    //     //------------Internet Connectivity Check---------------------------
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    print('Internet connection: $isConnected');
    // // ----------------------------------------------------------------------
    //     //----------------Set Notification------------------
    if (isConnected) {
      service.setNotificationInfo(
        title: "mRep7",
        content: "Updated at ${DateTime.now()}",
      );
    } else {
      service.setNotificationInfo(
        title: "mRep7",
        content: "Updated at ${DateTime.now()}",
      );
    }

    //     //------------------------Geo Location-----------------

    try {
      geo.Position? position = await geo.Geolocator.getCurrentPosition();
      if (position != null) {
        lat = position.latitude;
        long = position.longitude;

        List<geocoding.Placemark> placemarks =
            await geocoding.placemarkFromCoordinates(lat, long);

        address = placemarks[0].street! + " " + placemarks[0].country!;
      }
    } on Exception catch (e) {
      print("Exception geolocator section: $e");
    }

    print('latlong: $lat, $long');

    //     //--------------------Api Hit Logic-----------------------------

    if (lat != 0.0 && long != 0.0) {
      if (location == "") {
        location = "$lat|$long|$address";
      } else {
        location = "$location||$lat|$long|$address";
      }
    }

    print(location);

    // service.sendData(
    //   {
    //     //"current_date": DateTime.now().toIso8601String(),
    //   },
    // );
    //     //-------------------------------------------------
  });
  Timer.periodic(Duration(minutes: 15), (timer) async {
    var body = await timeTracker(location);
    print(body["status"]);
    if (body["status"] == "Success") {
      location = "";
    } else {
      Fluttertoast.showToast(msg: "failed");
      location = "";
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  getAddress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'mRep7',
      theme: defaultTheme,
      home: SplashScreen(),
    );
  }
}
