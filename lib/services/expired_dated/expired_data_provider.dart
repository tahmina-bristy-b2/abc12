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
}