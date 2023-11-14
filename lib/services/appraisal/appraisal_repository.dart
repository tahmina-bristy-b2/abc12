import 'dart:convert';
import 'package:MREPORTING/models/appraisal/appraisal_FF_details_data_model.dart';
import 'package:MREPORTING/models/appraisal/appraisal_details_model.dart';
import 'package:MREPORTING/models/appraisal/appraisal_employee_data_model.dart';
import 'package:MREPORTING/models/appraisal/appraisal_field_Force_data_model.dart';
import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppraisalRepository {
  // ---------------------- Get Employee list of Data-------------
  Future<AppraisalEmployee?> getEployeeListOfData(
      String syncUrl, String cid, String userId, String userPass) async {
    AppraisalEmployee? appraisalEmployee;
    try {
      http.Response response = await AppraisalDataprovider()
          .getEmployee(syncUrl, cid, userId, userPass);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          appraisalEmployee = appraisalEmployeeFromJson(response.body);
          return appraisalEmployee;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return appraisalEmployee;
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
    return appraisalEmployee;
  }

//================================ Employee Details Information =============================================
  Future<AppraisalDetailsModel?> getEmployeeDetails(
      String url,
      String cid,
      String userId,
      String userPass,
      String levelDepth,
      String employeeId) async {
    AppraisalDetailsModel? appraisalDetailsModel;
    try {
      http.Response response = await AppraisalDataprovider()
          .getEmployeeAppraisal(
              url, cid, userId, userPass, levelDepth, employeeId);
      Map<String, dynamic> body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (body["res_data"]["status"] == "Success") {
          appraisalDetailsModel = appraisalDetailsModelFromJson(response.body);
        } else {
          AllServices().toastMessage(
              "${body["res_data"]["ret_str"]}", Colors.red, Colors.white, 16);
          return appraisalDetailsModel;
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
    return appraisalDetailsModel;
  }

  //=======================Appraisal Submit===================================
  Future<Map<String, dynamic>> appraisalSubmit(
      String url,
      String cid,
      String userId,
      String userPass,
      String levelDepth,
      String employeeId,
      List kpiValus,
      String incrementAmount,
      String upgradeGrade,
      String designationChange,
      String feedback,
      String kpiKey) async {
    Map<String, dynamic> wholeData = {};
    try {
      http.Response response = await AppraisalDataprovider().appRaisalSubmit(
          url,
          cid,
          userId,
          userPass,
          levelDepth,
          employeeId,
          kpiValus,
          incrementAmount,
          upgradeGrade,
          designationChange,
          feedback,
          kpiKey);

      if (response.statusCode == 200) {
        wholeData = jsonDecode(response.body);
        return wholeData;
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
        return wholeData;
      }
    } catch (e) {
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }
    return wholeData;
  }

  //=========================== Get Appraisal Field Force ==================
  Future<AppraisalFfDataModel?> getAppraisalFFData(
      String syncUrl, String cid, String userId, String userPass) async {
    AppraisalFfDataModel? appraisalFfData;
    try {
      http.Response response = await AppraisalDataprovider()
          .getAppraisalFF(syncUrl, cid, userId, userPass);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          appraisalFfData = appraisalFfDataModelFromJson(response.body);
          // appraisalFfData = appraisalFfDataModelFromJson(json.encode(fFdata));
          return appraisalFfData;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return appraisalFfData;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      // appraisalFfData = appraisalFfDataModelFromJson(json.encode(fFdata));
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }
    return appraisalFfData;
  }

  //======================== Get Appraisal Approval Field Force Details Data For Approval ==================
  Future<AppraisalApprovalFfDetailsDataModel?> getAppraisalApprovalFFDetails(
      String syncUrl,
      String cid,
      String userId,
      String userPass,
      String restParams) async {
    AppraisalApprovalFfDetailsDataModel? appraisalApprovalFfDetailsData;
    try {
      http.Response response = await AppraisalDataprovider()
          .appraisalFFDetails(syncUrl, cid, userId, userPass, restParams);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          appraisalApprovalFfDetailsData =
              appraisalApprovalFfDetailsDataModelFromJson(response.body);
          // appraisalApprovalFfDetailsData =
          //     appraisalApprovalFfDetailsDataModelFromJson(
          //         json.encode(fFDetailsJson));

          return appraisalApprovalFfDetailsData;
        } else {
          // appraisalApprovalFfDetailsData =
          //     appraisalApprovalFfDetailsDataModelFromJson(
          //         json.encode(fFDetailsJson));
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return appraisalApprovalFfDetailsData;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      // appraisalApprovalFfDetailsData =
      //     appraisalApprovalFfDetailsDataModelFromJson(
      //         json.encode(fFDetailsJson));
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }
    return appraisalApprovalFfDetailsData;
  }

  //============================= get appraisal self assesment================================

  Future<AppraisalApprovalFfDetailsDataModel?> getSelfAssesment(
      String syncUrl, String cid, String userId, String userPass) async {
    AppraisalApprovalFfDetailsDataModel? appraisalApprovalFfDetailsData;
    try {
      http.Response response = await AppraisalDataprovider()
          .getSelfAppraisal(syncUrl, cid, userId, userPass);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          appraisalApprovalFfDetailsData =
              appraisalApprovalFfDetailsDataModelFromJson(response.body);
          // appraisalApprovalFfDetailsData =
          //     appraisalApprovalFfDetailsDataModelFromJson(
          //         json.encode(fFDetailsJson));

          return appraisalApprovalFfDetailsData;
        } else {
          // appraisalApprovalFfDetailsData =
          //     appraisalApprovalFfDetailsDataModelFromJson(
          //         json.encode(fFDetailsJson));
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
          return appraisalApprovalFfDetailsData;
        }
      } else {
        AllServices().toastMessage(
            "System Unable to reach the Server,\n StatusCode: ${response.statusCode}",
            Colors.red,
            Colors.white,
            14);
      }
    } catch (e) {
      // appraisalApprovalFfDetailsData =
      //     appraisalApprovalFfDetailsDataModelFromJson(
      //         json.encode(fFDetailsJson));
      AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }
    return appraisalApprovalFfDetailsData;
  }

  //======================== Appraisal Approval ==================
  Future<Map<String, dynamic>> appraisalFFApprovalSubmit(
      String syncUrl,
      String cid,
      String userId,
      String userPass,
      String restParams,
      List<Map<String, dynamic>> supRevData) async {
    Map<String, dynamic> resData = {};
    try {
      http.Response response = await AppraisalDataprovider()
          .appraisalFFApprovalSubmit(
              syncUrl, cid, userId, userPass, restParams, supRevData);
      resData = json.decode(response.body);
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
}
