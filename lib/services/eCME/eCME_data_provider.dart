import 'package:MREPORTING/services/eCME/eCME_apis.dart';
import 'package:http/http.dart' as http;

class ECMEDataProviders{
  //=========================================== E-CME Settings api=====================================================
  Future<http.Response> getECMESettingsInfo(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;

    print(
        "getECMESettingsInfo==${ECMEApis().getECMEDataDetails(eDsrSettingsUrl, cid, userId, userPass)}");
    response = await http.get(
      Uri.parse(
          ECMEApis().getECMEDataDetails(eDsrSettingsUrl, cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //=========================================== Territory based Doctor =====================================================
  Future<http.Response> terroBasedDoctor(
    String doctorUrl,
    String cid,
    String userId,
    String userPass,
    String regionId,
    String areaId,
    String terroId,
    String dsrType,
  ) async {
    late http.Response response;

    print(
        "Territory Based Doctor api==${ECMEApis().getECMEAddDoctorApi(doctorUrl, cid, userId, userPass, regionId, areaId, terroId, dsrType)}");
    response = await http.post(
      Uri.parse(ECMEApis().getECMEAddDoctorApi(doctorUrl, cid, userId, userPass, regionId,
          areaId, terroId, dsrType)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }



  //=========================================== E-CME Settings api=====================================================
  Future<http.Response> submitECMEData(
    String submitUrl
  ) async {
    final http.Response response;
    response = await http.get(
      Uri.parse(
          submitUrl),
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
    String territoryId,
    String levelDepth,
  ) async {
    final http.Response response;
    print("eCMe Details ${ECMEApis.eCMEDetailsApi(fmListUrl, cid, userId, userPass,
          submitedBy, territoryId, levelDepth)}");
    response = await http.get(
      Uri.parse(ECMEApis.eCMEDetailsApi(fmListUrl, cid, userId, userPass,
          submitedBy, territoryId, levelDepth)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }


  //================================= eCME Approved or reject ===============================
  Future<http.Response> approvedECMEDP(String sl,
         String approveEDSRUrl, String cid, String userId,
          String userPass, String approvedEdsrParams) async {
    final http.Response response;
    print("approved reject api =${ECMEApis.eCMEApproved(sl,
          approveEDSRUrl, cid, userId, userPass, approvedEdsrParams)}");
    response = await http.get(
      Uri.parse(ECMEApis.eCMEApproved(sl,
          approveEDSRUrl, cid, userId, userPass, approvedEdsrParams)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}