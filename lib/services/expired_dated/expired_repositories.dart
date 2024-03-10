import 'dart:convert';
import 'package:MREPORTING/models/expired_dated/expired_dated_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/expired_dated/expired_data_provider.dart';
import 'package:MREPORTING/services/expired_dated/expired_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ExpiredRepositoryRepo{
  //========================================== sync expired items ========================================
  Future<ExpiredItemListDataModel?> syncExpiredItems(String routeName, String syncUrl, String cid, String userId, String userpass) async {
    ExpiredItemListDataModel? expiredModelDataModel;
    try {
      final http.Response response =await ExpiredDataProviders().syncExpiredDate(syncUrl, cid, userId, userpass);
      Map<String, dynamic> responseBody = json.decode(response.body);
      final status = responseBody['status'];
      if (status == 'Success') {
        expiredModelDataModel=expiredItemListDataModelFromJson(response.body);
        ExpiredServices().putExpiredDate(expiredModelDataModel);
        AllServices().toastMessage(responseBody['ret_str'].toString(), Colors.green, Colors.white, 16);
        return expiredModelDataModel;
      }
      else{
        AllServices().toastMessage(responseBody['ret_str'].toString(), Colors.red, Colors.white, 16);
        return expiredModelDataModel;
      }
    } catch (e) {
       AllServices().toastMessage(e.toString(), Colors.red, Colors.white, 16);
    }
    return expiredModelDataModel;
  }


  //======================================== expired irtem submit==================================
  Future<Map<String, dynamic>> expiredSubmitRepo(
      String submitUrl,
      String? cid,
      String? userId,
      String? userPassword,
      String? deviceId,
      String clientId,
      String noteText,
      String itemString,
      double latitude,
      double longitude
      ) async {
    final http.Response response;
    Map<String, dynamic> orderInfo = {};
    // print();
    try {
      response = await ExpiredDataProviders().expiredItemsSubmit(
          submitUrl,
          cid,
          userId,
          userPassword,
          deviceId,
          clientId,
          noteText,
          itemString,
          latitude,
          longitude);

      if (response.statusCode == 200) {
        orderInfo = json.decode(response.body);
        return orderInfo;
      }
    } on Exception catch (e) {
      AllServices().toastMessage('$e', Colors.red, Colors.white, 16);
      print('Error Message: $e');
      return orderInfo;
    }
    return orderInfo;
  }
}