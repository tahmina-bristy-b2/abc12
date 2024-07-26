import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING_OFFLINE/ui/DCR_section/dcr_gift_sample_PPM_page.dart';
import 'package:MREPORTING_OFFLINE/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING_OFFLINE/local_storage/boxes.dart';

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
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Draft Doctor'),
          centerTitle: true,
          bottom: const TabBar(tabs: [
            Padding(
              padding: EdgeInsets.only(right: 8.0, left: 8.0),
              child: Tab(
                text: 'ALL DOCTOR',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0, left: 8.0),
              child: Tab(
                text: 'MAGIC DOCTOR',
              ),
            ),
          ]),
        ),
        body: TabBarView(
          children: [
            SafeArea(
              child: ValueListenableBuilder(
                valueListenable: Boxes.dcrUsers().listenable(),
                builder: (BuildContext context, Box box, Widget? child) {
                  final orderCustomers =
                      box.values.toList().cast<DcrDataModel>();

                  return genContent(orderCustomers);
                },
              ),
            ),
            //For showing Magic draft doctor
            SafeArea(
              child: ValueListenableBuilder(
                valueListenable: Boxes.dcrUsers().listenable(),
                builder: (BuildContext context, Box box, Widget? child) {
                  final orderCustomers =
                      box.values.toList().cast<DcrDataModel>();
                  orderCustomers.removeWhere((element) => !element.magic!);

                  return genContent(orderCustomers);
                },
              ),
            ),
          ],
          // child: SafeArea(
          //   child: ValueListenableBuilder(
          //     valueListenable: Boxes.dcrUsers().listenable(),
          //     builder: (BuildContext context, Box box, Widget? child) {
          //       final orderCustomers = box.values.toList().cast<DcrDataModel>();

          //       return genContent(orderCustomers);
          //     },
          //   ),
          // ),
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
          return Card(
            // color: Colors.white,
            child: ExpansionTile(
              title: Text(
                "${user[index].docName}(${user[index].docId})",
                maxLines: 2,
                // style: TextStyle(
                //     color: user[index].magic == true
                //         ? const Color.fromARGB(255, 0, 174, 29)
                //         : null),
              ),
              subtitle: Text(
                '${user[index].areaName}(${user[index].areaId})',
                style: const TextStyle(
                    color:
                        // user[index].magic == true
                        //     ?
                        Colors.grey
                    // : null

                    ),
              ),
              trailing: user[index].magic == true
                  ? Transform(
                      transform:
                          Matrix4.rotationY(0.2), // Adjust the rotation angle
                      child: Opacity(
                        opacity: 0.6,
                        child: Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                'assets/icons/m.png',
                              ), // Replace with your image path
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                            color: Colors.green,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  //  SizedBox(
                  //                   height: 30,
                  //                   child: Image.asset(
                  //                     'assets/images/m.png',
                  //                     //color: Colors.deepOrange,
                  //                   ))

                  // Transform(
                  //     alignment: Alignment.center,
                  //     transform: Matrix4.rotationZ(3.1415926535897932 / 4),
                  //     child:  SizedBox(
                  //                   height: 30,
                  //                   child: Image.asset(
                  //                     'assets/images/m.png',
                  //                     //color: Colors.deepOrange,
                  //                   )),
                  //   )
                  : const SizedBox.shrink(),
              children: [
                (user[index].magicBrandList != null &&
                        user[index].magicBrandList!.isNotEmpty)
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8.0),
                        child: Row(children: [
                          Expanded(
                              child: Wrap(
                            spacing: 3.0,
                            runSpacing: 3.0,
                            children: user[index]
                                .magicBrandList!
                                .map(
                                  (e) => Container(
                                    // margin: EdgeInsets.all(3.0),
                                    padding: const EdgeInsets.all(3.0),
                                    decoration: BoxDecoration(
                                        // color: Colors.green,
                                        // color: Color(
                                        //         (math.Random().nextDouble() *
                                        //                 0xFFFFFF)
                                        //             .toInt())
                                        //     .withOpacity(.8),
                                        color: Colors.primaries[Random()
                                                .nextInt(
                                                    Colors.primaries.length)]
                                            .withOpacity(.4),
                                        borderRadius: BorderRadius.circular(5)),

                                    child: Text(
                                      e,
                                      style: const TextStyle(
                                        fontSize: 9,
                                        color: Color.fromARGB(255, 50, 49, 49),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ))
                        ]),
                      )
                    : const SizedBox.shrink(),
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
                              magicBrand: user[index].magicBrandList ?? [],
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
          );
        },
      );
    }
  }
}
