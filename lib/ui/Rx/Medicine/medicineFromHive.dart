import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class MedicineListFromHiveData1 extends StatefulWidget {
  final List medicineData;
  List<MedicineListModel> medicinTempList;
  int counter;
  Function(List<MedicineListModel>) tempListFunc;

  MedicineListFromHiveData1({
    Key? key,
    required this.medicineData,
    required this.medicinTempList,
    required this.counter,
    required this.tempListFunc,
  }) : super(key: key);

  @override
  State<MedicineListFromHiveData1> createState() =>
      _MedicineListFromHiveData1State();
}

class _MedicineListFromHiveData1State extends State<MedicineListFromHiveData1> {
  Box? box;
  List syncItemList = [];
  final TextEditingController searchController = TextEditingController();
  Map<String, TextEditingController> controllers = {};

  List foundUsers = [];
  bool ok = true;
  bool value = false;
  String? tempId;
  var selectedMed;
  List finalList = [];
  Map<String, bool> pressedActivity = {};

  @override
  void initState() {
    foundUsers = widget.medicineData;
    for (var element in foundUsers) {
      pressedActivity[element['item_id']] = false;
    }

    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // late List<bool> pressedAttentions = foundUsers.map((e) => false).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Rx Medicine List Page'),
        centerTitle: true,
      ),
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
                        value, widget.medicineData, 'name');
                  });
                },
                controller: searchController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Search Medicine',
                  suffixIcon: searchController.text.isEmpty &&
                          searchController.text == ''
                      ? const Icon(Icons.search)
                      : IconButton(
                          onPressed: () {
                            searchController.clear();
                            setState(() {
                              foundUsers = AllServices().searchDynamicMethod(
                                  "", widget.medicineData, 'name');
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
          foundUsers.isNotEmpty
              ? Expanded(
                  flex: 9,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: foundUsers.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final pressAttention =
                            pressedActivity[foundUsers[index]['item_id']];
                        return GestureDetector(
                          onTap: () {
                            setState(() =>
                                pressedActivity[foundUsers[index]['item_id']] =
                                    !pressAttention);
                            selectedMed = foundUsers[index];
                            if (pressedActivity[selectedMed['item_id']] ==
                                true) {
                              finalList.add(selectedMed);
                            } else {
                              finalList.remove(selectedMed);
                            }
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                  color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 9,
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: pressAttention!
                                          ? const Color.fromARGB(
                                              255, 143, 199, 248)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Text(
                                              foundUsers[index]['name'],
                                              // foundUsers[index]['item_id'],
                                              // '${foundUsers[index]['name']} ' +
                                              //     '(${foundUsers[index]['item_id']})',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 19,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          for (var element in finalList) {
            var temp = MedicineListModel(
                strength: element['strength'],
                name: element['name'],
                generic: element['generic'],
                brand: element['brand'],
                company: element['company'],
                formation: element['formation'],
                uiqueKey: widget.counter,
                itemId: element['item_id'],
                quantity: 1);
            String tempItemId = temp.itemId;

            widget.medicinTempList
                .removeWhere((item) => item.itemId == tempItemId);

            widget.medicinTempList.add(temp);
          }

          widget.tempListFunc(widget.medicinTempList);
          Navigator.pop(context);
        },
        child: const Text('Add'),
      ),
    );
  }
}
