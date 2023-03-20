import 'package:MREPORTING/main.dart';

class DcrApis {
  static syncDcrApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_doctor/get_doctor?cid=$cid&user_id=$userId&user_pass=$userpass';

  static syncDcrGiftApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userpass';

  static syncDcrSampleApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_doctor/get_doctor_sample?cid=$cid&user_id=$userId&user_pass=$userpass';

  static syncDcrPpmApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_doctor/get_doctor_ppm?cid=$cid&user_id=$userId&user_pass=$userpass';

  static dcrAreBaseClientApi(String syncUrl, String cid, String userId,
          String userpass, String areaId) =>
      '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userpass&area_id=$areaId';

  static doctorAddUrl(String addUrl, String params) =>
      'http://w03.yeapps.com/skf_api/api_doctor/doctor_add?$params';

//  static docSettingsApi(String syncUrl) =>
//       syncUrl;

  static String docSettingsApi =
      'http://w03.yeapps.com/skf_api/api_doctor/get_doctor_setting_sync';
}
