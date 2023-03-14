import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderServices {
  //************************************* It uses for making Customer unique in CustomerListPage ****************************** */
  int incrementCounter(int count) {
    count++;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('_counter', count);
    });

    return count;
  }
}
