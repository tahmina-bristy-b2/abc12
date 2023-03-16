import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/apiCall.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/ui/DCR_section/add_doctor.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_area_page.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_gift_sample_PPM_page.dart';

import 'package:MREPORTING/ui/Widgets/customerListWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DcrListPage extends StatefulWidget {
  List dcrDataList;

  DcrListPage({Key? key, required this.dcrDataList}) : super(key: key);

  @override
  State<DcrListPage> createState() => _DcrListPageState();
}

class _DcrListPageState extends State<DcrListPage> {
  // Box<DmPathDataModel> dmpathBox = Boxes.getDmpath();
  DmPathDataModel? dmpathData;

  Box? box;
  String cid = '';

  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    // print(dmpathBox.values);
    dmpathData = Boxes.getDmpath().get("dmPathData");
    SharedPreferences.getInstance().then((prefs) {
      cid = prefs.getString("CID")!;
      if (prefs.getInt("_dcrcounter") != null) {
        int? a = prefs.getInt("_dcrcounter");

        setState(() {
          _counter = a!;
        });
      }
    });
    foundUsers = widget.dcrDataList;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('_dcrcounter', _counter);
    });

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text('Doctor List'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                (MaterialPageRoute(
                  builder: (context) => DCRAreaPage(),
                )),
              );
            },
            icon: const Icon(Icons.person_add),
          )
        ],
      ),

      // endDrawer: Drawer(
      //   // Add a ListView to the drawer. This ensures the user can scroll,
      //   // through the options in the drawer if there isn't enough vertical,
      //   // space to fit everything.
      //   child: ListView(
      //     // Important: Remove any padding from the ListView.
      //     padding: EdgeInsets.zero,
      //     children: [
      //       DrawerHeader(
      //         decoration: const BoxDecoration(
      //             color: Color.fromARGB(255, 138, 201, 149)),
      //         child: Column(
      //           children: [
      //             Image.asset('assets/images/mRep7_logo.png'),
      //             // Expanded(
      //             //   child: Text(
      //             //     '${widget.clientName}',
      //             //     // 'Chemist: ADEE MEDICINE CORNER(6777724244)',
      //             //     style: const TextStyle(
      //             //         color: Colors.white,
      //             //         fontSize: 18,
      //             //         fontWeight: FontWeight.bold),
      //             //   ),
      //             // ),
      //             // Expanded(
      //             //     child: Text(
      //             //   widget.clientId,
      //             //   style: const TextStyle(
      //             //       color: Colors.white,
      //             //       fontSize: 15,
      //             //       fontWeight: FontWeight.bold),
      //             // ))
      //           ],
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.person_add, color: Colors.blueAccent),
      //         title: const Text(
      //           'Doctor',
      //           style: TextStyle(
      //             fontSize: 14,
      //             fontWeight: FontWeight.w500,
      //             color: Color.fromARGB(255, 15, 53, 85),
      //           ),
      //         ),
      //         onTap: () {
      //           Navigator.push(
      //             context,
      //             (MaterialPageRoute(
      //               builder: (context) => DCRAreaPage(),
      //             )),
      //           );
      //         },
      //       )
      //       // Link(
      //       //     uri: Uri.parse(
      //       //         '$doctor_url?cid=$cid&rep_id=$userId&rep_pass=$userPassword'),
      //       //     target: LinkTarget.blank,
      //       //     builder: (BuildContext ctx, FollowLink? openLink) {
      //       //       return ListTile(
      //       //         onTap: openLink,
      //       //         leading:
      //       //             const Icon(Icons.person_add, color: Colors.blueAccent),
      //       //         title: const Text(
      //       //           'Doctor',
      //       //           style: TextStyle(
      //       //               fontSize: 14,
      //       //               fontWeight: FontWeight.w500,
      //       //               color: Color.fromARGB(255, 15, 53, 85)),
      //       //         ),
      //       //       );
      //       //     }),
      //       // ListTile(
      //       //   leading: const Icon(Icons.document_scanner_outlined,
      //       //       color: Colors.black),
      //       //   title: const Text('Report'),
      //       //   onTap: () {
      //       //     // Update the state of the app.
      //       //   },
      //       // ),
      //     ],
      //   ),
      // ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    foundUsers = AllServices().searchDynamicMethod(
                        value, widget.dcrDataList, "doc_name");
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  labelText: ' Search',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();

                            // runFilter('');
                            setState(() {
                              foundUsers = AllServices().searchDynamicMethod(
                                  "", widget.dcrDataList, "doc_name");
                            });
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                            // size: 28,
                          ),
                        ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 9,
            child: foundUsers.isNotEmpty
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: searchController.text.isNotEmpty
                        ? foundUsers.length
                        : widget.dcrDataList.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext itemBuilder, index) {
                      return GestureDetector(
                        onTap: () {
                          _incrementCounter();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DcrGiftSamplePpmPage(
                                        ck: '',
                                        dcrKey: 0,
                                        uniqueId: _counter,
                                        draftOrderItem: [],
                                        docName: foundUsers[index]['doc_name'],
                                        docId: foundUsers[index]['doc_id'],
                                        areaName: foundUsers[index]
                                            ['area_name'],
                                        areaId: foundUsers[index]['area_id'],
                                        address: foundUsers[index]['address'],
                                      )));
                        },
                        child: CustomerListCardWidget(
                          clientName: foundUsers[index]['doc_name'] +
                              '(${foundUsers[index]['doc_id']})',
                          base: foundUsers[index]['area_name'] +
                              '(${foundUsers[index]['area_id']})',
                          marketName: foundUsers[index]['address'],
                          outstanding: '',
                          icon: const Icon(
                            Icons.edit,
                            color: Color.fromARGB(255, 138, 201, 149),
                          ),
                          boolIcon: true,
                          onPressed: () async {
                            var areaCustomerList = await DcrRepositories()
                                .getDCRAreaBaseClient(
                                    dmpathData!.syncUrl,
                                    cid,
                                    userId,
                                    userPassword,
                                    foundUsers[index]['area_id'].toString());

                            if (!mounted) return;
                            Navigator.push(
                                context,
                                (MaterialPageRoute(
                                    builder: (context) => DcotorInfoScreen(
                                        areaName: foundUsers[index]
                                            ['area_name'],
                                        docID: foundUsers[index]["doc_id"],
                                        docName: foundUsers[index]['doc_name'],
                                        customerList: areaCustomerList))));
                          },
                        ),
                      );
                    })
                : const Text(
                    'No results found',
                    style: TextStyle(fontSize: 24),
                  ),
          ),
        ],
      ),
    );
  }
}
