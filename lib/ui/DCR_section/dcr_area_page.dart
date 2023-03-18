import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/doc_settings_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/ui/DCR_section/add_doctor.dart';
import 'package:flutter/material.dart';
import 'package:MREPORTING/services/apiCall.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DCRAreaPage extends StatefulWidget {
  const DCRAreaPage({Key? key}) : super(key: key);

  @override
  State<DCRAreaPage> createState() => _DCRAreaPageState();
}

class _DCRAreaPageState extends State<DCRAreaPage> {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  String cid = '';
  // String userId = '';
  String userPassword = '';
  // String areaPageUrl = '';
  // String syncUrl = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID")!;
        // userId = prefs.getString("USER_ID")!;
        // areaPageUrl = prefs.getString('user_area_url')!;
        userPassword = prefs.getString("PASSWORD")!;
        // syncUrl = prefs.getString("sync_url")!;
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
          future: getAreaPage(
              dmpathData!.userAreaUrl, cid, userInfo!.userId, userPassword),
          builder: ((context, AsyncSnapshot<List> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text('${snapshot.error} occured');
              } else if (snapshot.data != null) {
                return areaListViewBuilder(snapshot);
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

  ListView areaListViewBuilder(AsyncSnapshot<List<dynamic>> snapshot) {
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
                List clientList = await DcrRepositories().getDCRAreaBaseClient(
                    dmpathData!.syncUrl,
                    cid,
                    userInfo!.userId,
                    userPassword,
                    snapshot.data![index]['area_id']);
                if (clientList.isNotEmpty) {
                  final DocSettingsModel? responseOfDocSettings =
                      await DcrRepositories()
                          .docSettingsRepo(cid, userInfo!.userId, userPassword);

                  if (responseOfDocSettings != null) {
                    setState1(() {
                      _isLoading = false;
                    });
                    // if (!mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DcotorInfoScreen(
                          isEdit: false,
                          areaName: snapshot.data![index]['area_name'],
                          customerList: clientList,
                          docSettings: responseOfDocSettings,
                        ),
                      ),
                    );
                  } else {
                    setState1(() {
                      _isLoading = false;
                    });
                  }
                } else {
                  _isLoading = false;
                }

                // print(
                //     "ki! response ashce! ${responseOfDocSettings.resData.brandList}");

                // if (responseOfDocSettings.resData ==
                //     "Success") {
                // List category = responseOfDocSettings["d_category_list"];
                // List collarSize = responseOfDocSettings["collar_size_list"];
                // List disThanaList = responseOfDocSettings["dist_thana_list"];
                // List docCategory = responseOfDocSettings["doc_category_list"];
                // List docCategory = responseOfDocSettings["doc_category_list"];

                // List clientList =
                //     response['clientList'];
                // print(clientList);

                // clientList.forEach((element) {
                //   customerNameList.add(
                //       element["client_name"]);
                // });

                // }

                // setState1(() {
                //   _isLoading = false;
                // });
              },
              child: Card(
                elevation: 2,
                child: SizedBox(
                    height: 40,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            snapshot.data![index]['area_name'],
                          ),
                        ),
                        _isLoading
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator())
                            : const Icon(Icons.arrow_forward_ios_outlined)
                      ],
                    )),
              ),
            );
          },
        );
      },
    );
  }
}
