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
  @override
  void initState() {
    super.initState();
  }

  Future<void> deletedoctor(DcrDataModel dcrDataModel) async {
    dcrDataModel.delete();
  }

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
              // color: Colors.white,
              child: ExpansionTile(
                title: Text(
                  "${user[index].docName}(${user[index].docId})",
                  maxLines: 2,
                  style: TextStyle(
                      color: user[index].magic == true
                          ? const Color.fromARGB(255, 0, 174, 29)
                          : null),
                ),
                subtitle: Text(
                  '${user[index].areaName}(${user[index].areaId})',
                  style: TextStyle(
                      color: user[index].magic == true
                          ? const Color.fromARGB(255, 86, 173, 100)
                          : null),
                ),
                trailing: user[index].magic == true
                    ? Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationZ(3.1415926535897932 / 4),
                        child: SizedBox(
                            height: 70,
                            child: Image.asset(
                              'assets/images/hat_picture.png',
                              //color: Colors.deepOrange,
                            )),
                      )
                    : const SizedBox.shrink(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          deletedoctor(user[index]);
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DcrGiftSamplePpmPage(
                                isDraft: true,
                                draftOrderItem: user[index].dcrGspList,
                                notes: user[index].notes,
                                visitedWith: user[index].visitedWith,
                                docName: user[index].docName,
                                docId: user[index].docId,
                                areaName: user[index].areaName,
                                areaId: user[index].areaId,
                                address: user[index].address,
                                magic: user[index].magic ?? false,
                                magicBrand: const [],
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
