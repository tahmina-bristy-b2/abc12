import 'dart:convert';

import 'package:MREPORTING_OFFLINE/services/dcr/dcr_apis.dart';
import 'package:http/http.dart' as http;

class DcrDataProviders {
  //################################ Sync DCR  Data########################
  Future<http.Response> syncDcrDP(
      String syncUrl, String cid, String userId, String userpass) async {
    print("doctor List ${DcrApis.syncDcrApi(syncUrl, cid, userId, userpass)}");
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
    // print(
    //     "DCR apis=${DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID)}");

    final response = await http.get(
      Uri.parse(
          DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID)),
    );

    return response;
  }

  //################################ Doctor Settings########################
  Future<http.Response> docSettingsDP(
      String syncUrl, String cid, String userId, String userpass) async {
    print(
        " doctor dsettings              ${DcrApis.docSettingsApi(syncUrl)}?cid=$cid&user_id=$userId&user_pass=$userpass");

    final response = await http.get(
      Uri.parse(
          "${DcrApis.docSettingsApi(syncUrl)}?cid=$cid&user_id=$userId&user_pass=$userpass"),
    );

    return response;
  }

  Future<http.Response> getDoctorAddUrl(String addUrl, String params) async {
    final http.Response response;

    print("object=${DcrApis.doctorAddUrl(addUrl, params)}");
    response = await http.get(Uri.parse(DcrApis.doctorAddUrl(addUrl, params)));
    return response;
  }

  Future<http.Response> getDoctorEditUrl(
      String editSubmitUrl, String params) async {
    final http.Response response;

    // print("object=${DcrApis.doctorEditUrl(editSubmitUrl, params)}");
    response =
        await http.get(Uri.parse(DcrApis.doctorEditUrl(editSubmitUrl, params)));
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
    // print(
    //     '${gspSubmitUrl}api_dcr_submit_test/submit_data?cid=$cid&user_id=$userId&user_pass=$userPass&device_id=$deviceId&doc_id=$docId&doc_area_id=$areaId&visit_with=$dcrString&latitude=$lat&longitude=$lon&item_list_gsp=$itemString&remarks=$note');
    // print(
    //   jsonEncode(
    //     <String, dynamic>{
    //       'cid': cid,
    //       'user_id': userId,
    //       'user_pass': userPass,
    //       'device_id': deviceId,
    //       'doc_id': docId,
    //       'doc_area_id': areaId,
    //       'visit_with': dcrString,
    //       "latitude": lat,
    //       'longitude': lon,
    //       "item_list_gsp": itemString,
    //       "remarks": note,
    //     },
    //   ),
    // );
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

  //################ Doctor Edit info Settings########################
  Future<http.Response> docEditInfoDP(String docEditUrl, String cid,
      String userId, String userpass, String areaId, String docId) async {
    // print(DcrApis.docSettingsApi);

    final response = await http.get(
      Uri.parse(DcrApis.docEditInfoApi(
          docEditUrl, cid, userId, userpass, areaId, docId)),
    );

    return response;
  }

  //============================ Doctor Census=================================
  Future<http.Response> rxTargetSubmitDP(
      String submitUrl,
      String cid,
      String userId,
      String userpass,
      String deviceId,
      String doctorListString) async {
    print(
      jsonEncode(
        <String, dynamic>{
          'cid': cid,
          'user_id': userId,
          'user_pass': userpass,
          'device_id': deviceId,
          'item_list': doctorListString,
        },
      ),
    );

    final response = await http.post(
      Uri.parse(DcrApis.rxTarget(
          submitUrl, cid, userId, userpass, deviceId, doctorListString)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'cid': cid,
          'user_id': userId,
          'user_pass': userpass,
          'device_id': deviceId,
          'item_list': doctorListString,
        },
      ),
    );

    return response;
  }

  //============================ Doctor Census=================================
  Future<http.Response> clientCensusDP(
      String submitUrl,
      String cid,
      String userId,
      String userpass,
      String deviceId,
      String clientItemString) async {
    print(
      jsonEncode(
        <String, dynamic>{
          'cid': cid,
          'user_id': userId,
          'user_pass': userpass,
          'device_id': deviceId,
          'item_list': clientItemString,
        },
      ),
    );

    final response = await http.post(
      Uri.parse(DcrApis.clientCensusApi(submitUrl)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'cid': cid,
          'user_id': userId,
          'user_pass': userpass,
          'device_id': deviceId,
          'item_list': clientItemString,
        },
      ),
    );

    return response;
  }
}
