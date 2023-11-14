import 'dart:convert';

import 'package:MREPORTING/services/appraisal/appraisal_apis.dart';
import 'package:http/http.dart' as http;

class AppraisalDataprovider {
  Future getEmployee(
      String syncUrl, String cid, String userId, String userPass) async {
    final http.Response response;
    response = await http.get(
        Uri.parse(AppraisalApis.employeeApi(syncUrl, cid, userId, userPass)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response;
  }

  //========================== get appraisal Details========================
  Future getEmployeeAppraisal(String url, String cid, String userId,
      String userPass, String levelDepth, String employeeId) async {
    print(
        "Appraisal Details=${AppraisalApis.employeeAppraisaldetails(url, cid, userId, userPass, levelDepth, employeeId)}");
    final http.Response response;
    response = await http.get(
        Uri.parse(
          AppraisalApis.employeeAppraisaldetails(
              url, cid, userId, userPass, levelDepth, employeeId),
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response;
  }

  //==========================  appraisal Submit========================
  Future appRaisalSubmit(
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
    print(
        "Appraisal Submit=${AppraisalApis.employeeAppraisalSubmit(url, cid, userId, userPass, levelDepth, employeeId, kpiValus, incrementAmount, upgradeGrade, designationChange, feedback, kpiKey)}");
    final http.Response response;
    response = await http.post(
        Uri.parse(
          AppraisalApis.employeeAppraisalSubmit(
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
              kpiKey),
        ),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"kpi_values": kpiValus}));
    return response;
  }
  //======================== Get appraisal Field Force data ===============

  Future getAppraisalFF(
      String syncUrl, String cid, String userId, String userPass) async {
    final http.Response response;
    response = await http.get(
        Uri.parse(AppraisalApis.ffApi(syncUrl, cid, userId, userPass)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response;
  }

  //======================== Get appraisal Field Force data ===============

  Future appraisalFFDetails(String syncUrl, String cid, String userId,
      String userPass, String restParams) async {
    final http.Response response;
    response = await http.get(
        Uri.parse(AppraisalApis.ffDetailsApi(
            syncUrl, cid, userId, userPass, restParams)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response;
  }

  //======================== Get appraisal Field Force data ===============

  Future appraisalFFApprovalSubmit(String syncUrl, String cid, String userId,
      String userPass, String restParams) async {
    final http.Response response;
    response = await http.get(
        Uri.parse(AppraisalApis.ffapprovalSubmitApi(
            syncUrl, cid, userId, userPass, restParams)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response;
  }

  //======================== Get self appraisal ===============

  Future getSelfAppraisal(
    String syncUrl,
    String cid,
    String userId,
    String usrPass,
  ) async {
    final http.Response response;
    response = await http.get(
        Uri.parse(AppraisalApis.appraisalSelfAssesment(
            syncUrl, cid, userId, usrPass)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response;
  }
}
