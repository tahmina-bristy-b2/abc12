import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import 'package:geolocator/geolocator.dart';

class AllServices {
  //************************************* This method works for seraching *******************************/
  List searchDynamicMethod(String enteredKeyword, List data, String keyName) {
    List serachedData;
    serachedData = data;
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = serachedData;
    } else {
      var starts = serachedData
          .where((s) =>
              s[keyName].toLowerCase().startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = serachedData
          .where((s) =>
              s[keyName].toLowerCase().contains(enteredKeyword.toLowerCase()) &&
              !s[keyName]
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) =>
            a[keyName].toLowerCase().compareTo(b[keyName].toLowerCase()));

      results = [...starts, ...contains];
    }
    return results;
  }

//               // Todo!<<<<<<<<<<<<<<<<<<<<<<       Splash Screen     >>>>>>>>>>>>>>>>>>>>>>>>>>

//                             //todo Get Position for Track Location

//  Future<Position> determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }

// //todo!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  HOME PAGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// //todo>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  CustomerList PAGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Future<DateTime?> pickDate(context, dateTime) => showDatePicker(
        context: context,
        initialDate: dateTime,
        firstDate: DateTime(1800),
        lastDate: DateTime(2060),
        builder: (context, child) {
          return Theme(
            data: ThemeData(
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFE2EFDA),
                surface: Colors.teal,
              ),
              dialogBackgroundColor: Colors.blueGrey,
            ), // This will change to light theme.
            child: child!,
          );
        },
      );
// //todo    Tost Message  >>>>>>>>>>>>>>>>>>>

  void toastMessage(
      String msg, Color backgroundColor, Color textColor, fontSize) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16);
  }

// This message for Submit data made by Md-Moniruzzaman, Reason: ToastGravity
  void toastMessageForSubmitData(
      String msg, Color backgroundColor, Color textColor, fontSize) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: 16);
  }

// toast messages updated into RX for submitToastforphoto Only
//===================================================================================================================================
//==========================================SAMIRA========================================================================
//===================================================================================================================================

  // void rejectMessageForUser(String msg) {
  //   Fluttertoast.showToast(
  //       msg: msg,
  //       toastLength: Toast.LENGTH_LONG,
  //       gravity: ToastGravity.SNACKBAR,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  // Get Sync Saved Data from hive
  Future<List> getSyncSavedData(String tableName) async {
    List getList = [];
    Box? box = await Boxes().openBox(tableName);

    getList = box.toMap().values.toList();
    if (getList.isNotEmpty) {
      return getList;
    }
    return getList;
  }
}
