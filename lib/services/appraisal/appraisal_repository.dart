import 'dart:convert';

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
      appraisalFfData = appraisalFfDataModelFromJson(json.encode(fFdata));
      // AllServices().toastMessage("$e", Colors.red, Colors.white, 14);
    }
    return appraisalFfData;
  }
}
