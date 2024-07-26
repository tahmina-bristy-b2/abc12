import 'dart:async';

import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING_OFFLINE/ui/homePage.dart';
import 'package:MREPORTING_OFFLINE/ui/loginPage.dart';

import 'package:MREPORTING_OFFLINE/ui/syncDataTabPaga.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  String cid = '';
  // String userId = '';
  String userPassword = '';
  // bool? areaPage;
  // String? user_id;
  // String? userName;
  List itemToken = [];
  List clientToken = [];
  List dcrtToken = [];
  List gifttToken = [];

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    AllServices().getLatLong();

    Hive.openBox('data').then(
      (value) {
        // var mymap = value.toMap().values.toList();
        clientToken = value.toMap().values.toList();

        setState(() {});

        SharedPreferences.getInstance().then(
          (prefs) {
            cid = prefs.getString("CID") ?? '';
            // userId = prefs.getString("USER_ID") ?? '';
            userPassword = prefs.getString("PASSWORD") ?? '';
            // areaPage = prefs.getString("areaPage");
            // userName = prefs.getString("userName");
            // user_id = prefs.getString("user_id");
            // print(areaPage);

            if (cid != '' && userInfo!.userId != '' && userPassword != '') {
              // print(clientToken);
              if (clientToken.isNotEmpty) {
                Timer(
                  const Duration(seconds: 4),
                  () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MyHomePage(
                        userName: userInfo!.userName,
                        userId: userInfo!.userId,
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
                        userId: userInfo!.userId,
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
