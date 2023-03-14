import 'dart:convert';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/services/order/order_data_providers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OrderRepositories {
  Future syncClient(
      String syncUrl, String cid, String userId, String userpass) async {
    try {
      final http.Response response = await OrderDataProviders()
          .syncClientDP(syncUrl, cid, userId, userpass);
      Map<String, dynamic> jsonResponseDcrData = jsonDecode(response.body);
      final status = jsonResponseDcrData['status'];
      var clientList = jsonResponseDcrData['clientList'];

      if (status == 'Success') {
        await Boxes().openAndAddDataToBox('data', clientList);

        // Timer(const Duration(seconds: 3), () => Navigator.pop(context));
      } else {
        // ScaffoldMessenger.of(context)
        //     .showSnackBar(const SnackBar(content: Text('Didn\'t sync Data')));
      }
    } catch (e) {
      print('syncClient: $e');
    }
  }
}
