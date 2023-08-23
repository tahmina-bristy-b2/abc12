// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/services/eDSR/eDSR_services.dart';
import 'package:MREPORTING/services/order/order_repositories.dart';
import 'package:MREPORTING/services/rx/rx_repositories.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:MREPORTING/ui/homePage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:MREPORTING/ui/Widgets/syncCustomButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SyncDataTabScreen extends StatefulWidget {
  final String cid;
  final String userId;
  final String userPassword;

  const SyncDataTabScreen({
    super.key,
    required this.cid,
    required this.userId,
    required this.userPassword,
  });

  @override
  State<SyncDataTabScreen> createState() => _SyncDataTabScreenState();
}

class _SyncDataTabScreenState extends State<SyncDataTabScreen> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  String cid = '';
  String userId = '';
  String userPassword = '';
  String syncMsg = '';
  bool _loading = false;
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    userId = userInfo!.userId;

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID") ?? widget.cid;
        userPassword = prefs.getString("PASSWORD") ?? widget.userPassword;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: _loading ? Colors.black : const Color(0xffD8E5F1),
      appBar: _loading
          ? AppBar(
              backgroundColor: Colors.black,
            )
          : AppBar(
              title: const Text(
                'Sync Data',
              ),
              centerTitle: true,
            ),
      body: _loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircularProgressIndicator(
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(syncMsg,
                    style: const TextStyle(color: Colors.white, fontSize: 18)),
              ],
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: syncCustomBuildButton(
                            onClick: () async {
                              setState(() {
                                syncMsg = 'All data synchronizing... ';
                                _loading = true;
                              });
                              bool result = await InternetConnectionChecker()
                                  .hasConnection;
                              if (result == true) {
                                await syncDataMethod();
                              } else {
                                AllServices().toastMessage(interNetErrorMsg,
                                    Colors.red, Colors.white, 16);
                              }
                            },
                            color: Colors.teal.withOpacity(.5),
                            title: 'Sync ALL',
                            sizeWidth: screenWidth,
                          ),
                        ),
                      ],
                    ),
                    userInfo!.offerFlag
                        ? Row(
                            children: [
                              Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      syncMsg = 'Item data synchronizing... ';
                                      _loading = true;
                                    });
                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (result == true) {
                                      List itemList = await OrderRepositories()
                                          .syncItem(dmpathData!.syncUrl, cid,
                                              userId, userPassword);
                                      if (itemList.isNotEmpty) {
                                        AllServices().toastMessage(
                                            'Sync Item data Done.',
                                            Colors.teal,
                                            Colors.white,
                                            16);
                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        AllServices().toastMessage(
                                            'Didn\'t sync Item Data',
                                            Colors.red,
                                            Colors.white,
                                            16);

                                        setState(() {
                                          _loading = false;
                                        });
                                      }
                                    } else {
                                      AllServices().toastMessage(
                                          interNetErrorMsg,
                                          Colors.red,
                                          Colors.white,
                                          16);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'ITEMS',
                                  sizeWidth: screenWidth,
                                ),
                              ),
                              Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      syncMsg =
                                          'Customer data synchronizing... ';
                                      _loading = true;
                                    });

                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (result == true) {
                                      List clientList =
                                          await OrderRepositories().syncClient(
                                              dmpathData!.syncUrl,
                                              cid,
                                              userId,
                                              userPassword);
                                      if (clientList.isNotEmpty) {
                                        AllServices().toastMessage(
                                            'Sync Customer data Done.',
                                            Colors.teal,
                                            Colors.white,
                                            16);

                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        AllServices().toastMessage(
                                            'Didn\'t sync Customer Data',
                                            Colors.red,
                                            Colors.white,
                                            16);

                                        setState(() {
                                          _loading = false;
                                        });
                                      }
                                    } else {
                                      AllServices().toastMessage(
                                          interNetErrorMsg,
                                          Colors.red,
                                          Colors.white,
                                          16);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'CUSTOMER',
                                  sizeWidth: screenWidth,
                                ),
                              ),
                            ],
                          )
                        : const Text(""),
                    Row(
                      children: [
                        userInfo!.dcrFlag
                            ? Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      syncMsg =
                                          'Gift Sample PPM data synchronizing... ';
                                      _loading = true;
                                    });
                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (result == true) {
                                      List dcrGiftList = await DcrRepositories()
                                          .syncDcrGift(dmpathData!.syncUrl, cid,
                                              userId, userPassword);
                                      List sampleList = await DcrRepositories()
                                          .syncDcrSample(dmpathData!.syncUrl,
                                              cid, userId, userPassword);
                                      List ppmList = await DcrRepositories()
                                          .syncDcrPPM(dmpathData!.syncUrl, cid,
                                              userId, userPassword);

                                      if (dcrGiftList.isNotEmpty &&
                                          sampleList.isNotEmpty &&
                                          ppmList.isNotEmpty) {
                                        AllServices().toastMessage(
                                            'Sync Gift Sample PPM data Done.',
                                            Colors.teal,
                                            Colors.white,
                                            16);
                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        AllServices().toastMessage(
                                            'Didn\'t sync Gift Sample PPM Data',
                                            Colors.red,
                                            Colors.white,
                                            16);

                                        setState(() {
                                          _loading = false;
                                        });
                                      }
                                    } else {
                                      AllServices().toastMessage(
                                          interNetErrorMsg,
                                          Colors.red,
                                          Colors.white,
                                          16);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'GIFT\nSAMPLE PPM',
                                  sizeWidth: screenWidth,
                                ),
                              )
                            : const Text(""),
                        userInfo!.rxFlag
                            ? Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      syncMsg =
                                          'Medicine data synchronizing... ';
                                      _loading = true;
                                    });
                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (result == true) {
                                      List rxItemList = await RxRepositories()
                                          .syncRxItem(dmpathData!.syncUrl, cid,
                                              userId, userPassword);
                                      if (rxItemList.isNotEmpty) {
                                        AllServices().toastMessage(
                                            'Sync Medicine data Done.',
                                            Colors.teal,
                                            Colors.white,
                                            16);
                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        AllServices().toastMessage(
                                            'Didn\'t sync Medicine Data',
                                            Colors.red,
                                            Colors.white,
                                            16);
                                        setState(() {
                                          _loading = false;
                                        });
                                      }
                                    } else {
                                      AllServices().toastMessage(
                                          interNetErrorMsg,
                                          Colors.red,
                                          Colors.white,
                                          16);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'MEDICINE\n',
                                  sizeWidth: screenWidth,
                                ),
                              )
                            : const Text(""),
                      ],
                    ),
                    Row(
                      children: [
                        userInfo!.rxFlag || userInfo!.dcrFlag
                            ? Expanded(
                                child: syncCustomBuildButton(
                                  onClick: () async {
                                    setState(() {
                                      syncMsg = 'DCR data synchronizing... ';
                                      _loading = true;
                                    });
                                    bool result =
                                        await InternetConnectionChecker()
                                            .hasConnection;
                                    if (result == true) {
                                      List doctorList = await DcrRepositories()
                                          .syncDCR(dmpathData!.syncUrl, cid,
                                              userId, userPassword);

                                      // RegionListModel? body =
                                      //     await EDsrServices()
                                      //         .getRegionListInHive(
                                      //   "dmpathData!.areaUrl",
                                      //   cid,
                                      //   userInfo!.userId,
                                      //   userPassword,
                                      //   deviceId,
                                      // );

                                      if (doctorList.isNotEmpty) {
                                        AllServices().toastMessage(
                                            'Sync Doctor data Done.',
                                            Colors.teal,
                                            Colors.white,
                                            16);
                                        setState(() {
                                          _loading = false;
                                        });
                                      } else {
                                        AllServices().toastMessage(
                                            'Didn\'t sync Dcr Data',
                                            Colors.red,
                                            Colors.white,
                                            16);

                                        setState(() {
                                          _loading = false;
                                        });
                                      }
                                    } else {
                                      AllServices().toastMessage(
                                          interNetErrorMsg,
                                          Colors.red,
                                          Colors.white,
                                          16);
                                    }
                                  },
                                  color: Colors.white,
                                  title: 'DOCTOR',
                                  sizeWidth: screenWidth,
                                ),
                              )
                            : const Expanded(child: SizedBox()),
                        Expanded(
                          child: syncCustomBuildButton(
                            onClick: () async {
                              setState(() {
                                syncMsg = 'eDSR data synchronizing... ';
                                _loading = true;
                              });
                              bool result = await InternetConnectionChecker()
                                  .hasConnection;
                              if (result == true) {
                                EdsrDataModel? body = await EDsrServices()
                                    .geteDSRDataSettingsInfo(
                                  dmpathData!.submitUrl,
                                  cid,
                                  userInfo!.userId,
                                  userPassword,
                                );

                                if (body != null) {
                                  AllServices().toastMessage(
                                      'Sync eDSR data Done.',
                                      Colors.teal,
                                      Colors.white,
                                      16);
                                  setState(() {
                                    _loading = false;
                                  });
                                } else {
                                  AllServices().toastMessage(
                                      'Didn\'t sync eDSR Data',
                                      Colors.red,
                                      Colors.white,
                                      16);

                                  setState(() {
                                    _loading = false;
                                  });
                                }
                              } else {
                                AllServices().toastMessage(interNetErrorMsg,
                                    Colors.red, Colors.white, 16);
                              }
                            },
                            color: Colors.white,
                            title: 'eDSR',
                            sizeWidth: screenWidth,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: syncCustomBuildButton(
                            onClick: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MyHomePage(
                                    userName: userInfo!.userName,
                                    userId: userInfo!.userId,
                                    userPassword: userPassword,
                                  ),
                                ),
                              );
                            },
                            color: const Color(0xff56CCF2).withOpacity(.4),
                            title: 'Go to Home Page',
                            sizeWidth: screenWidth,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Spacer(),
                        SizedBox(
                          width: screenWidth / 2.5,
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
            ),
    );
  }

