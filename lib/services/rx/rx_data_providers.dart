import 'dart:convert';

import 'package:MREPORTING/models/hive_models/hive_data_model.dart';
import 'package:MREPORTING/services/rx/rx_apis.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class RxDataProviders {
  //================================================================================  ===================================================================
  //================================================================================ RX Submit ===================================================================
  //===================================================================================================================================================
  Future<http.Response> rxSubmit(
      String submitUrl,
      String fileName,
      String cid,
      String userId,
      String userPassword,
      String deviceId,
      List<RxDcrDataModel> finalDoctorList,
      String dropdownRxTypevalue,
      double latitude,
      double longitude,
      String itemString) async {
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
    print(RxApis.syncRxItemApi(syncUrl, cid, userId, userpass));
    final response = await http.get(
      Uri.parse(RxApis.syncRxItemApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }
}
