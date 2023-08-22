import 'dart:convert';

import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/eDSR/eDSR_data_providers.dart';
import 'package:http/http.dart' as http;

class eDSRRepository {
  //=========================================== Region List Api ==========================================
  // Future<RegionListModel> getRegionList(String areaUrl, String cid,
  //     String userId, String userPass, String deviceId) async {
  //   http.Response response = await EDSRDataProvider()
  //       .getRegionList(areaUrl, cid, userId, userPass, deviceId);
  //   return regionListModelFromJson(response.body);
  // }

  //=========================================== Territory Based Doctor ==========================================
  Future<Map<String, dynamic>> getTerritoryBasedDoctor(
      String doctorUrl,
      String cid,
      String userId,
      String userPass,
      String regionId,
      String areaId,
      String terroId,
      String dsrType) async {
    Map<String, dynamic> submitInfo = {};
    http.Response response = await EDSRDataProvider().terroBasedDoctor(
        doctorUrl, cid, userId, userPass, regionId, areaId, terroId, dsrType);
    submitInfo = json.decode(response.body);

    return submitInfo;
  }

  //=========================================== getEDSRSettingsInfo  ==========================================
  Future<EdsrDataModel> getEDSRSettingsInfo(
      String cid, String userId, String userPass) async {
    http.Response response =
        await EDSRDataProvider().getEDSRSettingsInfo(cid, userId, userPass);
    return edsrDataModelFromJson(response.body);
  }
}
