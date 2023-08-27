import 'dart:convert';

import 'package:MREPORTING/models/dDSR%20model/dSR_details_model.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_FM_list_model.dart';
import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eDSR/eDSR_data_providers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class eDSRRepository {
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
    try {
      http.Response response = await EDSRDataProvider().terroBasedDoctor(
          doctorUrl, cid, userId, userPass, regionId, areaId, terroId, dsrType);

      submitInfo = json.decode(response.body);
      return submitInfo;
    } catch (e) {
      print('get Doctor: $e');
    }
    return submitInfo;
  }

  //=========================================== getEDSRSettingsInfo  ==========================================
  Future<EdsrDataModel?> getEDSRSettingsInfo(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    EdsrDataModel? eDSrDataModel;
    try {
      final http.Response response = await EDSRDataProvider()
          .getEDSRSettingsInfo(eDsrSettingsUrl, cid, userId, userPass);
      eDSrDataModel = edsrDataModelFromJson(response.body);

      return eDSrDataModel;
    } catch (e) {
      print('Add eDSr: $e');
    }
    return eDSrDataModel;
  }

  //=========================================== Territory Based Doctor ==========================================
  Future<Map<String, dynamic>> submitEDSR(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
    String syncCode,
    String brandStr,
    String areaId,
    String doctorId,
    String doctorName,
    String doctorCategory,
    String latitude,
    String longitude,
    String dsrType,
    String dsrCat,
    String purpose,
    String purposeSub,
    String pDes,
    String pDtFrom,
    String pDtTo,
    String noOfPatient,
    String payFrom,
    String payTo,
    String schedule,
    String payNMonth,
    String payMode,
    String chequeTo,
    String rsmCash,
    String issueTo,
  ) async {
    Map<String, dynamic> submitInfo = {};
    //String submitInfo = "";
    try {
      http.Response response = await EDSRDataProvider().submiteDSRForAdd(
          eDsrSettingsUrl,
          cid,
          userId,
          userPass,
          syncCode,
          brandStr,
          areaId,
          doctorId,
          doctorName,
          doctorCategory,
          latitude,
          longitude,
          dsrType,
          dsrCat,
          purpose,
          purposeSub,
          pDes,
          pDtFrom,
          pDtTo,
          noOfPatient,
          payFrom,
          payTo,
          schedule,
          payNMonth,
          payMode,
          chequeTo,
          rsmCash,
          issueTo);

      submitInfo = json.decode(response.body);
      return submitInfo;
    } catch (e) {
      print('get Doctor: $e');
    }
    return submitInfo;
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

  Future<Map<String, dynamic>> brandAmountUpdate(
    String brandAmountUpdateUrl,
    String cid,
    String userId,
    String userPass,
    String brandAmountUpdateParams,
  ) async {
    Map<String, dynamic> resData = {};
    try {
      http.Response response = await EDSRDataProvider().brandAmountUpdate(
          brandAmountUpdateUrl, cid, userId, userPass, brandAmountUpdateParams);

      resData = json.decode(response.body);
      // print(resData["res_data"]["status"]);

      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          AllServices().toastMessage(
              resData["res_data"]["status"], Colors.green, Colors.white, 14);
          return resData;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return resData;
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

    return resData;
  }

  Future<Map<String, dynamic>> approvedOrRejectedDsr(
      String approveEDSRUrl,
      String cid,
      String userId,
      String userPass,
      String approvedEdsrParams) async {
    Map<String, dynamic> resData = {};
    try {
      http.Response response = await EDSRDataProvider().approvedDSR(
          approveEDSRUrl, cid, userId, userPass, approvedEdsrParams);

      resData = json.decode(response.body);
      // print(resData["res_data"]["status"]);

      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          AllServices().toastMessage(
              resData["res_data"]["status"], Colors.green, Colors.white, 14);
          return resData;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return resData;
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

    return resData;
  }
}
