import 'dart:convert';

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
        "getEDSRSettingsInfo==${EDSRApis().getEDsrSettingApi(eDsrSettingsUrl, cid, userId, userPass)}");
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

    // print(
    //     "eDsr Submit api==${EDSRApis().eDsrAddApi(eDsrSettingsUrl, cid, userId, userPass, syncCode, brandStr, areaId, doctorId, doctorName, doctorCategory, latitude, longitude, dsrType, dsrCat, purpose, purposeSub, pDes, pDtFrom, pDtTo, noOfPatient, payFrom, payTo, schedule, payNMonth, payMode, chequeTo, rsmCash, issueTo)}");
    response = await http.post(
      Uri.parse(EDSRApis().eDsrAddApi(
        eDsrSettingsUrl,
        cid,
        userId,
        userPass,
        // syncCode,
        // brandStr,
        // areaId,
        // doctorId,
        // doctorName,
        // doctorCategory,
        // latitude,
        // longitude,
        // dsrType,
        // dsrCat,
        // purpose,
        // purposeSub,
        // pDes,
        // pDtFrom,
        // pDtTo,
        // noOfPatient,
        // payFrom,
        // payTo,
        // schedule,
        // payNMonth,
        // payMode,
        // chequeTo,
        // rsmCash,
        // issueTo,
      )),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, dynamic>{
          "synccode": syncCode,
          "brand_Str": brandStr,
          "areaId": areaId,
          "doctor_id": doctorId,
          "doctor_name": doctorName,
          "doctor_category": doctorCategory,
          "latitude": latitude,
          "longitude": longitude,
          "dsr_type": dsrType,
          "dsr_cat": dsrCat,
          "purpose": purpose,
          "purpose_sub": purposeSub,
          "p_des": pDes,
          "p_dt_from": pDtFrom,
          "p_dt_to": pDtTo,
          "no_of_patient": noOfPatient,
          "pay_from": payFrom,
          "pay_to": payTo,
          "schedule": schedule,
          "pay_n_month": payNMonth,
          "pay_mode": payMode,
          "cheque_to": chequeTo,
          "rsm_cash": rsmCash,
          "pay_mode_bill_to": issueTo,
        },
      ),
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
    print("FFList =${EDSRApis.eDSRfmListApi(fmListUrl, cid, userId, userPass)}");

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
    String levelDepth,
  ) async {
    final http.Response response;
    // print(
    //     "eDSR details api=${EDSRApis.dsrDetailsApi(fmListUrl, cid, userId, userPass, submitedBy, territoryId)}");

    response = await http.get(
      Uri.parse(EDSRApis.dsrDetailsApi(fmListUrl, cid, userId, userPass,
          submitedBy, territoryId, levelDepth)),
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

  //================================= Mobile Number Updation=============================
  Future<http.Response> mobileUpdateDP(
      String approveEDSRUrl,
      String cid,
      String userId,
      String userPass,
      String doctorId,
      String dsrType,
      String upMobileNumber,
      String areaId) async {
    final http.Response response;

    response = await http.get(
      Uri.parse(EDSRApis.mobileUpdateApi(approveEDSRUrl, cid, userId, userPass,
          doctorId, dsrType, upMobileNumber, areaId)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    return response;
  }
}
