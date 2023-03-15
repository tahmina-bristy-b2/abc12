import 'dart:convert';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/services/order/order_data_providers.dart';
import 'package:http/http.dart' as http;

class OrderRepositories {
  //################################ Sync Client List Data########################
  Future<List> syncClient(
      String syncUrl, String cid, String userId, String userpass) async {
    List clientList = [];
    try {
      final http.Response response = await OrderDataProviders()
          .syncClientDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponseDcrData = json.decode(response.body);
      final status = jsonResponseDcrData['status'];
      clientList = jsonResponseDcrData['clientList'];

      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('data', clientList);
        return clientList;

        // Timer(const Duration(seconds: 3), () => Navigator.pop(context));
      }
    } catch (e) {
      print('syncClient: $e');
    }

    return clientList;
  }

  //################################ Sync Item  Data########################
  Future<List> syncItem(
      String syncUrl, String cid, String userId, String userpass) async {
    List itemList = [];
    try {
      final http.Response response =
          await OrderDataProviders().syncItemDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponseDcrData = json.decode(response.body);
      final status = jsonResponseDcrData['status'];
      itemList = jsonResponseDcrData['itemList'];

      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('syncItemData', itemList);
        return itemList;

        // Timer(const Duration(seconds: 3), () => Navigator.pop(context));
      }
    } catch (e) {
      print('itemList: $e');
    }

    return itemList;
  }
}
