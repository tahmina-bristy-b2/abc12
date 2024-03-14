import 'dart:convert';

import 'package:MREPORTING/services/expired_dated/expired_apis.dart';
import 'package:http/http.dart' as http;
class ExpiredDataProviders{
 
  Future<http.Response> syncExpiredDate(
      String syncUrl, String cid, String userId, String userpass) async {
        print("expired items =${ExpiredApi.syncExpiredItemsApi(syncUrl, cid, userId, userpass)}");
        final response = await http.get(
          Uri.parse(ExpiredApi.syncExpiredItemsApi(syncUrl, cid, userId, userpass)),
        );
    return response;
  }


  //==================================================Order Submit ===============================
  Future<http.Response> expiredItemsSubmit(
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
    http.Response response;
    response = await http.post(
      Uri.parse(ExpiredApi.orderSubmitApi(submitUrl)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'cid': cid,
          'user_id': userId,
          'user_pass': userPassword,
          'device_id': deviceId,
          'client_id': clientId,
          "latitude": latitude,
          'longitude': longitude,
          'note': noteText,
          "item_list": itemString,
        },
      ),
    );
    return response;
  }
}