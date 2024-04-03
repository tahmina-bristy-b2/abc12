import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/others/repositories.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_list_page.dart';
import 'package:MREPORTING/ui/order_sections/customerListPage.dart';
import 'package:MREPORTING/ui/rx_target_section/rx_target_client_screen.dart';
import 'package:MREPORTING/ui/rx_target_section/rx_target_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'eCME_section/e_cme_doctor_list_new.dart';

class AreaPage extends StatefulWidget {
  String screenName;
  AreaPage({
    Key? key,
    required this.screenName,
  }) : super(key: key);

  @override
  State<AreaPage> createState() => _AreaPageState();
}

class _AreaPageState extends State<AreaPage> {
  String cid = '';
  String userPassword = '';
  bool _isLoading = false;

  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  @override
  void initState() {
    super.initState();

    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID") ?? " ";
        userPassword = prefs.getString("PASSWORD")!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Area Page'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Repositories().areaRepo(
              dmpathData!.userAreaUrl, cid, userInfo!.userId, userPassword),
          builder: ((context, AsyncSnapshot<List> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('${snapshot.error} occured');
              } else if (snapshot.data != null) {
                return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return StatefulBuilder(
                          builder: (BuildContext context, setState1) {
                        return InkWell(
                          onTap: () async {
                            setState1(() {
                              _isLoading = true;
                            });
                            // bool response = false;

                            if (widget.screenName == 'order') {
                              List clientList = await Repositories()
                                  .areaBaseClientRepo(
                                      dmpathData!.syncUrl,
                                      cid,
                                      userInfo!.userId,
                                      userPassword,
                                      snapshot.data![index]['area_id']);

                                      //print("clientList===$clientList");

                              if (clientList.isNotEmpty) {
                                // response = true;
                                setState1(() {
                                  _isLoading = false;
                                });

                                if (!mounted) return;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => CustomerListScreen(
                                              data: clientList,
                                            )));
                              } else {
                                setState1(() {
                                  _isLoading = false;
                                });
                                AllServices().toastMessage(
                                    'Customer Loading failed!',
                                    Colors.red,
                                    Colors.white,
                                    16);
                              }
                            } 
                            
                            else if (widget.screenName == 'dcr') {
                              List chemistList = await Repositories()
                                  .areaBaseDoctorRepo(
                                      dmpathData!.syncUrl,
                                      cid,
                                      userInfo!.userId,
                                      userPassword,
                                      snapshot.data![index]['area_id']);
                                     // print("chemistList=====$chemistList");

                              if (chemistList.isNotEmpty) {
                                // response = true;
                                setState1(() {
                                  _isLoading = false;
                                });

                                if (!mounted) return;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => DcrListPage(
                                              dcrDataList: chemistList,
                                            )));
                              } else {
                                setState1(() {
                                  _isLoading = false;
                                });
                                AllServices().toastMessage(
                                    'Doctor Loading failed!',
                                    Colors.red,
                                    Colors.white,
                                    16);
                              }
                            }

                            else if (widget.screenName == 'chemist census') {
                              List chemistList = await Repositories()
                                  .areaBaseClientRepo(
                                      dmpathData!.syncUrl,
                                      cid,
                                      userInfo!.userId,
                                      userPassword,
                                      snapshot.data![index]['area_id']);

                              if (chemistList.isNotEmpty) {
                              
                                setState1(() {
                                  _isLoading = false;
                                });

                                if (!mounted) return;
                                Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                   ClientCensusScreen(syncClientList: chemistList)));
                              } else {
                                setState1(() {
                                  _isLoading = false;
                                });
                                AllServices().toastMessage(
                                    'Chemist Loading failed!',
                                    Colors.red,
                                    Colors.white,
                                    16);
                              }
                            }

                            else if (widget.screenName == 'doctor census') {
                              List doctorList = await Repositories()
                                  .areaBaseDoctorRepo(
                                      dmpathData!.syncUrl,
                                      cid,
                                      userInfo!.userId,
                                      userPassword,
                                      snapshot.data![index]['area_id']);
                              if (doctorList.isNotEmpty) {
                                setState1(() {
                                  _isLoading = false;
                                });

                                 if (!mounted) return;
                                             Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => RxTargetScreen(syncDoctorList: doctorList)
                                            ),
                                          );
                              } else {
                                setState1(() {
                                  _isLoading = false;
                                });
                                AllServices().toastMessage(
                                    'Doctor Loading failed!',
                                    Colors.red,
                                    Colors.white,
                                    16);
                              }
                            }
                             else if (widget.screenName == 'e-CME') {
                              List chemistList = await Repositories()
                                  .areaBaseDoctorRepo(
                                      dmpathData!.syncUrl,
                                      cid,
                                      userInfo!.userId,
                                      userPassword,
                                      snapshot.data![index]['area_id']);
                              if (chemistList.isNotEmpty) {
                                setState1(() {
                                  _isLoading = false;
                                });
                                ECMESavedDataModel?  eCMEDataModelData=Boxes.geteCMEsetData().get("eCMESavedDataSync");
                                                    if(eCMEDataModelData!=null){
                                                      if (!mounted) return;
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (_) => ECMEDoctorList(
                                                              dcrDataList: chemistList),
                                                        ),
                                                      );

                                                    }
                                                    else{
                                                        AllServices().toastMessage(
                                                          'e_CME Data Sync First ',
                                                          Colors.red,
                                                          Colors.white,
                                                          16);}
                               } else {
                                setState1(() {
                                  _isLoading = false;
                                });
                                AllServices().toastMessage(
                                    'Doctor Loading failed!',
                                    Colors.red,
                                    Colors.white,
                                    16);
                              }
                            }
                          },
                          child: Card(
                       
                            elevation: 2,
                            child: SizedBox(
                                height: 40,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        snapshot.data![index]['area_name'],
                                      ),
                                    ),
                                    _isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : const Icon(
                                            Icons.arrow_forward_ios_sharp),
                                  ],
                                )),
                          ),
                        );
                      });
                    });
              }
            } else {}
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
        ),
      ),
    );
  }
}
