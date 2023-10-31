import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/ui/eDSR_section/eDSR_add_screen.dart';
import 'package:MREPORTING/ui/eDSR_section/eDSR_doctor_selection.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EDcrScreen extends StatefulWidget {
  const EDcrScreen({super.key});

  @override
  State<EDcrScreen> createState() => _EDcrScreenState();
}

class _EDcrScreenState extends State<EDcrScreen> {
  Box? box;
  // OthersDataModel? othersData;
  List<RegionList>? regionListData;

  TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  List result = [];
  //String? sharedPrefIntance;
  String? cid;
  String? userId;
  String? password;
  String? region;
  String? territory;
  String? area;
  String dSRType = "";
  Map<String, dynamic> mapData = {
    "dsr_Type": "",
  };

  @override
  void initState() {
    if (Boxes.geteDSRsetData().get("eDSRSettingsData") != null) {
      regionListData =
          Boxes.geteDSRsetData().get("eDSRSettingsData")!.regionList;
    }

    box = Hive.box("doctorList");
    result = box!.toMap().values.toList();
    SharedPreferences.getInstance().then((prefs) {
      cid = prefs.getString("CID")!;
      userId = prefs.getString("USER_ID");
      password = prefs.getString("PASSWORD");
      region = prefs.getString("Region") ?? "";
      area = prefs.getString("Area") ?? "";
      territory = prefs.getString("Territory") ?? "";
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text("eDSR Doctor/Client List"),
          titleTextStyle: const TextStyle(
              color: Color.fromARGB(255, 27, 56, 34),
              fontWeight: FontWeight.w500,
              fontSize: 20),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
                  result.isNotEmpty
                      ? Expanded(
                          flex: 4,
                          child: TextField(
                            controller: searchController,
                            onChanged: (value) {
                              result = box!.toMap().values.toList();
                              result = AllServices().doctorSearch(
                                  value,
                                  result,
                                  'doc_name',
                                  'area_name',
                                  'area_id',
                                  'address');
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Search Doctor/Client.....',
                              suffixIcon: searchController.text.isEmpty &&
                                      searchController.text == ''
                                  ? const Icon(Icons.search)
                                  : IconButton(
                                      onPressed: () {
                                        searchController.clear();
                                        result = box!.toMap().values.toList();

                                        setState(() {
                                          result = AllServices().doctorSearch(
                                              '',
                                              result,
                                              'doc_name',
                                              'area_name',
                                              'area_id',
                                              'address');
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        color: Colors.black,
                                      ),
                                    ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  result.isNotEmpty
                      ? const SizedBox(
                          width: 10,
                        )
                      : const SizedBox(),
                  //******************************************************eDsr doctor Selection******************************************* */
                  Expanded(
                      child: InkWell(
                    onTap: () async {
                      await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return EDsrDoctorSelection(
                                callbackData: mapData,
                                callbackFuc: (value) {
                                  region = value["Region"];
                                  area = value["Area"];
                                  territory = value["Territory"];
                                  dSRType = value["dsr_Type"];
                                  setState(() {});
                                });
                          });
                      setState(() {
                        box = Hive.box("doctorList");
                        result = box!.toMap().values.toList();
                      });
                    },
                    child: Container(
                        height: 58,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            result.isEmpty
                                ? const Text(
                                    "Add Doctor/Client ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 54, 110, 63),
                                        fontWeight: FontWeight.bold),
                                  )
                                : const SizedBox(),
                            const Icon(Icons.add_box_sharp,
                                color: Color.fromARGB(255, 138, 201, 149),
                                size: 40),
                          ],
                        )),
                  ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " $region ",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(" $area ",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15)),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      // ignore: unnecessary_null_comparison
                      territory == null
                          ? const Text(
                              " ",
                            )
                          : Text(
                              " $territory ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15),
                            ),
                    ],
                  )),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => EDSRScreen(
                                      docInfo: result,
                                      dsrType: dSRType,
                                      index: index,
                                    )));
                        // widget.getList.first.docName =
                        //     result[index]['doc_name'];
                        // widget.getList.first.docId = result[index]['doc_id'];
                        // widget.getList.first.areaName =
                        //     result[index]['area_name'];
                        // widget.getList.first.areaId = result[index]['area_id'];
                        // widget.getList.first.address = result[index]['address'];
                        // widget.getListFunction(widget.getList);
                        // //finalDoctorList.clear();

                        // // finalDoctorListfirst.docName =
                        // //     result[index]['doc_name'];
                        // // finalDoctorList.first.docId = result[index]['doc_id'];
                        // // finalDoctorList.first.areaName =
                        // //     result[index]['area_name'];
                        // // finalDoctorList.first.address =
                        // //     result[index]['address'];

                        // // docName = result[index]['doc_name'];
                        // // docArea = "";
                        // // docAreaId = "";
                        // // docAreaAddreess = "";

                        // Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          //elevation: 7,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(6, 2, 6, 2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  result[index]["doc_name"],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "${result[index]["area_name"]}  (${result[index]["area_id"]}),",
                                ),
                                Text(
                                  "${result[index]["address"]}",
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            )
          ],
        )
        //   ;
        // })
        ,
      ),
    );
  }
}
