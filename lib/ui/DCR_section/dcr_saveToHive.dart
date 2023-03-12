import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:MREPORTING/ui/DCR_section/dcr_list_page.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SyncDcrtoHive {
  Box? box;
  List dcrDataList = [];

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrListData');
  }

  Future<dynamic> syncDcrToHive(String sync_url, String cid, String userId,
      String userPassward, BuildContext context) async {
    await openBox();
    try {
      var response = await http.get(Uri.parse(
          '${sync_url}api_doctor/get_doctor?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> res_data = jsonResponseDcrData['res_data'];

      var status = res_data['status'];
      var doctorList = res_data['doctorList'];

      if (status == 'Success') {
        await putData(doctorList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Doctor list')));
      }
    } on Exception catch (_) {
      // print(e);
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putData(dcrData) async {
    await box!.clear();

    for (var d in dcrData) {
      box!.add(d);
    }
  }

  getData(BuildContext context) async {
    await openBox();

    var mymap = box!.toMap().values.toList();

    if (mymap.isEmpty) {
      dcrDataList.add('empty');
    } else {
      dcrDataList = mymap;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DcrListPage(dcrDataList: dcrDataList),
        ),
      );
    }
  }

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierColor: Colors.black,
        barrierDismissible: false,
        // barrierDismissible: false,
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
                child: Text('DCR data synchronizing... '),
              )
            ],
          );
        });
  }
}
