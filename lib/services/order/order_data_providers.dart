import 'package:MREPORTING/services/order/order_apis.dart';
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
    final response = await http.get(
      Uri.parse(OrderApis.syncItemApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }
}
