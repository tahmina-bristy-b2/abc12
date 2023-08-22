import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/models/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  //************************************* This method works for EDSR Doctor seraching *******************************/
  List doctorSearch(String enteredKeyword, List serachedData, String keyName1,
      String keyName2, String keyName3, String keyName4) {
    List results = [];
    if (enteredKeyword.isEmpty || enteredKeyword == "") {
      results = serachedData;
    } else {
      var starts = serachedData
          .where((s) =>
              s[keyName1]
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()) ||
              s[keyName2]
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()) ||
              s[keyName2]
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()) ||
              s[keyName3]
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = serachedData
          .where((s) =>
              (s[keyName1]
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s[keyName1]
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())) ||
              (s[keyName2]
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s[keyName2]
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())) ||
              (s[keyName3]
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s[keyName3]
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())) ||
              (s[keyName4]
                      .toLowerCase()
                      .contains(enteredKeyword.toLowerCase()) &&
                  !s[keyName4]
                      .toLowerCase()
                      .startsWith(enteredKeyword.toLowerCase())))
          .toList()
        ..sort((a, b) =>
            a[keyName1].toLowerCase().compareTo(b[keyName1].toLowerCase()));

      results = [...starts, ...contains];
    }
    return results;
  }

//// Todo!<<<<<<<<<<<<<<<<<<<<<<       Splash Screen     >>>>>>>>>>>>>>>>>>>>>>>>>>

//                             //todo Get Position for Track Location

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = determinePosition();
    double latitude = 0.0;
    double longitude = 0.0;
    data.then((value) {
      // print("value $value");

      latitude = value.latitude;
      longitude = value.longitude;

      SharedPreferences.getInstance().then((prefs) {
        prefs.setDouble("latitude", latitude);
        prefs.setDouble("longitude", longitude);
      });
    }).catchError((error) {
      // print("Error $error");
    });
  }

// //todo!>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  HOME PAGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// //todo>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>  CustomerList PAGE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  Future<DateTime?> pickDate(context, dateTime) => showDatePicker(
        context: context,
        initialDate: dateTime == "" ? DateTime.now() : DateTime.parse(dateTime),
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
//============================================================================================
//===============================SAMIRA===================================================
//==================================================================================

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

  // For Stock Product search======================

  List<StockList> searchStockProduct(
    String enteredKeyword,
    StockModel data,
  ) {
    List<StockList> serachedData;
    serachedData = data.stockList;
    List<StockList> results = [];
    if (enteredKeyword.isEmpty && enteredKeyword == '') {
      results = serachedData;
    } else {
      var starts = serachedData
          .where((s) =>
              s.itemDes.toLowerCase().startsWith(enteredKeyword.toLowerCase()))
          .toList();

      List<StockList> contains = serachedData
          .where((s) =>
              s.itemDes.toLowerCase().contains(enteredKeyword.toLowerCase()) &&
              !s.itemDes.toLowerCase().startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) =>
            a.itemDes.toLowerCase().compareTo(b.itemDes.toLowerCase()));

      results = [...starts, ...contains];
    }

    return results;
  }
}
