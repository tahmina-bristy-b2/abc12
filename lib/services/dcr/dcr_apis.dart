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
  static doctorAddUrl() =>
      'http://w03.yeapps.com/skf_api/api_doctor/doctor_add?cid=skf&user_id=it003&user_pass=1234&area_id=DEMO&area_name=DEMO&doc_name=Dr Bristy&category=A&doctors_category=MBBS&doctor_type=CLINIC&specialty=EYE&degree=DCC&chemist_id=&address=&district=&thana=&mobile=&mar_day=2023-10-21&dob_child1=2023-10-21&dob_child2=2023-10-21&collar_size=&nop=&four_p_doc_id=&fourP_doc_name=&fourP_doc_specialty=&fourP_doc_address=&brand=&dob=2023-10-21';

  static String docSettingsApi =
      'http://w03.yeapps.com/skf_api/api_doctor/get_doctor_setting_sync';
}
// ?cid=$cid&user_id=$userId&user_pass=$userpass&area_id=$areaId