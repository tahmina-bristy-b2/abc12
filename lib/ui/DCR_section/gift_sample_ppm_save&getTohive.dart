// ignore_for_file: file_names

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class SyncDcrGSPtoHive {
  Box? box;
  List doctorGiftlist = [];
  List doctorSamplelist = [];
  List doctorPpmlist = [];

  Future giftOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrGiftListData');
  }

  Future sampleOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrSampleListData');
  }

  Future ppmOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrPpmListData');
  }

  Future discussionOpenBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('dcrDiscussionListData');
  }

// Dcr Gift section.................................

  Future<dynamic> syncDcrGiftToHive(String sync_url, String cid, String userId,
      String userPassward, BuildContext context) async {
    await giftOpenBox();
    try {
      var response = await http.get(Uri.parse(
          '${sync_url}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> res_data = jsonResponseDcrData['res_data'];

      var status = res_data['status'];
      var giftList = res_data['giftList'];

      if (status == 'Success') {
        await putData(giftList);

        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Gift list')));
      }
    } on Exception catch (e) {
      // throw Exception("Error on server");
      print(e);
    }
    // return Future.value(true);
  }

  Future putData(dcrData) async {
    await box!.clear();

    for (var d in dcrData) {
      box!.add(d);
    }
  }

  //  Dcr Sample section............................................

  Future<dynamic> syncDcrSampleToHive(String sync_url, String cid,
      String userId, String userPassward, BuildContext context) async {
    await sampleOpenBox();
    try {
      print(
          '${sync_url}api_doctor/get_doctor_sample?cid=$cid&user_id=$userId&user_pass=$userPassward');
      var response = await http.get(Uri.parse(
          '${sync_url}api_doctor/get_doctor_sample?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> res_data = jsonResponseDcrData['res_data'];

      var status = res_data['status'];
      var sampleList = res_data['sampleList'];

      if (status == 'Success') {
        await putSampleData(sampleList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));
        // String msg = 'DCR Gift/Sample/PPM  Synchronizing..';

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Sample list')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putSampleData(dcrData) async {
    await box!.clear();

    for (var d in dcrData) {
      box!.add(d);
    }
  }

  // / Dcr PPM section.........................................................

  Future<dynamic> syncDcrPpmToHive(String sync_url, String cid, String userId,
      String userPassward, BuildContext context) async {
    await ppmOpenBox();
    try {
      var response = await http.get(Uri.parse(
          '${sync_url}api_doctor/get_doctor_ppm?cid=$cid&user_id=$userId&user_pass=$userPassward'));
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> res_data = jsonResponseDcrData['res_data'];

      var status = res_data['status'];
      var ppmList = res_data['ppmList'];

      if (status == 'Success') {
        await putPpmData(ppmList);
        Timer(const Duration(seconds: 3), () => Navigator.pop(context));
        // String msg = 'DCR Gift/Sample/PPM  Synchronizing..';

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync PPM list')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putPpmData(dcrData) async {
    await box!.clear();

    for (var d in dcrData) {
      box!.add(d);
    }
  }

  //=======================================================================================
  //==============================DCR Discussion======================================
  //=======================================================================================

  Future<dynamic> syncDcrDiscussiontToHive(String sync_url, String cid,
      String userId, String userPassward, BuildContext context) async {
    //=================  giftopenbox to discussionToOpenBox ================================
    //======================================================================================
    await giftOpenBox();

    //=================  giftopenbox to discussionToOpenBox ================================
    //======================================================================================
    try {
      var response = await http.get(Uri.parse(
          '${sync_url}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userPassward'));

      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      Map<String, dynamic> res_data = jsonResponseDcrData['res_data'];

      var status = res_data['status'];
      var giftList = res_data['giftList'];

      if (status == 'Success') {
        await putDiscussionData(giftList);

        Timer(const Duration(seconds: 3), () => Navigator.pop(context));

        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Sync success')));
        return buildShowDialog(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Did not sync Gift list')));
      }
    } on Exception catch (_) {
      throw Exception("Error on server");
    }
    // return Future.value(true);
  }

  Future putDiscussionData(dcrData) async {
    await box!.clear();

    for (var d in dcrData) {
      box!.add(d);
    }
  }

//============================================================================================================

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierColor: Colors.black,
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
                child: Text('DCR Gift/Sample/PPM  Synchronizing..'),
              )
            ],
          );
        });
  }
}
