import 'package:MREPORTING/services/eDSR/eDSR_apis.dart';
import 'package:http/http.dart' as http;

class EDSRDataProvider {
  //==================================================DCR RegionList==========================================================
  Future<http.Response> getRegionList(String areaUrl, String cid, String userId,
      String userPass, String deviceId) async {
    final http.Response response;
    print(
        "RegionList Api=======${eDSRApis().regionListUri(areaUrl, cid, userId, userPass, deviceId)}");
    response = await http.get(
      Uri.parse(
          eDSRApis().regionListUri(areaUrl, cid, userId, userPass, deviceId)),
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
    final http.Response response;
    print(
        "Territory Based Doctor api==${eDSRApis().getDoctor(doctorUrl, cid, userId, userPass, regionId, areaId, terroId, dsrType)}");
    response = await http.post(
      Uri.parse(eDSRApis().getDoctor(doctorUrl, cid, userId, userPass, regionId,
          areaId, terroId, dsrType)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  //=========================================== eDSR Settings api=====================================================
  Future<http.Response> getEDSRSettingsInfo(
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;
    print(
        "getEDSRSettingsInfo==${eDSRApis().getEDsrSettingApi(cid, userId, userPass)}");
    response = await http.get(
      Uri.parse(eDSRApis().getEDsrSettingApi(cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  //=============================== eDSR Approval Section =================================
  Future<http.Response> getEdsrFmList(
    String fmListUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;

    response = await http.get(
      Uri.parse(eDSRApis.eDSRfmListApi(fmListUrl, cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  Future<http.Response> getDsrDetails(
    String fmListUrl,
    String cid,
    String userId,
    String userPass,
    String submitedBy,
    String territoryId,
  ) async {
    final http.Response response;

    response = await http.get(
      Uri.parse(eDSRApis.dsrDetailsApi(
          fmListUrl, cid, userId, userPass, submitedBy, territoryId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}
