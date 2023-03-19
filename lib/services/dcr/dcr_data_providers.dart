import 'package:MREPORTING/services/dcr/dcr_apis.dart';
import 'package:http/http.dart' as http;

class DcrDataProviders {
  //################################ Sync DCR  Data########################
  Future<http.Response> syncDcrDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ Sync DCR Gift Data########################
  Future<http.Response> syncDcrGiftDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrGiftApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ Sync DCR Sample Data########################
  Future<http.Response> syncDcrSampleDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrSampleApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ Sync DCR Sample Data########################
  Future<http.Response> syncDcrPpmDP(
      String syncUrl, String cid, String userId, String userpass) async {
    final response = await http.get(
      Uri.parse(DcrApis.syncDcrPpmApi(syncUrl, cid, userId, userpass)),
    );

    return response;
  }

  //################################ DCR Area Client Data########################
  Future<http.Response> dcrAreaBaseClient(String syncUrl, String cid,
      String userId, String userpass, String areaID) async {
    print(
        "DCR apis=${DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID)}");

    final response = await http.get(
      Uri.parse(
          DcrApis.dcrAreBaseClientApi(syncUrl, cid, userId, userpass, areaID)),
    );

    return response;
  }

  //################################ Doctor Settings########################
  Future<http.Response> docSettingsDP(
      String cid, String userId, String userpass) async {
    print(DcrApis.docSettingsApi);

    final response = await http.get(
      Uri.parse(
          "${DcrApis.docSettingsApi}?cid=$cid&user_id=$userId&user_pass=$userpass"),
    );

    return response;
  }

  Future<http.Response> getDoctorAddUrl(
      String addUrl,
      String skf,
      String userId,
      String password,
      String areaId,
      String areaName,
      String doctorName,
      String category,
      String doctorCategory,
      String doctorType,
      String specialty,
      String degree,
      String chemistId,
      String draddress,
      String drDistrict,
      String drThana,
      String drMobile,
      String marDay,
      String child1,
      String child2,
      String collerSize,
      String nop,
      String fDrId,
      String fDrName,
      String fDrspecilty,
      String fDocAddress,
      String brand,
      String dob) async {
    final http.Response response;
    print(
        "object=${DcrApis.doctorAddUrl(addUrl, skf, userId, password, areaId, areaName, doctorName, category, doctorCategory, doctorType, specialty, degree, chemistId, draddress, drDistrict, drThana, drMobile, marDay, child1, child2, collerSize, nop, fDrId, fDrName, fDrspecilty, fDocAddress, brand, dob)}");
    response = await http.get(Uri.parse(DcrApis.doctorAddUrl(
        addUrl,
        skf,
        userId,
        password,
        areaId,
        areaName,
        doctorName,
        category,
        doctorCategory,
        doctorType,
        specialty,
        degree,
        chemistId,
        draddress,
        drDistrict,
        drThana,
        drMobile,
        marDay,
        child1,
        child2,
        collerSize,
        nop,
        fDrId,
        fDrName,
        fDrspecilty,
        fDocAddress,
        brand,
        dob)));
    return response;
  }
}
