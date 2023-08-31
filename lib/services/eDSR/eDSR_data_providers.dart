import 'package:MREPORTING/services/eDSR/eDSR_apis.dart';
import 'package:http/http.dart' as http;

class EDSRDataProvider {
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
        "Territory Based Doctor api==${EDSRApis().getDoctor(doctorUrl, cid, userId, userPass, regionId, areaId, terroId, dsrType)}");
    response = await http.post(
      Uri.parse(EDSRApis().getDoctor(doctorUrl, cid, userId, userPass, regionId,
          areaId, terroId, dsrType)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //=========================================== eDSR Settings api=====================================================
  Future<http.Response> getEDSRSettingsInfo(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;

    print(
        "getEDSRSettingsInfo==${EDSRApis().getEDsrSettingApi(eDsrSettingsUrl, cid, "123", userPass)}");
    response = await http.get(
      Uri.parse(
          EDSRApis().getEDsrSettingApi(eDsrSettingsUrl, cid, userId, userPass)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }

  //=========================================== eDSR Add api=====================================================
  Future<http.Response> submiteDSRForAdd(
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
    String syncCode,
    String brandStr,
    String areaId,
    String doctorId,
    String doctorName,
    String doctorCategory,
    String latitude,
    String longitude,
    String dsrType,
    String dsrCat,
    String purpose,
    String purposeSub,
    String pDes,
    String pDtFrom,
    String pDtTo,
    String noOfPatient,
    String payFrom,
    String payTo,
    String schedule,
    String payNMonth,
    String payMode,
    String chequeTo,
    String rsmCash,
    String issueTo,
  ) async {
    final http.Response response;

    print(
        "eDsr Submit api==${EDSRApis().eDsrAddApi(eDsrSettingsUrl, cid, userId, userPass, syncCode, brandStr, areaId, doctorId, doctorName, doctorCategory, latitude, longitude, dsrType, dsrCat, purpose, purposeSub, pDes, pDtFrom, pDtTo, noOfPatient, payFrom, payTo, schedule, payNMonth, payMode, chequeTo, rsmCash, issueTo)}");
    response = await http.get(
      Uri.parse(EDSRApis().eDsrAddApi(
          eDsrSettingsUrl,
          cid,
          userId,
          userPass,
          syncCode,
          brandStr,
          areaId,
          doctorId,
          doctorName,
          doctorCategory,
          latitude,
          longitude,
          dsrType,
          dsrCat,
          purpose,
          purposeSub,
          pDes,
          pDtFrom,
          pDtTo,
          noOfPatient,
          payFrom,
          payTo,
          schedule,
          payNMonth,
          payMode,
          chequeTo,
          rsmCash,
          issueTo)),
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
      Uri.parse(EDSRApis.eDSRfmListApi(fmListUrl, cid, userId, userPass)),
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
    print(
        "eDSR details api=${EDSRApis.dsrDetailsApi(fmListUrl, cid, userId, userPass, submitedBy, territoryId)}");

    response = await http.get(
      Uri.parse(EDSRApis.dsrDetailsApi(
          fmListUrl, cid, userId, userPass, submitedBy, territoryId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  Future<http.Response> brandAmountUpdate(
    String brandAmountUpdateUrl,
    String cid,
    String userId,
    String userPass,
    String brandAmountUpdateParams,
  ) async {
    final http.Response response;

    response = await http.get(
      Uri.parse(EDSRApis.brandAmountUpdate(brandAmountUpdateUrl, cid, userId,
          userPass, brandAmountUpdateParams)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }

  Future<http.Response> approvedDSR(String approveEDSRUrl, String cid,
      String userId, String userPass, String approvedEdsrParams) async {
    final http.Response response;

    response = await http.get(
      Uri.parse(EDSRApis.approveEDSR(
          approveEDSRUrl, cid, userId, userPass, approvedEdsrParams)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}
