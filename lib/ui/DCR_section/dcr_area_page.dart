import 'package:MREPORTING/ui/DCR_section/add_doctor.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
// import 'package:MREPORTING/models/area_page_model.dart';
import 'package:MREPORTING/services/apiCall.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DCRAreaPage extends StatefulWidget {
  const DCRAreaPage({Key? key}) : super(key: key);

  @override
  State<DCRAreaPage> createState() => _DCRAreaPageState();
}

class _DCRAreaPageState extends State<DCRAreaPage> {
  String cid = '';
  String userId = '';
  String userPassword = '';
  String areaPageUrl = '';
  String syncUrl = '';
  bool _isLoading = false;
  List<String> customerNameList = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        cid = prefs.getString("CID")!;
        userId = prefs.getString("USER_ID")!;
        areaPageUrl = prefs.getString('user_area_url')!;
        userPassword = prefs.getString("PASSWORD")!;
        syncUrl = prefs.getString("sync_url")!;
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
          future: getAreaPage(areaPageUrl, cid, userId, userPassword),
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
                            bool response = await getAreaBaseClient(
                                context,
                                syncUrl,
                                cid,
                                userId,
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
                                        : IconButton(
                                            onPressed: () async {
                                              setState1(() {
                                                _isLoading = true;
                                              });
                                              var response =
                                                  await getDCRAreaBaseClient(
                                                      context,
                                                      syncUrl,
                                                      cid,
                                                      userId,
                                                      userPassword,
                                                      snapshot.data![index]
                                                          ['area_id']);
                                              print("response $response");
                                              if (response["status"] ==
                                                  'Success') {
                                                List clientList =
                                                    response['clientList'];
                                                print(clientList);

                                                clientList.forEach((element) {
                                                  customerNameList.add(
                                                      element["client_name"]);
                                                });
                                                if (!mounted) return;
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        DcotorInfoScreen(
                                                      docId:
                                                          snapshot.data![index]
                                                              ['area_id'],
                                                      docName:
                                                          snapshot.data![index]
                                                              ['area_name'],
                                                      customerList:
                                                          customerNameList,
                                                    ),
                                                  ),
                                                );
                                              }

                                              setState1(() {
                                                _isLoading = false;
                                              });
                                            },
                                            icon: const Icon(
                                                Icons.arrow_forward_ios_sharp),
                                          ),
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
