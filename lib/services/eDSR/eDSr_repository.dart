import 'dart:convert';

import 'package:MREPORTING/models/dDSR%20model/eDSR_data_model.dart';
import 'package:MREPORTING/services/eDSR/eDSR_data_providers.dart';
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
  Future<String> submitEDSR(
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
  ) async {
    //Map<String, dynamic> submitInfo = {};
    String submitInfo = "";
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
          rsmCash);

      submitInfo = json.decode(response.body);
      return submitInfo;
    } catch (e) {
      print('get Doctor: $e');
    }
    return submitInfo;
  }
}
