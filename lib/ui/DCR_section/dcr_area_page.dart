import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
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
  String userPassword = '';
  bool _isLoading = false;
  List<String> customerNameList = [];

  @override
  void initState() {
    super.initState();
    // get user and dmPath data from hive
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID")!;
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
          return StatefulBuilder(builder: (BuildContext context, setState1) {
            return InkWell(
              onTap: () async {
                setState1(() {
                  _isLoading = true;
                });
                bool response = await getAreaBaseClient(
                    context,
                    dmpathData!.syncUrl,
                    cid,
                    userInfo!.userId,
                    userPassword,
                    snapshot.data![index]['area_id']);

                setState1(() {
                  _isLoading = response;
                });
              },
              child: Card(
                // color: Colors.blue.withOpacity(.03),
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
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : IconButton(
                                onPressed: () async {
                                  setState1(() {
                                    _isLoading = true;
                                  });
                                  var response = await getDCRAreaBaseClient(
                                      context,
                                      dmpathData!.syncUrl,
                                      cid,
                                      userInfo!.userId,
                                      userPassword,
                                      snapshot.data![index]['area_id']);
                                  if (response["status"] == 'Success') {
                                    List clientList = response['clientList'];

                                    for (var element in clientList) {
                                      customerNameList
                                          .add(element["client_name"]);
                                    }
                                    if (!mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => DcotorInfoScreen(
                                          docId: snapshot.data![index]
                                              ['area_id'],
                                          docName: snapshot.data![index]
                                              ['area_name'],
                                          customerList: customerNameList,
                                        ),
                                      ),
                                    );
                                  }

                                  setState1(() {
                                    _isLoading = false;
                                  });
                                },
                                icon: const Icon(Icons.arrow_forward_ios_sharp),
                              ),
                      ],
                    )),
              ),
            );
          });
        });
  }
}
