import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SyncItemstoHive {
  Box? box;

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('syncItemData');
  }

  Future<dynamic> syncItemsToHive(String sync_url, String cid, String userId,
      String userPassward, BuildContext context) async {
    await openBox();
    print(
        '${sync_url}api_item/item_list?cid=$cid&user_id=$userId&user_pass=$userPassward');
    try {
      var response = await http.get(Uri.parse(
          '${sync_url}api_item/item_list?cid=$cid&user_id=$userId&user_pass=$userPassward'));
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      var status = jsonResponseDcrData['status'];
      var itemList = jsonResponseDcrData['itemList'];

      if (status == 'Success') {
        await putData(itemList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text('Inavalid User Id & Password\n Please Login again!')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putData(itemData) async {
    await box!.clear();

    for (var d in itemData) {
      box!.add(d);
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        barrierColor: Colors.black,
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(
                height: 10,
              ),
              DefaultTextStyle(
                style: TextStyle(color: Colors.white, fontSize: 18),
                child: Text('Item data synchronizing... '),
              )
            ],
          );
        });
  }
}
