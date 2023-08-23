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
    String eDsrSettingsUrl,
    String cid,
    String userId,
    String userPass,
  ) async {
    final http.Response response;

    print(
        "getEDSRSettingsInfo==${eDSRApis().getEDsrSettingApi(eDsrSettingsUrl, cid, "123", userPass)}");
    response = await http.get(
      Uri.parse(
          eDSRApis().getEDsrSettingApi(eDsrSettingsUrl, cid, userId, userPass)),
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
  ) async {
    final http.Response response;

    print(
        "eDsr Submit api==${eDSRApis().eDsrAddApi(eDsrSettingsUrl, cid, userId, userPass, syncCode, brandStr, areaId, doctorId, doctorName, doctorCategory, latitude, longitude, dsrType, dsrCat, purpose, purposeSub, pDes, pDtFrom, pDtTo, noOfPatient, payFrom, payTo, schedule, payNMonth, payMode, chequeTo, rsmCash)}");
    response = await http.get(
      Uri.parse(eDSRApis().eDsrAddApi(
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
          rsmCash)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    return response;
  }
}
