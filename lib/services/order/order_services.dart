import 'dart:convert';

import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/order/order_repositories.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    print("1itemSTring= $itemString");
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

  deleteOrderItem(Box<CustomerDataModel> customerBox,
      List<AddItemModel> orderDataBox, String clientId) {
    dynamic desireKey;
    customerBox.toMap().forEach((key, value) {
      if (value.clientId == clientId) {
        desireKey = key;
      }
    });
    customerBox.delete(desireKey);
  }

  //=======================================client Outstanding APi Data=================================================================================

  Future<String> getOutstandingData(
      String clientOutstUrl,
      String? cid,
      String? userId,
      String? userPassword,
      String? deviceId,
      String clientId) async {
    String resultofOuts = '';
    http.Response response = await OrderRepositories().outstanding(
        clientOutstUrl, cid, userId, userPassword, deviceId, clientId);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data["outstanding"] == "") {
        resultofOuts = "No Outstanding";
      } else {
        if (data["outstanding"] != 0) {
          resultofOuts = data["outstanding"].replaceAll(", ", "\n").toString();
        } else {
          resultofOuts = data["outstanding"].toString();
        }
      }
    } else {
      AllServices().toastMessage('Order Failed', Colors.red, Colors.white, 16);
    }
    return resultofOuts;
  }
}
