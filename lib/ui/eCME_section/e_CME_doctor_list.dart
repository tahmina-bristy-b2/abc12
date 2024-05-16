import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/services/eCME/eCME_services.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/cancel-button.dart';
import 'package:MREPORTING/ui/Expired_dated_section/widget/confirm_widget.dart';
import 'package:MREPORTING/ui/eCME_section/eCME_add_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ECMEClientScreen extends StatefulWidget {
   List<DocListECMEModel> docList;
   List eCMEType;
   ECMEClientScreen({
      super.key,
      required this.docList,
      required this.eCMEType
    });

  @override
  State<ECMEClientScreen> createState() => _ECMEClientScreenState();
}

class _ECMEClientScreenState extends State<ECMEClientScreen> {
  Box? box;
  List<RegionList>? regionListData;

  TextEditingController searchController = TextEditingController();
  List foundUsers = [];
   List<DocListECMEModel> result = [];
  String? cid;
  String? userId;
  String? password;
  String? region;
  String? territory;
  String? area;
  String dSRType = "";
  Map<String,bool> doctorSelectionMap={};
  List<DocListECMEModel> doctInfo=[];
  bool isConfirm=false;
  bool isDocListShow=false;
  String eCmeType="";

  @override
  void initState() {
    super.initState();
    for (var eachType in widget.eCMEType) {
      doctorSelectionMap[eachType]=false;
    }
    addShowDialogForVeryFirstTime(widget.eCMEType,context);
    if(widget.docList!=null){
      result=widget.docList;
    }
    if(result.isNotEmpty){
      for (var element in result) {
        doctorSelectionMap[element.docId]=false;
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
    
    
  }
  void refreshData() {
    setState(() {
      
    });
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
            //======================================= Doctor Search ==============================
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Row(
                children: [
               ( widget.docList!=null &&  isDocListShow==true)
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
                                                result = ECMEServices().doctorSearch(
                                                    value,
                                                    widget.docList,
                                                    );
                                                setState(() {});
                                              },
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText:" Search doctor.....",
                                      hintStyle: const TextStyle(fontSize: 14
                                      
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      border: InputBorder.none,
                                      suffixIcon: searchController.text.isEmpty &&
                                              searchController.text == ''
                                          ? const Icon(Icons.search,color: Colors.grey,)
                                          : IconButton(
                                                   onPressed: () {
                                                          searchController.clear();
                                                          setState(() {
                                                            result = ECMEServices().doctorSearch(
                                                                '',
                                                                widget.docList,
                                                                );
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
                      : const SizedBox(),
                     widget.docList!=null
                      ? const SizedBox(
                          width: 10,
                        )
                      : const SizedBox(),
                 
                ],
              ),
            ),
           //================================= Doctor Lists  ======================================
             ( widget.docList!=null &&  isDocListShow==true)?Expanded(
              child: ListView.builder(
                  itemCount: result.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 6,right: 6,top: 6),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color:doctorSelectionMap[result[index].docId]==true?
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
                                    Flexible(
                                      child: Text(
                                        result[index].docName,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4,),
                                    Flexible(
                                      child: Text(
                                        "${result[index].areaName}  (${result[index].areaId}),",style: const TextStyle(fontSize: 11,color: Colors.black54),
                                      ),
                                    ),
                                   
                                  ],
                                ),
                              ),
                             ),
                             value:doctorSelectionMap[result[index].docId] , 
                             onChanged: (bool? value){
                                doctorSelectionMap[result[index].docId]=value!;
                                setState(() {  
                                });

                              }
                            ),
                        ),
                      ),
                    );
                  
                  }),
            ):const SizedBox()
          ],
        ),
        //================================ Confirm Button =======================================
        bottomNavigationBar: isConfirm? Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
               doctInfo=[];
              doctorSelectionMap.forEach((key1, value1) {
                if(value1==true){
                  for (var element2 in result) {   
                   if(key1==element2.docId){
                    doctInfo.add(element2);  
                   }
                  }
                }   
              });
              Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ECMEAddScreen(
                              docInfo: doctInfo, eCMEType: eCmeType,
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

//============================= Bottom Modal sheet for Selecting eCME Type ========================================
  void addShowDialogForVeryFirstTime(List doctorType, BuildContext context)async {
  Map<String, bool> doctorSelectionMap = {};
  WidgetsBinding.instance.addPostFrameCallback((_) {
    showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      isDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState2) {
            return SizedBox(
              height: (doctorType.length * 50)+105, //==this Size contains with Text+ eCME type +button height. if any changes needed, then change everywhere
              child: Column(
                children: [
                 const Padding(
                    padding:  EdgeInsets.symmetric(vertical: 10),
                    child:  Text(
                      "Select e-CME Type",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    height: doctorType.length * 50,
                    child: ListView.builder(
                      itemCount: doctorType.length,
                      itemBuilder: (context, index) {
                        doctorSelectionMap.putIfAbsent(doctorType[index], () => false);  //== as per user requirement .//only one option can be seleted by user
                        return Theme(
                          data: ThemeData(unselectedWidgetColor: Colors.grey),
                          child: SizedBox(
                            height: 45,
                            child: CheckboxListTile(
                              checkboxShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              activeColor: const Color.fromARGB(255, 138, 201, 149),
                              title: Padding(
                                padding: const EdgeInsets.fromLTRB(2, 2, 4, 2),
                                child: ListTile(
                                  title: Text(
                                    doctorType[index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              value: doctorSelectionMap[doctorType[index]],
                              onChanged: (bool? value) {
                                setState2(() {
                                  for (var key in doctorSelectionMap.keys) {
                                    doctorSelectionMap[key] = false;
                                  }
                                  doctorSelectionMap[doctorType[index]] = true;
                                  if(doctorSelectionMap[doctorType[index]] == true){
                                    eCmeType=doctorType[index];

                                  }
                                });
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    child: SizedBox(
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: CancelButtonWidget(
                              buttonHeight: 50,
                              fontColor: const Color.fromARGB(255, 82, 179, 98),
                              buttonName: "Cancel",
                              fontSize: 16,
                              onTapFuction: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              borderColor: const Color.fromARGB(255, 82, 179, 98),
                            ),
                          ),
                          const SizedBox(width: 10,),
                          Expanded(
                            child: ConfirmButtonWidget(
                              buttonHeight: 50,
                              fontColor: Colors.white,
                              buttonName: "OK",
                              fontSize: 16,
                              onTapFuction: () {
                                if((doctorSelectionMap["Intern Reception"]==true)||(doctorSelectionMap["Society"]==true) ){  //== no doctor needed ,if eEME type these
                                  doctInfo=[];
                                  Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ECMEAddScreen(
                                                     docInfo: doctInfo, eCMEType: eCmeType,
                                                    )));
                                }
                                else{
                                  setState(() {
                                     isDocListShow=true;                    //== it used for doctor List show //== be carefull
                                  });
                                  
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) {
      setState(() {
        
      });
      
    });
  });
}
}
