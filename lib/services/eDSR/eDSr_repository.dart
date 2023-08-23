import 'dart:convert';

import 'package:MREPORTING/models/dDSR%20model/dSR_details_model.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_FM_list_model.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSR_data_providers.dart';
import 'package:flutter/material.dart';
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

  //=============================== eDSR Approval Section =================================

  Future<EdsrFmListModel?> getEdsrFmlist(
      String fmListUrl, String cid, String userId, String userPass) async {
    EdsrFmListModel? edsrFmList;
    try {
      http.Response response = await EDSRDataProvider()
          .getEdsrFmList(fmListUrl, cid, userId, userPass);

      var resData = json.decode(response.body);
      // print(resData["res_data"]["status"]);

      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          edsrFmList = edsrFmListModelFromJson(response.body);
          return edsrFmList;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["status"], Colors.red, Colors.white, 14);
          return edsrFmList;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach th Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }

    return edsrFmList;
  }

  Future<DsrDetailsModel?> getDsrDetailsData(
    String fmListUrl,
    String cid,
    String userId,
    String userPass,
    String submitedBy,
    String territoryId,
  ) async {
    DsrDetailsModel? edsrFmList;
    try {
      http.Response response = await EDSRDataProvider().getDsrDetails(
          fmListUrl, cid, userId, userPass, submitedBy, territoryId);

      var resData = json.decode(response.body);
      print(resData["res_data"]["status"]);

      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          edsrFmList = dsrDetailsModelFromJson(response.body);
          return edsrFmList;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["status"], Colors.red, Colors.white, 14);
          return edsrFmList;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach th Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }

    return edsrFmList;
  }
}
