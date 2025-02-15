import 'package:MREPORTING_OFFLINE/services/eCME/eCME_apis.dart';
import 'package:http/http.dart' as http;

class ECMEDataProviders {
  //=========================================== E-CME Settings api=====================================================
  Future<http.Response> getECMESettingsInfo(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;

    print(
        "getECMESettingsInfo==${ECMEApis().getEcmeSettingsData(eDsrSettingsUrl, cid, userId, userPass)}");
    response = await http.get(
      Uri.parse(ECMEApis()
          .getEcmeSettingsData(eDsrSettingsUrl, cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  Future<http.Response> getEcmeDoctorCategory(
    String eCMEUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;

    print(
        "get Category for sync==${ECMEApis.geECMEDoctorCategory(eCMEUrl, cid, userId, userPass)}");
    response = await http.get(
      Uri.parse(ECMEApis.geECMEDoctorCategory(eCMEUrl, cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //=========================================== E-CME Settings api=====================================================
  Future<http.Response> submitECMEData(String submitUrl) async {
    final http.Response response;
    response = await http.get(
      Uri.parse(submitUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //=============================== eCME Approval Section =================================
  Future<http.Response> getECMEFFList(
    String fmListUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;
    print("daata =${ECMEApis.getEcmeFFList(fmListUrl, cid, userId, userPass)}");
    response = await http.get(
      Uri.parse(ECMEApis.getEcmeFFList(fmListUrl, cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  //===================== eCME details for approval =======================================
  Future<http.Response> getECMEApprovalDetails(
    String fmListUrl,
    String cid,
    String userId,
    String userPass,
    String submitedBy,
    String areaId,
    String levelDepth,
  ) async {
    final http.Response response;
    print(
        "eCMe Details ${ECMEApis.eCMEDetailsApi(fmListUrl, cid, userId, userPass, submitedBy, areaId, levelDepth)}");
    response = await http.get(
      Uri.parse(ECMEApis.eCMEDetailsApi(
          fmListUrl, cid, userId, userPass, submitedBy, areaId, levelDepth)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  //================================= eCME Approved or reject ===============================
  Future<http.Response> approvedECMEDP(
      String sl,
      String approveEDSRUrl,
      String cid,
      String userId,
      String userPass,
      String approvedEdsrParams) async {
    final http.Response response;
    print(
        "approved reject api =${ECMEApis.eCMEApproved(sl, approveEDSRUrl, cid, userId, userPass, approvedEdsrParams)}");
    response = await http.get(
      Uri.parse(ECMEApis.eCMEApproved(
          sl, approveEDSRUrl, cid, userId, userPass, approvedEdsrParams)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  //=====================  approval print =======================================
  Future<http.Response> getECMEApprovedPrint(String approveEDSRUrl, String cid,
      String userId, String userPass, String fromDate, String toDate) async {
    final http.Response response;
    print(
        "eCMe print data ${ECMEApis.eCMEApprovedPrint(approveEDSRUrl, cid, userId, userPass, fromDate, toDate)}");
    response = await http.get(
      Uri.parse(ECMEApis.eCMEApprovedPrint(
          approveEDSRUrl, cid, userId, userPass, fromDate, toDate)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  //=========================================== E-CME Bill Update =====================================================
  Future<http.Response> billUpdateDataProvider(String submitUrl) async {
    final http.Response response;
    response = await http.get(
      Uri.parse(submitUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //=====================  Get doctor  =======================================
  Future<http.Response> getDoctorApi(String eCMEUrl, String cid, String userId,
      String userPass, String doctorCategory) async {
    final http.Response response;
    print(
        "eCMe doctor data ${ECMEApis.eCMETerritoryWiseDoctorGet(eCMEUrl, cid, userId, userPass, doctorCategory)}");
    response = await http.get(
      Uri.parse(ECMEApis.eCMETerritoryWiseDoctorGet(
          eCMEUrl, cid, userId, userPass, doctorCategory)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}
