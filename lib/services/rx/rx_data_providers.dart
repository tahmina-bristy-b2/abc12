import 'dart:convert';

import 'package:MREPORTING/services/rx/rx_apis.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class RxDataProviders {
  //================================================================================  ===================================================================
  //================================================================================ RX Submit ===================================================================
  //===================================================================================================================================================
  Future<http.Response> rxSubmit(
      submitUrl,
      fileName,
      cid,
      userId,
      userPassword,
      deviceId,
      finalDoctorList,
      dropdownRxTypevalue,
      latitude,
      longitude,
      itemString) async {
    var dt = DateFormat('HH:mm:ss').format(DateTime.now());

    final http.Response response;
    response = await http.post(
      Uri.parse(RxApis.rxSubmitApi(submitUrl)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(
        <String, dynamic>{
          'cid': cid,
          'user_id': userId,
          'user_pass': userPassword,
          'device_id': deviceId,
          'doctor_id': finalDoctorList.isEmpty ? '' : finalDoctorList[0].docId,
          'area_id': finalDoctorList.isEmpty ? '' : finalDoctorList[0].areaId,
          'rx_type': dropdownRxTypevalue,
          "latitude": latitude,
          'longitude': longitude,
          'image_name': fileName,
          'cap_time': dt.toString(),
          "item_list": itemString,
        },
      ),
    );
    return response;
  }

//################################ Sync Rx Item  Data ########################
  Future<http.Response> syncRxItemDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(RxApis.syncRxItemApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }
}
