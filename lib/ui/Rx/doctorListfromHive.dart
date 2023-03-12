import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/hive_models/hive_data_model.dart';

class DoctorListFromHiveData extends StatefulWidget {
  String a;
  List doctorData;
  List<RxDcrDataModel> tempList;
  int counterForDoctorList;
  Function(List<RxDcrDataModel>) tempListFunc;
  Function counterCallback;

  DoctorListFromHiveData(
      {Key? key,
      required this.a,
      required this.doctorData,
      required this.tempList,
      required this.counterForDoctorList,
      required this.tempListFunc,
      required this.counterCallback})
      : super(key: key);

  @override
  State<DoctorListFromHiveData> createState() => _DoctorListFromHiveDataState();
}

class _DoctorListFromHiveDataState extends State<DoctorListFromHiveData> {
  Box? box;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  List foundUsers = [];
  bool ok = true;

  @override
  void initState() {
    print(widget.counterForDoctorList);
    // print('doclistid:${widget.counterForDoctorList}');
    SharedPreferences.getInstance().then((prefs) {
      if (widget.counterForDoctorList == 0) {
        int? a = prefs.getInt('DCLCounter') ?? 0;

        setState(() {
          widget.counterForDoctorList = a;

          widget.counterCallback(_doctorCOunter());
          // print('doctorcounterafterget: ${widget.counterForDoctorList}');
        });
      }
    });
    foundUsers = widget.doctorData;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void runFilter(String enteredKeyword) {
    foundUsers = widget.doctorData;
    List results = [];

    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
      // print(results);
    } else {
      var starts = foundUsers
          .where((s) => s['doc_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['doc_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              !s['doc_name']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) =>
            a['doc_name'].toLowerCase().compareTo(b['doc_name'].toLowerCase()));

      results = [...starts, ...contains];
    }

    // Refresh the UI
    setState(() {
      foundUsers = results;
    });
  }

  int _doctorCOunter() {
    setState(() {
      widget.counterForDoctorList++;
    });
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('DCLCounter', widget.counterForDoctorList);
    });
    return widget.counterForDoctorList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Rx DoctorList Page'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) => runFilter(value),
                controller: searchController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Search Doctor',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            runFilter('');
                            setState(() {});
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
                        : widget.doctorData.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext itemBuilder, index) {
                      return GestureDetector(
                        onTap: () {
                          widget.tempList.clear();
                          if (widget.counterForDoctorList == 0) {
                            widget.counterCallback(_doctorCOunter());
                          }

                          if (ok = true) {
                            widget.tempList.add(
                              RxDcrDataModel(
                                  docName: foundUsers[index]['doc_name'],
                                  docId: foundUsers[index]['doc_id'],
                                  areaName: foundUsers[index]['area_name'],
                                  areaId: foundUsers[index]['area_id'],
                                  address: foundUsers[index]['address'],
                                  uiqueKey: widget.counterForDoctorList,
                                  presImage: ''),
                            );

                            widget.tempListFunc(widget.tempList);
                            Navigator.pop(context);
                            ok = false;
                          }

                          // Navigator.push(context,
                          //     MaterialPageRoute(builder: (_) => RxPage()));
                        },
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 7,
                                        child: Text(
                                          '${foundUsers[index]['doc_name']} ' +
                                              '(${foundUsers[index]['doc_id']})',
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 19,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${foundUsers[index]['area_name']}' +
                                                '(${foundUsers[index]['area_id']}) ,' +
                                                ' ${foundUsers[index]['address']}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                              // fontSize: 19,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
