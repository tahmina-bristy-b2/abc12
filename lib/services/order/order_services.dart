import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  orderDraftDataUpdate(
    List<AddItemModel> itemList,
    Box<CustomerDataModel> customerBox,
    String clientId,
  ) {
    dynamic desireKey;
    customerBox.toMap().forEach((key, value) {
      if (value.clientId == clientId) {
        desireKey = key;
      }
    });

    CustomerDataModel? clientData = customerBox.get(desireKey);
    if (clientData!.isInBox) {
      clientData.itemList = itemList;
    }
    customerBox.put(desireKey, clientData);
  }
}
