import 'dart:convert';

import 'package:MREPORTING/local_storage/boxes.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/order/order_apis.dart';
import 'package:MREPORTING/services/order/order_data_providers.dart';
import 'package:flutter/material.dart';
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

  //=======================================client Outstanding URL=================================================================================
  //============================================================================================================================================

  Future<http.Response> outstanding(
      String clientOutstUrl,
      String? cid,
      String? userId,
      String? userPassword,
      String? deviceId,
      String clientId) async {
    final http.Response response;
    print(
        "clientOustStanding$clientOutstUrl?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$clientId'");
    try {
      response = await OrderDataProviders().showOutstandingDP(
          clientOutstUrl, cid, userId, userPassword, deviceId!, clientId);
    } on Exception catch (e) {
      AllServices().toastMessage(
          'Please check connection or data!', Colors.red, Colors.white, 16);
      throw Exception(e);
    }

    return response;
  }

  //======================================= Order Submit =================================================================================
  Future<Map<String, dynamic>> OrderSubmit(
      String submitUrl,
      String? cid,
      String? userId,
      String? userPassword,
      String? deviceId,
      String clientId,
      String dateSelected,
      String selectedDeliveryTime,
      String slectedPayMethod,
      String initialOffer,
      String noteText,
      String itemString,
      double latitude,
      double longitude) async {
    final http.Response response;
    Map<String, dynamic> orderInfo = {};
    try {
      response = await OrderDataProviders().orerSubmitDp(
          submitUrl,
          cid,
          userId,
          userPassword,
          deviceId,
          clientId,
          dateSelected,
          selectedDeliveryTime,
          slectedPayMethod,
          initialOffer,
          noteText,
          itemString,
          latitude,
          longitude);
      orderInfo = json.decode(response.body);
      return orderInfo;
    } on Exception catch (e) {
      throw Exception(e);
    }
  }
}
