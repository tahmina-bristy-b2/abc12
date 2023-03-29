import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

//******************************************Per Order calculation*************************************************************** */
  double totalCount(AddItemModel model) {
    double total = (model.tp + model.vat) * model.quantity;
    return total;
  }

//============================================== Delete Per Item ===========================================
  deleteSingleOrderItem(Box<CustomerDataModel> customerBox,
      Box<AddItemModel> itemBox, String clientId, String itemId) {
    dynamic desireKey;
    customerBox.toMap().forEach((key, value) {
      if (value.clientId == clientId) {
        desireKey = key;
      }
    });

    CustomerDataModel? clientData = customerBox.get(desireKey);
    if (clientData!.isInBox) {
      clientData.itemList.removeWhere((element) => element.item_id == itemId);
    }
    customerBox.put(desireKey, clientData);
  }

  //===================================================Total Order Calculation================================================================
  Map<String, dynamic> ordertotalAmount(String itemString, double orderAmount,
      List<AddItemModel> finalItemDataList, double total, String totalAmount) {
    Map<String, dynamic> mapData = {
      "TotalAmount": totalAmount,
      "ItemString": itemString
    };
    itemString = '';
    orderAmount = 0.0;
    if (finalItemDataList.isNotEmpty) {
      for (var element in finalItemDataList) {
        total = (element.tp + element.vat) * element.quantity;
        if (itemString == '' && element.quantity != 0) {
          itemString = '${element.item_id}|${element.quantity}';
        } else if (element.quantity != 0) {
          itemString += '||${element.item_id}|${element.quantity}';
        }
        orderAmount = orderAmount + total;
        totalAmount = orderAmount.toStringAsFixed(2);
      }
    }
    mapData["TotalAmount"] = totalAmount;
    mapData["ItemString"] = itemString;
    return mapData;
  }

//=======================================================Oder Draft Data Update===================================================================================
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

//==================================================Delete Order Item=============================================================================

  deleteOrderItem(String id) {
    final box = Hive.box<AddItemModel>("orderedItem");

    final Map<dynamic, AddItemModel> deliveriesMap = box.toMap();
    dynamic desiredKey;
    deliveriesMap.forEach((key, value) {
      if (value.item_id == id) desiredKey = key;
    });
    box.delete(desiredKey);
  }
}
