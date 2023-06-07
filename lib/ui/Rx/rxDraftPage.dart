import 'dart:io';

import 'package:MREPORTING/services/rx/rx_services.dart';
import 'package:extended_image/extended_image.dart';
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
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  void initState() {
    super.initState();
  }

  Future<void> deleteRxDoctor(RxDcrDataModel rxDcrDataModel) async {
    rxDcrDataModel.delete();
  }

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
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        padding: const EdgeInsets.all(8),
        itemCount: user.length,
        itemBuilder: (BuildContext ctx, index) {
          // int space = user[index].presImage.indexOf(" ");
          // String removeSpace = user[index]
          //     .presImage
          //     .substring(space + 1, user[index].presImage.length);
          // String finalImage = removeSpace.replaceAll("'", '');
          // File? imageFile = File(user[index].presImage);
          //   File? rxImageFile = await RxServices().getImageFrom(
          // imageFile:  File(finalImage) );

          return Stack(
            // alignment: AlignmentDirectional.topEnd,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          RxPage(isRxEdit: true, draftRxData: user[index]),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 100,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(0)),
                        child:
                            ExtendedImage.file(File(user[index].rxSmallImage),
                                // height: 100,
                                // width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover)
                        // Image.file(imageFile)
                        ),
                    Text(
                      user[index].docName,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: -10,
                right: -10,
                child: IconButton(
                  onPressed: () {
                    showAlertDialog(context, user[index]);
                    // deleteRxDoctor(user[index]);
                    // setState(() {});
                  },
                  // visualDensity: VisualDensity.adaptivePlatformDensity,
                  icon: const Icon(
                    Icons.cancel,
                    // color: Colors.amber,
                    // fill: 1.0,
                  ),
                  color: Colors.redAccent[700],
                  iconSize: 23,
                  tooltip: 'Delete',
                ),
              ),
              // Positioned(
              //   bottom: -15,
              //   left: 2,
              //   child: Text(
              //     "${user[index].docName} (${user[index].docId}) ",
              //     overflow: TextOverflow.ellipsis,
              //     style: const TextStyle(
              //         // fontWeight: FontWeight.bold,
              //         ),
              //   ),
              // ),
              // Positioned(
              //   bottom: 2,
              //   left: 2,
              //   child: Text(
              //     user[index].areaName,
              //     // style: const TextStyle(fontSize: 13),
              //   ),
              // ),
            ],
          );
        },
      );

      // ListView.builder(
      //   itemCount: user.length,
      //   itemBuilder: (BuildContext context, int index) {
      //     int space = user[index].presImage.indexOf(" ");
      //     String removeSpace = user[index]
      //         .presImage
      //         .substring(space + 1, user[index].presImage.length);
      //     String finalImage = removeSpace.replaceAll("'", '');

      //     return GestureDetector(
      //       onTap: () {},
      //       child: Card(
      //         // elevation: 10,
      //         color: const Color.fromARGB(255, 207, 240, 207),
      //         child: ExpansionTile(
      //           childrenPadding: const EdgeInsets.all(0),
      //           title: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             children: [
      //               Expanded(
      //                 child: SizedBox(
      //                   height: screenHeight / 8,
      //                   width: screenWidth / 6,
      //                   child: Image(
      //                     fit: BoxFit.cover,
      //                     image: FileImage(File(finalImage)),
      //                   ),
      //                 ),
      //               ),
      //               const SizedBox(
      //                 width: 30,
      //               ),
      //               Expanded(
      //                 flex: 2,
      //                 child: Column(
      //                   children: [
      //                     Text(
      //                       "${user[index].docName} (${user[index].docId}) ",
      //                       overflow: TextOverflow.ellipsis,
      //                       style: const TextStyle(
      //                           fontWeight: FontWeight.bold, fontSize: 16),
      //                     ),
      //                     Text(
      //                       user[index].areaName,
      //                       style: const TextStyle(fontSize: 13),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //           children: [
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceAround,
      //               children: [
      //                 TextButton.icon(
      //                   onPressed: () {
      //                     deleteRxDoctor(user[index]);
      //                     setState(() {});
      //                   },
      //                   icon: const Icon(
      //                     Icons.delete,
      //                     color: Colors.red,
      //                   ),
      //                   label: const Text(
      //                     "Delete",
      //                     style: TextStyle(color: Colors.red),
      //                   ),
      //                 ),
      //                 TextButton.icon(
      //                   onPressed: () {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (_) => RxPage(
      //                             isRxEdit: true, draftRxData: user[index]),
      //                       ),
      //                     );
      //                   },
      //                   icon: const Icon(
      //                     Icons.arrow_forward_outlined,
      //                     color: Colors.blue,
      //                   ),
      //                   label: const Text(
      //                     "Details",
      //                     style: TextStyle(color: Colors.blue),
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           ],
      //         ),
      //       ),
      //     );
      //   },
      // );
    }
  }

//show Alert Dialog.......................
  showAlertDialog(BuildContext context, RxDcrDataModel rxDcr) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.spaceBetween,

            // icon: const Icon(
            //   Icons.dangerous,
            //   size: 30,
            //   color: Colors.red,
            // ),
            // title: const Text('Delete This RX?'),
            content: const Text("Delete This RX?"),
            //  // content: const Text(
            //     "This will delete the Prescription from your Draft."),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    deleteRxDoctor(rxDcr);

                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  )),
            ],
          );
        });
  }
}
