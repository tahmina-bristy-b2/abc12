import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_gift_sample_PPM_page.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/local_storage/boxes.dart';

class DraftDCRScreen extends StatefulWidget {
  const DraftDCRScreen({Key? key}) : super(key: key);

  @override
  State<DraftDCRScreen> createState() => _DraftDCRScreenState();
}

class _DraftDCRScreenState extends State<DraftDCRScreen> {
  // final GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  // Box? box;

  // List itemDraftList = [];
  // List<DcrGSPDataModel> addedDcrGSPList = [];
  // List<DcrGSPDataModel> filteredOrder = [];
  // List<DcrDataModel> dcrDataList = [];

  @override
  void initState() {
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   // box = Boxes.selectedDcrGSP();
    //   // addedDcrGSPList = box!.toMap().values.toList().cast<DcrGSPDataModel>();

    //   // box = Boxes.dcrUsers();
    //   // dcrDataList = box!.toMap().values.toList().cast<DcrDataModel>();

    //   setState(() {});
    // });
    super.initState();
  }

  // int _currentSelected = 0;

  Future<void> deletedoctor(DcrDataModel dcrDataModel) async {
    dcrDataModel.delete();
  }

  // deletDcrGSPitem(int id) {
  //   final box = Hive.box<DcrGSPDataModel>("selectedDcrGSP");

  //   final Map<dynamic, DcrGSPDataModel> deliveriesMap = box.toMap();
  //   dynamic desiredKey;
  //   deliveriesMap.forEach((key, value) {
  //     if (value.uiqueKey == id) desiredKey = key;
  //   });
  //   box.delete(desiredKey);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Draft Doctor'), centerTitle: true),
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: Boxes.dcrUsers().listenable(),
          builder: (BuildContext context, Box box, Widget? child) {
            final orderCustomers = box.values.toList().cast<DcrDataModel>();

            return genContent(orderCustomers);
          },
        ),
      ),
    );
  }

  Widget genContent(List<DcrDataModel> user) {
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
          return GestureDetector(
            onTap: () {},
            child: Card(
              color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  "${user[index].docName} (${user[index].areaName}) ",
                  maxLines: 2,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text("${user[index].docId}  "),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          // final ckey = user[index].uiqueKey;
                          deletedoctor(user[index]);

                          // deletDcrGSPitem(ckey);
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

                          // filteredOrder = [];
                          // addedDcrGSPList
                          //     .where((item) => item.uiqueKey == dcrKey)
                          //     .forEach(
                          //   (item) {
                          //     final temp = DcrGSPDataModel(
                          //         uiqueKey: item.uiqueKey,
                          //         quantity: item.quantity,
                          //         giftName: item.giftName,
                          //         giftId: item.giftId,
                          //         giftType: item.giftType);
                          //     filteredOrder.add(temp);
                          //   },
                          // );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DcrGiftSamplePpmPage(
                                isDraft: true,
                                // dcrKey: dcrKey,
                                // uniqueId: dcrKey,
                                draftOrderItem: user[index].dcrGspList,
                                notes: user[index].notes,
                                visitedWith: user[index].visitedWith,
                                // draftOrderItem: filteredOrder,
                                docName: user[index].docName,
                                docId: user[index].docId,
                                areaName: user[index].areaName,
                                areaId: user[index].areaId,
                                address: user[index].address,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.arrow_forward_outlined,
                          color: Colors.blue,
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