// all sync mehtod.....
  syncDataMethod() async {
    List itemList = await OrderRepositories()
        .syncItem(dmpathData!.syncUrl, cid, userId, userPassword);
    List clientList = await OrderRepositories()
        .syncClient(dmpathData!.syncUrl, cid, userId, userPassword);
    List dcrGiftList = await DcrRepositories()
        .syncDcrGift(dmpathData!.syncUrl, cid, userId, userPassword);
    List sampleList = await DcrRepositories()
        .syncDcrSample(dmpathData!.syncUrl, cid, userId, userPassword);
    List ppmList = await DcrRepositories()
        .syncDcrPPM(dmpathData!.syncUrl, cid, userId, userPassword);
    List rxItemList = await RxRepositories()
        .syncRxItem(dmpathData!.syncUrl, cid, userId, userPassword);
    List doctorList = await DcrRepositories()
        .syncDCR(dmpathData!.syncUrl, cid, userId, userPassword);
    EdsrDataModel? eDsRData = await EDsrServices().geteDSRDataSettingsInfo(
      dmpathData!.submitUrl,
      cid,
      userInfo!.userId,
      userPassword,
    );
    if (itemList.isNotEmpty &&
        clientList.isNotEmpty &&
        dcrGiftList.isNotEmpty &&
        sampleList.isNotEmpty &&
        ppmList.isNotEmpty &&
        rxItemList.isNotEmpty &&
        doctorList.isNotEmpty &&
        eDsRData != null) {
      AllServices()
          .toastMessage('Sync all data Done.', Colors.teal, Colors.white, 16);

      setState(() {
        _loading = false;
      });
    } else {
      AllServices()
          .toastMessage('Didn\'t sync Alll Data', Colors.red, Colors.white, 16);

      setState(() {
        _loading = false;
      });
    }
  }
}
