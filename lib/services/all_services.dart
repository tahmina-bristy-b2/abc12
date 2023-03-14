import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';

class AllServices {
  //************************************* This method works for seraching *******************************/
  List searchDynamicMethod(String enteredKeyword, List data, String keyName) {
    List foundUsers;
    foundUsers = data;
    List results = [];
    if (enteredKeyword.isEmpty) {
      results = foundUsers;
    } else {
      var starts = foundUsers
          .where((s) =>
              s[keyName].toLowerCase().startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
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

// //todo    Tost Message  >>>>>>>>>>>>>>>>>>>

  void messageForUser(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
