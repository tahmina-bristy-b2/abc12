import 'package:MREPORTING/services/order/order_apis.dart';
import 'package:http/http.dart' as http;

class OrderDataProviders {
  Future<http.Response> syncClientDP(
      String syncUrl, String cid, String userId, String userpass) async {
    http.Response response = await http.get(
      Uri.parse(OrderApis.syncClientApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }
}
