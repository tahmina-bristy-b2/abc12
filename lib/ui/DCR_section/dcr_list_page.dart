import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/doc_settings_model.dart';
import 'package:MREPORTING/models/doctor_edit_model.dart';
import 'package:MREPORTING/models/hive_models/dmpath_data_model.dart';
import 'package:MREPORTING/models/hive_models/login_user_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/dcr/dcr_repositories.dart';
import 'package:MREPORTING/ui/DCR_section/add_doctor.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_area_page.dart';
import 'package:MREPORTING/utils/constant.dart';
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

class _DcrListPageState extends State<DcrListPage> {
  // Box<DmPathDataModel> dmpathBox = Boxes.getDmpath();
  UserLoginModel? userInfo;
  DmPathDataModel? dmpathData;

  String cid = '';
  bool _isLoading = false;

  final TextEditingController searchController = TextEditingController();
  List foundUsers = [];
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    userInfo = Boxes.getLoginData().get('userInfo');
    dmpathData = Boxes.getDmpath().get('dmPathData');

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
                  builder: (context) => const DCRAreaPage(),
                )),
              );
            },
            icon: const Icon(Icons.person_add),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
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
                                    foundUsers = AllServices()
                                        .searchDynamicMethod(
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
                                  if (clientList.isNotEmpty) {
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
                                      print(responseOfDocSettings);
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
                                            areaID: foundUsers[index]
                                                ['area_id'],
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
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    AllServices().toastMessage(
                                        'Client Not found',
                                        Colors.red,
                                        Colors.white,
                                        16);
                                  }
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
