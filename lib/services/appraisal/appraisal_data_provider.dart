import 'package:MREPORTING/services/appraisal/appraisal_apis.dart';
import 'package:http/http.dart' as http;

class AppraisalDataprovider {
  Future getEmployee(String cid, String userId, String userPass) async {
    final http.Response response;
    response = await http.get(
        Uri.parse(AppraisalApis.employeeApi(cid, userId, userPass)),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    return response;
  }
}
