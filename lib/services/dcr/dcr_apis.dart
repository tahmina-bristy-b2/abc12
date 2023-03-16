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
  static dcrAreBaseClient(String syncUrl, String cid, String userId,
          String userpass, String areaId) =>
      '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userpass&area_id=$areaId';
}
