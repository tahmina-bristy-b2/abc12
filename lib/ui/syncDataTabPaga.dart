// ignore_for_file: non_constant_identifier_names, unused_local_variable, file_names

import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';
import 'package:MREPORTING_OFFLINE/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/e_CME/e_cme_category_List_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/login_user_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING_OFFLINE/services/eCME/eCMe_repositories.dart';
import 'package:MREPORTING_OFFLINE/services/eDSR/eDSR_services.dart';
import 'package:MREPORTING_OFFLINE/services/expired_dated/expired_repositories.dart';
import 'package:MREPORTING_OFFLINE/services/order/order_repositories.dart';
import 'package:MREPORTING_OFFLINE/services/rx/rx_repositories.dart';
import 'package:MREPORTING_OFFLINE/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:MREPORTING_OFFLINE/ui/homePage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:MREPORTING_OFFLINE/ui/Widgets/syncCustomButton.dart';
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
                    // Row(
                    //   children: [
                    //     userInfo!.dcrFlag
                    //         ? Expanded(
                    //             child: syncCustomBuildButton(
                    //               onClick: () async {
                    //                 setState(() {
                    //                   syncMsg =
                    //                       'Gift Sample PPM data synchronizing... ';
                    //                   _loading = true;
                    //                 });
                    //                 bool result =
                    //                     await InternetConnectionChecker()
                    //                         .hasConnection;
                    //                 if (result == true) {
                    //                   List dcrGiftList = await DcrRepositories()
                    //                       .syncDcrGift(dmpathData!.syncUrl, cid,
                    //                           userId, userPassword);
                    //                   List sampleList = await DcrRepositories()
                    //                       .syncDcrSample(dmpathData!.syncUrl,
                    //                           cid, userId, userPassword);
                    //                   List ppmList = await DcrRepositories()
                    //                       .syncDcrPPM(dmpathData!.syncUrl, cid,
                    //                           userId, userPassword);

                    //                   if (dcrGiftList.isNotEmpty &&
                    //                       sampleList.isNotEmpty &&
                    //                       ppmList.isNotEmpty) {
                    //                     AllServices().toastMessage(
                    //                         'Sync Gift Sample PPM data Done.',
                    //                         Colors.teal,
                    //                         Colors.white,
                    //                         16);
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   } else {
                    //                     AllServices().toastMessage(
                    //                         'Didn\'t sync Gift Sample PPM Data',
                    //                         Colors.red,
                    //                         Colors.white,
                    //                         16);

                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   }
                    //                 } else {
                    //                   AllServices().toastMessage(
                    //                       interNetErrorMsg,
                    //                       Colors.red,
                    //                       Colors.white,
                    //                       16);
                    //                 }
                    //               },
                    //               color: Colors.white,
                    //               title: 'GIFT\nSAMPLE PPM',
                    //               sizeWidth: screenWidth,
                    //             ),
                    //           )
                    //         : const Text(""),
                    //     userInfo!.rxFlag
                    //         ? Expanded(
                    //             child: syncCustomBuildButton(
                    //               onClick: () async {
                    //                 setState(() {
                    //                   syncMsg =
                    //                       'Medicine data synchronizing... ';
                    //                   _loading = true;
                    //                 });
                    //                 bool result =
                    //                     await InternetConnectionChecker()
                    //                         .hasConnection;
                    //                 if (result == true) {
                    //                   List rxItemList = await RxRepositories()
                    //                       .syncRxItem(dmpathData!.syncUrl, cid,
                    //                           userId, userPassword);
                    //                   if (rxItemList.isNotEmpty) {
                    //                     AllServices().toastMessage(
                    //                         'Sync Medicine data Done.',
                    //                         Colors.teal,
                    //                         Colors.white,
                    //                         16);
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   } else {
                    //                     AllServices().toastMessage(
                    //                         'Didn\'t sync Medicine Data',
                    //                         Colors.red,
                    //                         Colors.white,
                    //                         16);
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   }
                    //                 } else {
                    //                   AllServices().toastMessage(
                    //                       interNetErrorMsg,
                    //                       Colors.red,
                    //                       Colors.white,
                    //                       16);
                    //                 }
                    //               },
                    //               color: Colors.white,
                    //               title: 'MEDICINE\n',
                    //               sizeWidth: screenWidth,
                    //             ),
                    //           )
                    //         : const Text(""),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     userInfo!.rxFlag || userInfo!.dcrFlag
                    //         ? Expanded(
                    //             child: syncCustomBuildButton(
                    //               onClick: () async {
                    //                 setState(() {
                    //                   syncMsg = 'DCR data synchronizing... ';
                    //                   _loading = true;
                    //                 });
                    //                 bool result =
                    //                     await InternetConnectionChecker()
                    //                         .hasConnection;
                    //                 if (result == true) {
                    //                   List doctorList = await DcrRepositories()
                    //                       .syncDCR(dmpathData!.syncUrl, cid,
                    //                           userId, userPassword);

                    //                   // RegionListModel? body =
                    //                   //     await EDSRServices()
                    //                   //         .getRegionListInHive(
                    //                   //   "dmpathData!.areaUrl",
                    //                   //   cid,
                    //                   //   userInfo!.userId,
                    //                   //   userPassword,
                    //                   //   deviceId,
                    //                   // );

                    //                   if (doctorList.isNotEmpty) {
                    //                     AllServices().toastMessage(
                    //                         'Sync Doctor data Done.',
                    //                         Colors.teal,
                    //                         Colors.white,
                    //                         16);
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   } else {
                    //                     AllServices().toastMessage(
                    //                         'Didn\'t sync Dcr Data',
                    //                         Colors.red,
                    //                         Colors.white,
                    //                         16);

                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   }
                    //                 } else {
                    //                   AllServices().toastMessage(
                    //                       interNetErrorMsg,
                    //                       Colors.red,
                    //                       Colors.white,
                    //                       16);
                    //                 }
                    //               },
                    //               color: Colors.white,
                    //               title: 'DOCTOR',
                    //               sizeWidth: screenWidth,
                    //             ),
                    //           )
                    //         : const Expanded(child: SizedBox()),
                    //     Expanded(
                    //       child: syncCustomBuildButton(
                    //         onClick: () async {
                    //           setState(() {
                    //             syncMsg = 'eDSR data synchronizing... ';
                    //             _loading = true;
                    //           });
                    //           bool result = await InternetConnectionChecker()
                    //               .hasConnection;
                    //           if (result == true) {
                    //             EdsrDataModel? body = await EDSRServices()
                    //                 .geteDSRDataSettingsInfo(
                    //                     dmpathData!.submitUrl,
                    //                     cid,
                    //                     userInfo!.userId,
                    //                     userPassword,
                    //                     "");

                    //             if (body != null) {
                    //               AllServices().toastMessage(
                    //                   'Sync eDSR data Done.',
                    //                   Colors.teal,
                    //                   Colors.white,
                    //                   16);
                    //               setState(() {
                    //                 _loading = false;
                    //               });
                    //             } else {
                    //               setState(() {
                    //                 _loading = false;
                    //               });
                    //             }
                    //           } else {
                    //             AllServices().toastMessage(interNetErrorMsg,
                    //                 Colors.red, Colors.white, 16);
                    //           }
                    //         },
                    //         color: Colors.white,
                    //         title: 'eDSR',
                    //         sizeWidth: screenWidth,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // Row(
                    //   children: [
                    //     userInfo!.expiredFlag == true
                    //         ? Expanded(
                    //             child: syncCustomBuildButton(
                    //               onClick: () async {
                    //                 setState(() {
                    //                   syncMsg =
                    //                       'Expired data synchronizing... ';
                    //                   _loading = true;
                    //                 });
                    //                 bool result =
                    //                     await InternetConnectionChecker()
                    //                         .hasConnection;
                    //                 if (result == true) {
                    //                   ExpiredItemListDataModel? doctorList =
                    //                       await ExpiredRepositoryRepo()
                    //                           .syncExpiredItems(
                    //                               "",
                    //                               dmpathData!.syncUrl,
                    //                               cid,
                    //                               userId,
                    //                               userPassword);
                    //                   if (ExpiredItemListDataModel != null) {
                    //                     // AllServices().toastMessage(
                    //                     //     'Sync Expired data Done.',
                    //                     //     Colors.teal,
                    //                     //     Colors.white,
                    //                     //     16);
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   } else {
                    //                     // AllServices().toastMessage(
                    //                     //     'Didn\'t sync Dcr Data',
                    //                     //     Colors.red,
                    //                     //     Colors.white,
                    //                     //     16);

                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   }
                    //                 } else {
                    //                   AllServices().toastMessage(
                    //                       interNetErrorMsg,
                    //                       Colors.red,
                    //                       Colors.white,
                    //                       16);
                    //                 }
                    //               },
                    //               color: Colors.white,
                    //               title: 'Expired\nDated Items',
                    //               sizeWidth: screenWidth,
                    //             ),
                    //           )
                    //         : const SizedBox(),
                    //     userInfo!.ecmeAddFlag == true
                    //         ? Expanded(
                    //             child: syncCustomBuildButton(
                    //               onClick: () async {
                    //                 setState(() {
                    //                   syncMsg = 'CME data synchronizing... ';
                    //                   _loading = true;
                    //                 });
                    //                 bool result =
                    //                     await InternetConnectionChecker()
                    //                         .hasConnection;
                    //                 if (result == true) {
                    //                   ECMESavedDataModel? body =
                    //                       await ECMERepositry()
                    //                           .getECMESettingsData(
                    //                               dmpathData!.submitUrl,
                    //                               cid,
                    //                               userInfo!.userId,
                    //                               userPassword,
                    //                               "");

                    //                   EcmeDoctorCategoryDataModel?
                    //                       doctorCategoryList =
                    //                       await ECMERepositry()
                    //                           .getCategoryforSync(
                    //                               dmpathData!.submitUrl,
                    //                               cid,
                    //                               userInfo!.userId,
                    //                               userPassword,
                    //                               "");

                    //                   if (body != null &&
                    //                       doctorCategoryList!
                    //                               .resData.docSpecialtyList !=
                    //                           []) {
                    //                     AllServices().toastMessage(
                    //                         'Sync CME data Done.',
                    //                         Colors.teal,
                    //                         Colors.white,
                    //                         16);
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   } else {
                    //                     setState(() {
                    //                       _loading = false;
                    //                     });
                    //                   }
                    //                 } else {
                    //                   AllServices().toastMessage(
                    //                       interNetErrorMsg,
                    //                       Colors.red,
                    //                       Colors.white,
                    //                       16);
                    //                 }
                    //               },
                    //               color: Colors.white,
                    //               title: 'CME',
                    //               sizeWidth: screenWidth,
                    //             ),
                    //           )
                    //         : const SizedBox(),
                    //   ],
                    // ),
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
                          width: screenWidth / 2.1,
                          child: const Text(
                            loginPageVersionName,
                            style: TextStyle(fontSize: 16, color: Colors.blue),
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
    // List dcrGiftList = await DcrRepositories()
    //     .syncDcrGift(dmpathData!.syncUrl, cid, userId, userPassword);
    // List sampleList = await DcrRepositories()
    //     .syncDcrSample(dmpathData!.syncUrl, cid, userId, userPassword);
    // List ppmList = await DcrRepositories()
    //     .syncDcrPPM(dmpathData!.syncUrl, cid, userId, userPassword);
    // List rxItemList = await RxRepositories()
    //     .syncRxItem(dmpathData!.syncUrl, cid, userId, userPassword);
    // List doctorList = await DcrRepositories()
    //     .syncDCR(dmpathData!.syncUrl, cid, userId, userPassword);
    // EdsrDataModel? eDsRData = await EDSRServices().geteDSRDataSettingsInfo(
    //     dmpathData!.submitUrl, cid, userInfo!.userId, userPassword, "all");
    // ExpiredItemListDataModel? expiredItemsData = await ExpiredRepositoryRepo()
    //     .syncExpiredItems(
    //         "all", dmpathData!.syncUrl, cid, userId, userPassword);
    // ECMESavedDataModel? ecmeSavedData = await ECMERepositry()
    //     .getECMESettingsData(
    //         dmpathData!.submitUrl, cid, userInfo!.userId, userPassword, "All");

    // EcmeDoctorCategoryDataModel? doctorCategoryList = await ECMERepositry()
    //     .getCategoryforSync(
    //         dmpathData!.submitUrl, cid, userInfo!.userId, userPassword, "All");

    if (itemList.isNotEmpty && clientList.isNotEmpty
        //  &&
        // dcrGiftList.isNotEmpty &&
        // sampleList.isNotEmpty &&
        // ppmList.isNotEmpty &&
        // rxItemList.isNotEmpty &&
        // doctorList.isNotEmpty &&
        // (eDsRData == null || eDsRData != null) &&
        // (expiredItemsData != null || expiredItemsData == null) &&
        // (ecmeSavedData == null || ecmeSavedData != null) &&
        // (doctorCategoryList == null || doctorCategoryList != null)

        ) {
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
