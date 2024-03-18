import 'dart:convert';

import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCME_data_provider.dart';
import 'package:MREPORTING/services/eCME/eCME_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class eCMERepositry{

   //=========================================== get all settigs data from api  ==========================================
  Future<ECMESavedDataModel?> getECMESettingsData(String eDsrSettingsUrl, String cid,
      String userId, String userPass, String path) async {
    ECMESavedDataModel? eCMEDataModeldata;
    Map<String, dynamic> wholeData = {};

    try {
      final http.Response response = await ECMEDataProviders()
          .getECMESettingsInfo(eDsrSettingsUrl, cid, userId, userPass);
      wholeData = json.decode(response.body);
      if (wholeData["status"] == "Success") {
        eCMEDataModeldata = eCMEDataModelFromJson(response.body);
        if(eCMEDataModeldata!=null){
         ECMEServices().putEdsrSettingsData(eCMEDataModeldata);

        }
        return eCMEDataModeldata;
      } else {
        if (path == "all") {
          return eCMEDataModeldata;
        }

        AllServices().toastMessage(" eCME Data Sync ${wholeData["status"]}",
            Colors.red, Colors.white, 14);
        return eCMEDataModeldata;
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
      print('Add e-CME: $e');
    }
    return eCMEDataModeldata;
  }
}