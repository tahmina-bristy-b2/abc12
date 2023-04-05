// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';

class DcrPpmDataPage extends StatefulWidget {
  // final int uniqueId;
  final List doctorPpmlist;
  final List<DcrGSPDataModel> tempList;
  final Function tempListFunc;
  const DcrPpmDataPage(
      {Key? key,
      // required this.uniqueId,
      required this.doctorPpmlist,
      required this.tempList,
      required this.tempListFunc})
      : super(key: key);

  @override
  State<DcrPpmDataPage> createState() => _DcrPpmDataPageState();
}

class _DcrPpmDataPageState extends State<DcrPpmDataPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController searchController2 = TextEditingController();
  Map<String, TextEditingController> controllers = {};
  List foundDcrPPM = [];

  final _formkey = GlobalKey<FormState>();
  String? itemId;

  @override
  void initState() {
    foundDcrPPM = widget.doctorPpmlist;
    for (var element in foundDcrPPM) {
      controllers[element['ppm_id']] = TextEditingController();
    }
    for (var element in widget.tempList) {
      itemId = element.giftId;
    }
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();

    for (var element in foundDcrPPM) {
      controllers[element['ppm_id']]!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 138, 201, 149),
        title: const Text('PPM'),
        titleTextStyle: const TextStyle(
            color: Color.fromARGB(255, 27, 56, 34),
            fontWeight: FontWeight.w500,
            fontSize: 20),
        centerTitle: true,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   // type: BottomNavigationBarType.fixed,
      //   onTap: (index) {
      //     _onItemTapped(index);
      //   },
      //   currentIndex: 1,
      //   // showUnselectedLabels: true,
      //   unselectedItemColor: Colors.grey[800],
      //   selectedItemColor: const Color.fromRGBO(10, 135, 255, 1),
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       label: '',
      //       icon: Icon(
      //         Icons.save,
      //         color: Colors.white,
      //       ),
      //     ),
      //     BottomNavigationBarItem(
      //       // activeIcon: Icon(Icons.add_shopping_cart_outlined),
      //       label: 'AddtoCart',
      //       icon: Icon(Icons.add_shopping_cart_outlined),
      //     )
      //   ],
      // ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 60,
                      child: TextFormField(
                        onChanged: (value) {
                          foundDcrPPM = AllServices().searchDynamicMethod(
                              value, widget.doctorPpmlist, 'ppm_name');
                          setState(() {});
                        },
                        controller: searchController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.teal.shade50,
                          border: const OutlineInputBorder(),
                          labelText: 'Item Search',
                          suffixIcon: searchController.text.isEmpty &&
                                  searchController.text == ''
                              ? const Icon(Icons.search)
                              : IconButton(
                                  onPressed: () {
                                    searchController.clear();
                                    foundDcrPPM = AllServices()
                                        .searchDynamicMethod('',
                                            widget.doctorPpmlist, 'ppm_name');
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
                ),
              ],
            ),
          ),
          Expanded(
            flex: 9,
            child: Form(
              key: _formkey,
              child: foundDcrPPM.isNotEmpty
                  ? ppmListViewBuilder()
                  : const Text(
                      'No data found',
                      style: TextStyle(fontSize: 24),
                    ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                widget.tempListFunc(widget.tempList);

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
                maximumSize: const Size(200, 50),
                backgroundColor: const Color.fromARGB(255, 4, 60, 105),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      bottomLeft: Radius.circular(5)),
                ),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_shopping_cart_outlined, size: 30),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "AddToCart",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  ListView ppmListViewBuilder() {
    return ListView.builder(
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: foundDcrPPM.length,
        itemBuilder: (context, index) {
          return Card(
            // elevation: 2,
            // color: Colors.yellow.shade50,
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                  color: Color.fromARGB(108, 255, 255, 255), width: 1),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 2, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              foundDcrPPM[index]['ppm_name'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 30, 66, 77),
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                            Text(
                              foundDcrPPM[index]['ppm_id'],
                              style: const TextStyle(
                                color: Color.fromARGB(255, 30, 66, 77),
                                // fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Card(
                              elevation: 1,
                              child: Container(
                                height: 40,
                                color: const Color.fromARGB(255, 138, 201, 149)
                                    .withOpacity(.3),
                                width: 70,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  controller:
                                      controllers[foundDcrPPM[index]['ppm_id']],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(2.0)),
                                  ),
                                  onChanged: (value) {
                                    setState(() {});
                                    if (value != '') {
                                      var temp = DcrGSPDataModel(
                                          // uiqueKey: widget.uniqueId,
                                          quantity: int.parse(controllers[
                                                  foundDcrPPM[index]['ppm_id']]!
                                              .text),
                                          giftName: foundDcrPPM[index]
                                              ['ppm_name'],
                                          giftId: foundDcrPPM[index]['ppm_id'],
                                          giftType: 'PPM');

                                      // widget.tempList
                                      //     .forEach((element) {
                                      //   itemId = element.giftId;
                                      // });

                                      String tempItemId = temp.giftId;

                                      widget.tempList.removeWhere(
                                          (item) => item.giftId == tempItemId);

                                      widget.tempList.add(temp);
                                      // } else {
                                      //   widget.tempList
                                      //       .add(temp);
                                      // }
                                    } else if (value == '') {
                                      final temp = DcrGSPDataModel(
                                        // uiqueKey: widget.uniqueId,
                                        quantity: value == ''
                                            ? 0
                                            : int.parse(controllers[
                                                    foundDcrPPM[index]
                                                        ['ppm_id']]!
                                                .text),
                                        giftName: foundDcrPPM[index]
                                            ['ppm_name'],
                                        giftId: foundDcrPPM[index]['ppm_id'],
                                        giftType: 'PPM',
                                      );

                                      String tempItemId = temp.giftId;

                                      widget.tempList.removeWhere(
                                          (item) => item.giftId == tempItemId);

                                      setState(() {});
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
