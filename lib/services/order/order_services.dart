import 'package:flutter/material.dart';

class OrderServices {
  List customerSearchMethod(String enteredKeyword, List data) {
    List foundUsers;
    foundUsers = data;
    List results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = foundUsers;
    } else {
      var starts = foundUsers
          .where((s) => s['client_name']
              .toLowerCase()
              .startsWith(enteredKeyword.toLowerCase()))
          .toList();

      var contains = foundUsers
          .where((s) =>
              s['client_name']
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) &&
              !s['client_name']
                  .toLowerCase()
                  .startsWith(enteredKeyword.toLowerCase()))
          .toList()
        ..sort((a, b) => a['client_name']
            .toLowerCase()
            .compareTo(b['client_name'].toLowerCase()));

      results = [...starts, ...contains];
    }
    return results;

    // Refresh the UI....................
    // setState(() {
    //   foundUsers = results;
    // });
  }
}
