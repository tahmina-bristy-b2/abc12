import 'dart:convert';

import 'package:MREPORTING_OFFLINE/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING_OFFLINE/services/all_services.dart';
import 'package:MREPORTING_OFFLINE/services/order/order_repositories.dart';
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
    // print("1itemSTring= $itemString");
    return mapData;
  }

  //===================================================Total Order Calculation================================================================
  String orderTotalTPAmount(List<AddItemModel> finalItemDataList) {
    double totalTP = 0.0;
    double total = 0.0;
    if (finalItemDataList.isNotEmpty) {
      for (var element in finalItemDataList) {
        total = element.tp * element.quantity;

        totalTP = totalTP + total;
      }
    }

    return totalTP.toStringAsFixed(2);
  }

//=======================================================Oder Draft Data Update===================================================================================
  orderDraftDataUpdate(
    List<AddItemModel> itemList,
    Box<CustomerDataModel> customerBox,
    String clientId,
    String dateSelected,
    String selectedDeliveryTime,
    String initialOffer,
    String note,
    String slectedPayMethod,
  ) {
    dynamic desireKey;
    customerBox.toMap().forEach((key, value) {
      if (value.clientId == clientId) {
        desireKey = key;
      }
    });
    print("forder services=$note");

    CustomerDataModel? clientData = customerBox.get(desireKey);
    if (clientData!.isInBox) {
      clientData.itemList = itemList;
      clientData.deliveryDate = dateSelected;
      clientData.deliveryTime = selectedDeliveryTime;
      clientData.offer = initialOffer;
      clientData.note = note;
      clientData.paymentMethod = slectedPayMethod;
      // print("order services 2=$note");
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

  //======================================Client Delete in Draft order page==========================================================================
  deleteEachClient(Box<CustomerDataModel> customerBox,
      List<AddItemModel> orderDataBox, String clientId) {
    dynamic desireKey;
    customerBox.toMap().forEach((key, value) {
      if (value.clientId == clientId) {
        desireKey = key;
      }
    });
    customerBox.delete(desireKey);
  }

  //========================================item details in Draft order page======================================================================
  showDetailsDraftItem(List<AddItemModel> finalItemDataList,
      List<CustomerDataModel> user, int index) {
    finalItemDataList
        .where((item) => item.item_id == user[index].clientId)
        .forEach((item) {
      user[index].itemList.add(AddItemModel(
            quantity: item.quantity,
            item_name: item.item_name,
            tp: item.tp,
            item_id: item.item_id,
            category_id: item.category_id,
            vat: item.vat,
            manufacturer: item.manufacturer,
          ));
    });
  }

  //===============================================order Count==================================================================================
  Map<String, dynamic> orderCount(
      List<dynamic> foundUsers,
      int index,
      Map<String, TextEditingController> controllers,
      List<AddItemModel> tempList,
      bool incLen,
      double neworderamount,
      double total) {
    Map<String, dynamic> mapData = {
      "neworderamount": neworderamount,
      "total": total
    };

    final temp = AddItemModel(
      quantity: int.parse(controllers[foundUsers[index]['item_id']]!.text),
      item_name: foundUsers[index]['item_name'],
      tp: foundUsers[index]['tp'],
      item_id: foundUsers[index]['item_id'],
      category_id: foundUsers[index]['category_id'],
      vat: foundUsers[index]['vat'],
      manufacturer: foundUsers[index]['manufacturer'],
    );
    tempList.removeWhere((item) => item.item_id == temp.item_id);
    tempList.add(temp);
    incLen = false;
    neworderamount = 0.0;
    for (var element in tempList) {
      total = (element.tp + element.vat) * element.quantity;
      neworderamount = neworderamount + total;
    }
    mapData["total"] = total;
    mapData["neworderamount"] = neworderamount;
    return mapData;
  }

  //=========================regular Discount On Tp ==================================

  String regDiscOnTp(List<AddItemModel> orderedItem) {
    double regDisOnTp = 0.0;
    // orderedItem
    //     .removeWhere((element) => element.promo != '' && element.promo != null);

    for (var element in orderedItem) {
      if (element.promo == '') {
        regDisOnTp = regDisOnTp + (element.tp * element.quantity);
      }
    }
    return regDisOnTp.toStringAsFixed(2);
  }
}
