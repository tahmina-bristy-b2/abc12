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

  double totalCount(AddItemModel model) {
    double total = (model.tp + model.vat) * model.quantity;
    return total;
  }

  deleteSingleOrderItem(
      int dcrUniqueKey, int index, List<AddItemModel> finalItemDataList) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.uiqueKey1 == dcrUniqueKey) desiredKey = key;
    });
    box.delete(desiredKey);
    finalItemDataList.removeAt(index);
  }

  // order Amount calculation....................................................

  double ordertotalAmount(String itemString, double orderAmount,
      List<AddItemModel> finalItemDataList, double total, String totalAmount) {
    itemString = '';
    orderAmount = 0.0;
    if (finalItemDataList.isNotEmpty) {
      for (var element in finalItemDataList) {
        total = (element.tp + element.vat) * element.quantity;
        // print(total);

        if (itemString == '' && element.quantity != 0) {
          itemString = '${element.item_id}|${element.quantity}';
        } else if (element.quantity != 0) {
          itemString += '||${element.item_id}|${element.quantity}';
        }

        orderAmount = orderAmount + total;

        totalAmount = orderAmount.toStringAsFixed(2);

        // print(itemString);
      }
      // print(itemString);
    } else {
      totalAmount = '';
    }
    return total;
  }
}
