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
}
