// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/others/repositories.dart';
import 'package:MREPORTING_OFFLINE/utils/constant.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING_OFFLINE/ui/homePage.dart';
import 'package:MREPORTING_OFFLINE/ui/syncDataTabPaga.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _companyIdController = TextEditingController();
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  double screenHeight = 0;
  double screenWidth = 0;
  Color initialColor = Colors.white;
  bool _obscureText = true;
  List<String> visitedWith = [];
  List<String> rxType = [];
  String deviceId = '';
  String? deviceBrand = '';
  String? deviceModel = '';
  String? savedUserId = '';
  bool isLoading = false;

  @override
  initState() {
    _getDeviceInfo();

    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getString("CID") != null) {
        var a = prefs.getString("CID");
        savedUserId = prefs.getString('user_id');
        setState(() {
          _companyIdController.text = a.toString();
        });
      }
    });

    super.initState();
  }

  Future _getDeviceInfo() async {
    var deviceInfo = DeviceInfoPlugin();

    var androidDeviceInfo = await deviceInfo.androidInfo;

    deviceBrand = androidDeviceInfo.brand!;
    deviceModel = androidDeviceInfo.model!;

    try {
      deviceId = (await PlatformDeviceId.getDeviceId)!;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('deviceId', deviceId);
    await prefs.setString('deviceBrand', deviceBrand!);
    await prefs.setString('deviceModel', deviceModel!);
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return isLoading
        ? Container(
            padding: const EdgeInsets.all(50),
            color: Colors.white,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            backgroundColor: const Color(0xFFE2EFDA),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: screenHeight / 3.5,
                      width: screenWidth,
                      child: Center(
                        child: SizedBox(
                          width: 220,
                          height: 180,
                          child: Image.asset(
                            'assets/images/mRep7_wLogo.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight - screenHeight / 2.5,
                      width: screenWidth,
                      color: const Color(0xFFE2EFDA),
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: screenWidth / 60),
                        child: Column(
                          children: [
                            SizedBox(
                              height: screenHeight / 52,
                            ),
                            Form(
                              key: _formKey,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: screenWidth / 10,
                                    horizontal: screenWidth / 28),
                                child: Column(
                                  children: [
                                    // Company ID Field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _companyIdController,
                                      keyboardType: TextInputType.text,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'Company ID',
                                        labelStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Provide Your valid CompanyId';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),

                                    SizedBox(
                                      height: screenHeight / 40,
                                    ),

                                    // User ID field
                                    TextFormField(
                                      autofocus: false,
                                      controller: _userIdController,
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      decoration: const InputDecoration(
                                        labelText: 'User ID',
                                        labelStyle: TextStyle(
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please Provide Your User ID';
                                        }
                                        if (value.contains("@")) {
                                          return 'Please Provide Your Valid User ID';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: screenHeight / 50,
                                    ),

                                    // Password Field
                                    TextFormField(
                                      obscureText: _obscureText,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        labelStyle: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.vpn_key,
                                          color:
                                              Color.fromARGB(255, 98, 126, 112),
                                        ),
                                        suffixIcon: _obscureText == true
                                            ? IconButton(
                                                onPressed: () {
                                                  setState(
                                                    () {
                                                      _obscureText = false;
                                                    },
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.visibility_off,
                                                  size: 20,
                                                  color: Colors.grey,
                                                ))
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    _obscureText = true;
                                                  });
                                                },
                                                icon: const Icon(
                                                  Icons.remove_red_eye,
                                                  size: 20,
                                                  color: Colors.black,
                                                ),
                                              ),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.done,
                                      validator: (value) {
                                        // RegExp regexp = RegExp(r'^.{6,}$');
                                        if (value!.isEmpty) {
                                          return 'Please enter your password.';
                                        }
                                        // if (value.length >= 6) {
                                        //   return 'Password is too short ,please expand';
                                        // }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: screenHeight / 60),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth / 4,
                              height: screenHeight / 12,
                              child: Column(
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        // new call
                                        bool result =
                                            await InternetConnectionChecker()
                                                .hasConnection;

                                        if (result == true) {
                                          String loginUrl = await Repositories()
                                              .getDmPath(_companyIdController
                                                  .text
                                                  .trim());
                                          if (loginUrl != '') {
                                            UserLoginModel userLoginModelData =
                                                await Repositories().login(
                                                    loginUrl,
                                                    deviceId,
                                                    deviceBrand,
                                                    deviceModel,
                                                    _companyIdController.text
                                                        .trim(),
                                                    _userIdController.text,
                                                    _passwordController.text);

                                            if (userLoginModelData.status ==
                                                'Success') {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              Hive.openBox('data').then(
                                                (value) {
                                                  List clientToken = value
                                                      .toMap()
                                                      .values
                                                      .toList();

                                                  if (clientToken.isNotEmpty &&
                                                      savedUserId ==
                                                          _userIdController
                                                              .text) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => MyHomePage(
                                                            userName:
                                                                userLoginModelData
                                                                    .userName,
                                                            userId:
                                                                userLoginModelData
                                                                    .userId,
                                                            userPassword:
                                                                _passwordController
                                                                    .text),
                                                      ),
                                                    );
                                                  } else {
                                                    Boxes.clearBox();

                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) => SyncDataTabScreen(
                                                            cid:
                                                                _companyIdController
                                                                    .text,
                                                            userId:
                                                                userLoginModelData
                                                                    .userId,
                                                            userPassword:
                                                                _passwordController
                                                                    .text),
                                                      ),
                                                    );
                                                  }
                                                },
                                              );
                                            } else {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              // AllServices().toastMessage(
                                              //     'Wrong user Id and Password',
                                              //     Colors.red,
                                              //     Colors.white,
                                              //     16);
                                            }
                                          } else {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            // AllServices().toastMessage(
                                            //     'Wrong CID',
                                            //     Colors.red,
                                            //     Colors.white,
                                            //     16);
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          AllServices().toastMessage(
                                              interNetErrorMsg,
                                              Colors.red,
                                              Colors.white,
                                              16);
                                        }
                                      } else {}
                                    },
                                    child: const Text(
                                      'Login',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: screenWidth / 2.5,
                          // height: screenHeight / 10,
                          child: const Text(
                            loginPageVersionName,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              // color: Color.fromARGB(255, 129, 188, 236),
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
