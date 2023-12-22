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

  static doctorAddUrl(String addUrl, String params) => '$addUrl?$params';

  static doctorEditUrl(String editSubmitUrl, String params) =>
      '$editSubmitUrl?$params';

  static docEditInfoApi(String docEditUrl, String cid, String userId,
          String userpass, String areaId, String docId) =>
      '$docEditUrl?cid=$cid&user_id=$userId&user_pass=$userpass&area_id=$areaId&doc_id=$docId';

//  static docSettingsApi(String syncUrl) =>
//       syncUrl;

  static String docSettingsApi(String syncUrl) =>
      '${syncUrl}api_doctor/get_doctor_setting_sync';

  static String gspSubmitApi(String gspSubmitUrl) =>
      '${gspSubmitUrl}api_dcr_submit/submit_data';


   //=============================================Doctor Census===============================================
      static String rxTarget(String submitUrl, String cid, String userId, String userpass,String deviceId,String doctorListString)=>
        "${submitUrl}api_census_submit/submit_data_doctor";

  //=============================================Doctor Census===============================================
      static String clientCensusApi(String submitUrl)=>
        "${submitUrl}api_census_submit/submit_data_doctor";      
      
}
