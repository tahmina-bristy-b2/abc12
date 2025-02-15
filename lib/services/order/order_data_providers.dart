import 'dart:convert';
import 'package:MREPORTING_OFFLINE/services/order/order_apis.dart';
import 'package:http/http.dart' as http;

class OrderDataProviders {
  //################################ Sync Client  Data########################
  Future<http.Response> syncClientDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(OrderApis.syncClientApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ Sync Item  Data########################
  Future<http.Response> syncItemDP(
      String syncUrl, String cid, String userId, String userpass) async {
    print("items =${OrderApis.syncItemApi(syncUrl, cid, userId, userpass)}");
    final response = await http.get(
      Uri.parse(OrderApis.syncItemApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

//=======================================client Outstanding URL=================================================================================
  Future<http.Response> showOutstandingDP(
      String clientOutstUrl,
      String? cid,
      String? userId,
      String? userPassword,
      String deviceId,
      String clientId) async {
    // print(
    //     "object=${OrderApis.showOutstandingApi(clientOutstUrl, cid, userId, userPassword, deviceId, clientId)}");
    final response = await http.get(
      Uri.parse(OrderApis.showOutstandingApi(
          clientOutstUrl, cid, userId, userPassword, deviceId, clientId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    return response;
  }

//==================================================Order Submit ===============================
  Future<http.Response> orerSubmitDp(
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
    http.Response response;

    // print(submitUrl);

    // print(
    //     "${OrderApis.orderSubmitApi(submitUrl)}?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$clientId&delivery_date=$dateSelected&delivery_time=$selectedDeliveryTime&payment_mode=$slectedPayMethod&offer=$initialOffer&note=$noteText&item_list=$itemString&latitude=$latitude&longitude=$longitude");
    // var param =
    //     "${OrderApis.orderSubmitApi(submitUrl)}?cid=$cid&user_id=$userId&user_pass=$userPassword&device_id=$deviceId&client_id=$clientId&delivery_date=$dateSelected&delivery_time=$selectedDeliveryTime&payment_mode=$slectedPayMethod&offer=$initialOffer&note=$noteText&item_list=$itemString&latitude=$latitude&longitude=$longitude";
    // print(param);
    // // response = await http.get(
    // //   Uri.parse(param),
    // // );
    // var a = jsonEncode(
    //   <String, dynamic>{
    //     'cid': cid,
    //     'user_id': userId,
    //     'user_pass': userPassword,
    //     'device_id': deviceId,
    //     'client_id': clientId,
    //     'delivery_date': dateSelected,
    //     'delivery_time': selectedDeliveryTime,
    //     'payment_mode': slectedPayMethod,
    //     'offer': initialOffer,
    //     'note': noteText,
    //     "item_list": itemString,
    //     "latitude": latitude,
    //     'longitude': longitude,
    //   },
    // );
    // print(a);

    response = await http.post(
      Uri.parse(OrderApis.orderSubmitApi(submitUrl)),
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
          'delivery_date': dateSelected,
          'delivery_time': selectedDeliveryTime,
          'payment_mode': slectedPayMethod,
          'offer': initialOffer,
          'note': noteText,
          "item_list": itemString,
          "latitude": latitude,
          'longitude': longitude,
        },
      ),
    );
    return response;
  }
}
