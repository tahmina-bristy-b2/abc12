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

  static syncDcrDisApi(
          String syncUrl, String cid, String userId, String userpass) =>
      '${syncUrl}api_doctor/get_doctor_gift?cid=$cid&user_id=$userId&user_pass=$userpass';

  static dcrAreBaseClientApi(String syncUrl, String cid, String userId,
          String userpass, String areaId) =>
      '$syncUrl/api_client/client_list?cid=$cid&user_id=$userId&user_pass=$userpass&area_id=$areaId';

  static doctorAddUrl(
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
          String dob) =>
      '$addUrl/doctor_add?cid=$skf&user_id=$userId&user_pass=$password&area_id=$areaId&area_name=$areaName&doc_name=$doctorName&category=$category&doctors_category=$doctorCategory&doctor_type=$doctorType&specialty=$specialty&degree=$degree&chemist_id=$chemistId&address=$draddress&district=$drDistrict&thana=$drThana&mobile=$drMobile&mar_day=$marDay&dob_child1=$child1&dob_child2=$child2&collar_size=$collerSize&nop=$nop&four_p_doc_id=$fDrId&fourP_doc_name=$fDrName&fourP_doc_specialty=$fDrspecilty&fourP_doc_address=$fDocAddress&brand=$brand&dob=$dob';

//  static docSettingsApi(String syncUrl) =>
//       syncUrl;

  static String docSettingsApi =
      'http://w03.yeapps.com/skf_api/api_doctor/get_doctor_setting_sync';

  static String gspSubmitApi(String gspSubmitUrl) =>
      '${gspSubmitUrl}api_dcr_submit/submit_data';

  static docEditInfoApi(String docEditUrl, String cid, String userId,
          String userpass, String areaId, String docId) =>
      '$docEditUrl?cid=$cid&user_id=$userId&user_pass=$userpass&area_id=$areaId&doc_id=$docId';
}
