import 'package:MREPORTING/services/dcr/dcr_apis.dart';
import 'package:http/http.dart' as http;

class DcrDataProviders {
  //################################ Sync DCR  Data########################
  Future<http.Response> syncDcrDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ Sync DCR Gift Data########################
  Future<http.Response> syncDcrGiftDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrGiftApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ Sync DCR Sample Data########################
  Future<http.Response> syncDcrSampleDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrSampleApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ Sync DCR Sample Data########################
  Future<http.Response> syncDcrPpmDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrPpmApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ DCR Area Client Data########################
  Future<http.Response> dcrAreaBaseClient(String syncUrl, String cid,
      String userId, String userpass, String areaID) async {
    print(DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID));

    final response = await http.get(
      Uri.parse(
          DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID)),
    );

    return response;
  }

  //################################ Doctor Settings########################
  Future<http.Response> docSettingsDP(
      String cid, String userId, String userpass) async {
    print(DcrApis.docSettingsApi);

    final response = await http.get(
      Uri.parse(
          "${DcrApis.docSettingsApi}?cid=$cid&user_id=$userId&user_pass=$userpass"),
    );

    return response;
  }
}
