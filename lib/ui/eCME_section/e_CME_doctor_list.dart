import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/ui/eCME_section/eCME_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECMEClientScreen extends StatefulWidget {
  const ECMEClientScreen({super.key});

  @override
  State<ECMEClientScreen> createState() => _ECMEClientScreenState();
}

class _ECMEClientScreenState extends State<ECMEClientScreen> {
  Box? box;
  List<RegionList>? regionListData;

  TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  List result = [];
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
  Map<String,bool> doctorSelectionMap={};
  List doctInfo=[];
  bool isConfirm=false;


  @override
  void initState() {
    if (Boxes.geteDSRsetData().get("eDSRSettingsData") != null) {
      regionListData =
          Boxes.geteDSRsetData().get("eDSRSettingsData")!.regionList;
    }
    

    box = Hive.box("doctorList");
    result = box!.toMap().values.toList();
    if(result.isNotEmpty){
      for (var element in result) {
        doctorSelectionMap[element["doc_id"]]=false;
      }}
    
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
    isConfirm = doctorSelectionMap.containsValue(true);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 138, 201, 149),
          title: const Text("e-CME Doctor List"),
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
                  box!.isNotEmpty
                      ? Expanded(
                          flex: 5,
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                              
                                child: Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color.fromARGB(255, 240, 246, 246),
                                    border: Border.all(color: const Color.fromARGB(255, 138, 201, 149),)
                                  ),
                                  child: TextFormField(
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
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText:" Search doctor.....",
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      suffixIcon: searchController.text.isEmpty &&
                                              searchController.text == ''
                                          ? const Icon(Icons.search,color: Colors.grey,)
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
                                                color: Colors.teal
                                              
                                              ),
                                            ),
                  ),
                ),
              ),
          ),
        ],
      ),
    ))
                      
                      
                      //  Expanded(
                      //     flex: 4,
                      //     child: TextField(
                      //       controller: searchController,
                      //       onChanged: (value) {
                      //         result = box!.toMap().values.toList();
                      //         result = AllServices().doctorSearch(
                      //             value,
                      //             result,
                      //             'doc_name',
                      //             'area_name',
                      //             'area_id',
                      //             'address');
                      //         setState(() {});
                      //       },
                      //       decoration: InputDecoration(
                      //         border: const OutlineInputBorder(),
                      //         labelText: 'Search Doctor/Client.....',
                      //         suffixIcon: searchController.text.isEmpty &&
                      //                 searchController.text == ''
                      //             ? const Icon(Icons.search)
                      //             : IconButton(
                      //                 onPressed: () {
                      //                   searchController.clear();
                      //                   result = box!.toMap().values.toList();

                      //                   setState(() {
                      //                     result = AllServices().doctorSearch(
                      //                         '',
                      //                         result,
                      //                         'doc_name',
                      //                         'area_name',
                      //                         'area_id',
                      //                         'address');
                      //                   });
                      //                 },
                      //                 icon: const Icon(
                      //                   Icons.clear,
                      //                   color: Colors.black,
                      //                 ),
                      //               ),
                      //       ),
                      //     ),
                      //   )




                      : const SizedBox(),
                  box!.isNotEmpty
                      ? const SizedBox(
                          width: 10,
                        )
                      : const SizedBox(),
                  //******************************************************eCME doctor Selection******************************************* */
                  // Expanded(
                  //     child: InkWell(
                  //   onTap: () async {
                  //     // await showDialog(
                  //     //     context: context,
                  //     //     builder: (BuildContext context) {
                  //     //       return ECMETypeSelection(
                  //     //           callbackData: mapData,
                  //     //           callbackFuc: (value) {
                  //     //             region = value["Region"];
                  //     //             area = value["Area"];
                  //     //             territory = value["Territory"];
                  //     //             dSRType = value["dsr_Type"];
                  //     //             setState(() {});
                  //     //           });
                  //     //     });
                  //     // setState(() {
                  //     //   box = Hive.box("doctorList");
                  //     //   result = box!.toMap().values.toList();
                  //     // });
                  //   },
                  //   child: Container(
                  //       height: 50,
                  //      // width: ,
                  //       decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Colors.teal,
                  //           ),
                  //           borderRadius: BorderRadius.circular(8)),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           box!.isEmpty
                  //               ? const Text(
                  //                   "Add Doctor ",
                  //                   style: TextStyle(
                  //                       fontSize: 16,
                  //                       color: Color.fromARGB(255, 54, 110, 63),
                  //                       fontWeight: FontWeight.bold),
                  //                 )
                  //               : const SizedBox(),
                  //           const Icon(Icons.add_box_sharp,
                  //               color: Color.fromARGB(255, 138, 201, 149),
                  //               size: 40),
                  //         ],
                  //       )),
                  // ))
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8,right: 8,bottom: 8),
              child: Row(
                children: [
                  Expanded(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        " $region ",
                        style: const TextStyle(
                          color: Colors.black,
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      Text(" $area ",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 15,color: Colors.black,)),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                    
                      territory == null
                          ? const Text(
                              " ",
                            )
                          : Text(
                              " $territory ",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 15,color: Colors.black,),
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
                    return Padding(
                      padding: const EdgeInsets.only(left: 6,right: 6,top: 6),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:doctorSelectionMap[result[index]["doc_id"]]==true?
                                const Color.fromARGB(255, 243, 251, 245)
                                
                                :Colors.white
                        ),
                        child: Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.grey),
                          child: CheckboxListTile(
                            checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                              activeColor: const Color.fromARGB(255, 138, 201, 149),
                             title: Container(
                              color: Colors.transparent,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      result[index]["doc_name"],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    Text(
                                      "${result[index]["area_name"]}  (${result[index]["area_id"]}),",style: const TextStyle(fontSize: 11,color: Colors.black54),
                                    ),
                                   
                                  ],
                                ),
                              ),
                             ),
                             value:doctorSelectionMap[result[index]["doc_id"]] , 
                             onChanged: (bool? value){
                                doctorSelectionMap[result[index]["doc_id"]]=value!;
                                setState(() {  
                                });

                              }
                            ),
                        ),
                      ),
                    );

                  
                  }),
            )
          ],
        ),
        
        bottomNavigationBar: isConfirm? Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
               doctInfo=[];
              doctorSelectionMap.forEach((key1, value1) {
                if(value1==true){
                  for (var element2 in result) {   
                   if(key1==element2["doc_id"]){
                    doctInfo.add(element2);  
                   }
                  }
                }   
              });
             
                 Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ECMEAddScreen(
                              docInfo: doctInfo
                                )));

               },
            
            child: Container(
              
              height: 50,
              decoration: BoxDecoration(
               boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, 1),
                    blurRadius: 0.8,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
               color:const Color.fromARGB(255, 138, 201, 149),
              ),
               
               child: const Center(child: Text("Confirm",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),)),
            ),
          ),
        ):const SizedBox(),
      ),
    );
  }
}
