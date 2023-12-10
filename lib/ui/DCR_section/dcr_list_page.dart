import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/doc_settings_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/ui/DCR_section/add_doctor.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_area_page.dart';
import 'package:MREPORTING/utils/constant.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_gift_sample_PPM_page.dart';
import 'package:MREPORTING/ui/Widgets/customerListWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DcrListPage extends StatefulWidget {
  final List dcrDataList;

  const DcrListPage({Key? key, required this.dcrDataList}) : super(key: key);

  @override
  State<DcrListPage> createState() => _DcrListPageState();
}

class _DcrListPageState extends State<DcrListPage> with SingleTickerProviderStateMixin {
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;
  late ConfettiController _confettiController;
   late TabController _tabController;

  String cid = '';
  bool _isLoading = false;
  bool isMagicDoctor=false;

  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];

  List magicDcrDataList=[];
  List allDoctorList=[];
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 800));
    _confettiController.play();

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
    magicDcrDataList = widget.dcrDataList
                  .where((element) => element["magic_doctor"].toString().toUpperCase() == "MAGIC_DOCTOR")
                  .toList();
                  allDoctorList=widget.dcrDataList;
                   setState(() {});
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
                  builder: (context) => const DCRAreaPage(),
                )),
              );
            },
            icon: const Icon(Icons.person_add),
          )
        ],
         bottom: TabBar(
            controller: _tabController,
            onTap: (value) async {
              searchController.clear();
                  foundUsers=[];
              
           
              // _searchController.clear();
              // _searchExpand = false;
              // height = 0;
              // _color = false;

              // allEmployeeList = appraisalEmployee!.resData.ffList.toList();
              // submittedEmployeeList = appraisalEmployee!.resData.ffList
              //     .where((element) => element.appActionStatus == "SUBMITTED")
              //     .toList();

allDoctorList=widget.dcrDataList;
               magicDcrDataList = widget.dcrDataList
                  .where((element) => element["magic_doctor"].toString().toUpperCase() == "MAGIC_DOCTOR")
                  .toList();
             
                
                  if(value==0){
                     // allDoctorList=widget.dcrDataList;
                   
                    isMagicDoctor=false;
                    foundUsers=allDoctorList;
                  }
                  else{
                  //    magicDcrDataList = widget.dcrDataList
                  // .where((element) => element["magic_doctor"].toString().toUpperCase() == "MAGIC_DOCTOR")
                  // .toList();
                      // foundUsers=[];
                    isMagicDoctor=true;
                    foundUsers=magicDcrDataList;

                  }

              
              setState(() {});
            },
            isScrollable: true,
            tabs: const [
              Tab(text: "  ALL Doctor "),
              Tab(text: "  Magic Doctor  "),
              
            ]),
      ),
      body:TabBarView(
        controller: _tabController,
        children: [
        _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          foundUsers = AllServices().searchDynamicMethod(
                              value, allDoctorList, "doc_name");
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: ' Search Doctor.....',
                        suffixIcon: searchController.text.isEmpty &&
                                searchController.text == ''
                            ? const Icon(Icons.search)
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();

                                  // runFilter('');
                                  setState(() {
                                    foundUsers = AllServices()
                                        .searchDynamicMethod(
                                            "", allDoctorList, "doc_name");
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
                customerListWidget(context,searchController.text.isNotEmpty
                            ? foundUsers
                            : allDoctorList,false),
              ],
            ),
            //==================================================Magic Doctor=====================================================
          _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: 60,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          foundUsers = AllServices().searchDynamicMethod(
                              value, magicDcrDataList, "doc_name");
                        });
                      },
                      controller: searchController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        labelText: ' Search Magic Doctor',
                        suffixIcon: searchController.text.isEmpty &&
                                searchController.text == ''
                            ? const Icon(Icons.search)
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();

                                  // runFilter('');
                                  setState(() {
                                    foundUsers = AllServices()
                                        .searchDynamicMethod(
                                            "", magicDcrDataList, "doc_name");
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
                customerListWidget(context,searchController.text.isNotEmpty
                            ? foundUsers
                            : magicDcrDataList,true),
              ],
            ),
      ],),
      //  _isLoading
      //     ? const Center(
      //         child: CircularProgressIndicator(),
      //       )
      //     : Column(
      //         children: [
      //           SizedBox(
      //             height: 60,
      //             child: Padding(
      //               padding: const EdgeInsets.all(8.0),
      //               child: TextFormField(
      //                 onChanged: (value) {
      //                   setState(() {
      //                     foundUsers = AllServices().searchDynamicMethod(
      //                         value, widget.dcrDataList, "doc_name");
      //                   });
      //                 },
      //                 controller: searchController,
      //                 decoration: InputDecoration(
      //                   border: OutlineInputBorder(
      //                       borderRadius: BorderRadius.circular(10)),
      //                   labelText: ' Search',
      //                   suffixIcon: searchController.text.isEmpty &&
      //                           searchController.text == ''
      //                       ? const Icon(Icons.search)
      //                       : IconButton(
      //                           onPressed: () {
      //                             searchController.clear();

      //                             // runFilter('');
      //                             setState(() {
      //                               foundUsers = AllServices()
      //                                   .searchDynamicMethod(
      //                                       "", widget.dcrDataList, "doc_name");
      //                             });
      //                           },
      //                           icon: const Icon(
      //                             Icons.clear,
      //                             color: Colors.black,
      //                             // size: 28,
      //                           ),
      //                         ),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           customerListWidget(context),
      //         ],
      //       ),
    );
  }

  Expanded customerListWidget(BuildContext context, List doctorList,bool isMagic) {
    return Expanded(
                flex: 9,
                child: foundUsers.isNotEmpty
                    ? ListView.builder(
                        shrinkWrap: true,
                        
                        itemCount:doctorList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext itemBuilder, index) {
                          return GestureDetector(
                            onTap: () {
                              _incrementCounter();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => DcrGiftSamplePpmPage(
                                            isDraft: false,
                                            // dcrKey: 0,
                                            // uniqueId: _counter,
                                            draftOrderItem: [],
                                            docName: foundUsers[index]
                                                ['doc_name'],
                                            docId: foundUsers[index]
                                                ['doc_id'],
                                            areaName: foundUsers[index]
                                                ['area_name'],
                                            areaId: foundUsers[index]
                                                ['area_id'],
                                            address: foundUsers[index]
                                                ['address'],
                                            notes: '',
                                            visitedWith: '',
                                            magic: foundUsers[index]
                                                            ['magic_doctor']
                                                        .toString()
                                                        .toUpperCase() ==
                                                    'MAGIC_DOCTOR'
                                                ? true
                                                : false,
                                            // magicBrand: foundUsers[index]
                                            //     ['magic_brand'],
                                          )));
                                         
                            },
                            child: CustomerListCardWidget(
                              clientName: foundUsers[index]['doc_name'] +
                                  '(${foundUsers[index]['doc_id']})',
                              base: foundUsers[index]['area_name'] +
                                  '(${foundUsers[index]['area_id']})',
                              marketName: foundUsers[index]['address'],
                              outstanding: '',
                              magic: foundUsers[index]['magic_doctor']
                                          .toString()
                                          .toUpperCase() ==
                                      'MAGIC_DOCTOR'
                                  ? true
                                  : false,
                              confettiController: _confettiController,
                              icon: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 138, 201, 149),
                              ),
                              boolIcon: true,
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });

                                //=======================================================================================================================================
                                //======================================================CustomerApi======================================================================
                                //=======================================================================================================================================
                                List clientList = await DcrRepositories()
                                    .getDCRAreaBaseClient(
                                        dmpathData!.syncUrl,
                                        cid,
                                        userInfo!.userId,
                                        userPassword,
                                        foundUsers[index]['area_id']);
                                // if (clientList.isNotEmpty) {
                                //=======================================================================================================================================
                                //======================================================DOCEditApi======================================================================
                                //=======================================================================================================================================
                                final Map<String, dynamic>
                                    responseOfDoEditInfo =
                                    await DcrRepositories().docEditInfo(
                                        dmpathData!.doctorEditUrl,
                                        cid,
                                        userInfo!.userId,
                                        userPassword,
                                        foundUsers[index]['area_id'],
                                        foundUsers[index]['doc_id']);
                                //=======================================================================================================================================
                                //======================================================DOCSettingsApi======================================================================
                                //=======================================================================================================================================
                                final DocSettingsModel?
                                    responseOfDocSettings =
                                    await DcrRepositories().docSettingsRepo(
                                        dmpathData!.syncUrl,
                                        cid,
                                        userInfo!.userId,
                                        userPassword);

                                //=======================================================================================================================================
                                //======================================================Navigation======================================================================
                                //=======================================================================================================================================
                                if (responseOfDoEditInfo != {} &&
                                    responseOfDocSettings != null) {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  if (!mounted) return;
                                  // print(responseOfDocSettings);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DcotorInfoScreen(
                                        isEdit: true,
                                        areaName: foundUsers[index]
                                            ['area_id'],
                                        editDoctorInfo: foundUsers[index],
                                        docSettings: responseOfDocSettings,
                                        customerList: clientList,
                                        docEditInfo: responseOfDoEditInfo,
                                        areaID: foundUsers[index]['area_id'],
                                      ),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  AllServices().toastMessage(
                                      'Doctor data Not found',
                                      Colors.red,
                                      Colors.white,
                                      16);
                                }
                                // } else {
                                //   setState(() {
                                //     _isLoading = false;
                                //   });
                                //   AllServices().toastMessage(
                                //       'Client Not found',
                                //       Colors.red,
                                //       Colors.white,
                                //       16);
                                // }
                              },
                            ),
                          );
                        })
                    : const Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
              );
  }
}
