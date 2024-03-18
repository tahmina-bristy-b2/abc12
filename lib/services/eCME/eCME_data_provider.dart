import 'package:MREPORTING/services/eCME/eCME_apis.dart';
import 'package:http/http.dart' as http;

class ECMEDataProviders{
  //=========================================== E-CME Settings api=====================================================
  Future<http.Response> getECMESettingsInfo(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;

    print(
        "getECMESettingsInfo==${ECMEApis().getECMEDataDetails(eDsrSettingsUrl, cid, userId, userPass)}");
    response = await http.get(
      Uri.parse(
          ECMEApis().getECMEDataDetails(eDsrSettingsUrl, cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }
}