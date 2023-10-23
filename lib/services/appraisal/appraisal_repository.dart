import 'dart:convert';

import 'package:MREPORTING/services/all_services.dart';
import 'package:MREPORTING/services/appraisal/appraisal_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AppraisalRepository {
  Future getEployeeListOfData(
      String cid, String userId, String userPass) async {
    try {
      http.Response response =
          await AppraisalDataprovider().getEmployee(cid, userId, userPass);
      var resData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (resData["res_data"]["status"] == "Success") {
          return resData;
        } else {
          AllServices().toastMessage(
              resData["res_data"]["ret_str"], Colors.red, Colors.white, 14);
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
  }
}
