import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:MREPORTING/ui/loginPage.dart';

import 'package:MREPORTING/ui/syncDataTabPaga.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String cid = '';
  String userId = '';
  String userPassword = '';
  bool? areaPage;
  String? user_id;
  String? userName;
  List itemToken = [];
  List clientToken = [];
  List dcrtToken = [];
  List gifttToken = [];

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    getLatLong();

    Hive.openBox('data').then(
      (value) {
        // var mymap = value.toMap().values.toList();
        clientToken = value.toMap().values.toList();

        setState(() {});

        SharedPreferences.getInstance().then(
          (prefs) {
            cid = prefs.getString("CID") ?? '';
            userId = prefs.getString("USER_ID") ?? '';
            userPassword = prefs.getString("PASSWORD") ?? '';
            // areaPage = prefs.getString("areaPage");
            userName = prefs.getString("userName");
            user_id = prefs.getString("user_id");
            // print(areaPage);

            if (cid != '' && userId != '' && userPassword != '') {
              // print(clientToken);
              if (clientToken.isNotEmpty) {
                Timer(
                  const Duration(seconds: 4),
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyHomePage(
                        userName: userName.toString(),
                        userId: userId,
                        userPassword: userPassword,
                      ),
                    ),
                  ),
                );
              } else {
                Timer(
                  const Duration(seconds: 4),
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SyncDataTabScreen(
                        cid: cid,
                        userId: userId,
                        userPassword: userPassword,
                      ),
                    ),
                  ),
                );
              }
            } else {
              Timer(
                const Duration(seconds: 4),
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                ),
              );
            }
          },
        );
      },
    );
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
      // print("value $value");
      setState(() {
        latitude = value.latitude;
        longitude = value.longitude;

        SharedPreferences.getInstance().then((prefs) {
          prefs.setDouble("latitude", latitude!);
          prefs.setDouble("longitude", longitude!);
        });
      });
    }).catchError((error) {
      // print("Error $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/images/mRep7_wLogo.png",
                color: Colors.white,
              ),
              const SizedBox(
                height: 20,
              ),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
