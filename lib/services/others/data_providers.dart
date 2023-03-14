import 'package:MREPORTING/services/others/apis.dart';
import 'package:http/http.dart' as http;

class DataProviders {
  Future<http.Response> dmPathData(String cid) async {
    late http.Response response;
    try {
      response = await http.get(
        Uri.parse(Apis.dmpath(cid)),
      );
    } catch (e) {
      // ignore: avoid_print
      print('dmPath: $e');
    }
    return response;
  }

  Future<http.Response> userLogin(
      String loginUrl,
      String cid,
      String userId,
      String password,
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String version) async {
    late http.Response response;
    try {
      response = await http.get(
        Uri.parse(
            '$loginUrl?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=$deviceModel'
            '_$version'),
      );
    } catch (e) {
      // ignore: avoid_print
      print('UserLogin: $e');
    }
    return response;
  }
}
