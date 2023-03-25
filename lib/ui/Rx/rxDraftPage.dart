import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/Rx/rxPage.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';

class RxDraftPage extends StatefulWidget {
  const RxDraftPage({Key? key}) : super(key: key);

  @override
  State<RxDraftPage> createState() => _RxDraftPageState();
}

class _RxDraftPageState extends State<RxDraftPage> {
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  Box? box;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  List itemDraftList = [];
  List<MedicineListModel> addedRxMedicinList = [];
  List<MedicineListModel> filteredMedicin = [];
  List<RxDcrDataModel> dcrDataList = [];

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   box = Boxes.getMedicine();
    //   addedRxMedicinList =
    //       box!.toMap().values.toList().cast<MedicineListModel>();

    //   box = Boxes.dcrUsers();
    //   dcrDataList = box!.toMap().values.toList().cast<RxDcrDataModel>();

    //   setState(() {});
    // });
    super.initState();
  }

  // int _currentSelected = 0;

  // void _onItemTapped(int index) async {
  //   if (index == 1) {
  //     // await putData();
  //     setState(() {
  //       _currentSelected = index;
  //     });
  //     // print('order List seved to hive');
  //   } else {
  //     // print('ohe eta hbe na');
  //   }
  //   if (index == 0) {
  //     await Boxes.dcrUsers().clear();

  //     await Boxes.getMedicine().clear();

  //     setState(() {
  //       _currentSelected = index;
  //     });
  //   }
  // }

  Future<void> deleteRxDoctor(RxDcrDataModel rxDcrDataModel) async {
    rxDcrDataModel.delete();
  }

  // deletRxMedicinItem(int id) {
  //   final box = Hive.box<MedicineListModel>("draftMdicinList");

  //   final Map<dynamic, MedicineListModel> deliveriesMap = box.toMap();
  //   dynamic desiredKey;
  //   deliveriesMap.forEach((key, value) {
  //     if (value.uid == id) desiredKey = key;
  //   });
  //   box.delete(desiredKey);
  // }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: const Text('Draft Rx Doctor'), centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.rxdDoctor().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final rxDoctor = box.values.toList().cast<RxDcrDataModel>();

            return genContent(rxDoctor);
          },
        ),
      ),
    );
  }

  Widget genContent(List<RxDcrDataModel> user) {
    if (user.isEmpty) {
      return const Center(
        child: Text(
          "No Data Found",
          style: TextStyle(fontSize: 20),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: user.length,
        itemBuilder: (BuildContext context, int index) {
          int space = user[index].presImage.indexOf(" ");
          String removeSpace = user[index]
              .presImage
              .substring(space + 1, user[index].presImage.length);
          String finalImage = removeSpace.replaceAll("'", '');

          return GestureDetector(
            onTap: () {},
            child: Card(
              elevation: 10,
              color: const Color.fromARGB(255, 207, 240, 207),
              child: ExpansionTile(
                childrenPadding: const EdgeInsets.all(0),
                // tilePadding: EdgeInsets.all(0),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: screenHeight / 8,
                        width: screenWidth / 6,
                        child: Image(
                          fit: BoxFit.cover,
                          image: FileImage(File(finalImage)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Text(
                            "${user[index].docName} (${user[index].docId}) ",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            user[index].areaName,
                            style: const TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        // onPressed: () => deleteUser(user[index]),
                        onPressed: () {
                          // final rxDoctorkey = user[index].uid;
                          deleteRxDoctor(user[index]);
                          // deleteItem(user[index]);

                          // deletRxMedicinItem(rxDoctorkey);
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        label: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          // final dcrKey = user[index].uiqueKey;
                          // print('dcr:$dcrKey');
                          // filteredMedicin = [];
                          // addedRxMedicinList
                          //     .where((item) => item.uiqueKey == dcrKey)
                          //     .forEach(
                          //   (item) {
                          //     print('gsp: ${item.uiqueKey}');
                          //     final temp = MedicineListModel(
                          //         uiqueKey: item.uiqueKey,
                          //         strength: item.strength,
                          //         brand: item.brand,
                          //         company: item.company,
                          //         formation: item.formation,
                          //         name: item.name,
                          //         generic: item.generic,
                          //         itemId: item.itemId,
                          //         quantity: item.quantity);

                          //     filteredMedicin.add(temp);
                          //   },
                          // );
                          // print('ami jani na ${user[index].presImage}');

                          // print(ckey);
                          // if ((user[index].presImage != "") &&
                          //     filteredMedicin.isEmpty) {
                          // print("dcrkey when only Image ${dcrKey}");
                          // print(
                          //     "dcrkey when only Image ${user[index].uiqueKey}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RxPage(
                                  isRxEdit: true, draftRxData: user[index]

                                  // uid: user[index].uid,
                                  // draftRxMedicinItem: filteredMedicin,
                                  // docName: user[index].docName,
                                  // docId: user[index].docId,
                                  // areaName: user[index].areaName,
                                  // areaId: user[index].areaId,
                                  // address: user[index].address,
                                  // image1: user[index].presImage,
                                  ),
                            ),
                          );
                          // } else {
                          //   // print("dcrkey when medicine ${dcrKey}");
                          //   // print(
                          //   //     "dcrkey when medicine ${user[index].uiqueKey}");
                          //   Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (_) => RxPage(
                          //         ck: 'isCheck',
                          //         dcrKey: dcrKey,
                          //         uniqueId: user[index].uiqueKey,
                          //         draftRxMedicinItem: filteredMedicin,
                          //         docName: user[index].docName,
                          //         docId: user[index].docId,
                          //         areaName: user[index].areaName,
                          //         areaId: user[index].areaId,
                          //         address: user[index].address,
                          //         image1: user[index].presImage,
                          //       ),
                          //     ),
                          //   );
                          // }
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (_) => RxPage(
                          //       ck: 'isCheck',
                          //       dcrKey: dcrKey,
                          //       uniqueId: user[index].uiqueKey,
                          //       draftRxMedicinItem: filteredMedicin,
                          //       docName: user[index].docName,
                          //       docId: user[index].docId,
                          //       areaName: user[index].areaName,
                          //       areaId: user[index].areaId,
                          //       address: user[index].address,
                          //       image1: user[index].presImage,
                          //     ),
                          //   ),
                          // );
                        },
                        // onPressed: () => editUser(user[index]),
                        icon: const Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.blue,
                          // size: 30,
                        ),
                        label: const Text(
                          "Details",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }
}
