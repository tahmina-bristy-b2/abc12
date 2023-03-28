import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class DoctorListFromHiveData extends StatefulWidget {
  final List doctorData;
  final List<RxDcrDataModel> tempList;
  final Function(List<RxDcrDataModel>) tempListFunc;

  const DoctorListFromHiveData({
    Key? key,
    required this.doctorData,
    required this.tempList,
    required this.tempListFunc,
  }) : super(key: key);

  @override
  State<DoctorListFromHiveData> createState() => _DoctorListFromHiveDataState();
}

class _DoctorListFromHiveDataState extends State<DoctorListFromHiveData> {
  Box? box;
  List foundUsers = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    foundUsers = widget.doctorData;
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  foundUsers = AllServices().searchDynamicMethod(
                      value, widget.doctorData, "doc_name");
                });
              },
              controller: searchController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Search Doctor',
                suffixIcon:
                    searchController.text.isEmpty && searchController.text == ''
                        ? const Icon(Icons.search)
                        : IconButton(
                            onPressed: () {
                              searchController.clear();
                              setState(() {
                                foundUsers = AllServices().searchDynamicMethod(
                                    "", widget.doctorData, "doc_name");
                              });
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                            ),
                          ),
              ),
            ),
          ),
          foundUsers.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: searchController.text.isNotEmpty
                          ? foundUsers.length
                          : widget.doctorData.length,
                      itemBuilder: (BuildContext itemBuilder, index) {
                        return GestureDetector(
                          onTap: () {
                            widget.tempList.first.docName =
                                foundUsers[index]['doc_name'];
                            widget.tempList.first.docId =
                                foundUsers[index]['doc_id'];
                            widget.tempList.first.areaName =
                                foundUsers[index]['area_name'];
                            widget.tempList.first.areaId =
                                foundUsers[index]['area_id'];
                            widget.tempList.first.address =
                                foundUsers[index]['address'];

                            widget.tempListFunc(widget.tempList);
                            Navigator.pop(context);
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SizedBox(
                              height: 75,
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                minVerticalPadding: 0,
                                title: Text(
                                  '${foundUsers[index]['doc_name']} '
                                  '(${foundUsers[index]['doc_id']})',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 19,
                                  ),
                                ),
                                subtitle: Text(
                                  '${foundUsers[index]['area_name']}(${foundUsers[index]['area_id']}) , ${foundUsers[index]['address']}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    // fontSize: 19,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                )
              : const Text(
                  'No results found',
                  style: TextStyle(fontSize: 24),
                ),
        ],
      ),
    );
  }
}
