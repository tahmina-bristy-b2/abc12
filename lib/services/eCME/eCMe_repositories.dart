import 'dart:convert';

import 'package:MREPORTING/models/e_CME/eCME_details_saved_data_model.dart';
import 'package:MREPORTING/models/e_CME/e_CME_approval_data_model.dart';
import 'package:MREPORTING/models/e_CME/e_CME_approved_print_data_model.dart';
import 'package:MREPORTING/models/e_CME/e_CME_doctor_list.dart';
import 'package:MREPORTING/models/e_CME/e_CME_ff_list_data_model_approval.dart';
import 'package:MREPORTING/models/e_CME/e_cme_category_List_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/eCME/eCME_data_provider.dart';
import 'package:MREPORTING/services/eCME/eCME_services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ECMERepositry {
  //=========================================== get all settigs data from api  ==========================================
  Future<ECMESavedDataModel?> getECMESettingsData(String eDsrSettingsUrl,
      String cid, String userId, String userPass, String path) async {
    ECMESavedDataModel? eCMEDataModeldata;
    Map<String, dynamic> wholeData = {};

    try {
      final http.Response response = await ECMEDataProviders()
          .getECMESettingsInfo(eDsrSettingsUrl, cid, userId, userPass);
      wholeData = json.decode(response.body);
      if (wholeData["status"] == "Success") {
        eCMEDataModeldata = eCMEDataModelFromJson(response.body);
        if (eCMEDataModeldata != null) {
          ECMEServices().putEdsrSettingsData(eCMEDataModeldata);
        }
        return eCMEDataModeldata;
      } else {
        if (path == "All") {
          return eCMEDataModeldata;
        }

        AllServices().toastMessage(" CME Data Sync ${wholeData["status"]}",
            Colors.red, Colors.white, 14);
        return eCMEDataModeldata;
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
      print('Add CME: $e');
    }
    return eCMEDataModeldata;
  }

  Future<EcmeDoctorCategoryDataModel?> getCategoryforSync(
      String eDsrSettingsUrl,
      String cid,
      String userId,
      String userPass,
      String path) async {
    EcmeDoctorCategoryDataModel? eCMEDataModeldata;
    Map<String, dynamic> wholeData = {};

    try {
      final http.Response response = await ECMEDataProviders()
          .getEcmeDoctorCategory(eDsrSettingsUrl, cid, userId, userPass);
      wholeData = json.decode(response.body);
      if (wholeData["res_data"]["status"] == "Success") {
        eCMEDataModeldata = ecmeDoctorCategoryDataModelFromJson(response.body);
        if (eCMEDataModeldata != null) {
          ECMEServices().putECMECategory(eCMEDataModeldata.resData);
        }
        return eCMEDataModeldata;
      } else {
        if (path == "All") {
          return eCMEDataModeldata;
        }

        AllServices().toastMessage(
            " CME Doctor Category Sync ${wholeData["status"]}",
            Colors.red,
            Colors.white,
            14);
        return eCMEDataModeldata;
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
      print('Add CME: $e');
    }
    return eCMEDataModeldata;
  }

  //  //=========================================== Territory Based Doctor ==========================================
  // Future<Map<String, dynamic>> getTerritoryBasedDoctor(
  //     String doctorUrl,
  //     String cid,
  //     String userId,
  //     String userPass,
  //     String regionId,
  //     String areaId,
  //     String terroId,
  //     String dsrType) async {
  //   Map<String, dynamic> submitInfo = {};
  //   try {
  //     http.Response response = await ECMEDataProviders().terroBasedDoctor(
  //         doctorUrl, cid, userId, userPass, regionId, areaId, terroId, dsrType);
  //     submitInfo = json.decode(response.body);
  //     return submitInfo;
  //   } catch (e) {
  //     print('get Doctor: $e');
  //   }
  //   return submitInfo;
  // }

  //=========================================== Territory Based Doctor ==========================================
  Future<Map<String, dynamic>> eCMESubmitURL(String submitUrl) async {
    Map<String, dynamic> submitInfo = {};
    try {
      http.Response response =
          await ECMEDataProviders().submitECMEData(submitUrl);
      submitInfo = json.decode(response.body);
      return submitInfo;
    } catch (e) {
      print('get Doctor: $e');
    }
    return submitInfo;
  }

  // ========================================= get Ff List For e-CME approval=============================================
  Future<ECMEffListDataModel?> getECMEFFListData(
      String fmListUrl, String cid, String userId, String userPass) async {
    ECMEffListDataModel? eCMEFFlistData;
    try {
      http.Response response = await ECMEDataProviders()
          .getECMEFFList(fmListUrl, cid, userId, userPass);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          eCMEFFlistData = eCMEFFListModelFromJson(response.body);
          print("data =${response.body}");
          return eCMEFFlistData;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return eCMEFFlistData;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }
    return eCMEFFlistData;
  }

//=================================== eCME Details Data Get for Approval =========================================
  Future<EcmeApprovalDetailsDataModel?> getDsrDetailsData(
    String fmListUrl,
    String cid,
    String userId,
    String userPass,
    String submitedBy,
    String areaId,
    String levelDepth,
  ) async {
    EcmeApprovalDetailsDataModel? dsrDetailsData;
    try {
      http.Response response = await ECMEDataProviders().getECMEApprovalDetails(
          fmListUrl, cid, userId, userPass, submitedBy, areaId, levelDepth);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          dsrDetailsData = ecmeApprovalDetailsDataModelFromJson(response.body);
          return dsrDetailsData;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return dsrDetailsData;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }

    return dsrDetailsData;
  }

//============================================= Approved or Reject =======================================================================
  Future<Map<String, dynamic>> approvedOrRejectedECME(
      String sl,
      String approveEDSRUrl,
      String cid,
      String userId,
      String userPass,
      String approvedEdsrParams) async {
    Map<String, dynamic> resData = {};
    try {
      http.Response response = await ECMEDataProviders().approvedECMEDP(
          sl, approveEDSRUrl, cid, userId, userPass, approvedEdsrParams);

      resData = json.decode(response.body);
      // print(resData["res_data"]["status"]);

      if (response.statusCode == 200) {
        if (resData["status"] == "Success") {
          AllServices()
              .toastMessage(resData["ret_str"], Colors.green, Colors.white, 14);
          return resData;
        } else {
          AllServices()
              .toastMessage(resData["ret_str"], Colors.red, Colors.white, 14);
          return resData;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }

    return resData;
  }

  //=================================== eCME Approval Print =========================================
  Future<ApprovedPrintDataModel?> getECMEPrintDetails(
      String approveEDSRUrl,
      String cid,
      String userId,
      String userPass,
      String fromDate,
      String toDate) async {
    ApprovedPrintDataModel? approvedPrintData;
    try {
      http.Response response = await ECMEDataProviders().getECMEApprovedPrint(
          approveEDSRUrl, cid, userId, userPass, fromDate, toDate);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          //  print("data ==${resData["res_data"]["status"]}");
          if (resData["res_data"]["data_list"].isNotEmpty) {
            approvedPrintData = approvedPrintDataModelFromJson(response.body);
            return approvedPrintData;
          }
        } else {
          AllServices().toastMessage(resData["res_data"]["Massage"].toString(),
              Colors.red, const Color.fromARGB(255, 9, 7, 7), 14);
          return approvedPrintData;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }

    return approvedPrintData;
  }

  //=========================================== Territory Based Doctor ==========================================
  Future<Map<String, dynamic>> eCMEBillUpdate(String submitUrl) async {
    Map<String, dynamic> submitInfo = {};
    try {
      http.Response response =
          await ECMEDataProviders().billUpdateDataProvider(submitUrl);
      submitInfo = json.decode(response.body);
      return submitInfo;
    } catch (e) {
      print('get Doctor: $e');
    }
    return submitInfo;
  }

  //============================================= Approved or Reject =======================================================================
  Future<EcmeTerritoryWiseDoctorModel?> getECMEDoctorData(String eCMEUrl,
      String cid, String userId, String userPass, String doctorCategory) async {
    EcmeTerritoryWiseDoctorModel? doctorList;
    Map<String, dynamic> resData = {};

    try {
      http.Response response = await ECMEDataProviders()
          .getDoctorApi(eCMEUrl, cid, userId, userPass, doctorCategory);

      resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          doctorList = doctorListDatafromjson(response.body);
          ECMEServices().putDoctorList(doctorList.resData);
          return doctorList;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return doctorList;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }

    return doctorList;
  }
}
