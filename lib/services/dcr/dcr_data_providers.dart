import 'dart:convert';

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

  //################################ Sync DCR Discussion Data########################
  Future<http.Response> syncDcrDisDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrDisApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ DCR Area Client Data########################
  Future<http.Response> dcrAreaBaseClient(String syncUrl, String cid,
      String userId, String userpass, String areaID) async {
    print(
        "DCR apis=${DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID)}");

    final response = await http.get(
      Uri.parse(
          DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID)),
    );

    return response;
  }

  //################################ Doctor Settings########################
  Future<http.Response> docSettingsDP(
      String cid, String userId, String userpass) async {
    // print(DcrApis.docSettingsApi);

    final response = await http.get(
      Uri.parse(
          "${DcrApis.docSettingsApi}?cid=$cid&user_id=$userId&user_pass=$userpass"),
    );

    return response;
  }

  Future<http.Response> getDoctorAddUrl(String addUrl, String params) async {
    final http.Response response;

    print("object=${DcrApis.doctorAddUrl(addUrl, params)}");
    response = await http.get(Uri.parse(DcrApis.doctorAddUrl(addUrl, params)));
    return response;
  }

  Future<http.Response> gspSubmitDP(
      String gspSubmitUrl,
      String cid,
      String userId,
      String userPass,
      String deviceId,
      String docId,
      String areaId,
      String dcrString,
      double lat,
      double lon,
      String itemString,
      String note) async {
    final response = await http.post(
      Uri.parse(DcrApis.gspSubmitApi(gspSubmitUrl)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'cid': cid,
          'user_id': userId,
          'user_pass': userPass,
          'device_id': deviceId,
          'doc_id': docId,
          'doc_area_id': areaId,
          'visit_with': dcrString,
          "latitude": lat,
          'longitude': lon,
          "item_list_gsp": itemString,
          "remarks": note,
        },
      ),
    );

    return response;
  }
}
