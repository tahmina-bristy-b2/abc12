import 'package:MREPORTING/services/others/apis.dart';
import 'package:http/http.dart' as http;

class DataProviders {
  Future<http.Response> dmPathData(String cid) async {
    late http.Response response;
    try {
      response = await http.get(
        Uri.parse(Apis.dmpath(cid)),
      );
    } catch (e) {
      print('dmPath: $e');
    }
    return response;
  }

  Future<http.Response> userLogin(
      String loginUrl,
      String cid,
      String userId,
      String password,
      String? deviceId,
      String? deviceBrand,
      String? deviceModel,
      String version) async {
            late http.Response response;
    try {
      response = await http.get(
        Uri.parse(
            '$loginUrl?cid=$cid&user_id=$userId&user_pass=$password&device_id=$deviceId&device_brand=$deviceBrand&device_model=$deviceModel'
            '_$version'),
      );
    } catch (e) {
      print('UserLogin: $e');
    }
    return response;
  }

  // ==============================Attendance Data Providers===========

  Future<http.Response> attendanceDP(
      String attendanceUrl,
      String? cid,
      String userId,
      String? userPass,
      String deviceId,
      String lat,
      String long,
      String address,
      String submitType,
      String mtrReading) async {
    String params =
        "cid=$cid&user_id=$userId&user_pass=$userPass&device_id=$deviceId&latitude=$lat&longitude=$long&address=$address&submit_type=$submitType&meter_reading=$mtrReading";
print(Apis.attendanceApi(attendanceUrl, params));
    http.Response response = await http.get(
      Uri.parse(Apis.attendanceApi(attendanceUrl, params)),
    );

    return response;
  }

  // ==============================area Data Providers===========

  Future<http.Response> areaDP(
    String areaUrl,
    String? cid,
    String userId,
    String? userPass,
  ) async {
    String params = "cid=$cid&user_id=$userId&user_pass=$userPass";

    print(params);

    http.Response response = await http.get(
      Uri.parse(Apis.areaApi(areaUrl, params)),
    );

    return response;
  }

  // ==============================area Base Client Data Providers===========

  Future<http.Response> areaBaseClientDP(
    String areaBaseClientUrl,
    String? cid,
    String userId,
    String? userPass,
    String areaId,
  ) async {
    String params =
        "cid=$cid&user_id=$userId&user_pass=$userPass&area_id=$areaId";

    http.Response response = await http.get(
      Uri.parse(Apis.areaBaseClientApi(areaBaseClientUrl, params)),
    );

    return response;
  }

  // ==============================area Base Doctor Data Providers===========

  Future<http.Response> areaBaseDoctorDP(
    String areaBaseDoctorUrl,
    String? cid,
    String userId,
    String? userPass,
    String areaId,
  ) async {
    String params =
        "cid=$cid&user_id=$userId&user_pass=$userPass&area_id=$areaId";

    http.Response response = await http.get(
      Uri.parse(Apis.areaBaseDoctorApi(areaBaseDoctorUrl, params)),
    );

    return response;
  }

  // ==============================area Base Doctor Data Providers===========

  Future<http.Response> tarAchDP(
    String tarAchUrl,
    String cid,
    String userId,
    String userPass,
    String deviceId,
  ) async {
    String params =
        "cid=$cid&user_id=$userId&user_pass=$userPass&device_id=$deviceId";
    print(Apis.getTargerAch(tarAchUrl, params));
    http.Response response = await http.get(
      Uri.parse(Apis.getTargerAch(tarAchUrl, params)),
    );

    return response;
  }

  // ==============================Expense Entry Data Providers===========

  Future<http.Response> expenseEntryDP(
    String expenseType,
    String cid,
    String userId,
    String userPass,
  ) async {
    print("a02");

    String params = "cid=$cid&user_id=$userId&user_pass=$userPass";
    print(Apis.getTargerAch(expenseType, params));
    http.Response response = await http.get(
      Uri.parse(Apis.getTargerAch(expenseType, params)),
    );

    return response;
  }

//########################## Promo section##############################
  Future<http.Response> promoDP(
      String promoUrl, String cid, String userId, String uesrpass) async {
    // print(Apis.promoApi(promoUrl, cid, userId, uesrpass));
    http.Response response = await http.get(
      Uri.parse(Apis.promoApi(promoUrl, cid, userId, uesrpass)),
    );

    return response;
  }

//########################## Stock section##############################
  Future<http.Response> stockDP(String stockUrl, String cid, String userId,
      String uesrpass, String depotId) async {
    // print(Apis.promoApi(promoUrl, cid, userId, uesrpass));
    http.Response response = await http.get(
      Uri.parse(Apis.stockApi(stockUrl, cid, userId, uesrpass, depotId)),
    );

    return response;
  }

//########################## Approved section##############################
  Future<http.Response> approvedDP(String approvedUrl, String cid,
      String userId, String uesrpass, String clientId) async {
    // print(Apis.promoApi(promoUrl, cid, userId, uesrpass));
    http.Response response = await http.get(
      Uri.parse(Apis.approvedApi(approvedUrl, cid, userId, uesrpass, clientId)),
    );

    return response;
  }

//###################### User Depot data for stock ########################
  Future<http.Response> userDepotDP(
      String userDepotUrl, String cid, String userId, String uesrpass) async {
    // print(Apis.userDepotApi(userDepotUrl, cid, userId, uesrpass));
    http.Response response = await http.get(
      Uri.parse(Apis.userDepotApi(userDepotUrl, cid, userId, uesrpass)),
    );

    return response;
  }


  // ==============================Get Attendance Data Providers===========

  Future<http.Response> getAttenadance (
     String attendaceurl,String cid,String userid,String userPass,) async {  
    print(Apis.attendanceGetApi(attendaceurl, cid, userid, userPass));
    http.Response response = await http.get(
      Uri.parse(Apis.attendanceGetApi(attendaceurl, cid, userid, userPass)),
    );

    return response;
  }
}
